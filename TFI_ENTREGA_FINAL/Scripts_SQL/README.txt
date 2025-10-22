# =========================================================================
# README - Scripts del TFI
# Integrantes: Leonel González y Gonzalo Inga
# UTN - Bases de Datos I - Octubre 2025
# =========================================================================

INFORMACIÓN DEL PROYECTO:
========================
Proyecto: Sistema de Gestión de Pedidos y Envíos
Integrantes: Leonel González y Gonzalo Inga
Materia: Bases de Datos I
Universidad: UTN
Motor: PostgreSQL (funciona desde la versión 13, nosotros probamos con 18.0)

QUÉ ES ESTO:
===========
Es nuestro TFI de base de datos. Hicimos un sistema de pedidos y envíos.
Cada pedido tiene un envío (relación 1:1). Metimos 20,000 registros de prueba
para que se vea que funciona bien. Tiene índices para que vaya rápido,
usuarios con permisos, transacciones que funcionan bien y manejo de concurrencia.

ORDEN PARA EJECUTAR (IMPORTANTE):
=================================
Hay que ejecutar los archivos en este orden SÍ O SÍ:

1. 01_esquema.sql           - Crea las tablas y relaciones
2. 02_catalogos.sql         - Mete los datos básicos
3. 04_indices.sql           - Crea índices ANTES de meter datos masivos
4. 03_carga_masiva.sql      - Carga los 20,000 registros (después de índices)
5. 05_consultas.sql         - Las consultas que nos pidieron
6. 05_explain.sql           - Ve cómo PostgreSQL ejecuta las consultas
7. 06_vistas.sql            - Crea reportes automáticos
8. 07_seguridad.sql         - Usuarios y permisos
9. 08_transacciones.sql     - Funciones y transacciones
10. 09_concurrencia_guiada.sql - Simula varios usuarios al mismo tiempo

COSAS IMPORTANTES:
==================
- ⚠️ MUY IMPORTANTE: Ejecutar 04_indices.sql ANTES que 03_carga_masiva.sql
  ¿Por qué? Porque es más rápido crear los índices primero y después meter los datos

- Los scripts se pueden ejecutar varias veces sin problemas
- Usamos DROP IF EXISTS para borrar cosas anteriores

- Los archivos están en UTF-8
  Si da error en Windows, ejecutar esto antes:
  SET client_encoding = 'UTF8';

CÓMO EJECUTAR EN POSTGRESQL:
===========================

-- 1. Crear la base de datos
CREATE DATABASE sistema_pedidos_envios;
\c sistema_pedidos_envios;

-- 2. Si estás en Windows, hacer esto para que no de error de codificación
SET client_encoding = 'UTF8';
\encoding UTF8;

-- 3. Ejecutar los archivos en orden (cambiar la ruta por donde tengas los archivos)
\i '01_esquema.sql'
\i '02_catalogos.sql'
\i '04_indices.sql'
\i '03_carga_masiva.sql'
\i '05_consultas.sql'
\i '05_explain.sql'
\i '06_vistas.sql'
\i '07_seguridad.sql'
\i '08_transacciones.sql'
\i '09_concurrencia_guiada.sql'

VERIFICAR QUE TODO FUNCIONÓ:
===========================
Cuando termines de ejecutar todo, podés verificar así:

-- Ver qué se creó
SELECT 
    'Tablas' as tipo, COUNT(*) as cantidad 
FROM information_schema.tables 
WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
UNION ALL
SELECT 
    'Vistas' as tipo, COUNT(*) 
FROM information_schema.views 
WHERE table_schema = 'public'
UNION ALL
SELECT 
    'Funciones' as tipo, COUNT(*) 
FROM information_schema.routines 
WHERE routine_schema = 'public';

-- Ver cuántos datos se cargaron
SELECT 
    'pedidos' as tabla, COUNT(*) as registros FROM pedidos
UNION ALL
SELECT 
    'envios' as tabla, COUNT(*) as registros FROM envios;

LO QUE DEBERÍA SALIR:
====================
- Tablas: 2 (pedidos y envios)
- Vistas: 4 o más (para los reportes)
- Funciones: 2 o más (las que creamos)
- Pedidos: 20,000+ registros
- Envíos: 20,000+ registros

LO QUE HICIMOS EN EL TFI:
========================
✅ Esquema con relación 1:1 (cada pedido tiene un envío)
✅ Restricciones para que los datos estén bien (claves, checks, etc.)
✅ Baja lógica (no borramos, marcamos como inactivo)
✅ Índices para que las consultas vayan rápido
✅ 20,000 registros de prueba que parecen reales
✅ Consultas complejas con JOIN, GROUP BY, subconsultas, etc.
✅ Análisis de rendimiento con EXPLAIN ANALYZE
✅ 4 vistas para hacer reportes fácil
✅ Seguridad: usuario limitado y protección contra inyección SQL
✅ Transacciones que funcionan bien con rollback
✅ Manejo de concurrencia (varios usuarios al mismo tiempo)

SI ALGO NO FUNCIONA:
===================

Error de codificación:
----------------------
Si sale algo como: "carácter con secuencia de bytes 0x8d en codificación «WIN1252»"
Solución: Ejecutar esto antes de cada script:
SET client_encoding = 'UTF8';

No encuentra el archivo:
-----------------------
Fijarse que la ruta esté bien en el comando \i
Ejemplo: \i 'C:/Users/tuusuario/Desktop/archivo.sql'

Error de índice ya existe:
-------------------------
Es normal, los scripts usan DROP IF EXISTS para que se puedan ejecutar varias veces.

No se cargan los datos:
----------------------
Revisar que ejecutaste 04_indices.sql ANTES que 03_carga_masiva.sql

========
Integrantes: Leonel González y Gonzalo Inga
Materia: Bases de Datos I - UTN
Fecha de entrega: 23 de Octubre de 2025

Este README forma parte del TFI. El sistema funciona y está probado
con 20K registros en PostgreSQL.