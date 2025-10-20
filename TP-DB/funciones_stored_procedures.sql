-- =========================================================================
-- SISTEMA DE GESTIÓN DE PEDIDOS Y ENVÍOS
-- Archivo: funciones_stored_procedures.sql
-- Propósito: Implementación de lógica de negocio mediante funciones almacenadas
-- Autor: TFI Bases de Datos I - UTN
-- =========================================================================

/*
DESCRIPCIÓN:
Este archivo contiene funciones y procedimientos almacenados que encapsulan
la lógica de negocio del sistema de pedidos y envíos.

VENTAJAS DE LOS STORED PROCEDURES:
- Lógica centralizada en la base de datos
- Mejor rendimiento por pre-compilación
- Transacciones atómicas complejas
- Validaciones de negocio consistentes
- Reutilización de código entre aplicaciones

FUNCIONES IMPLEMENTADAS:
1. Función para despachar envíos (cambio de estado transaccional)
2. Función para calcular costos de envío dinámicos
3. Función para generar reportes de cliente
4. Procedimiento para limpieza de datos históricos
*/

-- =========================================================================
-- FUNCIÓN 1: DESPACHO DE ENVÍOS CON VALIDACIONES DE NEGOCIO
-- Propósito: Procesar despacho de envío con todas las validaciones necesarias
-- =========================================================================

