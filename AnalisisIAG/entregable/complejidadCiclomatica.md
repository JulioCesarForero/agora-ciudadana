## Métrica de Complejidad Ciclomática (Legacy vs Modernizado)

### ✅ Descripción de la Métrica

**Complejidad ciclomática**: es una métrica que cuantifica el número de caminos independientes que existen a través del código fuente. A mayor complejidad, mayor es el esfuerzo de mantenimiento, el riesgo de errores y la dificultad de pruebas.

---

### 🧱 Contexto de la App Legacy

- La aplicación legacy está desarrollada en **Django 1.5.5**, con estructura monolítica y alto acoplamiento entre vistas, modelos y formularios.
- Las funcionalidades de `crear agora` y `editar agora` están embebidas en archivos grandes, con múltiples condicionales, validaciones manuales y lógica de negocio mezclada con la presentación.
- Para medir la complejidad, se ejecutará **SonarQube** sobre el código legacy, enfocándose en los fragmentos de código directamente asociados a estas dos funcionalidades.

> 🟡 **Expectativa**: alta complejidad ciclomática debido a funciones extensas, acoplamiento y ausencia de modularidad.

---

### ☁️ Contexto de la App Modernizada (Funciones Lambda)

- Cada funcionalidad modernizada (`crear agora`, `editar agora`) se reescribirá como una **función Lambda aislada**, utilizando FastAPI y buenas prácticas de separación de responsabilidades.
- El código modernizado está diseñado para ser:
  - Más corto.
  - Más modular.
  - Mejor testeado.
- Se ejecutará también **SonarQube** (o `radon`/`lizard`) sobre las nuevas funciones para medir la complejidad de forma comparable.

> 🟢 **Expectativa**: significativa reducción de la complejidad ciclomática debido a modularidad, menor número de decisiones lógicas por función y separación clara entre capa de entrada, validación, lógica y persistencia.

---

### 📊 Enfoque Comparativo

| Funcionalidad       | Complejidad (Legacy) | Complejidad (Lambda) | Diferencia esperada |
|---------------------|----------------------|-----------------------|----------------------|
| crear_agora         | 14                   | 4                     | ↓ Código desacoplado y funciones pequeñas |
| editar_agora        | 17                   | 5                     | ↓ Validaciones y persistencia separadas |

*Nota: Los valores reales se completarán luego de ejecutar las mediciones.*

---

### 🎯 Conclusión

La comparación de esta métrica permite **demostrar de forma objetiva** cómo la modernización progresiva mediante funciones Lambda:

- Reduce el esfuerzo necesario para entender, mantener y extender el código.
- Mejora la legibilidad y testabilidad de las funcionalidades.
- Permite detectar funciones complejas desde el legacy para priorizar su modernización.

Esta evidencia respalda la decisión técnica de migrar progresivamente hacia una arquitectura desacoplada, favoreciendo la mantenibilidad del sistema.

