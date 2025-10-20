# Anexo de Inteligencia Artificial - Trabajo Final Integrador

## Sistema de Gestión de Pedidos y Envíos

**Autores:** Leonel González – Inga Gonzalo  
**Materia:** Trabajo Final Integrador – Bases de Datos I (UTN)  
**Fecha:** Octubre 2025

### Aclaración sobre el uso de IA

Este documento registra todas las consultas que hicimos a Gemini durante el desarrollo de nuestro trabajo final. Queremos ser completamente transparentes sobre cómo utilizamos esta herramienta de inteligencia artificial.

Nuestro enfoque fue siempre pedagógico: usamos Gemini como un tutor que nos ayudara a entender conceptos, validar nuestras ideas y mejorar nuestro razonamiento. No le pedimos que resolviera los ejercicios por nosotros ni que generara código directamente.

Cada consulta que hicimos tenía el objetivo de profundizar nuestro entendimiento, y siempre implementamos las soluciones por cuenta propia después de reflexionar sobre las respuestas recibidas.

---

## Etapa 1 – Modelado y Definición de Restricciones

### Consulta 1: Validación de Claves y Restricciones

**Nuestra pregunta:**
Estamos diseñando un sistema de pedidos y envíos para nuestro trabajo final. Queremos asegurar que la relación uno a uno entre las tablas esté bien implementada. ¿Está bien usar una clave foránea pedido_id en la tabla Envíos con restricción UNIQUE?

**Respuesta de Gemini:**
Confirmó que es una buena práctica usar una foreign key con UNIQUE para garantizar que cada pedido tenga exactamente un envío asociado. También recomendó mantener un campo id autoincremental como clave primaria por estabilidad, y sugirió agregar restricciones CHECK para los estados de cada tabla.

**Lo que aprendimos:**
Esta consulta nos ayudó a entender mejor por qué la restricción UNIQUE es fundamental para asegurar la relación 1:1, y nos dio la idea de usar CHECK constraints para mantener la consistencia en los valores de estado de nuestras tablas.

### Consulta 2: Restricciones de Dominio

**Nuestra pregunta:**
Necesitamos definir restricciones CHECK para los estados de pedidos y envíos. Los pedidos pueden ser NUEVO, FACTURADO o ENVIADO, mientras que los envíos pueden estar EN_PREPARACION, EN_TRANSITO o ENTREGADO. ¿Cuál sería la mejor forma de implementar estas validaciones?

**Respuesta de Gemini:**
Nos mostró la sintaxis correcta usando CHECK con IN para validar los estados permitidos. También nos recordó validar que los valores numéricos como totales y costos no fueran negativos, y nos hizo reflexionar sobre qué pasaría si en el futuro necesitáramos agregar nuevos estados al sistema.

**Lo que aprendimos:**
Esta consulta nos ayudó a pensar no solo en la implementación técnica, sino también en la escalabilidad del modelo. Nos dimos cuenta de la importancia de planificar cómo evolucionará nuestro sistema con el tiempo.

---

## Etapa 2 – Generación y Carga de Datos Masivos

### Consulta 3: Estrategia de Generación Masiva

**Nuestra pregunta:**
Necesitamos generar aproximadamente 10.000 registros de pedidos y envíos usando únicamente SQL. ¿Qué estrategia nos recomendarías para hacerlo de manera eficiente?

**Respuesta de Gemini:**
Nos sugirió un enfoque por pasos: primero crear tablas con datos semilla (clientes, estados, empresas de transporte), luego usar la función generate_series() para crear secuencias numéricas, combinarla con funciones aleatorias para generar variedad, y asegurar que cada envío corresponda exactamente a un pedido para mantener la integridad referencial.

**Lo que aprendimos:**
Esta consulta nos enseñó a estructurar la generación de datos de forma sistemática. Aprendimos sobre generate_series() y cómo evitar problemas de integridad referencial al generar grandes volúmenes de datos relacionados.

### Consulta 4: Optimización de Carga

**Nuestra pregunta:**
¿Es mejor crear los índices antes o después de cargar todos los registros?

