-- =========================================================================
-- Archivo: 09_concurrencia_guiada.sql  
-- Integrantes: Leonel González y Gonzalo Inga
-- UTN - TFI Bases de Datos I - Octubre 2025
-- =========================================================================

-- Este es el tema más complejo: concurrencia y deadlocks
-- Simulamos lo que pasa cuando varios usuarios usan la BD al mismo tiempo
-- PostgreSQL maneja automáticamente muchos de estos problemas
-- Creamos una función que reintenta automáticamente si hay conflictos

-- =========================================================================
-- LIMPIEZA PREVIA (IDEMPOTENCIA)
-- =========================================================================
DROP FUNCTION IF EXISTS fn_transferir_monto_con_retry(BIGINT, BIGINT, DECIMAL) CASCADE;
DELETE FROM Envios WHERE tracking LIKE 'CONC-%';
DELETE FROM Pedidos WHERE numero LIKE 'CONC-%';

-- =========================================================================
-- PREPARACIÓN: DATOS PARA PRUEBAS DE CONCURRENCIA
-- =========================================================================

-- Insertar pedidos de prueba para concurrencia
INSERT INTO Pedidos (numero, fecha, clienteNombre, total, estado, eliminado) 
VALUES 
('CONC-001', '2024-10-22', 'Cliente Concurrente A', 2000.00, 'FACTURADO', FALSE),
('CONC-002', '2024-10-22', 'Cliente Concurrente B', 1500.00, 'FACTURADO', FALSE);

-- Insertar envíos asociados
INSERT INTO Envios (tracking, costo, empresa, tipo, estado, pedido_id, eliminado)
SELECT 
    'CONC-TRK-' || LPAD(p.id::text, 3, '0'),
    150.00,
    'ANDREANI',
    'ESTANDAR',
    'EN_PREPARACION',
    p.id,
    FALSE
FROM Pedidos p 
WHERE p.numero LIKE 'CONC-%';

-- =========================================================================
-- SECCIÓN 1: SIMULACIÓN DE ACTUALIZACIÓN CONCURRENTE
-- Demuestra: Actualizaciones simultáneas y posibles bloqueos
-- =========================================================================

-- Simular actualización concurrente del mismo pedido
-- (En la realidad, esto sería desde sesiones diferentes)

-- Transacción 1: Actualizar total del pedido
BEGIN;
UPDATE Pedidos 
SET total = total + 500.00 
WHERE numero = 'CONC-001';
-- En producción: esta transacción mantendría un lock

-- Transacción 2: Intentar actualizar el mismo pedido (simularía bloqueo)
UPDATE Pedidos 
SET estado = 'ENVIADO' 
WHERE numero = 'CONC-001';
-- En producción: esta esperaría hasta que termine la transacción 1

COMMIT;

-- =========================================================================
-- SECCIÓN 2: SIMULACIÓN DE DEADLOCK CONTROLADO
-- Demuestra: Situación de deadlock y su resolución
-- =========================================================================

-- NOTA: PostgreSQL detecta y resuelve deadlocks automáticamente
-- Esta es una simulación didáctica del concepto

BEGIN;
-- Simular: Transacción A actualiza Pedido 1, luego intenta actualizar Pedido 2
UPDATE Pedidos SET total = total + 100 WHERE numero = 'CONC-001';

-- Simular: Transacción B actualiza Pedido 2, luego intenta actualizar Pedido 1
-- (En realidad esto causaría deadlock entre sesiones concurrentes)
BEGIN;
    UPDATE Pedidos SET total = total + 200 WHERE numero = 'CONC-002';
    -- Si fuera concurrente real: UPDATE Pedidos SET total = total + 50 WHERE numero = 'CONC-001';
COMMIT;

COMMIT;

-- =========================================================================
-- SECCIÓN 3: SIMULACIÓN DE NIVELES DE AISLAMIENTO
-- Demuestra: Diferencias entre READ committed y serializable
-- =========================================================================

-- Nivel READ COMMITTED (por defecto)
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Leer datos actuales
SELECT total, clienteNombre FROM Pedidos WHERE numero = 'CONC-001';

-- En producción, otra transacción podría modificar estos datos aquí
-- Releer para simular lectura no repetible
SELECT total, clienteNombre FROM Pedidos WHERE numero = 'CONC-001';

COMMIT;

-- Nivel SERIALIZABLE (más estricto)
BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Leer datos en modo serializable
SELECT total, clienteNombre FROM Pedidos WHERE numero = 'CONC-002';

