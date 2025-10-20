-- =========================================================================
-- SISTEMA DE GESTIÓN DE PEDIDOS Y ENVÍOS
-- Archivo: transacciones_atomicidad.sql
-- Propósito: Demostración de control transaccional y propiedades ACID
-- Autor: TFI Bases de Datos I - UTN
-- =========================================================================

/*
DESCRIPCIÓN:
Este archivo demuestra el manejo de transacciones en PostgreSQL,
mostrando las propiedades ACID (Atomicidad, Consistencia, Aislamiento, Durabilidad).

CONCEPTOS DEMOSTRADOS:
- Atomicidad: Las transacciones se ejecutan completamente o no se ejecutan
- Consistencia: Las restricciones de integridad se mantienen
- Rollback automático: Cuando una operación falla, toda la transacción se deshace
- Control explícito: COMMIT y ROLLBACK manuales

ESCENARIOS DE PRUEBA:
1. Transacción exitosa con múltiples operaciones
2. Transacción fallida que debe hacer rollback
3. Savepoints para rollback parcial
4. Verificación de estado después de transacciones
*/

-- =========================================================================
-- PRUEBA 1: TRANSACCIÓN EXITOSA - CREACIÓN COMPLETA DE PEDIDO Y ENVÍO
-- Objetivo: Demostrar atomicidad en operación exitosa
-- =========================================================================

BEGIN TRANSACTION;

-- Insertar nuevo pedido
INSERT INTO Pedidos (numero, fecha, clienteNombre, total, estado, eliminado)
VALUES ('TXN-TEST-001', CURRENT_DATE, 'Cliente Transaccional', 2500.00, 'NUEVO', FALSE);

-- Obtener el ID del pedido recién creado
-- En una aplicación real esto se haría con RETURNING o en una sola operación
DO $$
DECLARE
    nuevo_pedido_id BIGINT;
BEGIN
    SELECT id INTO nuevo_pedido_id 
    FROM Pedidos 
    WHERE numero = 'TXN-TEST-001';
    
    -- Insertar el envío asociado
    INSERT INTO Envios (
        tracking, costo, empresa, tipo, estado, 
        fechaDespacho, fechaEstimada, pedido_id, eliminado
    )
    VALUES (
        'TXN-TRACK-001', 150.00, 'OCA', 'ESTANDAR', 'EN_PREPARACION',
        CURRENT_DATE + 1, CURRENT_DATE + 5, nuevo_pedido_id, FALSE
    );
    
    -- Actualizar estado del pedido a FACTURADO
    UPDATE Pedidos 
    SET estado = 'FACTURADO' 
    WHERE id = nuevo_pedido_id;
END $$;

-- Confirmar la transacción (todas las operaciones se guardan)
COMMIT;

-- Verificación de la transacción exitosa
SELECT 'TRANSACCIÓN EXITOSA - Pedido creado:' AS resultado,
       P.numero, P.estado, E.tracking
FROM Pedidos P
JOIN Envios E ON P.id = E.pedido_id
WHERE P.numero = 'TXN-TEST-001';

-- =========================================================================
-- PRUEBA 2: TRANSACCIÓN FALLIDA - ROLLBACK AUTOMÁTICO
-- Objetivo: Demostrar rollback automático cuando una operación viola restricciones
-- =========================================================================

-- Iniciar transacción que DEBE fallar
BEGIN TRANSACTION;

-- Operación 1: Inserción válida de pedido
INSERT INTO Pedidos (numero, fecha, clienteNombre, total, estado, eliminado)
VALUES ('TXN-FAIL-001', CURRENT_DATE, 'Cliente Fallido', 1500.00, 'NUEVO', FALSE);

-- Operación 2: Inserción de envío con pedido_id que no existe (DEBE FALLAR)
-- Esto violará la restricción de clave foránea
INSERT INTO Envios (
    tracking, costo, empresa, tipo, estado, 
    pedido_id, eliminado
)
VALUES (
    'TXN-FAIL-TRACK', 100.00, 'ANDREANI', 'ESTANDAR', 'EN_PREPARACION',
    999999, FALSE  -- ID que no existe, causará fallo
);

-- Esta línea no se ejecutará debido al error anterior
-- COMMIT; -- No se alcanza debido al error

-- Verificación: El pedido NO debe existir (rollback automático)
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN 'CORRECTO: Rollback automático funcionó'
        ELSE 'ERROR: El rollback no funcionó'
    END AS resultado_test_rollback
FROM Pedidos 
WHERE numero = 'TXN-FAIL-001';

-- =========================================================================
-- PRUEBA 3: TRANSACCIÓN CON SAVEPOINT Y ROLLBACK PARCIAL
-- Objetivo: Demostrar control granular con savepoints
-- =========================================================================

BEGIN TRANSACTION;

-- Insertar pedido base
INSERT INTO Pedidos (numero, fecha, clienteNombre, total, estado, eliminado)
VALUES ('TXN-SAVE-001', CURRENT_DATE, 'Cliente Savepoint', 3000.00, 'NUEVO', FALSE);