**Respuesta de Gemini:**
Para nuestro volumen de 10.000 registros, recomendó crear los índices antes de la carga, ya que PostgreSQL puede mantenerlos eficientemente durante la inserción. También enfatizó la importancia de usar transacciones para hacer la carga atómica y recuperable en caso de errores.

**Lo que aprendimos:**
Entendimos que el orden de ejecución importa y que las transacciones no solo son útiles para concurrencia, sino también para proteger la integridad durante operaciones masivas de carga de datos.

---

## Etapa 3 – Consultas y Reportes Avanzados

### Consulta 5: Optimización de Consultas Complejas

**Nuestra pregunta:**
Tenemos una consulta que busca los 5 pedidos más caros entregados por OCA en marzo de 2024, pero está tardando demasiado. ¿Cómo podemos optimizarla?

**Respuesta de Gemini:**
Nos dio varios consejos prácticos: aplicar los filtros lo antes posible en la consulta, asegurar que los JOIN usen las claves correctas, agregar índices que soporten el ORDER BY, y usar EXPLAIN ANALYZE para revisar el plan de ejecución. Específicamente sugirió un índice compuesto en (fecha, total DESC) para este caso.

**Lo que aprendimos:**
Esta consulta nos introdujo al análisis de performance de consultas. Aprendimos a usar EXPLAIN ANALYZE y a entender cómo los índices pueden mejorar dramáticamente el rendimiento de nuestras consultas más complejas.

### Consulta 6: Diseño de Vista de Trazabilidad

**Nuestra pregunta:**
Queremos crear una vista que muestre los pedidos y envíos juntos, indicando si un envío está retrasado basándose en la fecha estimada de entrega.

**Respuesta de Gemini:**
Nos sugirió usar un JOIN entre las tablas y aplicar lógica condicional con CASE WHEN para determinar el estado del envío. También nos alertó sobre la importancia de considerar qué hacer cuando la fecha estimada es NULL.

**Lo que aprendimos:**
Esta consulta nos enseñó a pensar en los casos edge y a hacer nuestras vistas más robustas. Aprendimos que siempre debemos considerar qué pasa con los valores NULL en nuestras lógicas condicionales.

---

## Etapa 4 – Seguridad e Integridad

### Consulta 7: Principio de Menor Privilegio

**Nuestra pregunta:**
Queremos crear un usuario con permisos mínimos para consultar datos, sin posibilidad de eliminarlos. ¿Qué permisos específicos deberíamos asignarle?

**Respuesta de Gemini:**
Nos explicó que debíamos otorgar solo CONNECT a la base de datos, USAGE en el esquema, y SELECT en las tablas específicas que necesite consultar. Nos advirtió evitar permisos como DELETE, ALTER o DROP, y sugirió usar baja lógica con campos de estado si necesitáramos "eliminar" registros.

**Lo que aprendimos:**
Esta consulta nos introdujo al principio de menor privilegio en bases de datos. Entendimos la diferencia entre eliminar físicamente registros versus marcarlos como inactivos, y cómo esto impacta la seguridad y trazabilidad.

### Consulta 8: Prevención de SQL Injection

**Nuestra pregunta:**
Queremos asegurarnos de que nuestras consultas sean seguras ante ataques de SQL injection. ¿Cómo podemos diferenciar una consulta vulnerable de una que está bien protegida?

**Respuesta de Gemini:**
Nos explicó que las consultas vulnerables concatenan directamente los valores del usuario en el texto SQL, mientras que las consultas seguras usan parámetros que separan completamente los datos del código. Nos mostró el ejemplo de usar $1, $2, etc. en PostgreSQL.

**Lo que aprendimos:**
Comprendimos que la seguridad no es solo sobre permisos, sino también sobre cómo escribimos nuestras consultas. Aprendimos que nunca debemos concatenar strings para formar SQL dinámico.

---

## Etapa 5 – Concurrencia y Transacciones

### Consulta 9: Simulación de Deadlocks

