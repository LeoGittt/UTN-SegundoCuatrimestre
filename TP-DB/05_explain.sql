-- =========================================================================
-- SISTEMA DE GESTIÓN DE PEDIDOS Y ENVÍOS
-- Archivo: analisis_rendimiento.sql
-- Propósito: Análisis de planes de ejecución y optimización de consultas
-- Autor: TFI Bases de Datos I - UTN
-- =========================================================================

/*
DESCRIPCIÓN:
Este archivo contiene consultas con EXPLAIN ANALYZE para evaluar el rendimiento
y efectividad de los índices creados en el sistema.

OBJETIVOS:
- Analizar planes de ejecución de consultas complejas
- Verificar utilización de índices
- Identificar cuellos de botella de performance
- Validar estrategias de optimización

MÉTRICAS EVALUADAS:
- Tiempo total de ejecución
- Número de filas procesadas
- Utilización de índices vs. escaneos completos
- Eficiencia de JOINs y filtros

NOTA: Ejecutar después de crear índices y cargar datos masivos
*/

-- =========================================================================
-- MEDICIÓN 1: CONSULTA DE IGUALDAD (FILTRO WHERE = valor específico)
-- Evalúa: Utilización de índices en filtros por igualdad
-- =========================================================================

-- CORRIDA 1 SIN ÍNDICE
DROP INDEX IF EXISTS idx_pedidos_cliente_fecha;
\timing on
SELECT P.numero, P.fecha, P.total, P.clienteNombre
FROM Pedidos P
WHERE P.clienteNombre = 'Ana García' AND P.eliminado = FALSE
ORDER BY P.fecha DESC;
-- Ejecutar 3 veces y anotar tiempos

-- CORRIDA 1 CON ÍNDICE  
CREATE INDEX idx_pedidos_cliente_fecha ON Pedidos (clienteNombre, fecha DESC) WHERE eliminado = FALSE;
ANALYZE Pedidos;

-- Ejecutar la misma consulta 3 veces más y anotar tiempos
SELECT P.numero, P.fecha, P.total, P.clienteNombre
FROM Pedidos P
WHERE P.clienteNombre = 'Ana García' AND P.eliminado = FALSE
ORDER BY P.fecha DESC;

-- EXPLAIN para análisis
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT P.numero, P.fecha, P.total, P.clienteNombre
FROM Pedidos P
WHERE P.clienteNombre = 'Ana García' AND P.eliminado = FALSE
ORDER BY P.fecha DESC;

/*
RESULTADOS MEDICIÓN 1 - IGUALDAD:
Sin índice - Corrida 1: ___ms, Corrida 2: ___ms, Corrida 3: ___ms | Mediana: ___ms
Con índice - Corrida 1: ___ms, Corrida 2: ___ms, Corrida 3: ___ms | Mediana: ___ms
Mejora: ___ms (___% más rápido)
*/

-- =========================================================================
-- MEDICIÓN 2: CONSULTA DE RANGO (BETWEEN, >=, <=)  
-- Evalúa: Eficiencia de índices en filtros por rangos
-- =========================================================================

-- CORRIDA 2 SIN ÍNDICE
DROP INDEX IF EXISTS idx_pedidos_fecha_total;
\timing on
SELECT P.numero, P.fecha, P.total, P.estado
FROM Pedidos P
WHERE P.fecha BETWEEN '2024-06-01' AND '2024-06-30'
  AND P.eliminado = FALSE
ORDER BY P.total DESC
LIMIT 20;
-- Ejecutar 3 veces y anotar tiempos

-- CORRIDA 2 CON ÍNDICE
CREATE INDEX idx_pedidos_fecha_total ON Pedidos (fecha, total DESC) WHERE eliminado = FALSE;
ANALYZE Pedidos;

-- Ejecutar la misma consulta 3 veces más y anotar tiempos  
SELECT P.numero, P.fecha, P.total, P.estado
FROM Pedidos P
WHERE P.fecha BETWEEN '2024-06-01' AND '2024-06-30'
  AND P.eliminado = FALSE
ORDER BY P.total DESC
LIMIT 20;

-- EXPLAIN para análisis
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT P.numero, P.fecha, P.total, P.estado
FROM Pedidos P
WHERE P.fecha BETWEEN '2024-06-01' AND '2024-06-30'
  AND P.eliminado = FALSE
ORDER BY P.total DESC
LIMIT 20;

/*
RESULTADOS MEDICIÓN 2 - RANGO:
Sin índice - Corrida 1: ___ms, Corrida 2: ___ms, Corrida 3: ___ms | Mediana: ___ms
Con índice - Corrida 1: ___ms, Corrida 2: ___ms, Corrida 3: ___ms | Mediana: ___ms
Mejora: ___ms (___% más rápido)
*/

