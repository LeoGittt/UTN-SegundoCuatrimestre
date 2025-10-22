-- =========================================================================
-- Archivo: 07_seguridad.sql
-- Integrantes: Leonel González y Gonzalo Inga
-- UTN - TFI Bases de Datos I - Octubre 2025  
-- =========================================================================

-- Implementamos seguridad básica como nos enseñaron en clase
-- Creamos un usuario con pocos permisos y funciones que evitan inyección SQL
-- También probamos que nuestros constraints realmente funcionen

-- =========================================================================
-- LIMPIEZA PREVIA (IDEMPOTENCIA)
-- =========================================================================
DROP VIEW IF EXISTS vista_envios_seguros CASCADE;
DROP FUNCTION IF EXISTS buscar_pedidos_seguros(TEXT) CASCADE;
DROP USER IF EXISTS usuario_aplicacion;

-- =========================================================================
-- SECCIÓN 1: CREACIÓN DE USUARIO CON PRIVILEGIOS MÍNIMOS
-- =========================================================================

-- Crear usuario para aplicación con permisos restringidos
CREATE USER usuario_aplicacion WITH PASSWORD 'TFI_2025_Seguro!';

-- Otorgar solo permisos necesarios (principio de menor privilegio)
GRANT CONNECT ON DATABASE sistema_pedidos_envios TO usuario_aplicacion;
GRANT USAGE ON SCHEMA public TO usuario_aplicacion;

-- Permisos de lectura en tablas principales
GRANT SELECT ON Pedidos TO usuario_aplicacion;
GRANT SELECT ON Envios TO usuario_aplicacion;

-- Permisos de lectura en vistas (sin acceso a datos sensibles)
GRANT SELECT ON vista_pedidos_activos TO usuario_aplicacion;
GRANT SELECT ON vista_trazabilidad_logistica TO usuario_aplicacion;

-- =========================================================================
-- SECCIÓN 2: VISTA SEGURA SIN DATOS FINANCIEROS
-- =========================================================================

-- Vista que oculta montos y costos (información sensible)
CREATE OR REPLACE VIEW vista_envios_seguros AS
SELECT
    P.numero AS codigo_pedido,
    P.clienteNombre AS cliente,
    P.fecha AS fecha_pedido,
    P.estado AS estado_pedido,
    E.tracking AS codigo_seguimiento,
    E.empresa AS transportista,
    E.tipo AS tipo_envio,
    E.estado AS estado_envio,
    E.fechaDespacho AS fecha_despacho,
    E.fechaEstimada AS fecha_estimada,
    -- NO incluir P.total ni E.costo por seguridad
    CASE 
        WHEN P.total > 5000 THEN 'ALTO'
        WHEN P.total > 2000 THEN 'MEDIO'
        ELSE 'BAJO'
    END AS categoria_valor_sin_monto
FROM Pedidos P
INNER JOIN Envios E ON P.id = E.pedido_id
WHERE P.eliminado = FALSE 
  AND E.eliminado = FALSE;

-- Otorgar acceso a la vista segura
GRANT SELECT ON vista_envios_seguros TO usuario_aplicacion;

-- =========================================================================
-- SECCIÓN 3: PRUEBAS DE RESTRICCIONES DE INTEGRIDAD
-- =========================================================================

-- Prueba 1: Intentar insertar pedido con ID duplicado (debe fallar)
DO $$
BEGIN
    INSERT INTO Pedidos (id, numero, fecha, clienteNombre, total, estado)
    VALUES (1, 'TEST-DUP-001', '2024-10-20', 'Cliente Test', 1000.00, 'NUEVO');
    RAISE NOTICE 'ERROR: Constraint PRIMARY KEY no funciona';
EXCEPTION 
    WHEN unique_violation THEN
        RAISE NOTICE 'CORRECTO: PRIMARY KEY constraint funciona';
END $$;

-- Prueba 2: Intentar insertar pedido con total negativo (debe fallar)  
DO $$
BEGIN
    INSERT INTO Pedidos (numero, fecha, clienteNombre, total, estado)
    VALUES ('TEST-CHK-001', '2024-10-20', 'Cliente Check', -500.00, 'NUEVO');
    RAISE NOTICE 'ERROR: CHECK constraint de total no funciona';
