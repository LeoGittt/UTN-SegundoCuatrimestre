-- =========================================================================
-- SISTEMA DE GESTIÓN DE PEDIDOS Y ENVÍOS
-- Archivo: vistas_reportes.sql
-- Propósito: Definición de vistas para simplificar acceso a datos y reportes
-- Autor: TFI Bases de Datos I - UTN
-- =========================================================================

/*
DESCRIPCIÓN:
Este archivo define vistas que encapsulan lógica de negocio compleja
y facilitan el acceso a datos para usuarios finales y aplicaciones.

BENEFICIOS DE LAS VISTAS:
- Simplificación de consultas complejas
- Abstracción de la estructura interna
- Reutilización de lógica de negocio
- Control de acceso a datos sensibles
- Mantenimiento centralizado de consultas

VISTAS IMPLEMENTADAS:
1. Vista de pedidos activos (sin baja lógica)
2. Vista de trazabilidad logística completa
3. Vista de resumen ejecutivo por cliente
4. Vista de análisis de performance logística
*/

-- =========================================================================
-- VISTA 1: PEDIDOS ACTIVOS RESUMIDOS
-- Propósito: Acceso rápido a pedidos en proceso (excluye eliminados y nuevos)
-- =========================================================================

CREATE OR REPLACE VIEW vista_pedidos_activos AS
SELECT
    P.id,
    P.numero,
    P.fecha,
    P.clienteNombre,
    '$' || TO_CHAR(P.total, 'FM999,999.00') AS total_formateado,
    P.total AS monto_numerico,
    P.estado,
    CASE 
        WHEN P.estado = 'FACTURADO' THEN 'Listo para envío'
        WHEN P.estado = 'ENVIADO' THEN 'En proceso logístico'
        ELSE 'Pendiente procesamiento'
    END AS descripcion_estado,
    -- Días desde la creación del pedido
    CURRENT_DATE - P.fecha AS dias_transcurridos
FROM
    Pedidos P
WHERE
    P.estado IN ('FACTURADO', 'ENVIADO')
    AND P.eliminado = FALSE
ORDER BY P.fecha DESC;

COMMENT ON VIEW vista_pedidos_activos IS 
'Vista de pedidos en proceso activo (facturados y enviados)';

-- =========================================================================
-- VISTA 2: TRAZABILIDAD LOGÍSTICA COMPLETA
-- Propósito: Vista integrada de pedidos y envíos para seguimiento
-- =========================================================================

CREATE OR REPLACE VIEW vista_trazabilidad_completa AS
SELECT
    -- Información del pedido
    P.numero AS codigo_pedido,
    P.clienteNombre AS cliente,
    TO_CHAR(P.fecha, 'DD/MM/YYYY') AS fecha_pedido,
    P.total AS valor_pedido,
    P.estado AS estado_pedido,
    
    -- Información del envío
    E.tracking AS codigo_seguimiento,
    E.empresa AS transportista,
    E.tipo AS tipo_envio,
    E.costo AS costo_envio,
    E.estado AS estado_logistico,
    
    -- Fechas logísticas
    TO_CHAR(E.fechaDespacho, 'DD/MM/YYYY') AS fecha_despacho,
    TO_CHAR(E.fechaEstimada, 'DD/MM/YYYY') AS fecha_estimada_entrega,
    
    -- Análisis de tiempos
    CASE 
        WHEN E.fechaEstimada < CURRENT_DATE AND E.estado != 'ENTREGADO' THEN 'RETRASADO'
        WHEN E.estado = 'ENTREGADO' THEN 'COMPLETADO'
        WHEN E.fechaDespacho IS NOT NULL THEN 'EN_TRANSITO'
        ELSE 'PREPARACION'
    END AS situacion_actual,
    
    -- Costo total para el cliente
    P.total + E.costo AS costo_total_cliente,
    
    -- Tiempo de procesamiento
    COALESCE(E.fechaDespacho - P.fecha, 0) AS dias_procesamiento
FROM
    Pedidos P
INNER JOIN
    Envios E ON P.id = E.pedido_id
WHERE
    P.eliminado = FALSE 
    AND E.eliminado = FALSE
ORDER BY P.fecha DESC;

COMMENT ON VIEW vista_trazabilidad_completa IS 
'Vista integrada para seguimiento completo de pedidos y envíos';

-- =========================================================================
-- VISTA 3: RESUMEN EJECUTIVO POR CLIENTE
-- Propósito: Análisis consolidado de la actividad por cliente
-- =========================================================================