-- =========================================================================
-- MEDICIÓN 3: CONSULTA CON JOIN 
-- Evalúa: Eficiencia de índices en operaciones JOIN
-- =========================================================================

-- CORRIDA 3 SIN ÍNDICE
DROP INDEX IF EXISTS idx_envios_pedido_id;
DROP INDEX IF EXISTS idx_envios_empresa_estado;
\timing on
SELECT P.numero, P.clienteNombre, P.total,
       E.tracking, E.empresa, E.estado AS estado_envio
FROM Pedidos P
INNER JOIN Envios E ON P.id = E.pedido_id
WHERE E.empresa = 'OCA' 
  AND E.estado = 'ENTREGADO'
  AND P.eliminado = FALSE 
  AND E.eliminado = FALSE
ORDER BY P.total DESC
LIMIT 15;
-- Ejecutar 3 veces y anotar tiempos

-- CORRIDA 3 CON ÍNDICES
CREATE INDEX idx_envios_pedido_id ON Envios (pedido_id) WHERE eliminado = FALSE;
CREATE INDEX idx_envios_empresa_estado ON Envios (empresa, estado, fechaEstimada) WHERE eliminado = FALSE;
ANALYZE Pedidos;
ANALYZE Envios;

-- Ejecutar la misma consulta 3 veces más y anotar tiempos
SELECT P.numero, P.clienteNombre, P.total,
       E.tracking, E.empresa, E.estado AS estado_envio
FROM Pedidos P
INNER JOIN Envios E ON P.id = E.pedido_id
WHERE E.empresa = 'OCA' 
  AND E.estado = 'ENTREGADO'
  AND P.eliminado = FALSE 
  AND E.eliminado = FALSE
ORDER BY P.total DESC
LIMIT 15;

-- EXPLAIN para análisis
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT P.numero, P.clienteNombre, P.total,
       E.tracking, E.empresa, E.estado AS estado_envio
FROM Pedidos P
INNER JOIN Envios E ON P.id = E.pedido_id
WHERE E.empresa = 'OCA' 
  AND E.estado = 'ENTREGADO'
  AND P.eliminado = FALSE 
  AND E.eliminado = FALSE
ORDER BY P.total DESC
LIMIT 15;

/*
RESULTADOS MEDICIÓN 3 - JOIN:
Sin índice - Corrida 1: ___ms, Corrida 2: ___ms, Corrida 3: ___ms | Mediana: ___ms
Con índice - Corrida 1: ___ms, Corrida 2: ___ms, Corrida 3: ___ms | Mediana: ___ms
Mejora: ___ms (___% más rápido)
*/

-- =========================================================================
-- ANÁLISIS 2: CONSULTA DE AGREGACIÓN POR GRUPO
-- Evalúa: Eficiencia de GROUP BY y HAVING
-- =========================================================================

EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT
    E.empresa,
    E.tipo,
    COUNT(*) AS total_envios,
    ROUND(AVG(E.costo)::NUMERIC, 2) AS costo_promedio,
    ROUND(SUM(E.costo)::NUMERIC, 2) AS costo_total
FROM 
    Envios E
WHERE
    E.eliminado = FALSE
    AND E.fechaDespacho BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY 
    E.empresa, E.tipo
HAVING 
    AVG(E.costo) > 200.00
ORDER BY 
    costo_promedio DESC;

/*
ANÁLISIS ESPERADO:
- Debe utilizar idx_envios_empresa_estado para filtros y agrupamiento
- HashAggregate o GroupAggregate según cardinalidad
- Filtro HAVING aplicado después de agregación
*/

-- =========================================================================
-- ANÁLISIS 3: BÚSQUEDA POR TRACKING (CONSULTA FRECUENTE)
-- Evalúa: Eficiencia de búsqueda por clave única
-- =========================================================================

EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT 
    P.numero,
    P.clienteNombre,
    P.fecha,
    P.total,
    P.estado AS estado_pedido,
    E.tracking,
    E.empresa,
    E.estado AS estado_envio,
    E.fechaEstimada
FROM 
    Pedidos P
INNER JOIN 
    Envios E ON P.id = E.pedido_id
WHERE 
    E.tracking LIKE 'TRK0001%'
    AND P.eliminado = FALSE
    AND E.eliminado = FALSE;

/*
ANÁLISIS ESPERADO:
- Debe utilizar idx_envios_tracking para búsqueda por tracking
- Index Scan o Bitmap Index Scan según selectividad
- Nested Loop Join eficiente por clave primaria
*/

-- =========================================================================
-- ANÁLISIS 4: CONSULTA SIN ÍNDICES (COMPARACIÓN)
-- Evalúa: Performance sin optimización para comparar mejoras
-- =========================================================================

