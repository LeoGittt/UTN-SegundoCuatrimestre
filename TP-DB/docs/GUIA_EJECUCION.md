# Guía de Ejecución - Sistema de Gestión de Pedidos y Envíos

## Orden de Ejecución Recomendado

Para implementar correctamente el sistema de base de datos, sigue este orden de ejecución optimizado:

### 🚀 **NOTA IMPORTANTE SOBRE EL ORDEN:**
Los **índices se crean ANTES** de la carga masiva de datos por las siguientes razones:
- ✅ **Mayor eficiencia**: PostgreSQL puede mantener los índices durante las inserciones
- ✅ **Mejor rendimiento**: Las 10,000 inserciones se benefician de índices preexistentes  
- ✅ **Menos fragmentación**: Los índices se construyen de forma más ordenada
- ✅ **Menor tiempo total**: Evita reconstruir índices después de cargas masivas

### 1. Preparación del Entorno
```sql
-- Conectar a PostgreSQL como superusuario o usuario con privilegios
-- Crear base de datos (opcional si no existe)
CREATE DATABASE sistema_pedidos_envios;
\c sistema_pedidos_envios;
```

### 2. Creación del Esquema Base
**Archivo:** `schema_definicion_tablas.sql`
```bash
psql -d sistema_pedidos_envios -f schema_definicion_tablas.sql
```
**Propósito:** Crea las tablas principales con todas sus restricciones.

### 3. Optimización de Performance (ANTES de cargar datos)
**Archivo:** `indices_optimizacion.sql`
```bash
psql -d sistema_pedidos_envios -f indices_optimizacion.sql
```
**Propósito:** Crea índices estratégicos ANTES de la carga masiva para mayor eficiencia.
**⚠️ IMPORTANTE:** Los índices se crean antes de insertar datos para optimizar las inserciones masivas.

### 4. Carga de Datos de Prueba
**Archivo:** `datos_carga_masiva.sql`
```bash
psql -d sistema_pedidos_envios -f datos_carga_masiva.sql
```
**Propósito:** Inserta 10,000 pedidos y envíos aprovechando los índices ya creados.
**Tiempo estimado:** 1-3 minutos (más rápido con índices preexistentes)

### 5. Creación de Vistas de Negocio
**Archivo:** `vistas_reportes.sql`
```bash
psql -d sistema_pedidos_envios -f vistas_reportes.sql
```
**Propósito:** Define vistas para simplificar consultas complejas.

### 6. Implementación de Lógica de Negocio
**Archivo:** `funciones_stored_procedures.sql`
```bash
psql -d sistema_pedidos_envios -f funciones_stored_procedures.sql
```
**Propósito:** Crea funciones almacenadas para operaciones complejas.

### 7. Pruebas y Consultas de Ejemplo
**Archivo:** `consultas_negocio.sql`
```bash
psql -d sistema_pedidos_envios -f consultas_negocio.sql
```
**Propósito:** Ejecuta consultas de ejemplo para validar el sistema.

### 8. Análisis de Rendimiento
**Archivo:** `analisis_rendimiento.sql`
```bash
psql -d sistema_pedidos_envios -f analisis_rendimiento.sql
```
**Propósito:** Analiza planes de ejecución y performance de consultas.

### 9. Pruebas de Transacciones
**Archivo:** `transacciones_atomicidad.sql`
```bash
psql -d sistema_pedidos_envios -f transacciones_atomicidad.sql
```
**Propósito:** Demuestra el manejo transaccional y propiedades ACID.

## Comandos de Ejecución Completa

### Opción 1: Ejecución Individual
Ejecuta cada archivo por separado siguiendo el orden indicado arriba.

