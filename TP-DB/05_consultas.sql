-- =========================================================================
-- SISTEMA DE GESTIÓN DE PEDIDOS Y ENVÍOS
-- Archivo: consultas_negocio.sql
-- Propósito: Consultas complejas para análisis de negocio y reportes
-- Autor: TFI Bases de Datos I - UTN
-- =========================================================================

/*
DESCRIPCIÓN:
Este archivo contiene consultas SQL complejas que demuestran diferentes
técnicas avanzadas de consulta y proporcionan valor analítico al negocio.

TÉCNICAS IMPLEMENTADAS:
- GROUP BY y HAVING para agregaciones
- JOINs para relacionar entidades
- Subconsultas para filtros complejos
- Funciones de ventana para rankings
- CTEs para consultas legibles
- Funciones de agregación y estadísticas

CASOS DE USO:
- Análisis de costos logísticos
- Identificación de pedidos de alto valor
- Seguimiento de performance por empresa
- Reportes ejecutivos y operacionales
*/

-- =========================================================================
-- CONSULTA 1: ANÁLISIS DE COSTOS PROMEDIO POR EMPRESA Y TIPO DE ENVÍO
-- Técnicas: GROUP BY, HAVING, funciones de agregación
-- =========================================================================

SELECT
    E.empresa,
    E.tipo,
    COUNT(*) AS total_envios,
    ROUND(AVG(E.costo)::NUMERIC, 2) AS costo_promedio,
    ROUND(MIN(E.costo)::NUMERIC, 2) AS costo_minimo,
    ROUND(MAX(E.costo)::NUMERIC, 2) AS costo_maximo,
    ROUND(STDDEV(E.costo)::NUMERIC, 2) AS desviacion_estandar
FROM 
    Envios E
WHERE
    E.eliminado = FALSE
GROUP BY 
    E.empresa, E.tipo
HAVING 
    -- Solo mostrar combinaciones con costo promedio significativo
    AVG(E.costo) > 200.00
    AND COUNT(*) > 50  -- Mínimo 50 envíos para estadística confiable
ORDER BY 
    costo_promedio DESC, E.empresa, E.tipo;

-- =========================================================================
-- CONSULTA 2: TOP 10 PEDIDOS DE MAYOR VALOR CON INFORMACIÓN LOGÍSTICA
-- Técnicas: JOIN, ORDER BY, LIMIT, formateo de datos
-- =========================================================================

SELECT
    P.numero AS numero_pedido,
    P.clienteNombre AS cliente,
    TO_CHAR(P.fecha, 'DD/MM/YYYY') AS fecha_pedido,
    '$' || TO_CHAR(P.total, 'FM999,999.00') AS monto_formateado,
    P.estado AS estado_pedido,
    E.tracking,
    E.empresa AS transportista,
    E.estado AS estado_envio,
    CASE 
        WHEN E.fechaEstimada < CURRENT_DATE AND E.estado != 'ENTREGADO' 
        THEN 'RETRASADO'
        ELSE 'EN_TIEMPO'
    END AS evaluacion_tiempo
FROM 
    Pedidos P
INNER JOIN
    Envios E ON P.id = E.pedido_id
WHERE
    P.eliminado = FALSE 
    AND E.eliminado = FALSE
ORDER BY
    P.total DESC
LIMIT 10;

-- =========================================================================
-- CONSULTA 3: PEDIDOS ENTREGADOS POR OCA EN MARZO 2024 (CON SUBCONSULTA)
-- Técnicas: Subconsulta, filtros de fecha, JOIN específico
-- =========================================================================

SELECT
    P.numero,
    P.clienteNombre,
    P.total,
    E.tracking,
    E.fechaEstimada,
    E.costo AS costo_envio,
    (P.total + E.costo) AS costo_total_cliente
FROM 
    Pedidos P
JOIN
    Envios E ON P.id = E.pedido_id
