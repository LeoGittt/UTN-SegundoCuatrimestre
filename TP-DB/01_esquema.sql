-- =========================================================================
-- SISTEMA DE GESTIÓN DE PEDIDOS Y ENVÍOS
-- Archivo: schema_definicion_tablas.sql
-- Propósito: Definición completa del esquema de base de datos
-- Dominio: Pedidos -> Envíos (Relación 1:1 Unidireccional)
-- Motor: PostgreSQL
-- Autor: TFI Bases de Datos I - UTN
-- =========================================================================

/*
DESCRIPCIÓN:
Este archivo contiene la definición completa del esquema de la base de datos para
el sistema de gestión de pedidos y envíos. Implementa:

- Dos entidades principales: Pedidos y Envíos
- Relación 1:1 unidireccional (Pedido -> Envío)
- Baja lógica para mantener históricos
- Restricciones de integridad y dominio
- Validaciones con CHECK constraints

CARACTERÍSTICAS TÉCNICAS:
- Claves primarias autoincrementales (BIGSERIAL)
- Restricciones de integridad referencial
- Validaciones de dominio (estados, valores monetarios)
- Eliminación en cascada controlada
*/

-- Asegurar idempotencia: Eliminar tablas existentes
DROP TABLE IF EXISTS Envios CASCADE;
DROP TABLE IF EXISTS Pedidos CASCADE;

-- =========================================================================
-- TABLA: PEDIDOS
-- Descripción: Almacena información de pedidos realizados por clientes
-- =========================================================================
CREATE TABLE Pedidos (
    -- Identificación y control
    id BIGSERIAL PRIMARY KEY,
    eliminado BOOLEAN NOT NULL DEFAULT FALSE,

    -- Datos del pedido
    numero VARCHAR(20) NOT NULL UNIQUE, 
    fecha DATE NOT NULL,
    clienteNombre VARCHAR(120) NOT NULL,
    total DECIMAL(12, 2) NOT NULL,
    estado VARCHAR(20) NOT NULL,

    -- Restricciones de dominio
    CONSTRAINT chk_pedido_total 
        CHECK (total >= 0.00),
    
    CONSTRAINT chk_pedido_estado 
        CHECK (estado IN ('NUEVO', 'FACTURADO', 'ENVIADO'))
);

-- =========================================================================
-- TABLA: ENVIOS  
-- Descripción: Gestiona envíos asociados a pedidos (relación 1:1)
-- =========================================================================
CREATE TABLE Envios (
    -- Identificación y control
    id BIGSERIAL PRIMARY KEY,
    eliminado BOOLEAN NOT NULL DEFAULT FALSE,
    
    -- Datos del envío
    tracking VARCHAR(40) UNIQUE, 
    costo DECIMAL(10, 2) NOT NULL,
    empresa VARCHAR(30) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    estado VARCHAR(30) NOT NULL,
    fechaDespacho DATE,
    fechaEstimada DATE,

    -- Relación 1:1 con Pedidos
    pedido_id BIGINT NOT NULL UNIQUE, 
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(id) ON DELETE CASCADE,

    -- Restricciones de dominio
    CONSTRAINT chk_envio_costo 
        CHECK (costo >= 0.00),
    
    CONSTRAINT chk_envio_empresa 
        CHECK (empresa IN ('ANDREANI', 'OCA', 'CORREO_ARG')),
    
    CONSTRAINT chk_envio_tipo 
        CHECK (tipo IN ('ESTANDAR', 'EXPRES')),
    
    CONSTRAINT chk_envio_estado 
        CHECK (estado IN ('EN_PREPARACION', 'EN_TRANSITO', 'ENTREGADO')),
    
    CONSTRAINT chk_fechas_envio 
        CHECK (fechaEstimada >= fechaDespacho) 
);

-- =========================================================================
-- COMENTARIOS PARA DOCUMENTACIÓN
-- =========================================================================
COMMENT ON TABLE Pedidos IS 'Almacena pedidos de clientes con baja lógica';
COMMENT ON TABLE Envios IS 'Gestiona envíos con relación 1:1 hacia Pedidos';

COMMENT ON COLUMN Pedidos.eliminado IS 'Baja lógica: FALSE=activo, TRUE=eliminado';
COMMENT ON COLUMN Pedidos.numero IS 'Código único del pedido (formato: PED-XXXXX)';
COMMENT ON COLUMN Pedidos.total IS 'Monto total del pedido (validado >= 0)';

COMMENT ON COLUMN Envios.eliminado IS 'Baja lógica: FALSE=activo, TRUE=eliminado';
COMMENT ON COLUMN Envios.tracking IS 'Código de seguimiento único del envío';
COMMENT ON COLUMN Envios.pedido_id IS 'FK única hacia Pedidos (garantiza relación 1:1)';