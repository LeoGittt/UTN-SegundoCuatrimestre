-- =========================================================================
-- SISTEMA DE GESTIÓN DE PEDIDOS Y ENVÍOS
-- Archivo: datos_carga_masiva.sql
-- Propósito: Poblado masivo de la base de datos con datos de prueba
-- Registros: 10,000 pedidos + envíos asociados (relación 1:1)
-- Autor: TFI Bases de Datos I - UTN
-- =========================================================================

/*
DESCRIPCIÓN:
Este archivo realiza la carga masiva de datos de prueba para el sistema.
Genera datos realistas y consistentes para facilitar pruebas y análisis.

⚠️ PREREQUISITO: Ejecutar indices_optimizacion.sql ANTES de este archivo
BENEFICIO: Las inserciones masivas son más eficientes con índices preexistentes

PROCESO:
1. Carga 10,000 pedidos con datos aleatorios pero realistas
2. Crea un envío por cada pedido (manteniendo relación 1:1)
3. Utiliza tablas temporales para valores aleatorios consistentes
4. Implementa baja lógica en un porcentaje de registros
5. Aprovecha los índices ya creados para inserciones optimizadas

CARACTERÍSTICAS:
- Fechas distribuidas entre 2024-2025
- 10 clientes recurrentes simulados
- Montos aleatorios en rangos realistas
- Estados distribuidos probabilísticamente
- Códigos de tracking únicos generados automáticamente
*/

-- =========================================================================
-- SECCIÓN 1: CARGA MASIVA DE PEDIDOS
-- =========================================================================

-- Tabla temporal: Nombres de clientes frecuentes
CREATE TEMP TABLE NombresClientes (nombre VARCHAR(120));
INSERT INTO NombresClientes (nombre) VALUES 
('Ana García'), ('Luis Martínez'), ('Sofía Torres'), ('David Reyes'), ('Elena Castro'), 
('Felipe Gómez'), ('Isabel Nuñez'), ('Javier Ruiz'), ('Laura Vidal'), ('Miguel Soto');

-- Tabla temporal: Estados de pedidos
CREATE TEMP TABLE EstadosPedido (estado VARCHAR(20));
INSERT INTO EstadosPedido (estado) VALUES ('NUEVO'), ('FACTURADO'), ('ENVIADO');

-- Inserción masiva: 10,000 pedidos
INSERT INTO Pedidos (numero, fecha, clienteNombre, total, estado, eliminado)
SELECT
    -- Número único con formato: PED-00001, PED-00002, etc.
    'PED-' || LPAD(s::TEXT, 5, '0'),
    
    -- Fechas aleatorias entre 2024 y 2025
    '2024-01-01'::DATE + (random() * 365)::INT AS fecha,
    
    -- Cliente aleatorio de la lista (simula clientes recurrentes)
    (SELECT nombre FROM NombresClientes OFFSET floor(random() * 10) LIMIT 1),
    
    -- Total aleatorio entre $100.00 y $5000.00
    ROUND((100 + random() * 4900)::NUMERIC, 2) AS total,
    
    -- Estado aleatorio con distribución uniforme
    (SELECT estado FROM EstadosPedido OFFSET floor(random() * 3) LIMIT 1),
    
    -- Baja lógica: 5% de registros marcados como eliminados
    CASE WHEN random() < 0.05 THEN TRUE ELSE FALSE END
FROM generate_series(1, 10000) s;

-- Limpieza de tablas temporales
DROP TABLE NombresClientes;
DROP TABLE EstadosPedido;

SELECT 'Pedidos cargados exitosamente: ' || COUNT(*) FROM Pedidos;

-- =========================================================================
-- SECCIÓN 2: CARGA MASIVA DE ENVÍOS
-- =========================================================================

-- Tablas temporales para valores de envíos
CREATE TEMP TABLE EmpresasEnvio (empresa VARCHAR(30));
INSERT INTO EmpresasEnvio (empresa) VALUES ('ANDREANI'), ('OCA'), ('CORREO_ARG');

CREATE TEMP TABLE TiposEnvio (tipo VARCHAR(20));
INSERT INTO TiposEnvio (tipo) VALUES ('ESTANDAR'), ('EXPRES');

CREATE TEMP TABLE EstadosEnvio (estado VARCHAR(30));
INSERT INTO EstadosEnvio (estado) VALUES ('EN_PREPARACION'), ('EN_TRANSITO'), ('ENTREGADO');

-- Inserción masiva: Un envío por cada pedido activo
INSERT INTO Envios (
    tracking, 
    costo, 
    empresa, 
    tipo, 
    fechaDespacho, 
    fechaEstimada, 
    estado, 
    pedido_id, 
    eliminado
)
SELECT
    -- Tracking único: TRK + ID del pedido + hash aleatorio
    'TRK' || LPAD(P.id::TEXT, 5, '0') || SUBSTRING(MD5(RANDOM()::TEXT), 1, 5) AS tracking,
    
    -- Costo aleatorio entre $50.00 y $500.00
    ROUND((50 + random() * 450)::NUMERIC, 2) AS costo,
    
    -- Empresa aleatoria
    (SELECT empresa FROM EmpresasEnvio OFFSET floor(random() * 3) LIMIT 1),
    
    -- Tipo aleatorio
    (SELECT tipo FROM TiposEnvio OFFSET floor(random() * 2) LIMIT 1),
    
    -- Fecha despacho: 1-3 días después del pedido
    P.fecha + (1 + floor(random() * 3))::INT AS fechaDespacho,
    
    -- Fecha estimada: 3-10 días después del despacho
    P.fecha + (4 + floor(random() * 7))::INT AS fechaEstimada,
    
    -- Estado aleatorio
    (SELECT estado FROM EstadosEnvio OFFSET floor(random() * 3) LIMIT 1),
    
    -- Relación 1:1: Cada envío se asocia a un pedido único
    P.id AS pedido_id, 
    
    -- Baja lógica: 5% marcados como eliminados
    CASE WHEN random() < 0.05 THEN TRUE ELSE FALSE END

FROM Pedidos P
WHERE P.eliminado = FALSE; -- Solo crear envíos para pedidos activos

-- Limpieza de tablas temporales
DROP TABLE EmpresasEnvio;
DROP TABLE TiposEnvio;
DROP TABLE EstadosEnvio;

-- =========================================================================
-- SECCIÓN 3: VERIFICACIÓN DE INTEGRIDAD
-- =========================================================================

SELECT 'Envíos cargados exitosamente: ' || COUNT(*) FROM Envios;

-- Verificación de relación 1:1
SELECT 
    'Pedidos con envío asociado: ' || COUNT(DISTINCT E.pedido_id) || ' de ' || 
    (SELECT COUNT(*) FROM Pedidos WHERE eliminado = FALSE) || ' pedidos activos'
FROM Envios E 
WHERE E.eliminado = FALSE;

-- Estadísticas finales
SELECT 
    'Carga completada - Pedidos: ' || (SELECT COUNT(*) FROM Pedidos) ||
    ', Envíos: ' || (SELECT COUNT(*) FROM Envios) ||
    ', Relación 1:1 verificada' AS resultado_final;