-- =========================================================================
-- Archivo: 06_vistas.sql
-- Integrantes: Leonel González y Gonzalo Inga  
-- UTN - TFI Bases de Datos I - Octubre 2025
-- =========================================================================

-- Las vistas nos sirven para simplificar consultas complejas
-- En vez de escribir JOINs largos cada vez, usamos las vistas
-- También podemos controlar qué datos ve cada usuario

-- =========================================================================
-- LIMPIEZA PREVIA (IDEMPOTENCIA)
-- =========================================================================
DROP VIEW IF EXISTS vista_pedidos_activos CASCADE;
DROP VIEW IF EXISTS vista_trazabilidad_logistica CASCADE;
DROP VIEW IF EXISTS vista_costos_por_empresa CASCADE;
DROP VIEW IF EXISTS vista_dashboard_kpis CASCADE;

-- =========================================================================
-- VISTA 1: PEDIDOS ACTIVOS RESUMIDOS
-- Propósito: Acceso rápido a pedidos en proceso (excluye eliminados)
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
        WHEN P.estado = 'NUEVO' THEN 'Pendiente procesamiento'
        ELSE 'Estado desconocido'
    END AS descripcion_estado,
    -- Días desde la creación del pedido
    CURRENT_DATE - P.fecha AS dias_transcurridos,
    -- Categorización por valor
    CASE 
        WHEN P.total > 5000 THEN 'ALTO_VALOR'
        WHEN P.total > 2000 THEN 'MEDIO_VALOR'
        ELSE 'BAJO_VALOR'
    END AS categoria_valor
FROM
    Pedidos P
WHERE
    P.eliminado = FALSE
ORDER BY P.fecha DESC;

COMMENT ON VIEW vista_pedidos_activos IS 
'Vista de pedidos activos con información formateada y categorizaciones';

-- =========================================================================
-- VISTA 2: TRAZABILIDAD LOGÍSTICA COMPLETA
-- Propósito: Vista integrada de pedidos y envíos para seguimiento
-- =========================================================================

CREATE OR REPLACE VIEW vista_trazabilidad_logistica AS
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
    
    -- Cálculos de tiempo
    CASE 
        WHEN E.fechaDespacho IS NULL THEN 'Sin despachar'
        WHEN E.fechaEstimada < CURRENT_DATE AND E.estado != 'ENTREGADO' THEN 'RETRASADO'
        WHEN E.estado = 'ENTREGADO' THEN 'ENTREGADO A TIEMPO'
        ELSE 'EN PROCESO'
    END AS evaluacion_tiempo,
    
    -- Costo total para el cliente
    P.total + E.costo AS costo_total_cliente,
    
    -- Estado consolidado
    CASE 
        WHEN P.estado = 'ENVIADO' AND E.estado = 'ENTREGADO' THEN 'COMPLETADO'
        WHEN P.estado = 'ENVIADO' AND E.estado IN ('EN_TRANSITO', 'EN_PREPARACION') THEN 'EN_TRANSITO'
        WHEN P.estado = 'FACTURADO' THEN 'PREPARANDO_ENVIO'
        ELSE 'PENDIENTE'
    END AS estado_consolidado
FROM
    Pedidos P
INNER JOIN
    Envios E ON P.id = E.pedido_id
WHERE
    P.eliminado = FALSE 
    AND E.eliminado = FALSE
ORDER BY P.fecha DESC;

COMMENT ON VIEW vista_trazabilidad_logistica IS 
'Vista completa de trazabilidad que combina información de pedidos y envíos';

-- =========================================================================
-- VISTA 3: ANÁLISIS DE COSTOS POR EMPRESA
-- Propósito: Estadísticas agregadas por empresa transportista
-- =========================================================================

