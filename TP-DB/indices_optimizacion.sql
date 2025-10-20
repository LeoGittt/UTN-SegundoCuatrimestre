-- =========================================================================
-- SISTEMA DE GESTIÓN DE PEDIDOS Y ENVÍOS
-- Archivo: indices_optimizacion.sql
-- Propósito: Creación de índices estratégicos para optimización de consultas
-- Autor: TFI Bases de Datos I - UTN
-- =========================================================================

/*
DESCRIPCIÓN:
Este archivo contiene la definición de índices optimizados para mejorar
el rendimiento de las consultas más frecuentes del sistema.

⚠️ ORDEN CRÍTICO: Este archivo debe ejecutarse ANTES de datos_carga_masiva.sql
RAZÓN: Crear índices antes de cargar 10,000 registros es más eficiente porque:
- PostgreSQL mantiene los índices automáticamente durante las inserciones
- Evita la reconstrucción costosa de índices después de cargas masivas
- Reduce la fragmentación y mejora la performance general
- El tiempo total de ejecución es menor

ESTRATEGIA DE INDEXACIÓN:
- Índices compuestos para consultas con múltiples filtros
- Optimización de ordenamiento y agrupamiento
- Consideración de cardinalidad y selectividad
- Balance entre performance de lectura y escritura

CONSULTAS OPTIMIZADAS:
- Búsquedas por fecha y ordenamiento por total
- Filtros por estado y empresa
- Consultas de trazabilidad por tracking
- Reportes por cliente y período
*/

-- =========================================================================
-- ÍNDICE 1: OPTIMIZACIÓN PARA CONSULTAS POR FECHA Y TOTAL
-- =========================================================================

-- Índice compuesto para consultas que filtran por fecha y ordenan por total
-- Útil para: reportes de pedidos por período, top pedidos por valor
CREATE INDEX idx_pedidos_fecha_total 
ON Pedidos (fecha, total DESC)
WHERE eliminado = FALSE;

COMMENT ON INDEX idx_pedidos_fecha_total IS 
'Optimiza consultas por fecha con ordenamiento por total descendente';

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
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes 
WHERE tablename IN ('pedidos', 'envios')
AND schemaname = 'public'
ORDER BY tablename, indexname;