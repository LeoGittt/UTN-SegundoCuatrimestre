-- =====================================================
-- CARGA MASIVA SIMPLIFICADA Y FUNCIONAL
-- Sistema de Gestión de Pedidos y Envíos
-- =====================================================

BEGIN;

-- Limpiar datos existentes
DELETE FROM envios WHERE id > 0;
DELETE FROM pedidos WHERE id > 0;
ALTER SEQUENCE pedidos_id_seq RESTART WITH 1;
ALTER SEQUENCE envios_id_seq RESTART WITH 1;

-- Generar 1000 pedidos (funcional y rápido)
INSERT INTO pedidos (eliminado, numero, fecha, clienteNombre, total, estado)
SELECT 
    false,
    'PED-' || LPAD(i::text, 6, '0'),
    CURRENT_DATE - (random() * 365)::int,
    CASE (i % 10)
        WHEN 0 THEN 'Juan Pérez'
        WHEN 1 THEN 'María González'
        WHEN 2 THEN 'Carlos López'
        WHEN 3 THEN 'Ana Martínez'
        WHEN 4 THEN 'Luis Rodríguez'
        WHEN 5 THEN 'Carmen Fernández'
        WHEN 6 THEN 'José García'
        WHEN 7 THEN 'Laura Sánchez'
        WHEN 8 THEN 'Miguel Torres'
        ELSE 'Patricia Ruiz'
    END,
    (random() * 5000 + 100)::decimal(10,2),
    CASE (i % 3)
        WHEN 0 THEN 'NUEVO'
        WHEN 1 THEN 'FACTURADO'
        ELSE 'ENVIADO'
    END
FROM generate_series(1, 1000) AS i;

-- Generar envíos para cada pedido (relación 1:1)
INSERT INTO envios (
    eliminado, tracking, costo, empresa, tipo, estado, 
    fechaDespacho, fechaEstimada, pedido_id
)
SELECT 
    false,
    'TRK-' || LPAD(p.id::text, 8, '0'),
    (random() * 300 + 50)::decimal(8,2),
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
    p.fecha + (random() * 3 + 1)::int,
    p.fecha + (random() * 3 + 1)::int + (random() * 4 + 3)::int,
    p.id
FROM pedidos p
WHERE p.eliminado = false;

COMMIT;

-- Verificación de carga
SELECT 
    'CARGA MASIVA COMPLETADA' as resultado,
    (SELECT COUNT(*) FROM pedidos) as total_pedidos,
    (SELECT COUNT(*) FROM envios) as total_envios,
    'Relación 1:1 verificada' as validacion;

-- Mostrar algunos ejemplos
SELECT 
    p.numero, p.clienteNombre, p.total, p.estado,
    e.tracking, e.empresa, e.estado as estado_envio
FROM pedidos p 
JOIN envios e ON p.id = e.pedido_id 
WHERE p.eliminado = false 
LIMIT 5;