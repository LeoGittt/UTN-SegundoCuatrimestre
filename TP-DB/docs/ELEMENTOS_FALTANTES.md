# ELEMENTOS FALTANTES PARA COMPLETAR EL TFI

## 1. ETAPA 1 - Validaciones Prácticas
Crear archivo: `validaciones_constraints.sql`
- 2 inserciones correctas que funcionen
- 2 inserciones erróneas que muestren violación de diferentes constraints
- Documentar los mensajes de error obtenidos

## 2. ETAPA 2 - Descripción Conceptual  
Crear archivo: `descripcion_carga_masiva.md`
- Documento de 1 página explicando el mecanismo de carga
- Tablas semilla utilizadas
- Cómo se garantizó integridad y cardinalidades
- Cuadro de verificaciones con conteos

## 3. ETAPA 3 - Mediciones de Performance
Completar archivo: `analisis_rendimiento.sql`
- Medición de 3 consultas con/sin índices
- 3 corridas por consulta, reportar mediana
- Incluir EXPLAIN y EXPLAIN ANALYZE
- Conclusiones de 5-10 líneas

## 4. ETAPA 4 - Seguridad e Integridad
Crear archivo: `seguridad_integridad.sql`
- Usuario con privilegios mínimos
- 2 vistas que oculten información sensible  
- 2 pruebas de violación de integridad
- Consulta segura con PreparedStatement (Java) o procedimiento SQL

## 5. ETAPA 5 - Concurrencia Avanzada
Completar archivo: `concurrencia_avanzada.sql`
- Simulación documentada de 1 deadlock
- Comparación práctica de READ COMMITTED vs REPEATABLE READ
- Informe de observaciones (5-10 líneas)
- Código con retry ante deadlock

## 6. ANEXO IA - OBLIGATORIO
Crear archivo: `anexo_ia.md`
- Texto completo de todos los chats con IA
- Organizado por etapa del TPI
- Evidencia de uso reflexivo, no copia literal
- Interacciones que muestren proceso de aprendizaje

## 7. DER (Diagrama Entidad-Relación)
Crear archivo: `modelo_der.pdf` o imagen
- Diagrama visual del modelo conceptual
- Entidades, atributos y relaciones
- Cardinalidades claramente marcadas

## PRIORIDADES:
1. **CRÍTICO**: Anexo IA (obligatorio para todos las etapas)
2. **ALTO**: Etapa 4 completa (Seguridad)
3. **ALTO**: Mediciones de performance (Etapa 3)
4. **MEDIO**: Validaciones prácticas (Etapa 1)
5. **MEDIO**: Concurrencia avanzada (Etapa 5)