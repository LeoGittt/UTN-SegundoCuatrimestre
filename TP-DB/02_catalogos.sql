-- =========================================================================
-- ARCHIVO: 02_catalogos.sql
-- PROPÓSITO: Catálogos y datos maestros del sistema
-- SISTEMA: Gestión de Pedidos y Envíos
-- AUTOR: TFI Bases de Datos I - UTN
-- =========================================================================

/*
NOTA: Este archivo está incluido para cumplir con la nomenclatura oficial
del TFI, pero no contiene datos de catálogos específicos ya que nuestro
sistema maneja los valores permitidos directamente en las restricciones
CHECK de las tablas principales.

Los "catálogos" de nuestro sistema están implementados como:
- Estados de pedidos: CHECK constraint en tabla Pedidos
- Estados de envíos: CHECK constraint en tabla Envios  
- Empresas de transporte: CHECK constraint en tabla Envios
- Tipos de envío: CHECK constraint en tabla Envios

Esta implementación es más eficiente para el volumen de datos manejado
y mantiene la integridad referencial directamente en las tablas.
*/

-- Archivo completado - No requiere ejecución adicional
SELECT 'Catálogos implementados via CHECK constraints en tablas principales' AS mensaje;