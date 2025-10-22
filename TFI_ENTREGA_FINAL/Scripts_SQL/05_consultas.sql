-- =========================================================================
-- Archivo: 05_consultas.sql
-- Integrantes: Leonel González y Gonzalo Inga
-- UTN - TFI Bases de Datos I - Octubre 2025
-- =========================================================================

-- Acá ponemos todas las consultas complejas que nos pidieron
-- Usamos JOINs, GROUP BY, subconsultas y CTEs
-- Cada consulta está pensada para mostrar diferentes técnicas de SQL

-- =========================================================================
-- CONSULTA 1: ANÁLISIS DE COSTOS PROMEDIO POR EMPRESA Y TIPO DE ENVÍO
-- Técnicas: GROUP BY, HAVING, funciones de agregación
-- =========================================================================

SELECT
    'ANÁLISIS DE COSTOS LOGÍSTICOS' as reporte,
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
    -- Solo mostrar combinaciones con volumen significativo
    COUNT(*) > 50  -- Mínimo 50 envíos para estadística confiable
ORDER BY 
    costo_promedio DESC, E.empresa, E.tipo;

-- =========================================================================
-- CONSULTA 2: TOP 10 PEDIDOS DE MAYOR VALOR CON INFORMACIÓN LOGÍSTICA
-- Técnicas: JOIN, ORDER BY, LIMIT, formateo de datos
-- =========================================================================

SELECT
    'TOP 10 PEDIDOS DE MAYOR VALOR' as reporte,
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
-- CONSULTA 3: PEDIDOS DE ALTO VALOR CON SUBCONSULTA
-- Técnicas: Subconsulta, filtros complejos, JOIN específico
-- =========================================================================

SELECT
    'PEDIDOS SUPERIORES AL PROMEDIO' as reporte,
    P.numero,
    P.clienteNombre,
    P.total,
    E.tracking,
    E.empresa,
    E.fechaEstimada,
    E.costo AS costo_envio,
    (P.total + E.costo) AS costo_total_cliente
FROM 
    Pedidos P
JOIN
    Envios E ON P.id = E.pedido_id
WHERE
    P.eliminado = FALSE
    AND E.eliminado = FALSE
    AND P.total > (
        -- Subconsulta: Pedidos que superan el promedio general
        SELECT AVG(P2.total) 
        FROM Pedidos P2 
        WHERE P2.eliminado = FALSE
    )
    AND P.fecha BETWEEN '2024-01-01' AND '2024-12-31'
    AND E.estado IN ('EN_TRANSITO', 'ENTREGADO')
ORDER BY
    P.total DESC
LIMIT 15;

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
    'RANKING DE EMPRESAS TRANSPORTISTAS' as reporte,
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
-- Técnicas: Múltiples agregaciones, formateo avanzado, GROUP BY temporal
-- =========================================================================

SELECT 
    'RESUMEN EJECUTIVO MENSUAL' as reporte,
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
HAVING 
    COUNT(DISTINCT P.id) > 0  -- Solo meses con actividad
ORDER BY 
    mes DESC
LIMIT 12;

-- =========================================================================
-- CONSULTA 6: ANÁLISIS DE CLIENTES VIP
-- Técnicas: Agregaciones, clasificación por valor, múltiples criterios
-- =========================================================================

SELECT 
    'ANÁLISIS DE CLIENTES VIP' as reporte,
    P.clienteNombre,
    COUNT(P.id) AS total_pedidos,
    SUM(P.total) AS facturacion_total,
    ROUND(AVG(P.total)::NUMERIC, 2) AS ticket_promedio,
    MAX(P.fecha) AS ultima_compra,
    COUNT(DISTINCT E.empresa) AS empresas_utilizadas,
    CASE 
        WHEN SUM(P.total) > 50000 THEN 'VIP_PLATINUM'
        WHEN SUM(P.total) > 20000 THEN 'VIP_GOLD'
        WHEN SUM(P.total) > 10000 THEN 'VIP_SILVER'
        ELSE 'REGULAR'
    END AS categoria_cliente
FROM 
    Pedidos P
LEFT JOIN 
    Envios E ON P.id = E.pedido_id
WHERE 
    P.eliminado = FALSE
GROUP BY 
    P.clienteNombre
HAVING 
    COUNT(P.id) >= 3  -- Mínimo 3 pedidos
ORDER BY 
    facturacion_total DESC
LIMIT 20;