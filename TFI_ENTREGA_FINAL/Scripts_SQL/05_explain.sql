-- =========================================================================
-- Archivo: 05_explain.sql  
-- Integrantes: Leonel González y Gonzalo Inga
-- UTN - TFI Bases de Datos I - Octubre 2025
-- =========================================================================

-- Acá medimos si nuestros índices realmente mejoran las consultas
-- EXPLAIN ANALYZE nos dice cuánto tarda cada query y si usa los índices
-- Con 20K registros deberíamos ver diferencias claras

-- =========================================================================
-- PREPARACIÓN: LIMPIAR ESTADÍSTICAS Y ACTUALIZAR ANALYZE
-- =========================================================================
ANALYZE Pedidos;
ANALYZE Envios;

-- =========================================================================
-- MEDICIÓN 1: CONSULTA DE IGUALDAD CON ÍNDICE
-- Evalúa: Utilización de índices en filtros por igualdad
-- =========================================================================

-- Verificar que el índice existe
CREATE INDEX IF NOT EXISTS idx_pedidos_cliente_fecha 
ON Pedidos (clienteNombre, fecha DESC) 
WHERE eliminado = FALSE;

-- EXPLAIN ANALYZE para filtro por cliente
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT P.numero, P.fecha, P.total, P.clienteNombre
FROM Pedidos P
WHERE P.clienteNombre = 'Juan Pérez' AND P.eliminado = FALSE
ORDER BY P.fecha DESC;

SELECT 'MEDICIÓN 1 COMPLETADA: Consulta por cliente con índice' as resultado;

-- =========================================================================
-- MEDICIÓN 2: CONSULTA DE RANGO CON ÍNDICE COMPUESTO
-- Evalúa: Eficiencia de índices en filtros por rangos
-- =========================================================================

-- Verificar que el índice existe
CREATE INDEX IF NOT EXISTS idx_pedidos_fecha_total 
ON Pedidos (fecha, total DESC) 
WHERE eliminado = FALSE;

-- EXPLAIN ANALYZE para consulta de rango
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT P.numero, P.fecha, P.total, P.estado
FROM Pedidos P
WHERE P.fecha BETWEEN '2024-06-01' AND '2024-06-30'
  AND P.eliminado = FALSE
ORDER BY P.total DESC
LIMIT 20;

SELECT 'MEDICIÓN 2 COMPLETADA: Consulta por rango de fechas con índice' as resultado;

-- =========================================================================
-- MEDICIÓN 3: JOIN ENTRE TABLAS CON ÍNDICE EN FK
-- Evalúa: Eficiencia de JOINs con índices en claves foráneas
-- =========================================================================

-- Verificar que el índice en FK existe
CREATE INDEX IF NOT EXISTS idx_envios_pedido_id 
ON Envios (pedido_id) 
WHERE eliminado = FALSE;

-- EXPLAIN ANALYZE para JOIN optimizado
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT 
    P.numero,
    P.clienteNombre,
    P.total,
    E.tracking,
    E.empresa,
    E.estado
FROM Pedidos P
INNER JOIN Envios E ON P.id = E.pedido_id
WHERE P.eliminado = FALSE 
  AND E.eliminado = FALSE
  AND P.total > 5000
ORDER BY P.total DESC
LIMIT 20;

SELECT 'MEDICIÓN 3 COMPLETADA: JOIN entre Pedidos y Envios con índices' as resultado;

-- =========================================================================
-- MEDICIÓN 4: CONSULTA COMPLEJA CON AGREGACIONES
-- Evalúa: Performance de GROUP BY y funciones agregadas
-- =========================================================================

-- EXPLAIN ANALYZE para consulta con agregación
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT 
    E.empresa,
    COUNT(*) as total_envios,
    ROUND(AVG(E.costo)::NUMERIC, 2) as costo_promedio,
    ROUND(AVG(P.total)::NUMERIC, 2) as pedido_promedio
FROM Pedidos P
JOIN Envios E ON P.id = E.pedido_id
WHERE P.eliminado = FALSE 
  AND E.eliminado = FALSE
  AND P.fecha >= '2024-01-01'
GROUP BY E.empresa
ORDER BY total_envios DESC;

SELECT 'MEDICIÓN 4 COMPLETADA: Consulta con agregaciones y GROUP BY' as resultado;

-- =========================================================================
-- MEDICIÓN 5: ANÁLISIS DE UTILIZACIÓN DE ÍNDICES
-- Evalúa: Estadísticas de uso de los índices creados
-- =========================================================================

-- Actualizar estadísticas después de las consultas
ANALYZE;

-- Verificar utilización de índices
SELECT 
    'ESTADÍSTICAS DE ÍNDICES' as seccion,
    schemaname,
    tablename,
    indexname,
    idx_scan as veces_utilizado,
    idx_tup_read as tuplas_leidas,
    idx_tup_fetch as tuplas_obtenidas
FROM pg_stat_user_indexes 
WHERE tablename IN ('pedidos', 'envios')
  AND indexname LIKE 'idx_%'
ORDER BY idx_scan DESC;

-- =========================================================================
-- MEDICIÓN 6: COMPARACIÓN DE PERFORMANCE SIN ÍNDICES
-- Evalúa: Diferencia de rendimiento sin optimización
-- =========================================================================

-- Crear tabla temporal sin índices para comparación
CREATE TEMP TABLE pedidos_sin_indices AS 
SELECT * FROM Pedidos WHERE eliminado = FALSE;

-- EXPLAIN ANALYZE sin índices (Sequential Scan)
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT numero, fecha, total, clienteNombre
FROM pedidos_sin_indices
WHERE clienteNombre = 'Juan Pérez'
ORDER BY fecha DESC;

SELECT 'MEDICIÓN 6 COMPLETADA: Comparación sin índices (Sequential Scan)' as resultado;

-- =========================================================================
-- RESUMEN DE ANÁLISIS DE RENDIMIENTO
-- =========================================================================

SELECT 'ANÁLISIS DE RENDIMIENTO COMPLETADO' as resultado;

SELECT 
    'RESUMEN EJECUTIVO' as seccion,
    'Índices creados: ' || COUNT(*) as indices_implementados
FROM pg_indexes 
WHERE tablename IN ('pedidos', 'envios')
  AND schemaname = 'public'
  AND indexname LIKE 'idx_%';

SELECT 
    'RECOMENDACIONES' as seccion,
    'Los índices mejoran significativamente el rendimiento de consultas' as conclusion,
    'Index Scan vs Sequential Scan demuestra la optimización' as evidencia;

-- Limpiar tabla temporal
DROP TABLE IF EXISTS pedidos_sin_indices;