CREATE OR REPLACE FUNCTION fn_procesar_despacho_envio(
    p_tracking VARCHAR,
    p_fecha_despacho DATE DEFAULT CURRENT_DATE
)
RETURNS TABLE(
    resultado VARCHAR,
    pedido_numero VARCHAR,
    nuevo_estado_envio VARCHAR,
    nuevo_estado_pedido VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_pedido_id BIGINT;
    v_estado_envio_actual VARCHAR;
    v_estado_pedido_actual VARCHAR;
    v_pedido_numero VARCHAR;
BEGIN
    -- Validar que la fecha de despacho no sea futura
    IF p_fecha_despacho > CURRENT_DATE THEN
        RETURN QUERY SELECT 
            'ERROR: La fecha de despacho no puede ser futura'::VARCHAR,
            NULL::VARCHAR, NULL::VARCHAR, NULL::VARCHAR;
        RETURN;
    END IF;

    -- Obtener información del envío y pedido asociado
    SELECT E.pedido_id, E.estado, P.estado, P.numero
    INTO v_pedido_id, v_estado_envio_actual, v_estado_pedido_actual, v_pedido_numero
    FROM Envios E
    INNER JOIN Pedidos P ON E.pedido_id = P.id
    WHERE E.tracking = p_tracking AND E.eliminado = FALSE;

    -- Validar que el envío existe
    IF NOT FOUND THEN
        RETURN QUERY SELECT 
            'ERROR: No se encontró envío activo con el tracking especificado'::VARCHAR,
            NULL::VARCHAR, NULL::VARCHAR, NULL::VARCHAR;
        RETURN;
    END IF;

    -- Validar estado actual del envío
    IF v_estado_envio_actual != 'EN_PREPARACION' THEN
        RETURN QUERY SELECT 
            ('ADVERTENCIA: El envío ya fue despachado. Estado actual: ' || v_estado_envio_actual)::VARCHAR,
            v_pedido_numero, v_estado_envio_actual, v_estado_pedido_actual;
        RETURN;
    END IF;

    -- Validar que el pedido esté en estado válido para despacho
    IF v_estado_pedido_actual NOT IN ('FACTURADO', 'ENVIADO') THEN
        RETURN QUERY SELECT 
            ('ERROR: Pedido no está listo para despacho. Estado actual: ' || v_estado_pedido_actual)::VARCHAR,
            v_pedido_numero, v_estado_envio_actual, v_estado_pedido_actual;
        RETURN;
    END IF;

    -- Realizar el despacho (transacción atómica)
    UPDATE Envios
    SET 
        estado = 'EN_TRANSITO',
        fechaDespacho = p_fecha_despacho
    WHERE tracking = p_tracking;

    -- Actualizar estado del pedido si no estaba ya enviado
    IF v_estado_pedido_actual = 'FACTURADO' THEN
        UPDATE Pedidos
        SET estado = 'ENVIADO'
        WHERE id = v_pedido_id;
        v_estado_pedido_actual = 'ENVIADO';
    END IF;

    -- Retornar resultado exitoso
    RETURN QUERY SELECT 
        'ÉXITO: Envío despachado correctamente'::VARCHAR,
        v_pedido_numero,
        'EN_TRANSITO'::VARCHAR,
        v_estado_pedido_actual;
END;
$$;

COMMENT ON FUNCTION fn_procesar_despacho_envio IS 
'Procesa el despacho de un envío con validaciones completas de negocio';

-- =========================================================================
-- FUNCIÓN 2: CÁLCULO DINÁMICO DE COSTOS DE ENVÍO
-- Propósito: Calcular costo de envío basado en reglas de negocio complejas
-- =========================================================================

CREATE OR REPLACE FUNCTION fn_calcular_costo_envio(
    p_empresa VARCHAR,
    p_tipo VARCHAR,
    p_valor_pedido DECIMAL,
    p_codigo_postal VARCHAR DEFAULT NULL
)
RETURNS DECIMAL(10,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_costo_base DECIMAL(10,2);
    v_multiplicador DECIMAL(3,2) := 1.0;
    v_descuento DECIMAL(3,2) := 0.0;
    v_costo_final DECIMAL(10,2);
BEGIN
    -- Costo base por empresa
    CASE p_empresa
        WHEN 'ANDREANI' THEN v_costo_base := 120.00;
        WHEN 'OCA' THEN v_costo_base := 100.00;
        WHEN 'CORREO_ARG' THEN v_costo_base := 80.00;
        ELSE v_costo_base := 150.00; -- Empresa desconocida
    END CASE;

    -- Multiplicador por tipo de envío
    IF p_tipo = 'EXPRES' THEN
        v_multiplicador := 1.5;
    END IF;

    -- Descuento por valor del pedido
    CASE 
        WHEN p_valor_pedido >= 5000.00 THEN v_descuento := 0.20; -- 20% descuento
        WHEN p_valor_pedido >= 2000.00 THEN v_descuento := 0.10; -- 10% descuento
        WHEN p_valor_pedido >= 1000.00 THEN v_descuento := 0.05; -- 5% descuento
        ELSE v_descuento := 0.00; -- Sin descuento
    END CASE;

    -- Recargo por zona (simulado con código postal)
    IF p_codigo_postal IS NOT NULL AND 
       (p_codigo_postal LIKE '9%' OR p_codigo_postal LIKE '8%') THEN
        v_multiplicador := v_multiplicador + 0.3; -- Zona alejada +30%
    END IF;

    -- Cálculo final
    v_costo_final := v_costo_base * v_multiplicador * (1 - v_descuento);
    
    -- Costo mínimo de $50
    IF v_costo_final < 50.00 THEN
        v_costo_final := 50.00;
    END IF;

    RETURN ROUND(v_costo_final, 2);
END;
$$;

COMMENT ON FUNCTION fn_calcular_costo_envio IS 
'Calcula costo de envío basado en empresa, tipo, valor del pedido y ubicación';

-- =========================================================================
-- FUNCIÓN 3: GENERADOR DE REPORTE DE CLIENTE
-- Propósito: Generar reporte completo de actividad de un cliente
-- =========================================================================

CREATE OR REPLACE FUNCTION fn_reporte_cliente(p_cliente_nombre VARCHAR)
RETURNS TABLE(
    seccion VARCHAR,
    metrica VARCHAR,
    valor TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_pedidos INTEGER;
    v_facturacion_total DECIMAL;
    v_primer_pedido DATE;
    v_ultimo_pedido DATE;
    v_ticket_promedio DECIMAL;
    v_pedidos_enviados INTEGER;
    v_costo_envio_total DECIMAL;
BEGIN
    -- Obtener métricas básicas
    SELECT 
        COUNT(*),
        COALESCE(SUM(total), 0),
        MIN(fecha),
        MAX(fecha),
        COALESCE(AVG(total), 0),
        COUNT(CASE WHEN estado = 'ENVIADO' THEN 1 END)
    INTO 
        v_total_pedidos, v_facturacion_total, v_primer_pedido,
        v_ultimo_pedido, v_ticket_promedio, v_pedidos_enviados
    FROM Pedidos 
    WHERE clienteNombre = p_cliente_nombre AND eliminado = FALSE;

    -- Obtener costo total de envíos
    SELECT COALESCE(SUM(E.costo), 0)
    INTO v_costo_envio_total
    FROM Envios E
    INNER JOIN Pedidos P ON E.pedido_id = P.id
    WHERE P.clienteNombre = p_cliente_nombre 
    AND P.eliminado = FALSE AND E.eliminado = FALSE;

    -- Validar que el cliente existe
    IF v_total_pedidos = 0 THEN
        RETURN QUERY SELECT 
            'ERROR'::VARCHAR,
            'Cliente no encontrado'::VARCHAR,
            p_cliente_nombre::TEXT;
        RETURN;
    END IF;

    -- Información básica
    RETURN QUERY SELECT 
        'INFORMACIÓN BÁSICA'::VARCHAR,
        'Cliente'::VARCHAR,
        p_cliente_nombre::TEXT;
    
    RETURN QUERY SELECT 
        'INFORMACIÓN BÁSICA'::VARCHAR,
        'Total de pedidos'::VARCHAR,
        v_total_pedidos::TEXT;
    
    RETURN QUERY SELECT 
        'INFORMACIÓN BÁSICA'::VARCHAR,
        'Pedidos enviados'::VARCHAR,
        v_pedidos_enviados::TEXT;

    -- Métricas financieras
    RETURN QUERY SELECT 
        'MÉTRICAS FINANCIERAS'::VARCHAR,
        'Facturación total'::VARCHAR,
        ('$' || TO_CHAR(v_facturacion_total, 'FM999,999,999.00'))::TEXT;
    
    RETURN QUERY SELECT 
        'MÉTRICAS FINANCIERAS'::VARCHAR,
        'Ticket promedio'::VARCHAR,
        ('$' || TO_CHAR(v_ticket_promedio, 'FM999,999.00'))::TEXT;
    
    RETURN QUERY SELECT 
        'MÉTRICAS FINANCIERAS'::VARCHAR,
        'Costos de envío'::VARCHAR,
        ('$' || TO_CHAR(v_costo_envio_total, 'FM999,999.00'))::TEXT;

    -- Información temporal
    RETURN QUERY SELECT 
        'INFORMACIÓN TEMPORAL'::VARCHAR,
        'Primer pedido'::VARCHAR,
        TO_CHAR(v_primer_pedido, 'DD/MM/YYYY')::TEXT;
    
    RETURN QUERY SELECT 
        'INFORMACIÓN TEMPORAL'::VARCHAR,
        'Último pedido'::VARCHAR,
        TO_CHAR(v_ultimo_pedido, 'DD/MM/YYYY')::TEXT;

    -- Clasificación del cliente
    RETURN QUERY SELECT 
        'CLASIFICACIÓN'::VARCHAR,
        'Categoría'::VARCHAR,
        CASE 
            WHEN v_facturacion_total > 50000 THEN 'VIP'
            WHEN v_facturacion_total > 20000 THEN 'PREMIUM'
            WHEN v_facturacion_total > 5000 THEN 'REGULAR'
            ELSE 'NUEVO'
        END::TEXT;
END;
$$;

COMMENT ON FUNCTION fn_reporte_cliente IS 
'Genera reporte completo de actividad y métricas de un cliente';

-- =========================================================================
-- FUNCIÓN 4: LIMPIEZA DE DATOS HISTÓRICOS
-- Propósito: Archivar o limpiar registros antiguos según políticas de retención
-- =========================================================================

CREATE OR REPLACE FUNCTION fn_limpieza_datos_historicos(
    p_dias_retencion INTEGER DEFAULT 365,
    p_solo_simulacion BOOLEAN DEFAULT TRUE
)
RETURNS TABLE(
    accion VARCHAR,
    tabla VARCHAR,
    registros_afectados INTEGER,
    fecha_corte DATE
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_fecha_corte DATE;
    v_pedidos_archivados INTEGER;
    v_envios_archivados INTEGER;
BEGIN
    -- Calcular fecha de corte
    v_fecha_corte := CURRENT_DATE - p_dias_retencion;
    
    -- Contar pedidos que serían afectados
    SELECT COUNT(*) INTO v_pedidos_archivados
    FROM Pedidos 
    WHERE fecha < v_fecha_corte AND eliminado = FALSE;
    
    -- Contar envíos que serían afectados
    SELECT COUNT(*) INTO v_envios_archivados
    FROM Envios E
    INNER JOIN Pedidos P ON E.pedido_id = P.id
    WHERE P.fecha < v_fecha_corte AND E.eliminado = FALSE;

    -- Retornar información de la simulación
    RETURN QUERY SELECT 
        CASE WHEN p_solo_simulacion THEN 'SIMULACIÓN' ELSE 'EJECUCIÓN' END::VARCHAR,
        'Pedidos'::VARCHAR,
        v_pedidos_archivados,
        v_fecha_corte;
    
    RETURN QUERY SELECT 
        CASE WHEN p_solo_simulacion THEN 'SIMULACIÓN' ELSE 'EJECUCIÓN' END::VARCHAR,
        'Envios'::VARCHAR,
        v_envios_archivados,
        v_fecha_corte;

    -- Si no es simulación, realizar el archivado (baja lógica)
    IF NOT p_solo_simulacion THEN
        -- Marcar envíos como eliminados
        UPDATE Envios 
        SET eliminado = TRUE
        WHERE pedido_id IN (
            SELECT id FROM Pedidos WHERE fecha < v_fecha_corte
        );
        
        -- Marcar pedidos como eliminados
        UPDATE Pedidos 
        SET eliminado = TRUE
        WHERE fecha < v_fecha_corte AND eliminado = FALSE;
        
        RETURN QUERY SELECT 
            'COMPLETADO'::VARCHAR,
            'Archivado'::VARCHAR,
            v_pedidos_archivados + v_envios_archivados,
            v_fecha_corte;
    END IF;
END;
$$;

COMMENT ON FUNCTION fn_limpieza_datos_historicos IS 
'Archiva datos históricos antiguos según política de retención';

-- =========================================================================
-- EJEMPLOS DE USO DE LAS FUNCIONES
-- =========================================================================

-- Ejemplo 1: Despachar un envío
/*
SELECT * FROM fn_procesar_despacho_envio('TRK00001A1B2C');
*/

-- Ejemplo 2: Calcular costo de envío
/*
SELECT fn_calcular_costo_envio('OCA', 'EXPRES', 2500.00, '1425');
*/

-- Ejemplo 3: Generar reporte de cliente
/*
SELECT * FROM fn_reporte_cliente('Ana García');
*/

-- Ejemplo 4: Simulación de limpieza de datos
/*
SELECT * FROM fn_limpieza_datos_historicos(730, TRUE); -- 2 años, solo simulación
*/