-- Crear savepoint después de la inserción exitosa
SAVEPOINT pedido_creado;

-- Intentar operación que puede fallar
DO $$
DECLARE
    pedido_id_var BIGINT;
BEGIN
    SELECT id INTO pedido_id_var FROM Pedidos WHERE numero = 'TXN-SAVE-001';
    
    -- Inserción válida de envío
    INSERT INTO Envios (
        tracking, costo, empresa, tipo, estado, 
        pedido_id, eliminado
    )
    VALUES (
        'SAVE-TRACK-001', 200.00, 'OCA', 'ESTANDAR', 'EN_PREPARACION',
        pedido_id_var, FALSE
    );
    
    -- Crear otro savepoint
    SAVEPOINT envio_creado;
    
    -- Intentar actualización inválida (estado no válido)
    BEGIN
        UPDATE Pedidos 
        SET estado = 'ESTADO_INVALIDO'  -- Esto violará CHECK constraint
        WHERE numero = 'TXN-SAVE-001';
    EXCEPTION 
        WHEN check_violation THEN
            -- Rollback al savepoint anterior (mantiene pedido y envío)
            ROLLBACK TO SAVEPOINT envio_creado;
            
            -- Actualización válida
            UPDATE Pedidos 
            SET estado = 'FACTURADO'
            WHERE numero = 'TXN-SAVE-001';
    END;
END $$;

-- Confirmar transacción con cambios parciales
COMMIT;

-- Verificación del savepoint
SELECT 'SAVEPOINT TEST:' AS resultado,
       P.numero, P.estado AS estado_pedido, E.tracking
FROM Pedidos P
JOIN Envios E ON P.id = E.pedido_id
WHERE P.numero = 'TXN-SAVE-001';

-- =========================================================================
-- PRUEBA 4: TRANSACCIÓN CON ROLLBACK MANUAL
-- Objetivo: Demostrar rollback explícito basado en lógica de negocio
-- =========================================================================

BEGIN TRANSACTION;

-- Variables para control de lógica
DO $$
DECLARE
    pedido_count INTEGER;
    cliente_total DECIMAL;
BEGIN
    -- Insertar nuevo pedido
    INSERT INTO Pedidos (numero, fecha, clienteNombre, total, estado, eliminado)
    VALUES ('TXN-MANUAL-001', CURRENT_DATE, 'Ana García', 8000.00, 'NUEVO', FALSE);
    
    -- Verificar si el cliente supera límite de crédito (ejemplo: $50,000)
    SELECT COALESCE(SUM(total), 0) INTO cliente_total
    FROM Pedidos 
    WHERE clienteNombre = 'Ana García' AND eliminado = FALSE;
    
    -- Lógica de negocio: Si supera $50,000, rechazar pedido
    IF cliente_total > 50000 THEN
        RAISE NOTICE 'Cliente supera límite de crédito: $%', cliente_total;
        ROLLBACK;  -- Rollback manual por regla de negocio
    ELSE
        RAISE NOTICE 'Pedido aprobado. Total cliente: $%', cliente_total;
        -- Continuar con la transacción...
    END IF;
END $$;

-- Si llegamos aquí, el pedido fue aprobado
COMMIT;

-- =========================================================================
-- LIMPIEZA Y VERIFICACIÓN FINAL
-- =========================================================================

-- Mostrar todos los pedidos de prueba creados
SELECT 
    'RESUMEN TRANSACCIONES' AS seccion,
    P.numero,
    P.estado,
    COALESCE(E.tracking, 'Sin envío') AS tracking,
    CASE 
        WHEN P.numero LIKE 'TXN-%' THEN 'Pedido de prueba transaccional'
        ELSE 'Pedido regular'
    END AS tipo_pedido
FROM Pedidos P
LEFT JOIN Envios E ON P.id = E.pedido_id AND E.eliminado = FALSE
WHERE P.numero LIKE 'TXN-%'
ORDER BY P.numero;

-- Limpiar datos de prueba (opcional)
-- DELETE FROM Envios WHERE tracking LIKE 'TXN-%' OR tracking LIKE 'SAVE-%';
-- DELETE FROM Pedidos WHERE numero LIKE 'TXN-%';

/*
RESULTADOS ESPERADOS:
1. TXN-TEST-001: Debe existir con estado FACTURADO y envío asociado
2. TXN-FAIL-001: NO debe existir (rollback automático)
3. TXN-SAVE-001: Debe existir con estado FACTURADO (savepoint funcionó)
4. TXN-MANUAL-001: Depende del total acumulado del cliente Ana García

LECCIONES APRENDIDAS:
- Las transacciones garantizan atomicidad (todo o nada)
- Los errores causan rollback automático
- Los savepoints permiten rollback parcial
- Se puede hacer rollback manual por lógica de negocio
- Las restricciones de integridad se validan en cada operación
*/