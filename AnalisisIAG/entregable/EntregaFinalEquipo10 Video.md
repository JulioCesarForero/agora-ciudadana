# Entrega Final Equipo 10 – Proyecto de Modernización Agora Ciudadana

> Fecha de entrega: 27/07/2025  
> Versión: 1.0  
> Equipo 10: Julio César Forero, Juan Fernando Copete, Jorge Iván Puyo, Cristhian Camilo Delgado

---

## Índice
1. Arquitectura To-Be (Despliegue, descripción, patrones, Apigee)
2. Pre-Experimento
   1. Propósito del experimento
   2. Requisitos modernizados
   3. Tecnología / framework destino
   4. Mapeos Legacy → Modernizado
   5. Ejemplos de código comparativo
   6. Infraestructura computacional
   7. Instrumentación y métricas
   8. Interesados
   9. Diseño detallado (2 diagramas adicionales)
   10. Estimación de esfuerzo
3. Post-Experimento
   1. Resultados y métricas consolidadas
   2. Recomendaciones y desviaciones
   3. Esfuerzo real vs estimado
4. Enlaces y evidencia
5. Conclusiones
6. Speech para video (≤10 min)

---

## 1. Arquitectura To-Be

### 1.1 Diagrama de Despliegue
![Diagrama de despliegue](Imagenes/diagrama_to_be.png)

### 1.2 Descripción de los Elementos y Patrones
| Componente | Tipo | Descripción | Patrones/Tácticas |
|------------|------|-------------|-------------------|
| **API Gateway (Façade)** | AWS API Gateway | Punto único de acceso, enrutamiento dinámico Legacy ↔️ Microservicio, auth, throttling, logging. | Façade, Proxy, Observabilidad |
| **Lambda AgoraService** | AWS Lambda + Docker | Función containerizada (FastAPI) para `crear` y `editar` ágoras. | Microservicio, Strangler Fig |
| **DynamoDB** | NoSQL DB | Persistencia de estructuras modernizadas. | Persistencia desacoplada |
| **Secrets Manager** | Gestión de secretos | Almacena credenciales y tokens. | Externalized Configuration |
| **EC2 Legacy** | VM + Docker Compose | Monolito Django 1.5.5 aún activo. | Legacy Encapsulation |

> **Patrón Principal:** **Strangler Fig** para migración progresiva.  
> **Tácticas destacadas:** Auto-scaling serverless, aislamiento de fallos, configuración externalizada, façade centralizada.

### 1.3 Prácticas Apigee Extrapoladas
1. **Proxy y enrutamiento granular** – API Gateway replica el control de tráfico de Apigee.  
2. **Políticas declarativas** – Uso de stages, authorizers y throttling como equivalentes a políticas Apigee.  
3. **Observabilidad unificada** – CloudWatch + API Gateway logs ≈ Analytics de Apigee.

---

## 2. Pre-Experimento

### 2.1 Propósito
Validar si la modernización incremental de funcionalidades críticas mejora rendimiento, mantenibilidad, seguridad y operaciones sin interrumpir el servicio.

### 2.2 Requisitos Modernizados (n = 2)
| Nº | Requisito | Criterios de Aceptación |
|----|-----------|-------------------------|
| 1  | Crear Ágora | Tiempo < 500 ms, éxito ≥ 99.9 %, respuesta JSON válida |
| 2  | Editar Ágora | Tiempo < 500 ms, éxito ≥ 99.9 %, consistencia de datos |

### 2.3 Tecnología Destino
- **FastAPI 0.110** (Python 3.11) dentro de contenedor Docker.  
- Despliegue en **AWS Lambda** vía **AWS SAM**.  
- Infraestructura declarada con **CloudFormation**.

### 2.4 Mapeos Legacy → Modernizado
| Elemento Legacy | Elemento Modernizado | Cardinalidad | Descripción |
|-----------------|----------------------|--------------|-------------|
| Vista Django “create_agora” | Endpoint POST `/agora` en Lambda | 1 → 1 | Lógica de validación y persistencia desacoplada |
| Vista Django “edit_agora” | Endpoint PUT `/agora/{id}` | 1 → 1 | Reescritura modular, uso de Pydantic |
| Modelo Django `Agora` (ORM) | Documento DynamoDB | 1 → 1 | Campos mapeados a atributos NoSQL |

### 2.5 Ejemplos de Código
```python
# Legacy (Django)
if request.method == 'POST':
    form = AgoraForm(request.POST)
    if form.is_valid():
        agora = form.save()
        messages.success(request, 'Ágora creada')
    else:
        messages.error(request, 'Error')
```
```python
# Modernizado (FastAPI in Lambda)
@app.post("/agora", status_code=201)
async def create_agora(payload: CreateAgoraDTO):
    item = payload.model_dump()
    table.put_item(Item=item)
    return item
```
*Reducción de condicionales, uso de tipado fuerte y persistencia separada.*

### 2.6 Infraestructura Computacional
![Infraestructura](Imagenes/infraestructura_to_be.png)  
Uso de servicios administrados AWS (Lambda, DynamoDB, Secrets, API Gateway, CloudWatch).