-- Temporalmente remover un índice para comparación
DROP INDEX IF EXISTS idx_pedidos_fecha_total;

EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT 
    P.numero,
    P.total,
    P.fecha
FROM 
    Pedidos P
WHERE 
    P.fecha BETWEEN '2024-06-01' AND '2024-06-30'
    AND P.eliminado = FALSE
ORDER BY 
    P.total DESC
LIMIT 20;

-- Recrear el índice
CREATE INDEX idx_pedidos_fecha_total 
ON Pedidos (fecha, total DESC)
WHERE eliminado = FALSE;

-- Ejecutar la misma consulta con índice
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT 
    P.numero,
    P.total,
    P.fecha
FROM 
    Pedidos P
WHERE 
    P.fecha BETWEEN '2024-06-01' AND '2024-06-30'
    AND P.eliminado = FALSE
ORDER BY 
    P.total DESC
LIMIT 20;

/*
COMPARACIÓN ESPERADA:
- Sin índice: Sequential Scan + Sort (costoso)
- Con índice: Index Scan (eficiente, sin ordenamiento adicional)
- Mejora significativa en tiempo de ejecución
*/

-- =========================================================================
-- ANÁLISIS 5: ESTADÍSTICAS DE TABLAS
-- Evalúa: Información para el optimizador de consultas
-- =========================================================================

-- Actualizar estadísticas para decisiones óptimas del query planner
ANALYZE Pedidos;
ANALYZE Envios;

-- Verificar estadísticas de las tablas
SELECT 
    schemaname,
    tablename,
    n_tup_ins AS inserciones,
    n_tup_upd AS actualizaciones,
    n_tup_del AS eliminaciones,
    n_live_tup AS filas_activas,
    n_dead_tup AS filas_muertas,
    last_analyze AS ultima_analisis
FROM pg_stat_user_tables 
WHERE tablename IN ('pedidos', 'envios');

-- =========================================================================
-- TABLA RESUMEN DE MEDICIONES
-- =========================================================================

/*
TABLA COMPARATIVA DE TIEMPOS (completar con mediciones reales):

┌─────────────────┬─────────────┬─────────────┬──────────────┬─────────────────┐
│ Tipo Consulta   │ Sin Índice  │ Con Índice  │ Mejora (ms)  │ Mejora (%)      │
├─────────────────┼─────────────┼─────────────┼──────────────┼─────────────────┤
│ Igualdad        │ ___ms       │ ___ms       │ ___ms        │ ____%           │
│ Rango           │ ___ms       │ ___ms       │ ___ms        │ ____%           │  
│ JOIN            │ ___ms       │ ___ms       │ ___ms        │ ____%           │
└─────────────────┴─────────────┴─────────────┴──────────────┴─────────────────┘

CONCLUSIONES (5-10 líneas):
1. [Completar] Los índices muestran mayor beneficio en consultas de tipo ____
2. [Completar] La mejora más significativa se observó en ____
3. [Completar] En consultas JOIN, la reducción de tiempo fue de ____
4. [Completar] Los índices compuestos son especialmente efectivos para ____
5. [Completar] Para datasets de 10K registros, el impacto es ____ pero sería mayor con volúmenes de 200K-500K
*/

-- =========================================================================
-- REPORTE DE UTILIZACIÓN DE ÍNDICES
-- =========================================================================

SELECT 
    schemaname,
    tablename,
    indexname,
    idx_tup_read AS lecturas_indice,
    idx_tup_fetch AS accesos_tabla_via_indice
FROM pg_stat_user_indexes 
WHERE schemaname = 'public' 
AND tablename IN ('pedidos', 'envios')
ORDER BY idx_tup_read DESC;

-- =========================================================================
-- INSTRUCCIONES PARA COMPLETAR LAS MEDICIONES
-- =========================================================================

/*
PASOS PARA REALIZAR LAS MEDICIONES:

1. Ejecutar cada sección de medición (1, 2, 3) completa
2. Para cada consulta, ejecutar exactamente 3 veces y anotar los tiempos
3. Calcular la mediana de las 3 corridas (valor del medio)
4. Completar la tabla comparativa con los resultados reales
5. Escribir conclusiones basadas en los resultados observados

EJEMPLO DE MEDICIÓN:
- Corrida 1: 45ms, Corrida 2: 42ms, Corrida 3: 48ms → Mediana: 45ms
- Sin índice mediana: 45ms, Con índice mediana: 12ms  
- Mejora: 33ms (73% más rápido)

NOTAS IMPORTANTES:
- \timing on debe estar activo para ver los tiempos
- Ejecutar ANALYZE después de crear índices
- Los tiempos pueden variar, por eso se hacen 3 corridas
- Fijarse en los EXPLAIN ANALYZE para entender los planes de ejecución
*/