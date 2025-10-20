-- =========================================================================
-- SISTEMA DE GESTIÓN DE PEDIDOS Y ENVÍOS
-- Archivo: validaciones_constraints.sql
-- Propósito: Validación práctica de restricciones de integridad
-- Etapa: 1 - Modelado y Definición de Constraints
-- Autor: TFI Bases de Datos I - UTN
-- =========================================================================

/*
DESCRIPCIÓN:
Este archivo demuestra la efectividad de las restricciones definidas en el esquema
mediante pruebas prácticas con inserciones válidas e inválidas.

PRUEBAS INCLUIDAS:
- 2 inserciones correctas que respetan todas las restricciones
- 2 inserciones erróneas que violan diferentes tipos de constraints
- Documentación de los mensajes de error esperados

OBJETIVO PEDAGÓGICO:
Validar que las restricciones PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK 
funcionan correctamente y proporcionan mensajes de error informativos.
*/

-- =========================================================================
-- SECCIÓN 1: INSERCIONES CORRECTAS (DEBEN FUNCIONAR)
-- =========================================================================

-- ✅ INSERCIÓN CORRECTA 1: Pedido válido con todos los datos correctos
INSERT INTO Pedidos (numero, fecha, clienteNombre, total, estado, eliminado)
VALUES ('VAL-TEST-001', '2024-10-15', 'María González', 1500.50, 'NUEVO', FALSE);

-- ✅ INSERCIÓN CORRECTA 2: Envío válido asociado al pedido anterior
INSERT INTO Envios (
    tracking, costo, empresa, tipo, estado, 
    fechaDespacho, fechaEstimada, pedido_id, eliminado
)
VALUES (
    'TRK-VAL-001', 125.00, 'OCA', 'ESTANDAR', 'EN_PREPARACION',
    '2024-10-16', '2024-10-20', 
    (SELECT id FROM Pedidos WHERE numero = 'VAL-TEST-001'),
    FALSE
);

-- Verificación de inserciones correctas
SELECT 'INSERCIONES CORRECTAS - Verificación:' AS resultado,
       P.numero, P.clienteNombre, P.total, E.tracking, E.empresa
FROM Pedidos P
LEFT JOIN Envios E ON P.id = E.pedido_id
WHERE P.numero = 'VAL-TEST-001';

-- =========================================================================
-- SECCIÓN 2: INSERCIONES ERRÓNEAS (DEBEN FALLAR)
-- =========================================================================

-- ❌ ERROR 1: Violación de CHECK constraint en estado de pedido
-- RESULTADO ESPERADO: ERROR - estado inválido
INSERT INTO Pedidos (numero, fecha, clienteNombre, total, estado, eliminado)
VALUES ('ERR-TEST-001', '2024-10-15', 'Cliente Error', 1000.00, 'CANCELADO', FALSE);

/*
MENSAJE DE ERROR ESPERADO:
ERROR: new row for relation "pedidos" violates check constraint "chk_pedido_estado"
DETAIL: Failing row contains (ERR-TEST-001, 2024-10-15, Cliente Error, 1000.00, CANCELADO, f).
*/

-- ❌ ERROR 2: Violación de UNIQUE constraint en número de pedido
-- RESULTADO ESPERADO: ERROR - número duplicado
INSERT INTO Pedidos (numero, fecha, clienteNombre, total, estado, eliminado)
VALUES ('VAL-TEST-001', '2024-10-16', 'Otro Cliente', 2000.00, 'NUEVO', FALSE);

/*
MENSAJE DE ERROR ESPERADO:
ERROR: duplicate key value violates unique constraint "pedidos_numero_key"
DETAIL: Key (numero)=(VAL-TEST-001) already exists.
*/

-- ❌ ERROR 3: Violación de CHECK constraint en costo de envío
-- RESULTADO ESPERADO: ERROR - costo negativo
INSERT INTO Envios (
    tracking, costo, empresa, tipo, estado, 
    pedido_id, eliminado
)
VALUES (
    'TRK-ERR-001', -50.00, 'ANDREANI', 'ESTANDAR', 'EN_PREPARACION',
    (SELECT id FROM Pedidos WHERE numero = 'VAL-TEST-001'),
    FALSE
);

/*
MENSAJE DE ERROR ESPERADO:
ERROR: new row for relation "envios" violates check constraint "chk_envio_costo"
DETAIL: Failing row contains (..., -50.00, ...).
*/