WHERE
    E.empresa = 'OCA'
    AND E.estado = 'ENTREGADO'
    AND P.fecha BETWEEN '2024-03-01' AND '2024-03-31'
    AND P.eliminado = FALSE
    AND E.eliminado = FALSE
    AND P.id IN (
        -- Subconsulta: Solo pedidos que superan el promedio del mes
        SELECT DISTINCT P2.id 
        FROM Pedidos P2 
        WHERE P2.fecha BETWEEN '2024-03-01' AND '2024-03-31'
        AND P2.total > (
            SELECT AVG(P3.total) 
            FROM Pedidos P3 
            WHERE P3.fecha BETWEEN '2024-03-01' AND '2024-03-31'
        )
    )
ORDER BY
    P.total DESC;

-- =========================================================================
-- CONSULTA 4: ANÁLISIS DE PERFORMANCE POR EMPRESA (CTE Y FUNCIONES VENTANA)
-- Técnicas: CTE, funciones de ventana, CASE WHEN
-- =========================================================================

WITH estadisticas_empresa AS (
    SELECT 
        E.empresa,
        COUNT(*) AS total_envios,
        AVG(E.costo) AS costo_promedio,
        SUM(CASE WHEN E.estado = 'ENTREGADO' THEN 1 ELSE 0 END) AS entregas_exitosas,
        SUM(CASE WHEN E.fechaEstimada < CURRENT_DATE AND E.estado != 'ENTREGADO' 
                 THEN 1 ELSE 0 END) AS envios_retrasados
    FROM Envios E
    WHERE E.eliminado = FALSE
    GROUP BY E.empresa
),
ranking_empresas AS (
    SELECT 
        *,
        ROUND((entregas_exitosas * 100.0 / total_envios), 2) AS tasa_exito,
        ROUND((envios_retrasados * 100.0 / total_envios), 2) AS tasa_retraso,
        RANK() OVER (ORDER BY (entregas_exitosas * 100.0 / total_envios) DESC) AS ranking_performance
    FROM estadisticas_empresa
)
SELECT 
    empresa,
    total_envios,
    ROUND(costo_promedio::NUMERIC, 2) AS costo_promedio,
    entregas_exitosas,
    envios_retrasados,
    tasa_exito || '%' AS porcentaje_exito,
    tasa_retraso || '%' AS porcentaje_retraso,
    ranking_performance AS posicion_ranking,
    CASE 
        WHEN tasa_exito >= 95 THEN 'EXCELENTE'
        WHEN tasa_exito >= 90 THEN 'BUENO'
        WHEN tasa_exito >= 80 THEN 'REGULAR'
        ELSE 'NECESITA_MEJORA'
    END AS calificacion
FROM ranking_empresas
ORDER BY ranking_performance;

-- =========================================================================
-- CONSULTA 5: RESUMEN EJECUTIVO MENSUAL
-- Técnicas: Múltiples agregaciones, formateo avanzado
-- =========================================================================

SELECT 
    TO_CHAR(P.fecha, 'YYYY-MM') AS mes,
    COUNT(DISTINCT P.id) AS pedidos_realizados,
    COUNT(DISTINCT CASE WHEN P.estado = 'ENVIADO' THEN P.id END) AS pedidos_enviados,
    '$' || TO_CHAR(SUM(P.total), 'FM999,999,999.00') AS facturacion_total,
    '$' || TO_CHAR(AVG(P.total), 'FM999,999.00') AS ticket_promedio,
    COUNT(DISTINCT P.clienteNombre) AS clientes_activos,
    ROUND(AVG(E.costo)::NUMERIC, 2) AS costo_envio_promedio
FROM 
    Pedidos P
LEFT JOIN 
    Envios E ON P.id = E.pedido_id AND E.eliminado = FALSE
WHERE 
    P.eliminado = FALSE
    AND P.fecha >= '2024-01-01'
GROUP BY 
    TO_CHAR(P.fecha, 'YYYY-MM')
ORDER BY 
    mes DESC;