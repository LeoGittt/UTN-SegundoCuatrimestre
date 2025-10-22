ORDEN DE EJECUCION - TFI BASES DE DATOS I
==========================================

Sistema: Gestion de Pedidos y Envios
Autores: Leonel Gonzalez - Inga Gonzalo
Universidad Tecnologica Nacional (UTN)
Fecha: Octubre 2025
Version PostgreSQL: 13+

INSTRUCCIONES DE EJECUCION:
==========================

PREPARACION INICIAL:
1. Crear base de datos: CREATE DATABASE sistema_pedidos_envios;
2. Conectar a la BD: \c sistema_pedidos_envios;
3. Configurar UTF-8: SET client_encoding = 'UTF8'; \encoding UTF8;

ORDEN DE EJECUCION DE SCRIPTS:
==============================

1. 01_esquema.sql
   - Crear estructura de tablas con todas las restricciones
   - Definir PKs, FKs, UNIQUEs, CHECKs
   - Implementar relacion 1:1 entre Pedidos y Envios
   
2. 02_catalogos.sql
   - Datos de catalogos (implementados via CHECK constraints)
   - No requiere ejecucion adicional
   
3. 04_indices.sql
   - Crear indices ANTES de la carga masiva para eficiencia
   - Indices compuestos para optimizacion de consultas
   
4. 03_carga_masiva.sql
   - Cargar 20,000 registros (10,000 pedidos + 10,000 envios)
   - Garantizar integridad referencial 1:1
   - Usar datos realistas para testing
   
5. 06_vistas.sql
   - Crear 4 vistas para reportes de negocio
   - Simplificar acceso a datos complejos
   
6. 07_seguridad.sql
   - Implementar usuario con privilegios minimos
   - Crear vistas de seguridad
   - Demostrar prevencion de SQL injection
   
7. 08_transacciones.sql
   - Probar transacciones ACID
   - Demostrar rollback automatico
   - Validar integridad referencial
   
8. 09_concurrencia_guiada.sql
   - Simular deadlocks entre sesiones
   - Comparar niveles de aislamiento
   - Implementar retry con backoff exponencial
   
9. 05_consultas.sql
   - Ejecutar consultas complejas de negocio
   - JOINs, GROUP BY/HAVING, subconsultas
   - Reportes y estadisticas
   
10. 05_explain.sql
    - Analizar planes de ejecucion
    - Mediciones con/sin indices
    - EXPLAIN ANALYZE de consultas criticas

COMANDOS DE VERIFICACION:
========================

-- Verificar tablas creadas
\dt

-- Verificar vistas
\dv

-- Verificar funciones
\df

-- Verificar indices
\di

-- Contar registros cargados
SELECT 'pedidos' as tabla, COUNT(*) as registros FROM pedidos
UNION ALL
SELECT 'envios' as tabla, COUNT(*) as registros FROM envios;

ARCHIVOS ADICIONALES (OPCIONALES):
==================================

- validaciones_constraints.sql: Pruebas de restricciones
- funciones_stored_procedures.sql: Funciones de negocio
- test_carga_masiva.sql: Verificaciones adicionales

NOTAS IMPORTANTES:
==================

1. Ejecutar scripts en el orden especificado
2. Configurar UTF-8 antes de ejecutar cualquier script
3. Los errores en validaciones_constraints.sql son ESPERADOS
4. Los deadlocks en concurrencia son CONTROLADOS para demostracion
5. Todos los scripts son idempotentes (DROP IF EXISTS)

TIEMPO ESTIMADO DE EJECUCION: 15-20 minutos total
REGISTROS FINALES: 20,000 (cumple requisitos academicos)

Para soporte: consultar README.md o documentacion en carpeta docs/