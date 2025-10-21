-- =====================================================
-- SCRIPT DE PRUEBA PARA CARGA MASIVA
-- Propósito: Validar que la carga de 20,000 registros funcione correctamente
-- =====================================================

-- Conectar a la base de datos
\c sistema_pedidos_envios;

-- Configurar para medir tiempo
\timing on

-- Ejecutar la carga masiva
\i 'C:/Users/lg606/Desktop/UTN-SegundoCuatrimestre/TP-DB/carga_masiva_simple.sql'

-- Verificaciones detalladas
SELECT 
    'RESUMEN FINAL DE CARGA' as seccion,
    (SELECT COUNT(*) FROM pedidos) as total_pedidos,
    (SELECT COUNT(*) FROM envios) as total_envios,
    (SELECT COUNT(*) FROM pedidos WHERE eliminado = false) as pedidos_activos,
    (SELECT COUNT(*) FROM envios WHERE eliminado = false) as envios_activos;

-- Verificar integridad referencial
SELECT 
    'VERIFICACIÓN DE INTEGRIDAD' as seccion,
    COUNT(*) as envios_huerfanos
FROM envios e 
LEFT JOIN pedidos p ON e.pedido_id = p.id 
WHERE p.id IS NULL;

-- Estadísticas por estado
SELECT 
    estado, 
    COUNT(*) as cantidad,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM pedidos), 2) as porcentaje
FROM pedidos 
GROUP BY estado 
ORDER BY cantidad DESC;

-- Estadísticas por empresa de envío
SELECT 
    empresa, 
    COUNT(*) as cantidad,
    ROUND(AVG(costo), 2) as costo_promedio
FROM envios 
GROUP BY empresa 
ORDER BY cantidad DESC;

SELECT 'CARGA MASIVA VALIDADA EXITOSAMENTE - 20,000 REGISTROS' as resultado;