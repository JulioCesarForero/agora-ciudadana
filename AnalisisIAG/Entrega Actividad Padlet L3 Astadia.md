# Número del grupo: 10

# Nombres de los miembros del grupo
- Julio César Forero Orjuela
- Juan Fernando Copete Mutis
- Jorge Iván Puyo
- Cristhian Camilo Delgado Pazos

---

# Artículo escogido

**L3 – Modernize Mainframe Workloads to AWS with Astadia Automated Refactoring**

---

# Motivación del proyecto
Ágora Ciudadana, plataforma de democracia líquida, fue construida con **Python 2.7 y Django 1.5.5** (EOL 2020). Esto genera vulnerabilidades, despliegues manuales y un monolito difícil de escalar. La modernización busca:
1. Habilitar **despliegues continuos** mediante contenedores.
2. **Desacoplar funcionalidades** hacia microservicios y serverless en AWS.
3. Reducir costos operativos y dependencias obsoletas.
4. Lograr **escalabilidad horizontal** y resiliencia.

---

# Problemáticas en común entre el artículo y el proyecto del equipo
- **Tecnología legacy y escasez de talento**: el artículo parte de COBOL/IDMS; Ágora depende de Python 2 sin soporte.
- **Monolito de gran tamaño** que dificulta cambios rápidos y pruebas.
- **Costos y riesgos** de operar sobre infraestructura antigua.
- Necesidad de **automatizar pruebas y despliegues** para garantizar equivalencia funcional durante la migración.

---

# Estrategia de modernización usada en el artículo y justificación
El artículo describe una **Migración (Code Translation) 100 % automatizada** con herramientas Astadia (CodeTurn/DataTurn) que:
• Convierten código y datos a lenguajes cloud-ready (Java/C#) y Amazon Aurora.  
• Despliegan la aplicación moderna en **Amazon EKS** usando contenedores.  
• Orquestan un pipeline **Jenkins** que ejecuta conversión, build, despliegue y *testing* continuo en AWS.  
• Integran pruebas automatizadas (TestMatch/DataMatch) para validar equivalencia batch y online.

Justificación para Ágora: este enfoque minimiza la congelación del sistema y garantiza funcionalidad idéntica antes y después del cambio, reduciendo riesgo mientras habilita un stack moderno (Kubernetes, Aurora, Redis, observabilidad AWS).

---

# Lista de ideas extrapolables al proyecto Ágora Ciudadana
1. **Pipeline de refactorización automática**: crear jobs en Jenkins/GitHub Actions que corran pruebas de regresión tras cada conversión de Python 2 → Python 3/Django 4.
2. **Conversión por lotes + sincronización incremental**: aplicar ciclos Convert-Test-Tune sobre módulos Django (apps) para evitar congelar toda la plataforma.
3. **Despliegue en Kubernetes (Amazon EKS)**: empaquetar el monolito actualizado como contenedor y habilitar *rolling updates* y *autoscaling*.
4. **Suite de pruebas equivalentes**: capturar interacciones clave (REST, formularios) y compararlas contra la versión legacy usando herramientas de snapshot testing.
5. **Migración de base de datos a Amazon Aurora** con réplicas de lectura para escalar consultas.
6. **Observabilidad unificada**: usar Amazon CloudWatch + Prometheus/Grafana para métricas del clúster y la aplicación, replicando el stack de referencia de Astadia.
7. **Política de freeze mínima**: sincronizar cambios del repositorio principal con la rama de migración hasta semanas antes del *go-live*, reduciendo disrupción.
8. **Normalización progresiva del modelo de datos**: tras la migración funcional, refactorizar esquemas para mejorar mantenibilidad sin romper equivalencia inicial. 