-- =========================================================================
-- Archivo: 08_transacciones.sql
-- Integrantes: Leonel González y Gonzalo Inga
-- UTN - TFI Bases de Datos I - Octubre 2025
-- =========================================================================

-- Acá probamos las transacciones ACID como vimos en teoría
-- Hacemos pruebas con COMMIT (todo sale bien) y ROLLBACK (algo falla)
-- PostgreSQL maneja esto automáticamente cuando hay errores

-- =========================================================================
-- LIMPIEZA PREVIA (IDEMPOTENCIA)
-- =========================================================================
-- Eliminar datos de prueba anteriores
DELETE FROM Envios WHERE tracking LIKE 'TXN-%';
DELETE FROM Pedidos WHERE numero LIKE 'TXN-%';

-- =========================================================================
-- SECCIÓN 1: TRANSACCIÓN EXITOSA CON COMMIT
-- Demuestra: Atomicidad exitosa - todas las operaciones se confirman
-- =========================================================================

BEGIN;

-- Insertar pedido de prueba
INSERT INTO Pedidos (numero, fecha, clienteNombre, total, estado, eliminado)
VALUES ('TXN-TEST-001', '2024-10-22', 'Cliente Transaccional', 1500.00, 'FACTURADO', FALSE);

-- Obtener el ID del pedido recién insertado
DO $$
DECLARE
    pedido_id_nuevo BIGINT;
BEGIN
    SELECT id INTO pedido_id_nuevo 
    FROM Pedidos 
    WHERE numero = 'TXN-TEST-001';
    
    -- Insertar envío asociado en la misma transacción
    INSERT INTO Envios (tracking, costo, empresa, tipo, estado, fechaDespacho, fechaEstimada, pedido_id, eliminado)
    VALUES ('TXN-TRACK-001', 120.00, 'ANDREANI', 'ESTANDAR', 'EN_PREPARACION', '2024-10-23', '2024-10-26', pedido_id_nuevo, FALSE);
    
    RAISE NOTICE 'Pedido y envío insertados correctamente en la transacción';
END $$;

-- Confirmar transacción (COMMIT)
COMMIT;

-- Verificar que la transacción se completó exitosamente
SELECT 
    'TRANSACCIÓN EXITOSA - Pedido creado:' as resultado,
    numero,
    estado,
    (SELECT tracking FROM Envios WHERE pedido_id = p.id) as tracking
FROM Pedidos p 
WHERE numero = 'TXN-TEST-001';

-- =========================================================================
-- SECCIÓN 2: TRANSACCIÓN FALLIDA CON ROLLBACK AUTOMÁTICO
-- Demuestra: Rollback automático cuando hay errores
-- =========================================================================

BEGIN;

-- Insertar pedido válido
INSERT INTO Pedidos (numero, fecha, clienteNombre, total, estado, eliminado)
VALUES ('TXN-ROLLBACK-001', '2024-10-22', 'Cliente Rollback', 800.00, 'NUEVO', FALSE);

-- Intentar insertar envío con pedido_id inexistente (debe fallar)
-- Esto provocará un error y PostgreSQL hará ROLLBACK automático
INSERT INTO Envios (tracking, costo, empresa, tipo, estado, pedido_id, eliminado)
VALUES ('TXN-ERROR-001', 80.00, 'OCA', 'ESTANDAR', 'EN_PREPARACION', 999999, FALSE);

-- Intentar más operaciones (serán ignoradas porque la transacción está abortada)
INSERT INTO Pedidos (numero, fecha, clienteNombre, total, estado, eliminado)
VALUES ('TXN-NUNCA-001', '2024-10-22', 'Nunca Existirá', 100.00, 'NUEVO', FALSE);

UPDATE Pedidos SET estado = 'PROCESADO' WHERE numero = 'TXN-ROLLBACK-001';

-- PostgreSQL ignorará el COMMIT porque hubo errores
COMMIT;

-- Verificar que la transacción se revirtió completamente
SELECT 
    'Verificación de ROLLBACK:' as resultado,
    numero,
    estado_pedido,
    tracking
FROM (
    SELECT 
        numero,
        estado as estado_pedido,
        'Sin envío' as tracking
    FROM Pedidos 
    WHERE numero IN ('TXN-ROLLBACK-001', 'TXN-NUNCA-001')
    
    UNION ALL
    
    SELECT 
        'Sin pedido' as numero,
        'Sin estado' as estado_pedido,
        tracking
    FROM Envios 
    WHERE tracking = 'TXN-ERROR-001'
) resultados;

-- =========================================================================
-- SECCIÓN 3: TRANSACCIÓN COMPLEJA CON VALIDACIONES DE NEGOCIO
-- Demuestra: Lógica de negocio dentro de transacciones
-- =========================================================================

BEGIN;

-- Simular un proceso de aprobación de pedido con validaciones
DO $$
DECLARE
    pedido_id_proceso BIGINT;
    total_cliente DECIMAL(10,2);
BEGIN
    -- Insertar pedido inicial
    INSERT INTO Pedidos (numero, fecha, clienteNombre, total, estado, eliminado)
    VALUES ('TXN-MANUAL-001', '2024-10-22', 'Cliente Manual', 3500.00, 'NUEVO', FALSE)
    RETURNING id INTO pedido_id_proceso;
    
    -- Simular validación de crédito del cliente
    SELECT total INTO total_cliente FROM Pedidos WHERE id = pedido_id_proceso;
    
    IF total_cliente > 5000 THEN
        RAISE EXCEPTION 'Cliente excede límite de crédito: $%', total_cliente;
    END IF;
    
    -- Simular aprobación automática
    IF total_cliente > 1000 THEN
        RAISE NOTICE 'Pedido aprobado. Total cliente: $%', total_cliente;
    END IF;
    
    -- El pedido queda en estado NUEVO, sin envío hasta aprobación manual
END $$;

COMMIT;

-- =========================================================================
-- VERIFICACIÓN FINAL DE TRANSACCIONES
-- =========================================================================

-- Mostrar resumen de todas las transacciones de prueba
SELECT 
    'RESUMEN TRANSACCIONES' as seccion,
    numero,
    estado,
    COALESCE((SELECT tracking FROM Envios WHERE pedido_id = p.id), 'Sin envío') as tracking,
    'Pedido de prueba transaccional' as tipo_pedido
FROM Pedidos p 
WHERE numero LIKE 'TXN-%'
ORDER BY numero;

SELECT 'PRUEBAS DE TRANSACCIONES COMPLETADAS' as resultado;