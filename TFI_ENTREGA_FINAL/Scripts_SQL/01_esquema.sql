-- =========================================================================
-- TFI Bases de Datos I - Sistema de Pedidos y Envíos  
-- Archivo: 01_esquema.sql
-- Integrantes: Leonel González y Gonzalo Inga
-- UTN - Octubre 2025
-- =========================================================================

-- Este script crea las tablas principales del sistema
-- Usamos relación 1:1 entre pedidos y envíos como nos pidieron en clase

-- Primero borramos todo por si ya existe (idempotencia)
-- Así podemos ejecutar el script varias veces sin problemas

DROP TABLE IF EXISTS Envios CASCADE;
DROP TABLE IF EXISTS Pedidos CASCADE;

-- TABLA PEDIDOS - acá guardamos toda la info de los pedidos
CREATE TABLE Pedidos (
    id BIGSERIAL PRIMARY KEY,
    eliminado BOOLEAN NOT NULL DEFAULT FALSE, -- para baja lógica
    
    numero VARCHAR(20) NOT NULL UNIQUE, -- formato PED-XXXXX
    fecha DATE NOT NULL,
    clienteNombre VARCHAR(120) NOT NULL,
    total DECIMAL(12, 2) NOT NULL,
    estado VARCHAR(20) NOT NULL,

    -- validaciones que nos pidieron 
    CONSTRAINT chk_pedido_total CHECK (total >= 0.00),
    CONSTRAINT chk_pedido_estado CHECK (estado IN ('NUEVO', 'FACTURADO', 'ENVIADO'))
);

-- TABLA ENVIOS - un envío por cada pedido (relación 1:1)
CREATE TABLE Envios (
    id BIGSERIAL PRIMARY KEY,
    eliminado BOOLEAN NOT NULL DEFAULT FALSE, -- baja lógica también acá
    
    tracking VARCHAR(40) UNIQUE, -- código de seguimiento
    costo DECIMAL(10, 2) NOT NULL,
    empresa VARCHAR(30) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    estado VARCHAR(30) NOT NULL,
    fechaDespacho DATE,
    fechaEstimada DATE,

    -- acá está la magia de la relación 1:1
    pedido_id BIGINT NOT NULL UNIQUE, -- UNIQUE garantiza el 1:1
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(id) ON DELETE CASCADE,

    -- más validaciones
    CONSTRAINT chk_envio_costo CHECK (costo >= 0.00),
    CONSTRAINT chk_envio_empresa CHECK (empresa IN ('ANDREANI', 'OCA', 'CORREO_ARG')),
    CONSTRAINT chk_envio_tipo CHECK (tipo IN ('ESTANDAR', 'EXPRES')),
    CONSTRAINT chk_envio_estado CHECK (estado IN ('EN_PREPARACION', 'EN_TRANSITO', 'ENTREGADO')),
    CONSTRAINT chk_fechas_envio CHECK (fechaEstimada >= fechaDespacho) 
);

-- documentación básica para que el profe entienda qué hace cada cosa
COMMENT ON TABLE Pedidos IS 'Pedidos de clientes - Leonel y Gonzalo';
COMMENT ON TABLE Envios IS 'Envíos asociados a pedidos (1:1)';

-- verificamos que se creó todo bien
SELECT 'Tablas creadas: ' || COUNT(*) as resultado
FROM information_schema.tables 
WHERE table_schema = 'public' AND table_type = 'BASE TABLE';