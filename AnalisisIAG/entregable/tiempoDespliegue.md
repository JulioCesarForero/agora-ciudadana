## Métrica de Tiempo de Despliegue (Legacy vs Modernizado)

### ✅ Descripción de la Métrica

**Tiempo de despliegue**: se refiere al tiempo requerido desde que se realiza un cambio en el código hasta que dicho cambio está disponible en el entorno de producción y puede ser usado por usuarios finales.

---

### 🧱 Contexto de la App Legacy

- La aplicación legacy fue desarrollada con **Python 2.7** y **Django 1.5.5**, tecnologías actualmente en fin de vida (EOL).
- Originalmente no contaba con Docker ni pipelines de despliegue.
- Para esta modernización, se debió configurar manualmente un entorno Docker que permitiera ejecutar el monolito en versiones compatibles.
- Este proceso presenta múltiples dificultades:
  - Dependencias incompatibles o sin soporte.
  - Procesos manuales para reconstrucción de contenedor.
  - Posibles errores colaterales al modificar partes acopladas del sistema.
  - Reinicios manuales y pruebas post-despliegue sin automatización.

> 🟡 **Tiempo de despliegue estimado para la app legacy:** no determinístico, con alta probabilidad de errores, oscilando entre **15 y 30 minutos o más**.

---

### ☁️ Contexto de la App Modernizada (Funciones Lambda)

- Las funcionalidades extraídas son desplegadas como **funciones Lambda** en AWS.
- El despliegue se realiza de forma desacoplada, sin afectar el resto del sistema.
- El proceso puede realizarse mediante consola o comandos CLI como:
  - `aws lambda update-function-code`
  - `sam deploy`
  - Subida directa de archivo `.zip`
- No requiere reinicio del sistema, no hay dependencia con otros módulos y el cambio puede validarse inmediatamente.

> 🟢 **Tiempo de despliegue estimado para la app modernizada:** entre **1 y 3 minutos**, de forma estable y reproducible.

---

### 📊 Conclusión

Esta métrica evidencia un **mejoramiento sustancial en la mantenibilidad operativa** del sistema al aplicar el patrón estrangulador. En particular:

- Se reduce drásticamente el tiempo y el esfuerzo para llevar cambios a producción.
- Se mitiga el riesgo de fallos colaterales.
- Se facilita la evolución incremental del sistema.

El patrón de modernización implementado permite transitar de un entorno rígido y manual hacia uno **moderno, ágil y desacoplado**, alineado con buenas prácticas de ingeniería de software contemporánea.
