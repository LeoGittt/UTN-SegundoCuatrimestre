-- =========================================================================
-- Archivo: 04_indices.sql
-- Integrantes: Leonel González y Gonzalo Inga  
-- UTN - TFI Bases de Datos I - Octubre 2025
-- =========================================================================

-- IMPORTANTE: Este script va ANTES de cargar los 20K registros
-- Es más eficiente crear los índices primero y después cargar los datos
-- PostgreSQL mantiene los índices automáticamente durante los INSERT

-- Creamos índices para las consultas más comunes que vamos a usar

-- =========================================================================
-- LIMPIEZA PREVIA (IDEMPOTENCIA)
-- =========================================================================
DROP INDEX IF EXISTS idx_pedidos_fecha_total;
DROP INDEX IF EXISTS idx_envios_empresa_estado;
DROP INDEX IF EXISTS idx_envios_tracking;
DROP INDEX IF EXISTS idx_pedidos_cliente_fecha;
DROP INDEX IF EXISTS idx_envios_pedido_id;

-- Índice para búsquedas por fecha ordenadas por monto
-- sirve para los reportes de top pedidos del mes
CREATE INDEX idx_pedidos_fecha_total 
ON Pedidos (fecha, total DESC)
WHERE eliminado = FALSE;

-- =========================================================================
-- ÍNDICE 2: OPTIMIZACIÓN PARA CONSULTAS DE ENVÍOS POR EMPRESA Y ESTADO
-- =========================================================================

-- Índice compuesto para análisis logísticos por empresa y estado
-- Útil para: reportes por transportista, seguimiento de estados
CREATE INDEX idx_envios_empresa_estado 
ON Envios (empresa, estado, fechaEstimada)
WHERE eliminado = FALSE;

COMMENT ON INDEX idx_envios_empresa_estado IS 
'Optimiza consultas logísticas por empresa y estado de envío';

-- =========================================================================
-- ÍNDICE 3: OPTIMIZACIÓN PARA BÚSQUEDAS DE TRAZABILIDAD
-- =========================================================================

-- Índice para búsquedas rápidas por número de tracking
-- Útil para: consultas de clientes sobre estado de envío
CREATE INDEX idx_envios_tracking 
ON Envios (tracking)
WHERE eliminado = FALSE AND tracking IS NOT NULL;

COMMENT ON INDEX idx_envios_tracking IS 
'Optimiza búsquedas por código de tracking para trazabilidad';

-- =========================================================================
-- ÍNDICE 4: OPTIMIZACIÓN PARA CONSULTAS POR CLIENTE
-- =========================================================================

-- Índice para consultas por cliente y fecha
-- Útil para: historial de pedidos por cliente
CREATE INDEX idx_pedidos_cliente_fecha 
ON Pedidos (clienteNombre, fecha DESC)
WHERE eliminado = FALSE;

COMMENT ON INDEX idx_pedidos_cliente_fecha IS 
'Optimiza consultas de historial por cliente';

-- =========================================================================
-- ÍNDICE 5: OPTIMIZACIÓN PARA LA RELACIÓN 1:1
-- =========================================================================

-- Índice en la clave foránea para optimizar JOINs
-- PostgreSQL crea automáticamente índices en PKs pero no en FKs
CREATE INDEX idx_envios_pedido_id 
ON Envios (pedido_id)
WHERE eliminado = FALSE;

COMMENT ON INDEX idx_envios_pedido_id IS 
'Optimiza JOINs entre Pedidos y Envíos (relación 1:1)';

-- =========================================================================
-- VERIFICACIÓN DE ÍNDICES CREADOS
-- =========================================================================

-- Consulta para verificar los índices creados
SELECT 
    'ÍNDICES CREADOS EXITOSAMENTE' as resultado,
    COUNT(*) as total_indices
FROM pg_indexes 
WHERE tablename IN ('pedidos', 'envios')
AND schemaname = 'public'
AND indexname LIKE 'idx_%';

-- Detalle de índices creados
SELECT 
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes 
WHERE tablename IN ('pedidos', 'envios')
AND schemaname = 'public'
AND indexname LIKE 'idx_%'
ORDER BY tablename, indexname;