COMMIT;

-- =========================================================================
-- SECCIÓN 4: FUNCIÓN CON RETRY AUTOMÁTICO
-- Demuestra: Manejo inteligente de errores de concurrencia
-- =========================================================================

-- Función que reintenta operaciones en caso de deadlock o bloqueo
CREATE OR REPLACE FUNCTION fn_transferir_monto_con_retry(
    pedido_origen_id BIGINT,
    pedido_destino_id BIGINT,
    monto_transferir DECIMAL(10,2),
    max_intentos INTEGER DEFAULT 3
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    intento INTEGER := 1;
    pedido_origen_existe BOOLEAN;
    pedido_destino_existe BOOLEAN;
    total_origen DECIMAL(10,2);
BEGIN
    -- Validar que existan los pedidos
    SELECT EXISTS(SELECT 1 FROM Pedidos WHERE id = pedido_origen_id AND eliminado = FALSE) 
    INTO pedido_origen_existe;
    
    SELECT EXISTS(SELECT 1 FROM Pedidos WHERE id = pedido_destino_id AND eliminado = FALSE) 
    INTO pedido_destino_existe;
    
    IF NOT pedido_origen_existe THEN
        RETURN 'ERROR: Pedido origen no encontrado';
    END IF;
    
    IF NOT pedido_destino_existe THEN
        RETURN 'ERROR: Pedido destino no encontrado';
    END IF;
    
    -- Loop de reintentos
    WHILE intento <= max_intentos LOOP
        BEGIN
            -- Verificar fondos suficientes
            SELECT total INTO total_origen 
            FROM Pedidos 
            WHERE id = pedido_origen_id;
            
            IF total_origen < monto_transferir THEN
                RETURN 'ERROR: Fondos insuficientes en pedido origen';
            END IF;
            
            -- Realizar transferencia en transacción
            BEGIN;
                UPDATE Pedidos 
                SET total = total - monto_transferir 
                WHERE id = pedido_origen_id;
                
                UPDATE Pedidos 
                SET total = total + monto_transferir 
                WHERE id = pedido_destino_id;
                
            EXCEPTION
                WHEN serialization_failure OR deadlock_detected THEN
                    -- Reintentarar en caso de deadlock
                    intento := intento + 1;
                    PERFORM pg_sleep(0.1 * intento); -- Backoff exponencial
                    CONTINUE;
            END;
            
            RETURN 'ÉXITO: Transferencia completada en intento ' || intento;
            
        EXCEPTION 
            WHEN OTHERS THEN
                intento := intento + 1;
                IF intento > max_intentos THEN
                    RETURN 'ERROR: Falló después de ' || max_intentos || ' intentos';
                END IF;
                CONTINUE;
        END;
    END LOOP;
    
    RETURN 'ERROR: Máximo de intentos alcanzado';
END;
$$;

-- =========================================================================
-- SECCIÓN 5: PRUEBAS DE LA FUNCIÓN DE RETRY
-- =========================================================================

-- Actualizar algunos pedidos para tener montos específicos
UPDATE Pedidos SET total = 5000.00 WHERE numero = 'CONC-001';
UPDATE Pedidos SET total = 3000.00 WHERE numero = 'CONC-002';

-- Prueba 1: Transferencia exitosa
SELECT fn_transferir_monto_con_retry(
    (SELECT id FROM Pedidos WHERE numero = 'CONC-001'),
    (SELECT id FROM Pedidos WHERE numero = 'CONC-002'),
    500.00
);

-- Verificar resultado
SELECT numero, total FROM Pedidos WHERE numero IN ('CONC-001', 'CONC-002');

-- Prueba 2: Transferencia con pedido inexistente (debe fallar controladamente)
SELECT fn_transferir_monto_con_retry(999999, 999998, 100.00);

-- =========================================================================
-- SECCIÓN 6: ANÁLISIS DE BLOQUEOS ACTIVOS
-- Demuestra: Monitoreo de concurrencia en el sistema
-- =========================================================================

-- Consultar bloqueos activos (normalmente vacía en esta simulación)
SELECT 
    pid,
    state,
    query_start,
    query
FROM pg_stat_activity 
WHERE state = 'active' 
  AND query NOT ILIKE '%pg_stat_activity%'
  AND datname = current_database();

-- =========================================================================
-- VERIFICACIÓN FINAL
-- =========================================================================

SELECT 'SIMULACIÓN DE CONCURRENCIA COMPLETADA' as resultado;