### Opción 2: Script de Ejecución Automática (PowerShell)
```powershell
# Navegar al directorio del proyecto
cd "c:\Users\lg606\Desktop\UTN-SegundoCuatrimestre\TP-DB"

# Ejecutar TFI COMPLETO - Orden optimizado
psql -d sistema_pedidos_envios -f schema_definicion_tablas.sql     # 1. Estructura base
psql -d sistema_pedidos_envios -f validaciones_constraints.sql     # 2. Validar restricciones
psql -d sistema_pedidos_envios -f indices_optimizacion.sql         # 3. Índices ANTES de datos
psql -d sistema_pedidos_envios -f datos_carga_masiva.sql           # 4. Carga con índices
psql -d sistema_pedidos_envios -f vistas_reportes.sql              # 5. Vistas de negocio
psql -d sistema_pedidos_envios -f funciones_stored_procedures.sql  # 6. Lógica almacenada
psql -d sistema_pedidos_envios -f consultas_negocio.sql            # 7. Consultas complejas
psql -d sistema_pedidos_envios -f analisis_rendimiento.sql         # 8. Medición performance
psql -d sistema_pedidos_envios -f seguridad_integridad.sql         # 9. Seguridad completa
psql -d sistema_pedidos_envios -f transacciones_atomicidad.sql     # 10. Transacciones
psql -d sistema_pedidos_envios -f concurrencia_avanzada.sql        # 11. Concurrencia
```

### Opción 3: Script de Ejecución Automática (Bash/Linux)
```bash
#!/bin/bash
DB_NAME="sistema_pedidos_envios"

echo "Ejecutando setup completo del sistema..."

psql -d $DB_NAME -f schema_definicion_tablas.sql
psql -d $DB_NAME -f indices_optimizacion.sql         # ANTES de cargar datos
psql -d $DB_NAME -f datos_carga_masiva.sql           # Carga más eficiente con índices
psql -d $DB_NAME -f vistas_reportes.sql
psql -d $DB_NAME -f funciones_stored_procedures.sql
psql -d $DB_NAME -f consultas_negocio.sql
psql -d $DB_NAME -f analisis_rendimiento.sql
psql -d $DB_NAME -f transacciones_atomicidad.sql

echo "Setup completado!"
```

## Verificaciones Post-Instalación

### 1. Verificar Tablas Creadas
```sql
SELECT table_name, table_type 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;
```

### 2. Verificar Datos Cargados
```sql
SELECT 
    'Pedidos' as tabla, COUNT(*) as registros 
FROM Pedidos
UNION ALL
SELECT 
    'Envios' as tabla, COUNT(*) as registros 
FROM Envios;
```

### 3. Verificar Índices Creados
```sql
SELECT 
    schemaname, tablename, indexname 
FROM pg_indexes 
WHERE schemaname = 'public' 
ORDER BY tablename, indexname;
```

### 4. Verificar Vistas Creadas
```sql
SELECT table_name 
FROM information_schema.views 
WHERE table_schema = 'public' 
ORDER BY table_name;
```

### 5. Verificar Funciones Creadas
```sql
SELECT 
    routine_name, routine_type 
FROM information_schema.routines 
WHERE routine_schema = 'public' 
ORDER BY routine_name;
```

## Solución de Problemas Comunes

### Error: "relation does not exist"
- **Causa:** Intentar ejecutar archivos fuera de orden
- **Solución:** Ejecutar primero `schema_definicion_tablas.sql`

### Error: "duplicate key value"
- **Causa:** Ejecutar `datos_carga_masiva.sql` múltiples veces
- **Solución:** Truncar tablas o recrear el esquema

### Performance lenta en consultas
- **Causa:** No ejecutar `indices_optimizacion.sql`
- **Solución:** Crear índices y ejecutar `ANALYZE` en las tablas

### Error en funciones: "language plpgsql does not exist"
- **Causa:** PostgreSQL sin extensión PL/pgSQL
- **Solución:** `CREATE EXTENSION plpgsql;`

## Requisitos del Sistema

- **PostgreSQL:** Versión 12 o superior
- **Memoria RAM:** Mínimo 2GB recomendados
- **Espacio en disco:** 500MB para datos de prueba
- **Privilegios:** Usuario con permisos de CREATE TABLE, INDEX, FUNCTION

## Contacto y Soporte

Para dudas o problemas con la implementación:
- Revisar los comentarios en cada archivo SQL
- Consultar la documentación en `README.md`
- Verificar logs de PostgreSQL para errores específicos