# Descripción Conceptual del Mecanismo de Carga Masiva

## Sistema de Gestión de Pedidos y Envíos - Etapa 2

### Autor: TFI Bases de Datos I - UTN
### Fecha: Octubre 2025

---

## 1. Objetivo del Poblado Masivo

El objetivo de esta etapa es generar un conjunto de datos grande y consistente (10,000 registros iniciales, escalable a 200,000-500,000) que permita realizar pruebas realistas de performance, concurrencia y consultas complejas en las etapas posteriores del TFI.

## 2. Estrategia General Adoptada

### 2.1 Mecanismo Principal: Tablas Semilla + Producto Cartesiano Controlado

Se utilizó una estrategia de **generación determinística con elementos aleatorios controlados** basada en:

- **Tablas temporales semilla**: Catálogos pequeños con valores válidos del dominio
- **Función `generate_series()`**: Para crear secuencias numéricas base
- **Producto cartesiano controlado**: Combinación sistemática de valores
- **Pseudoaleatoriedad con `random()`**: Para distribuciones realistas pero reproducibles

### 2.2 Proceso de Dos Fases

1. **Fase 1**: Generación de 10,000 Pedidos
2. **Fase 2**: Generación de Envíos (1:1 con Pedidos activos)

## 3. Tablas Semilla Utilizadas

### 3.1 Para Pedidos
```sql
-- Clientes recurrentes (simula comportamiento real)
NombresClientes: 10 nombres frecuentes
EstadosPedido: 3 estados válidos (NUEVO, FACTURADO, ENVIADO)
```

### 3.2 Para Envíos
```sql  
EmpresasEnvio: 3 transportistas (ANDREANI, OCA, CORREO_ARG)
TiposEnvio: 2 modalidades (ESTANDAR, EXPRES)
EstadosEnvio: 3 estados (EN_PREPARACION, EN_TRANSITO, ENTREGADO)
```

## 4. Garantía de Integridad y Cardinalidades

### 4.1 Integridad Referencial
- **Clave foránea válida**: Cada envío referencia un `pedido_id` existente
- **Relación 1:1**: `pedido_id UNIQUE` en tabla Envíos garantiza un envío por pedido
- **Solo pedidos activos**: Envíos creados únicamente para `pedidos.eliminado = FALSE`

### 4.2 Cardinalidades Respetadas
- **Clientes recurrentes**: 10 clientes simulan el 80/20 de Pareto (pocos clientes, muchos pedidos)
- **Distribución temporal**: Fechas aleatorias en rango 2024-2025
- **Baja lógica**: 5% de registros marcados como eliminados (realista)

### 4.3 Restricciones de Dominio
- **Montos realistas**: Pedidos entre $100-$5000, envíos entre $50-$500
- **Estados coherentes**: Distribución uniforme de estados válidos
- **Fechas lógicas**: `fechaEstimada >= fechaDespacho`
- **Códigos únicos**: Tracking generado con patrón único + hash

## 5. Técnicas SQL Avanzadas Empleadas

### 5.1 Generación Masiva Eficiente
```sql
-- Uso de generate_series() para volumen
FROM generate_series(1, 10000) s

-- Selección aleatoria de catálogos
(SELECT valor FROM TablaSemilla OFFSET floor(random() * count) LIMIT 1)

-- Formateo con padding
'PED-' || LPAD(s::TEXT, 5, '0')
```

### 5.2 Cálculos Derivados
```sql
-- Fechas calculadas relacionalmente
fechaDespacho: P.fecha + (1 a 3 días)
fechaEstimada: P.fecha + (4 a 10 días)

-- Tracking único combinando ID + hash
'TRK' || LPAD(P.id::TEXT, 5, '0') || SUBSTRING(MD5(RANDOM()::TEXT), 1, 5)
```

## 6. Verificaciones de Consistencia

### 6.1 Conteos y Volumetría
- **Pedidos totales**: 10,000 registros
- **Envíos generados**: ~9,500 (solo para pedidos activos)
- **Ratio de baja lógica**: ~5% en ambas tablas

### 6.2 Validaciones de Integridad
```sql
-- FK huérfanas = 0
SELECT COUNT(*) FROM Envios E 
LEFT JOIN Pedidos P ON E.pedido_id = P.id 
WHERE P.id IS NULL;  -- Debe ser 0

-- Relación 1:1 respetada  
SELECT pedido_id, COUNT(*) FROM Envios 
GROUP BY pedido_id HAVING COUNT(*) > 1;  -- Debe estar vacío
```

### 6.3 Verificaciones de Dominio
- **Rangos de valores**: Todos los montos dentro de rangos definidos
- **Estados válidos**: Solo estados permitidos por CHECK constraints
- **Fechas coherentes**: No hay fechas estimadas menores a despacho

## 7. Escalabilidad y Reproducibilidad

### 7.1 Escalabilidad
El mecanismo puede escalar fácilmente cambiando el parámetro de `generate_series(1, N)`:
- **10K**: Ideal para validaciones funcionales
- **200K-500K**: Óptimo para mediciones de performance reales

### 7.2 Reproducibilidad Conceptual
- **Determinística en estructura**: Siempre respeta las mismas reglas de negocio
- **Variable en contenido**: Los valores aleatorios generan datasets únicos
- **Consistente en calidad**: Mantiene integridad independiente del volumen

## 8. Beneficios del Enfoque Adoptado

### 8.1 Técnicos
- ✅ **Performance**: Generación masiva en una sola transacción por tabla
- ✅ **Consistencia**: Todas las restricciones se respetan automáticamente  
- ✅ **Escalabilidad**: Fácil ajuste de volumen sin cambios estructurales

### 8.2 Pedagógicos
- ✅ **SQL Puro**: Demuestra capacidades avanzadas de PostgreSQL
- ✅ **Integridad**: Valida el diseño antes de cargar grandes volúmenes
- ✅ **Realismo**: Datos que simulan comportamientos del mundo real

---

## Conclusión

La estrategia de carga masiva implementada combina eficiencia técnica con realismo de datos, garantizando un dataset robusto para las siguientes etapas del TFI. El uso de tablas semilla y generación controlada asegura integridad referencial y distribuaciones realistas, mientras que la escalabilidad permite ajustar el volumen según las necesidades de testing específicas.