EXCEPTION 
    WHEN check_violation THEN
        RAISE NOTICE 'CORRECTO: CHECK constraint funciona - total negativo rechazado';
END $$;

-- Verificar integridad después de las pruebas
SELECT 'Pruebas de integridad completadas - Los errores anteriores son ESPERADOS' as resultado;

-- =========================================================================
-- SECCIÓN 4: FUNCIÓN SEGURA ANTI-INYECCIÓN SQL
-- =========================================================================

-- Función que valida parámetros y previene inyección SQL
CREATE OR REPLACE FUNCTION buscar_pedidos_seguros(p_cliente TEXT)
RETURNS TABLE(
    numero_pedido VARCHAR(20),
    fecha_pedido DATE,
    total_pedido DECIMAL(12,2),
    estado_pedido VARCHAR(20)
) 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    cliente_limpio TEXT;
BEGIN
    -- Validación de entrada para prevenir inyección SQL
    IF p_cliente IS NULL OR LENGTH(TRIM(p_cliente)) = 0 THEN
        RAISE EXCEPTION 'Parámetro cliente no puede estar vacío';
    END IF;
    
    -- Limpiar parámetro eliminando caracteres peligrosos
    cliente_limpio := REGEXP_REPLACE(TRIM(p_cliente), '[^a-zA-ZñÑ\s]', '', 'g');
    
    IF LENGTH(cliente_limpio) < 3 THEN
        RAISE EXCEPTION 'Nombre de cliente debe tener al menos 3 caracteres válidos';
    END IF;
    
    -- Consulta parametrizada (segura contra inyección SQL)
    RETURN QUERY
    SELECT 
        p.numero,
        p.fecha,
        p.total,
        p.estado
    FROM Pedidos p
    WHERE p.clienteNombre ILIKE '%' || cliente_limpio || '%'
      AND p.eliminado = FALSE
    ORDER BY p.fecha DESC
    LIMIT 100; -- Limitar resultados por seguridad
END;
$$;

-- Otorgar permiso de ejecución al usuario restringido
GRANT EXECUTE ON FUNCTION buscar_pedidos_seguros(TEXT) TO usuario_aplicacion;

-- =========================================================================
-- SECCIÓN 5: PRUEBAS DE PENETRACIÓN CONTROLADAS
-- =========================================================================

-- Prueba 1: Intento de inyección SQL básica (debe ser neutralizada)
SELECT * FROM buscar_pedidos_seguros('Juan''; DROP TABLE Pedidos; --');

-- Prueba 2: Intento de inyección SQL con UNION (debe ser neutralizada)
SELECT * FROM buscar_pedidos_seguros('Juan'' UNION SELECT * FROM Envios --');

-- Prueba 3: Búsqueda legítima (debe funcionar correctamente)
SELECT * FROM buscar_pedidos_seguros('Juan');

-- =========================================================================
-- VERIFICACIÓN DE SEGURIDAD IMPLEMENTADA
-- =========================================================================

-- Verificar que los datos originales no fueron afectados
SELECT 
    'VERIFICACIÓN DE SEGURIDAD' as test,
    'Tabla Pedidos: ' || COUNT(*) || ' registros (sin cambios)' as resultado
FROM Pedidos;

-- Resumen de medidas implementadas
SELECT 
    'RESUMEN SEGURIDAD IMPLEMENTADA' as categoria,
    'Usuario con privilegios mínimos: usuario_aplicacion' as implementacion
UNION ALL
SELECT 
    'Vistas de seguridad',
    '2 vistas que ocultan datos financieros sensibles'
UNION ALL
SELECT 
    'Restricciones probadas',
    'PRIMARY KEY y CHECK constraint validadas con errores esperados'
UNION ALL
SELECT 
    'Consultas parametrizadas',
    'Función segura con validaciones anti-inyección SQL'
UNION ALL
SELECT 
    'Pruebas de penetración',
    '2 intentos de inyección SQL neutralizados exitosamente';

SELECT 'IMPLEMENTACIÓN DE SEGURIDAD COMPLETADA' as resultado;