CREATE OR REPLACE VIEW vista_costos_por_empresa AS
SELECT
    E.empresa,
    COUNT(*) AS total_envios,
    ROUND(AVG(E.costo)::NUMERIC, 2) AS costo_promedio,
    ROUND(MIN(E.costo)::NUMERIC, 2) AS costo_minimo,
    ROUND(MAX(E.costo)::NUMERIC, 2) AS costo_maximo,
    ROUND(SUM(E.costo)::NUMERIC, 2) AS costo_total,
    
    -- Distribución por tipo de envío
    COUNT(CASE WHEN E.tipo = 'ESTANDAR' THEN 1 END) AS envios_estandar,
    COUNT(CASE WHEN E.tipo = 'EXPRES' THEN 1 END) AS envios_express,
    
    -- Análisis de estados
    COUNT(CASE WHEN E.estado = 'ENTREGADO' THEN 1 END) AS entregas_exitosas,
    COUNT(CASE WHEN E.estado = 'EN_TRANSITO' THEN 1 END) AS en_transito,
    COUNT(CASE WHEN E.estado = 'EN_PREPARACION' THEN 1 END) AS en_preparacion,
    
    -- Porcentaje de éxito
    ROUND(
        (COUNT(CASE WHEN E.estado = 'ENTREGADO' THEN 1 END) * 100.0 / COUNT(*)), 
        2
    ) AS porcentaje_exito,
    
    -- Evaluación de performance
    CASE 
        WHEN (COUNT(CASE WHEN E.estado = 'ENTREGADO' THEN 1 END) * 100.0 / COUNT(*)) >= 95 THEN 'EXCELENTE'
        WHEN (COUNT(CASE WHEN E.estado = 'ENTREGADO' THEN 1 END) * 100.0 / COUNT(*)) >= 90 THEN 'BUENO'
        WHEN (COUNT(CASE WHEN E.estado = 'ENTREGADO' THEN 1 END) * 100.0 / COUNT(*)) >= 80 THEN 'REGULAR'
        ELSE 'NECESITA_MEJORA'
    END AS calificacion_performance
FROM
    Envios E
WHERE
    E.eliminado = FALSE
GROUP BY
    E.empresa
ORDER BY
    total_envios DESC;

COMMENT ON VIEW vista_costos_por_empresa IS 
'Análisis estadístico completo por empresa transportista';

-- =========================================================================
-- VISTA 4: DASHBOARD EJECUTIVO CON KPIS
-- Propósito: Métricas consolidadas para dashboard ejecutivo
-- =========================================================================

CREATE OR REPLACE VIEW vista_dashboard_kpis AS
SELECT
    'DASHBOARD EJECUTIVO' AS seccion,
    
    -- KPIs principales
    (SELECT COUNT(*) FROM Pedidos WHERE eliminado = FALSE) AS total_pedidos,
    (SELECT COUNT(*) FROM Envios WHERE eliminado = FALSE) AS total_envios,
    
    -- Facturación
    '$' || TO_CHAR(
        (SELECT SUM(total) FROM Pedidos WHERE eliminado = FALSE), 
        'FM999,999,999.00'
    ) AS facturacion_total,
    
    '$' || TO_CHAR(
        (SELECT AVG(total) FROM Pedidos WHERE eliminado = FALSE), 
        'FM999,999.00'
    ) AS ticket_promedio,
    
    -- Logística
    (SELECT COUNT(DISTINCT empresa) FROM Envios WHERE eliminado = FALSE) AS empresas_activas,
    
    '$' || TO_CHAR(
        (SELECT AVG(costo) FROM Envios WHERE eliminado = FALSE), 
        'FM999.00'
    ) AS costo_envio_promedio,
    
    -- Performance
    ROUND(
        (SELECT COUNT(*) * 100.0 / 
         (SELECT COUNT(*) FROM Envios WHERE eliminado = FALSE)
         FROM Envios WHERE estado = 'ENTREGADO' AND eliminado = FALSE), 
        2
    ) || '%' AS tasa_entregas_exitosas,
    
    -- Clientes
    (SELECT COUNT(DISTINCT clienteNombre) FROM Pedidos WHERE eliminado = FALSE) AS clientes_unicos,
    
    -- Estados actuales
    (SELECT COUNT(*) FROM Pedidos WHERE estado = 'NUEVO' AND eliminado = FALSE) AS pedidos_nuevos,
    (SELECT COUNT(*) FROM Pedidos WHERE estado = 'FACTURADO' AND eliminado = FALSE) AS pedidos_facturados,
    (SELECT COUNT(*) FROM Pedidos WHERE estado = 'ENVIADO' AND eliminado = FALSE) AS pedidos_enviados;

COMMENT ON VIEW vista_dashboard_kpis IS 
'Dashboard ejecutivo con KPIs consolidados del negocio';

-- =========================================================================
-- VERIFICACIÓN DE VISTAS CREADAS
-- =========================================================================

SELECT 
    'VISTAS CREADAS EXITOSAMENTE' as resultado,
    COUNT(*) as total_vistas
FROM information_schema.views 
WHERE table_schema = 'public' 
AND table_name LIKE 'vista_%';

-- Listar todas las vistas creadas
SELECT 
    table_name as nombre_vista,
    view_definition as definicion_truncada
FROM information_schema.views 
WHERE table_schema = 'public' 
AND table_name LIKE 'vista_%'
ORDER BY table_name;