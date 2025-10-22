-- =========================================================================  
-- Archivo: 02_catalogos.sql
-- Integrantes: Leonel González y Gonzalo Inga
-- UTN - TFI Bases de Datos I - Octubre 2025
-- =========================================================================

-- Este script carga algunos datos básicos y prueba que los constraints funcionen
-- También probamos casos que deben fallar para verificar las validaciones

-- limpiamos todo para empezar desde cero
DELETE FROM Envios WHERE id > 0;
DELETE FROM Pedidos WHERE id > 0;
ALTER SEQUENCE pedidos_id_seq RESTART WITH 1;
ALTER SEQUENCE envios_id_seq RESTART WITH 1;

-- PARTE 1: Insertamos datos que SÍ deben funcionar

-- Insertar pedido válido
INSERT INTO Pedidos (numero, fecha, clienteNombre, total, estado, eliminado) 
VALUES ('PED-00001', '2024-10-01', 'Juan Pérez', 1500.00, 'NUEVO', FALSE);

-- Insertar envío asociado válido
INSERT INTO Envios (tracking, costo, empresa, tipo, estado, fechaDespacho, fechaEstimada, pedido_id, eliminado)
VALUES ('TRK-001', 150.00, 'ANDREANI', 'ESTANDAR', 'EN_PREPARACION', '2024-10-02', '2024-10-05', 1, FALSE);

-- Verificar inserción exitosa
SELECT 'INSERCIÓN EXITOSA' as resultado, 
       p.numero, p.clienteNombre, e.tracking, e.empresa
FROM Pedidos p
JOIN Envios e ON p.id = e.pedido_id
WHERE p.id = 1;

-- =========================================================================
-- SECCIÓN 2: PRUEBAS DE CONSTRAINTS - CASOS DE ERROR ESPERADOS
-- =========================================================================

-- NOTA: Los siguientes comandos DEBEN fallar para demostrar que los constraints funcionan

-- Prueba 1: Total negativo (debe fallar)
DO $$
BEGIN
    INSERT INTO Pedidos (numero, fecha, clienteNombre, total, estado) 
    VALUES ('PED-00002', '2024-10-01', 'Cliente Test', -100.00, 'NUEVO');
    RAISE NOTICE 'ERROR: Constraint de total no está funcionando';
EXCEPTION 
    WHEN check_violation THEN
        RAISE NOTICE 'CORRECTO: Constraint chk_pedido_total funciona - total negativo rechazado';
END $$;

-- Prueba 2: Estado inválido (debe fallar)
DO $$
BEGIN
    INSERT INTO Pedidos (numero, fecha, clienteNombre, total, estado) 
    VALUES ('PED-00003', '2024-10-01', 'Cliente Test', 100.00, 'ESTADO_INVALIDO');
    RAISE NOTICE 'ERROR: Constraint de estado no está funcionando';
EXCEPTION 
    WHEN check_violation THEN
        RAISE NOTICE 'CORRECTO: Constraint chk_pedido_estado funciona - estado inválido rechazado';
END $$;

-- Prueba 3: Empresa de envío inválida (debe fallar)
DO $$
BEGIN
    INSERT INTO Envios (tracking, costo, empresa, tipo, estado, pedido_id)
    VALUES ('TRK-002', 100.00, 'EMPRESA_INEXISTENTE', 'ESTANDAR', 'EN_PREPARACION', 1);
    RAISE NOTICE 'ERROR: Constraint de empresa no está funcionando';
EXCEPTION 
    WHEN check_violation THEN
        RAISE NOTICE 'CORRECTO: Constraint chk_envio_empresa funciona - empresa inválida rechazada';
END $$;

-- Prueba 4: Violación de unicidad en pedido_id (debe fallar)
DO $$
BEGIN
    INSERT INTO Envios (tracking, costo, empresa, tipo, estado, pedido_id)
    VALUES ('TRK-003', 100.00, 'OCA', 'ESTANDAR', 'EN_PREPARACION', 1);
    RAISE NOTICE 'ERROR: Constraint UNIQUE en pedido_id no está funcionando';
EXCEPTION 
    WHEN unique_violation THEN
        RAISE NOTICE 'CORRECTO: Constraint UNIQUE pedido_id funciona - relación 1:1 garantizada';
END $$;

-- =========================================================================
-- SECCIÓN 3: DATOS DE CATÁLOGO ADICIONALES
-- =========================================================================

-- Insertar más pedidos para pruebas
INSERT INTO Pedidos (numero, fecha, clienteNombre, total, estado, eliminado) VALUES
('PED-00002', '2024-10-02', 'María González', 750.50, 'FACTURADO', FALSE),
('PED-00003', '2024-10-03', 'Carlos Rodriguez', 2100.75, 'ENVIADO', FALSE),
('PED-00004', '2024-10-04', 'Ana Martinez', 1200.00, 'NUEVO', FALSE),
('PED-00005', '2024-10-05', 'Luis Fernandez', 850.25, 'FACTURADO', FALSE);

-- Insertar envíos correspondientes
INSERT INTO Envios (tracking, costo, empresa, tipo, estado, fechaDespacho, fechaEstimada, pedido_id, eliminado) VALUES
('TRK-002', 75.00, 'OCA', 'ESTANDAR', 'EN_TRANSITO', '2024-10-03', '2024-10-07', 2, FALSE),
('TRK-003', 210.00, 'CORREO_ARG', 'EXPRES', 'ENTREGADO', '2024-10-04', '2024-10-06', 3, FALSE),
('TRK-004', 120.00, 'ANDREANI', 'ESTANDAR', 'EN_PREPARACION', NULL, NULL, 4, FALSE),
('TRK-005', 85.00, 'OCA', 'EXPRES', 'EN_TRANSITO', '2024-10-06', '2024-10-08', 5, FALSE);

-- =========================================================================
-- VERIFICACIÓN FINAL
-- =========================================================================
SELECT 'CATÁLOGOS CARGADOS EXITOSAMENTE' as resultado,
       (SELECT COUNT(*) FROM Pedidos) as total_pedidos,
       (SELECT COUNT(*) FROM Envios) as total_envios,
       (SELECT COUNT(*) FROM Pedidos p JOIN Envios e ON p.id = e.pedido_id) as relaciones_1_a_1;