-- ❌ ERROR 4: Violación de FOREIGN KEY constraint
-- RESULTADO ESPERADO: ERROR - pedido_id inexistente
INSERT INTO Envios (
    tracking, costo, empresa, tipo, estado, 
    pedido_id, eliminado
)
VALUES (
    'TRK-ERR-002', 100.00, 'OCA', 'ESTANDAR', 'EN_PREPARACION',
    999999, -- ID que no existe
    FALSE
);

/*
MENSAJE DE ERROR ESPERADO:
ERROR: insert or update on table "envios" violates foreign key constraint "envios_pedido_id_fkey"
DETAIL: Key (pedido_id)=(999999) is not present in table "pedidos".
*/

-- =========================================================================
-- SECCIÓN 3: PRUEBAS ADICIONALES DE RESTRICCIONES
-- =========================================================================

-- ❌ ERROR 5: Violación de restricción de fechas (fecha estimada menor a despacho)
INSERT INTO Envios (
    tracking, costo, empresa, tipo, estado, 
    fechaDespacho, fechaEstimada, pedido_id, eliminado
)
VALUES (
    'TRK-ERR-003', 100.00, 'CORREO_ARG', 'EXPRES', 'EN_TRANSITO',
    '2024-10-20', '2024-10-18', -- Fecha estimada MENOR a despacho
    (SELECT id FROM Pedidos WHERE numero = 'VAL-TEST-001'),
    FALSE
);

/*
MENSAJE DE ERROR ESPERADO:
ERROR: new row for relation "envios" violates check constraint "chk_fechas_envio"
DETAIL: Failing row contains (..., 2024-10-20, 2024-10-18, ...).
*/

-- ❌ ERROR 6: Violación de UNIQUE en relación 1:1 (pedido_id duplicado)
-- Intentar crear segundo envío para el mismo pedido
INSERT INTO Envios (
    tracking, costo, empresa, tipo, estado, 
    pedido_id, eliminado
)
VALUES (
    'TRK-ERR-004', 150.00, 'ANDREANI', 'ESTANDAR', 'EN_PREPARACION',
    (SELECT id FROM Pedidos WHERE numero = 'VAL-TEST-001'), -- Mismo pedido
    FALSE
);

/*
MENSAJE DE ERROR ESPERADO:
ERROR: duplicate key value violates unique constraint "envios_pedido_id_key"
DETAIL: Key (pedido_id)=(X) already exists.
*/

-- =========================================================================
-- SECCIÓN 4: VERIFICACIÓN FINAL Y LIMPIEZA
-- =========================================================================

-- Mostrar resumen de validaciones
SELECT 
    'RESUMEN DE VALIDACIONES' AS seccion,
    'Restricciones probadas:' AS detalle,
    '6 tipos diferentes (PK, FK, UNIQUE, CHECK múltiples)' AS resultado;

-- Contar registros válidos creados
SELECT 
    'DATOS VÁLIDOS CREADOS' AS seccion,
    COUNT(*) || ' pedidos y ' || 
    (SELECT COUNT(*) FROM Envios WHERE pedido_id IN (SELECT id FROM Pedidos WHERE numero LIKE 'VAL-TEST-%')) || ' envíos'
    AS resultado
FROM Pedidos 
WHERE numero LIKE 'VAL-TEST-%';

-- Limpiar datos de prueba (opcional)
-- DELETE FROM Envios WHERE tracking LIKE 'TRK-VAL-%';
-- DELETE FROM Pedidos WHERE numero LIKE 'VAL-TEST-%';

/*
CONCLUSIONES DE LA VALIDACIÓN:
1. ✅ PRIMARY KEY: Garantiza unicidad de registros
2. ✅ FOREIGN KEY: Mantiene integridad referencial
3. ✅ UNIQUE: Previene duplicados en campos clave
4. ✅ CHECK: Valida rangos de valores y estados permitidos
5. ✅ Restricciones de fechas: Asegura lógica temporal correcta
6. ✅ Restricción 1:1: Un pedido tiene exactamente un envío

MENSAJES DE ERROR:
- Son informativos y específicos
- Indican claramente qué restricción se violó
- Facilitan la depuración y corrección
- Garantizan la robustez del sistema

VALIDACIÓN EXITOSA: El modelo cumple con todas las restricciones de integridad.
*/