CREATE OR REPLACE VIEW vista_resumen_clientes AS
SELECT
    P.clienteNombre AS cliente,
    COUNT(P.id) AS total_pedidos,
    COUNT(CASE WHEN P.estado = 'ENVIADO' THEN 1 END) AS pedidos_enviados,
    ROUND(
        (COUNT(CASE WHEN P.estado = 'ENVIADO' THEN 1 END) * 100.0 / COUNT(P.id)), 2
    ) AS porcentaje_conversion,
    
    -- Análisis financiero
    SUM(P.total) AS facturacion_total,
    ROUND(AVG(P.total)::NUMERIC, 2) AS ticket_promedio,
    MAX(P.total) AS pedido_mayor,
    MIN(P.total) AS pedido_menor,
    
    -- Análisis temporal
    MIN(P.fecha) AS primer_pedido,
    MAX(P.fecha) AS ultimo_pedido,
    MAX(P.fecha) - MIN(P.fecha) AS dias_como_cliente,
    
    -- Análisis logístico
    ROUND(AVG(E.costo)::NUMERIC, 2) AS costo_envio_promedio,
    SUM(E.costo) AS total_costos_envio,
    
    -- Clasificación del cliente
    CASE 
        WHEN SUM(P.total) > 50000 THEN 'VIP'
        WHEN SUM(P.total) > 20000 THEN 'PREMIUM'
        WHEN SUM(P.total) > 5000 THEN 'REGULAR'
        ELSE 'NUEVO'
    END AS categoria_cliente
FROM
    Pedidos P
LEFT JOIN
    Envios E ON P.id = E.pedido_id AND E.eliminado = FALSE
WHERE
    P.eliminado = FALSE
GROUP BY
    P.clienteNombre
HAVING
    COUNT(P.id) > 0  -- Al menos un pedido
ORDER BY
    facturacion_total DESC;

COMMENT ON VIEW vista_resumen_clientes IS 
'Análisis consolidado de actividad y valor por cliente';

-- =========================================================================
-- VISTA 4: DASHBOARD DE PERFORMANCE LOGÍSTICA
-- Propósito: KPIs operacionales para gestión logística
-- =========================================================================

CREATE OR REPLACE VIEW vista_performance_logistica AS
SELECT
    E.empresa,
    E.tipo,
    
    -- Volumen operacional
    COUNT(*) AS total_envios,
    COUNT(CASE WHEN E.estado = 'ENTREGADO' THEN 1 END) AS entregas_completadas,
    COUNT(CASE WHEN E.estado = 'EN_TRANSITO' THEN 1 END) AS envios_en_curso,
    COUNT(CASE WHEN E.estado = 'EN_PREPARACION' THEN 1 END) AS envios_preparacion,
    
    -- KPIs de eficiencia
    ROUND(
        (COUNT(CASE WHEN E.estado = 'ENTREGADO' THEN 1 END) * 100.0 / COUNT(*)), 2
    ) AS tasa_entrega_exitosa,
    
    COUNT(CASE WHEN E.fechaEstimada < CURRENT_DATE AND E.estado != 'ENTREGADO' THEN 1 END) AS envios_retrasados,
    
    ROUND(
        (COUNT(CASE WHEN E.fechaEstimada < CURRENT_DATE AND E.estado != 'ENTREGADO' THEN 1 END) * 100.0 / COUNT(*)), 2
    ) AS tasa_retraso,
    
    -- Análisis financiero
    ROUND(AVG(E.costo)::NUMERIC, 2) AS costo_promedio,
    ROUND(SUM(E.costo)::NUMERIC, 2) AS facturacion_logistica,
    ROUND(STDDEV(E.costo)::NUMERIC, 2) AS variabilidad_costos,
    
    -- Análisis temporal
    ROUND(AVG(E.fechaEstimada - E.fechaDespacho)::NUMERIC, 1) AS dias_promedio_entrega,
    
    -- Calificación de performance
    CASE 
        WHEN (COUNT(CASE WHEN E.estado = 'ENTREGADO' THEN 1 END) * 100.0 / COUNT(*)) >= 95 
        THEN 'EXCELENTE'
        WHEN (COUNT(CASE WHEN E.estado = 'ENTREGADO' THEN 1 END) * 100.0 / COUNT(*)) >= 90 
        THEN 'BUENO'
        WHEN (COUNT(CASE WHEN E.estado = 'ENTREGADO' THEN 1 END) * 100.0 / COUNT(*)) >= 80 
        THEN 'REGULAR'
        ELSE 'CRITICO'
    END AS calificacion_servicio
FROM
    Envios E
WHERE
    E.eliminado = FALSE
GROUP BY
    E.empresa, E.tipo
ORDER BY
    tasa_entrega_exitosa DESC, costo_promedio ASC;

COMMENT ON VIEW vista_performance_logistica IS 
'KPIs operacionales y de calidad para gestión logística';

-- =========================================================================
-- VERIFICACIÓN DE VISTAS CREADAS
-- =========================================================================

-- Listar todas las vistas creadas
SELECT 
    table_name as vista,
    view_definition
FROM information_schema.views 
WHERE table_schema = 'public' 
AND table_name LIKE 'vista_%'
ORDER BY table_name;