### 2.7 Instrumentación & Métricas
- **Desempeño**: Artillery.io (tiempo respuesta, throughput, errores).  
- **Mantenibilidad**: Radon/Lizard (complejidad ciclomática).  
- **Seguridad**: Análisis estático & versión del lenguaje.  
- **Operaciones**: Tiempo de despliegue cronometrado.

### 2.8 Interesados
Product Owner, Arquitecto de Software, DevOps, Equipo QA, Stakeholders gobierno-cliente.

### 2.9 Diseño Detallado
1. **Diagrama de Secuencia** – Flujo crear ágora (API Gateway → Lambda → DynamoDB).  
2. **Diagrama de Componentes** – Módulos del microservicio (entrada, validación, dominio, persistencia).

### 2.10 Estimación de Esfuerzo
Ver documento `Estimacion_de_esfuerzo.md` – 30 SP totales ≈ 120 h estimadas.  
Técnica: **Juicio de expertos** apoyado en analogía.  
Unidad: Story Points (1 SP ≈ 4 h) por su flexibilidad en proyectos ágiles.

---

## 3. Post-Experimento

### 3.1 Resultados Consolidados
| Métrica | Legacy | To-Be | Mejora |
|---------|--------|-------|--------|
| Tiempo Promedio | 8,201 ms | 262 ms | **+96.8 %** |
| Throughput | 5.77 req/s | 9.84 req/s | **+70.5 %** |
| Tasa Éxito | 31.97 % | 100 % | **+68 %** |
| Errores 500 | 266 | 0 | **–100 %** |
| Complejidad Ciclomática | 14-17 | 4-5 | **–70 %** |
| Tiempo Despliegue | 15-30 min | 1-3 min | **–90 %** |

### 3.2 Recomendaciones
- Migrar inmediatamente microservicio a producción.  
- Optimizar cold starts con provisioned concurrency.  
- Extender patrón a otras funcionalidades.  
- Implementar CI/CD y monitoreo avanzado.

### 3.3 Desviaciones
Todas las desviaciones fueron **positivas**, superando los objetivos iniciales.

### 3.4 Esfuerzo Real vs Estimado
| Integrante | SP Estimados | Horas Estimadas | Horas Reales | Variación |
|------------|-------------|-----------------|-------------|-----------|
| Julio C. | 10 | 40 | 30 | –10 h |
| Juan F. | 7 | 28 | 19 | –9 h |
| Jorge I. | 8 | 32 | 28 | –4 h |
| Cristhian | 5 | 20 | 18 | –2 h |

---

## 4. Enlaces y Evidencia
- Repositorio modernizado: <https://github.com/modernizacionsoft/agora-lambda>
- Reporte Artillery: `EjecucionPruebas/AGORA-AWS-performance-report-3.html`
- Video demostración: **(URL a publicar)**
- Documentos de apoyo: `PruebasMicroservicios.md`, `seguridad.md`, `tiempoDespliegue.md`, `complejidadCiclomatica.md`, `Arquitectura To-Be.md`.

---

## 5. Conclusiones
La modernización mediante microservicios serverless demostró **viabilidad total**, con mejoras contundentes en rendimiento, confiabilidad, seguridad, escalabilidad y operaciones. La estrategia Strangler Fig permitió migrar sin riesgos y preparar el camino para la modernización completa del sistema.

---

## 6. Speech para Video (≤10 min)

> **Duración estimada**: ~8 min

1. **Introducción (0:00-0:30)**  
   - Bienvenida, propósito del proyecto: modernizar Agora Ciudadana.

2. **Problema del Sistema Legacy (0:30-1:30)**  
   - Python 2.7 EOL, errores 500, tiempos > 8 s, despliegues manuales.

3. **Arquitectura To-Be (1:30-3:00)**  
   - Mostrar diagrama: API Gateway, Lambda, DynamoDB, EC2 legacy.  
   - Explicar patrón Strangler Fig y prácticas Apigee replicadas.

4. **Pre-Experimento (3:00-4:00)**  
   - Requisitos modernizados, tecnología FastAPI + AWS Lambda.  
   - Instrumentación: Artillery, Radon, cronómetro despliegue.

5. **Demostración en Vivo (4:00-7:00)**  
   - Legacy vs Modernizado: crear y editar ágora.  
   - Mostrar errores 500 vs respuestas 201/200 en 262 ms.  
   - Pruebas de carga: throughput y cero errores.  
   - Complejidad ciclomática: 17 vs 5.

6. **Resultados y Métricas (7:00-8:00)**  
   - Tabla comparativa de mejoras (tiempo, éxito, despliegue).  
   - Riesgos mitigados.

7. **Conclusiones y Próximos Pasos (8:00-9:30)**  
   - Arquitectura To-Be ⟶ **Completamente Viable**.  
   - Extender modernización, CI/CD, optimizar cold starts.

8. **Cierre (9:30-10:00)**  
   - Agradecimiento, llamado a acción para aprobar migración completa.

---

**Fin del documento** 