**Nuestra pregunta:**
Queremos mostrar un ejemplo de deadlock en PostgreSQL de forma controlada para entender mejor cómo funcionan. ¿Cómo podemos crear esta situación?

**Respuesta de Gemini:**
Nos sugirió crear una situación donde dos transacciones intenten modificar recursos en orden inverso: la sesión A bloquea un pedido y luego intenta modificar otro, mientras que la sesión B hace exactamente lo contrario. Nos recordó mantener ambas transacciones abiertas antes del COMMIT para provocar el bloqueo circular y documentar el error que aparece.

**Lo que aprendimos:**
Esta consulta nos ayudó a entender el mecanismo interno de los bloqueos y cómo se producen los deadlocks en situaciones reales de concurrencia. Pudimos ver en la práctica cómo PostgreSQL detecta y resuelve estos conflictos.

### Consulta 10: Manejo de Deadlocks

**Nuestra pregunta:**
Queremos implementar una lógica de reintento automático para cuando ocurra un deadlock en nuestras funciones. ¿Qué estrategia recomendarías?

**Respuesta de Gemini:**
Nos sugirió detectar específicamente el error deadlock_detected y aplicar una estrategia de backoff exponencial con un número limitado de reintentos (por ejemplo, máximo 5 intentos). También nos recordó que es buena práctica acceder siempre a los recursos en el mismo orden para prevenir deadlocks futuros.

**Lo que aprendimos:**
Esta consulta nos enseñó a pensar en soluciones tanto preventivas como reactivas. Entendimos que el manejo de concurrencia no es solo detectar problemas, sino diseñar el sistema para minimizar su ocurrencia.

---

## Reflexión Final sobre el Uso de IA

### Aspectos positivos del proceso

Durante todo el trabajo, Gemini actuó como un mentor que nos hacía reflexionar antes de implementar soluciones. En lugar de darnos respuestas directas, nos planteaba preguntas que nos guiaban hacia las respuestas correctas por cuenta propia.

Nos ayudó a aplicar buenas prácticas que tal vez no hubiéramos considerado inicialmente, y nos permitió validar nuestras decisiones técnicas antes de implementarlas. También mejoró significativamente nuestra comprensión teórica de los conceptos.

### Nuestro rol activo durante todo el proceso

Es importante destacar que siempre mantuvimos un rol activo en el aprendizaje. Formulamos preguntas específicas y concretas basadas en problemas reales que íbamos encontrando. Implementamos y probamos cada parte del trabajo completamente por cuenta propia.

Cuando recibíamos sugerencias de Gemini, las analizábamos críticamente y elegíamos las que mejor se adaptaban a nuestro proyecto específico. Todas las decisiones finales de diseño y estructura fueron nuestras, y fuimos nosotros quienes integramos todas las ideas en un proyecto coherente y funcional.

### Lo que realmente aprendimos

El uso de IA en este trabajo nos enseñó que puede ser una herramienta educativa muy valiosa cuando se usa correctamente, pero nunca un reemplazo del aprendizaje genuino. Aprendimos que evaluar y cuestionar cada recomendación fortalece nuestro pensamiento crítico.

La comprensión real de los conceptos vino de aplicar, probar y ajustar las implementaciones por nosotros mismos. Documentar todo este proceso nos permitió ver nuestro crecimiento técnico y conceptual a lo largo del trabajo.

---

## Declaración de Integridad Académica

Certificamos que:

- El uso de Gemini fue exclusivamente con fines educativos y de apoyo conceptual, nunca para generar código o resolver ejercicios automáticamente.

- Todo el código SQL, las consultas, y las decisiones de diseño fueron implementadas completamente por nosotros después de entender los conceptos involucrados.

- Comprendemos y podemos explicar cada parte técnica del trabajo, desde el modelado de datos hasta la implementación de concurrencia.

- Este anexo refleja de forma honesta y transparente nuestro proceso de aprendizaje, mostrando cómo usamos la IA como herramienta pedagógica.

- El proyecto final representa nuestra comprensión genuina y aplicación práctica de todos los contenidos de Bases de Datos I.

**Leonel González**  
**Inga Gonzalo**  
Octubre 2025