# Diagrama Entidad-Relación (DER)
## Sistema de Gestión de Pedidos y Envíos

### TFI Bases de Datos I - UTN

---

```
                    SISTEMA DE PEDIDOS Y ENVÍOS
                         (Relación 1:1)

    ┌─────────────────────────────────────┐         ┌─────────────────────────────────────┐
    │              PEDIDOS                │         │              ENVÍOS                 │
    ├─────────────────────────────────────┤         ├─────────────────────────────────────┤
    │ 🔑 id: BIGINT (PK)                  │    1    │ 🔑 id: BIGINT (PK)                  │
    │ 📋 numero: VARCHAR(20) (UK)         │ ──────→ │ 📦 tracking: VARCHAR(40) (UK)       │
    │ 📅 fecha: DATE                      │         │ 💰 costo: DECIMAL(10,2)             │
    │ 👤 clienteNombre: VARCHAR(120)      │    1    │ 🏢 empresa: VARCHAR(30)             │
    │ 💵 total: DECIMAL(12,2)             │         │ 🚚 tipo: VARCHAR(20)                │
    │ 📊 estado: VARCHAR(20)              │         │ 📈 estado: VARCHAR(30)              │
    │ 🗑️ eliminado: BOOLEAN               │         │ 📤 fechaDespacho: DATE              │
    ├─────────────────────────────────────┤         │ 📬 fechaEstimada: DATE              │
    │ CHECK: total >= 0.00                │         │ 🔗 pedido_id: BIGINT (FK, UK)      │
    │ CHECK: estado IN                    │         │ 🗑️ eliminado: BOOLEAN               │
    │   ('NUEVO','FACTURADO','ENVIADO')   │         ├─────────────────────────────────────┤
    └─────────────────────────────────────┘         │ CHECK: costo >= 0.00                │
                                                    │ CHECK: empresa IN                   │
                                                    │   ('ANDREANI','OCA','CORREO_ARG')   │
                                                    │ CHECK: tipo IN                      │
                                                    │   ('ESTANDAR','EXPRES')             │
                                                    │ CHECK: estado IN                    │
                                                    │   ('EN_PREPARACION','EN_TRANSITO', │
                                                    │    'ENTREGADO')                     │
                                                    │ CHECK: fechaEstimada >=             │
                                                    │        fechaDespacho                │
                                                    └─────────────────────────────────────┘
```

---

## Especificaciones del Modelo

### 🎯 **Tipo de Relación**
**Relación 1:1 Unidireccional**
- Un Pedido tiene exactamente un Envío
- Un Envío pertenece a exactamente un Pedido
- La clave foránea está en la tabla Envíos

### 🔐 **Claves y Restricciones**

#### **Claves Primarias (PK)**
- `Pedidos.id`: BIGSERIAL (autoincremental)
- `Envios.id`: BIGSERIAL (autoincremental)

#### **Claves Foráneas (FK)**
- `Envios.pedido_id` → `Pedidos.id`
- Con `ON DELETE CASCADE`

#### **Claves Únicas (UK)**
- `Pedidos.numero`: Código único del pedido
- `Envios.tracking`: Código de seguimiento único  
- `Envios.pedido_id`: Garantiza relación 1:1

#### **Restricciones CHECK**
- Valores monetarios no negativos
- Estados válidos según el negocio
- Fechas lógicamente coherentes

### 📊 **Cardinalidades**
```
Pedidos (1) ──────── (1) Envíos
   │                    │
   └── Un pedido       └── Un envío
       un envío            un pedido
```

### 🏗️ **Características del Diseño**

#### **Baja Lógica**
- Campo `eliminado` en ambas tablas
- Permite mantener históricos
- No eliminación física de datos

#### **Integridad Referencial**
- Eliminación en cascada controlada
- Validación automática de FK
- Prevención de registros huérfanos

#### **Validaciones de Dominio**
- Rangos de valores apropiados
- Estados de negocio consistentes
- Formatos de datos estandarizados

---

## Diccionario de Datos

### **Tabla: PEDIDOS**
| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | BIGSERIAL | PK, NOT NULL | Identificador único |
| numero | VARCHAR(20) | UNIQUE, NOT NULL | Código del pedido (PED-XXXXX) |
| fecha | DATE | NOT NULL | Fecha de creación |
| clienteNombre | VARCHAR(120) | NOT NULL | Nombre del cliente |
| total | DECIMAL(12,2) | NOT NULL, >= 0 | Monto total del pedido |
| estado | VARCHAR(20) | NOT NULL, CHECK | NUEVO/FACTURADO/ENVIADO |
| eliminado | BOOLEAN | NOT NULL, DEFAULT FALSE | Flag de baja lógica |

### **Tabla: ENVÍOS**
| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | BIGSERIAL | PK, NOT NULL | Identificador único |
| tracking | VARCHAR(40) | UNIQUE | Código de seguimiento |
| costo | DECIMAL(10,2) | NOT NULL, >= 0 | Costo del envío |
| empresa | VARCHAR(30) | NOT NULL, CHECK | Transportista |
| tipo | VARCHAR(20) | NOT NULL, CHECK | ESTANDAR/EXPRES |
| estado | VARCHAR(30) | NOT NULL, CHECK | Estado del envío |
| fechaDespacho | DATE | NULL | Fecha de despacho |
| fechaEstimada | DATE | NULL, >= fechaDespacho | Fecha estimada entrega |
| pedido_id | BIGINT | FK, UNIQUE, NOT NULL | Referencia al pedido |
| eliminado | BOOLEAN | NOT NULL, DEFAULT FALSE | Flag de baja lógica |

---

## Decisiones de Diseño

### ✅ **Fortalezas del Modelo**
1. **Simplicidad**: Relación 1:1 fácil de entender y mantener
2. **Integridad**: Múltiples niveles de validación
3. **Flexibilidad**: Baja lógica permite históricos
4. **Performance**: Diseño optimizado para consultas frecuentes
5. **Extensibilidad**: Fácil agregar nuevas entidades relacionadas

### 🔄 **Posibles Extensiones**
- **Clientes**: Entidad separada para información de clientes
- **Productos**: Detalle de items en cada pedido  
- **Direcciones**: Información de entrega específica
- **Auditoria**: Tracking de cambios y modificaciones

### 📋 **Casos de Uso Soportados**
- Gestión completa del ciclo de vida de pedidos
- Seguimiento logístico en tiempo real
- Reportes financieros y operacionales
- Análisis de performance por transportista
- Auditoría y trazabilidad completa

---

*Diagrama creado para el Trabajo Final Integrador - Bases de Datos I*  
*Universidad Tecnológica Nacional (UTN) - 2025*