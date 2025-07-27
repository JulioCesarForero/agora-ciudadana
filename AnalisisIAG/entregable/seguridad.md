## Métrica de Seguridad (Legacy vs Modernizado)

### ✅ Descripción de la Métrica

La métrica de seguridad evalúa el **riesgo asociado a vulnerabilidades técnicas y prácticas inseguras** en el código o infraestructura. En este experimento, se comparan únicamente tres aspectos críticos:

1. Versión del lenguaje de programación utilizado.
2. Gestión de secretos y credenciales.
3. Mecanismo de autenticación.

---

### 🧱 Estado de Seguridad en la App Legacy

| Aspecto Evaluado               | Estado Legacy                                                              | Riesgo Asociado                             |
|-------------------------------|-----------------------------------------------------------------------------|---------------------------------------------|
| **Versión de Python**         | Python 2.7 (End-of-Life desde enero 2020)                                  | Sin parches de seguridad; múltiples CVEs    |
| **Gestión de secretos**       | Claves embebidas en el código (`settings.py`)                              | Alta exposición a filtrado o leaks          |
| **Autenticación**             | Propia, implementada sobre sesiones en Django 1.5.5                         | Sin soporte OIDC; propensa a secuestro      |

---

### ☁️ Estado de Seguridad en la App Modernizada

| Aspecto Evaluado               | Estado Modernizado                                                         | Mejora Implementada                          |
|-------------------------------|-----------------------------------------------------------------------------|----------------------------------------------|
| **Versión de Python**         | Python 3.11 (versión actual con soporte activo y mejoras de seguridad)     | Reduce superficie de ataque                  |
| **Gestión de secretos**       | Uso de variables de entorno y **AWS Secrets Manager / Parameter Store**    | Minimiza riesgo de exposición o filtrado     |
| **Autenticación**             | Centralizada mediante **Amazon Cognito** con JWT y control de sesiones     | Compatible con OIDC y mejores prácticas      |

---

### 📊 Comparación de Métricas

| Métrica                           | Legacy                       | Modernizado                  | Resultado       |
|----------------------------------|------------------------------|-------------------------------|-----------------|
| Uso de versión segura de Python  | ❌ (2.7 sin soporte)         | ✅ (3.11 con soporte)         | Mejora clara    |
| Gestión segura de secretos       | ❌ En código                 | ✅ En entorno y AWS Secrets   | Mejora clara    |
| Mecanismo robusto de autenticación | ❌ Casero sin estándares     | ✅ Cognito con JWT + OIDC     | Mejora clara    |

---

### 🎯 Conclusión

Durante este experimento, la modernización aplicada sobre la funcionalidad `crear agora` y `editar agora` ha permitido abordar vulnerabilidades críticas identificadas en la versión legacy. Se migró a una versión segura del lenguaje, se aislaron los secretos fuera del código fuente, y se integró un mecanismo moderno y centralizado de autenticación.

Estas mejoras **reducen drásticamente la exposición a ataques**, facilitan el cumplimiento de buenas prácticas y preparan el sistema para escalar con seguridad en el tiempo.

