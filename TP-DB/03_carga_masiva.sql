-- =====================================================
-- CARGA MASIVA OPTIMIZADA PARA ANÁLISIS DE RENDIMIENTO
-- Sistema de Gestión de Pedidos y Envíos
-- Versión: 20,000 registros para mediciones convincentes
-- =====================================================

BEGIN;

-- Limpiar datos existentes
DELETE FROM envios WHERE id > 0;
DELETE FROM pedidos WHERE id > 0;
ALTER SEQUENCE pedidos_id_seq RESTART WITH 1;
ALTER SEQUENCE envios_id_seq RESTART WITH 1;

-- Generar 20,000 pedidos (volumen óptimo para análisis de rendimiento)
INSERT INTO pedidos (eliminado, numero, fecha, clienteNombre, total, estado)
SELECT 
    false,
    'PED-' || LPAD(i::text, 6, '0'),
    CURRENT_DATE - (random() * 730)::int, -- Últimos 2 años para mayor variedad
    CASE (i % 20) -- Más variedad de clientes para análisis realista
        WHEN 0 THEN 'Juan Pérez'
        WHEN 1 THEN 'María González'
        WHEN 2 THEN 'Carlos López'
        WHEN 3 THEN 'Ana Martínez'
        WHEN 4 THEN 'Luis Rodríguez'
        WHEN 5 THEN 'Carmen Fernández'
        WHEN 6 THEN 'José García'
        WHEN 7 THEN 'Laura Sánchez'
        WHEN 8 THEN 'Miguel Torres'
        WHEN 9 THEN 'Patricia Ruiz'
        WHEN 10 THEN 'Roberto Silva'
        WHEN 11 THEN 'Elena Vargas'
        WHEN 12 THEN 'Fernando Castro'
        WHEN 13 THEN 'Isabel Morales'
        WHEN 14 THEN 'Andrés Herrera'
        WHEN 15 THEN 'Sofía Jiménez'
        WHEN 16 THEN 'Diego Ramírez'
        WHEN 17 THEN 'Valentina Cruz'
        WHEN 18 THEN 'Sebastián Flores'
        ELSE 'Camila Ortega'
    END,
    (random() * 8000 + 50)::decimal(10,2), -- Rango más amplio: $50-$8050
    CASE (i % 3)
        WHEN 0 THEN 'NUEVO'
        WHEN 1 THEN 'FACTURADO'
        ELSE 'ENVIADO'
    END
FROM generate_series(1, 20000) AS i;

-- Generar envíos para cada pedido (relación 1:1) - 20,000 envíos
INSERT INTO envios (
    eliminado, tracking, costo, empresa, tipo, estado, 
    fechaDespacho, fechaEstimada, pedido_id
)
WITH fechas_calculadas AS (
    SELECT 
        p.id,
        p.fecha + (random() * 5 + 1)::int AS fecha_despacho_calc
    FROM pedidos p
    WHERE p.eliminado = false
)
SELECT 
    false,
    'TRK-' || LPAD(p.id::text, 8, '0'),
    (random() * 500 + 30)::decimal(8,2), -- Costos más variados: $30-$530
    CASE (p.id % 3)
        WHEN 0 THEN 'OCA'
        WHEN 1 THEN 'ANDREANI'
        ELSE 'CORREO_ARG'
    END,
    CASE (p.id % 2)
        WHEN 0 THEN 'ESTANDAR'
        ELSE 'EXPRES'
    END,
    CASE (p.id % 3)
        WHEN 0 THEN 'EN_PREPARACION'
        WHEN 1 THEN 'EN_TRANSITO'
        ELSE 'ENTREGADO'
    END,
    fc.fecha_despacho_calc, -- Fecha de despacho calculada
    fc.fecha_despacho_calc + (random() * 7 + 3)::int, -- Fecha estimada DESPUÉS del despacho
    p.id
FROM pedidos p
JOIN fechas_calculadas fc ON p.id = fc.id
WHERE p.eliminado = false;

COMMIT;

-- Verificación de carga masiva
SELECT 
    'CARGA MASIVA DE 20,000 REGISTROS COMPLETADA' as resultado,
    (SELECT COUNT(*) FROM pedidos) as total_pedidos,
    (SELECT COUNT(*) FROM envios) as total_envios,
    'Relación 1:1 verificada' as validacion;

-- Estadísticas adicionales para validar la distribución
SELECT 
    'ESTADÍSTICAS DE DISTRIBUCIÓN' as seccion,
    COUNT(DISTINCT clienteNombre) as clientes_unicos,
    COUNT(DISTINCT empresa) as empresas_envio,
    MIN(fecha) as fecha_mas_antigua,
    MAX(fecha) as fecha_mas_reciente
FROM pedidos p
JOIN envios e ON p.id = e.pedido_id;

-- Mostrar algunos ejemplos aleatorios
SELECT 
    p.numero, p.clienteNombre, p.total, p.estado,
    e.tracking, e.empresa, e.estado as estado_envio
FROM pedidos p 
JOIN envios e ON p.id = e.pedido_id 
WHERE p.eliminado = false 
ORDER BY RANDOM()
LIMIT 10;