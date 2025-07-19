# Instructions

## Overview
En esta actividad los equipos de proyecto aplicarán una estrategia de cartografía al proyecto, escogerán la estrategia de modernización y delimitarán el alcance. 

Los criterios de evaluación del documento se dividen por cada una de las actividades desarrolladas:


1° Aplicar una estrategia de cartografía:

Justificación de la elección de cartografía (5 puntos): Explicade forma clara la elección de la herramienta de cartografía.

Preguntas de comprensión (5 puntos): las preguntas listadas son claras y buscan la comprensión de la arquitectura as-isy la mantenibilidad actual del código

Respuestas a las preguntas de comprensión (30 puntos): las respuestas son claras, coherentes con las preguntas y están soportadas con capturas de las visualizaciones de la cartografía. Opcionalmente, se puede contar con capturas de la documentación de arquitectura (si se tiene)

Respuesta a la pregunta sobre degradación de atributos (10 puntos): la respuesta es clara y coherente. Está soportada con evidencia (por ej., métricas, resultados de encuesta, etc.)


2° Decidir la estrategia de modernización y el alcance 


Motivador de negocio (5): el motivador es claro y tiene asociado al menos un atributo de calidad de software

Estrategia de modernización (10): la decisión de la estrategia es coherente con el motivador y la justificación es clara

Diagrama de componentes (10): el diagrama establece los componentes del legado y las relaciones existentes entre ellos. Cada componente es descrito de forma clara y se resaltan aquellos que se desean modernizar dando una justificación

Tabla de funcionalidades (20): la tabla contiene las columnas solicitadas y se justifica por qué fueron escogidas esas funcionalidades

Post en tablero colaborativo (5): el post creado en el marco de la actividad “Experiencias de modernización en AWS”es claro y coherente

---

1. El propósito de esta actividad es que el equipo termine de desarrollar las siguientes actividades del proceso de modernización en el marco de su proyecto particular:

Definir y aplicar estrategia de cartografía

Decidirla estrategia de modernización y el alcance

A continuación, se describe lo que se espera para cada actividad.

1° Definir y aplicar estrategia de cartografía

La actividad “Definir y aplicar estrategia de cartografía” consiste en obtener vistas/métricas de la aplicación que el equipo decidió modernizar en la primera entrega del proyecto. Se requieren vistas/métricas que respondan a las preguntas y retos que enfrentan los desarrolladores cuando tratan de comprender el legado. 

El equipo debe plantear preguntas cuyas respuestas conlleven a comprender la arquitectura as-is de la aplicación legada, teniendo en cuenta los siguientes ejes: arquitectura y mantenibilidad del código. A continuación, siguen unas preguntas orientadoras para cada eje, pero el equipo puede proponer otras de acuerdo con sus intereses.

Ejemplos de preguntas para el eje de arquitectura

Cuáles son los componentes funcionales de la aplicación y cómo se relacionan

Cómo es el despliegue de los componentes

Cómo se relacionan los componentes con las fuentes de datos

Qué patrones y tácticas de arquitectura se usan

…

Ejemplo de preguntas para el eje de mantenibilidad 

Cuáles son los componentes más grandes en términos de líneas de código

Cuáles son componentes más fuertemente acoplados

¿Hay código muerto o duplicado?

…

El equipo debe elaborar los siguientes elementos:

Justificación de la elección de la herramienta de cartografía, puede ser una herramienta de cartografía nueva o de una de las herramientas empleadas en el curso

Listado de preguntas que se desean responder como parte de la comprensión del legado. Mínimo 3 preguntas de la dimensión de arquitectura y 3 de la de mantenibilidad

Respuesta a las preguntas planteadas usando la documentación de arquitectura con la que cuente y las visualizaciones/métricas provistas por la herramienta de cartografía escogida. La respuesta debe estar soportada con capturas de las visualizaciones y la documentación (si esta última existe) que son referenciadas en las respuestas

Respuesta a la pregunta: ¿Existen atributos de calidad de la aplicación que se hayan degradado? Sí/no por qué, trate de especificar la degradación. Por ejemplo, una degradación de mantenibilidad se puede especificar con métricas de Codescene o SonaQ. Una degradación de desempeño se puede especificar con resultados de pruebas de carga o con logs del sistema. Una degradación de usabilidad se puede especificar con resultados de encuestas

Vale la pena resaltar que mientras en la entrega anterior se presentó la arquitectura de referencia de la tecnología legada, aquí se deben presentar diagramas de la arquitectura de software concreta de la aplicación a modernizar.

Para el desarrollo de estos puntos el equipo puede guiarse del ejemplo Forms2Java referenciado en la semana 1>>conformación de equipos de trabajo, el cual explica la definición y aplicación de herramientas de cartografía del proyecto real Oracle Forms - Java.

2° Decidir la estrategia de modernización y el alcance

El equipo debe decidir la estrategia de modernización que aplicarán al proyecto (puede ser más de una) y definir el alcance, es decir, los requisitos a modernizar. 

Lo que se espera para esta actividad se describe a continuación:

Motivador de negocio: plantee un motivador de negocio que guíe la modernización, relaciónelo con atributos de calidad que se hayan degradado y/o se quieran priorizar en la modernización (recuerde que los atributos de calidad degradados debieron haberse identificado en la actividad 1°)

Estrategia de modernización: escoja al menos una estrategia de modernización de software y justifique la selección teniendo en cuenta el motivador de negocio.

Alcance de la modernización:

Realice un diagrama de componentes de la aplicación legado e indique cuáles de los componentes desea modernizar en el marco del proyecto, justifique por qué. En la justificación use información provista por las visualizaciones de cartografía y la documentación del sistema (si se tiene)

Realice una tabla de las funcionalidades de la aplicación más importantes a modernizar, incluyendo un ID, una descripción y unos criterios de aceptación. Acompañe la tabla de una justificación de por qué incluyó esas funcionalidades en la tabla

Se espera que el equipo consolide los resultados de las actividades 1° y 2° en un documento que debe cargarse en esta asignación. Recuerde agregar una sección sobre el uso de IAG en su entregable, en dicha sección debe responder las preguntas indicadas en el programa del curso.


---

# Rubrica y Feedback

## 1. Justificación de la elección de cartografía 

Score:
3 out of 5 points


Se indican herramientas utilizadas como SonarQube, Copilot y ChatGPT, pero la justificación es limitada. No se explican los criterios técnicos que llevaron a esa elección ni se profundiza en cómo cada herramienta responde a las necesidades del análisis del sistema legado.

Faltó incluir:

Criterios comparativos frente a otras herramientas.

Relación entre capacidades de la herramienta y preguntas o métricas clave del proyecto.

Explicación de la utilidad combinada de estas herramientas en el proceso de diagnóstico.


## 2. Preguntas de comprensión 


Score:
5 out of 5 points

El contenido evidencia que se reflexionó sobre la estructura del sistema, los componentes más problemáticos, el tamaño del código, la cobertura de pruebas y los problemas técnicos detectados. Estas cuestiones se formulan implícitamente dentro del texto y las visualizaciones, lo que permite inferir que fueron tenidas en cuenta y respondidas con base en evidencia técnica proveniente de herramientas como SonarQube y GitHub Copilot.  

## 3. Respuestas a las preguntas de comprensión 

Score:
22 out of 30 points

El documento presenta algunas respuestas que abordan temas de mantenibilidad, salud del código y estructura técnica, apoyadas en capturas de pantalla de SonarQube. Sin embargo, la profundidad del análisis es limitada. Las visualizaciones están presentes pero no están referenciadas dentro del texto, ni acompañadas de una interpretación técnica clara. Se describe lo que se ve, pero no se extrae de ello una conclusión estructurada que sirva para tomar decisiones informadas sobre la arquitectura o el alcance de la modernización.

El contenido revela que hubo una intención de observar y reportar métricas relevantes (como duplicación de código, complejidad o errores de seguridad), pero no se explicita el impacto de estos hallazgos en la mantenibilidad o en la integridad del sistema. Tampoco se establecen conexiones entre lo observado y las decisiones de estrategia o alcance. La evidencia está presente, pero no está bien articulada.

Faltó incorporar capturas más específicas para cada pregunta, darles un título o numeración, referenciarlas desde el texto y, sobre todo, interpretarlas en términos técnicos. Era necesario explicar por qué una métrica determinada representa un riesgo, una oportunidad de mejora o un componente prioritario para modernización. También habría sido útil articular una conclusión por cada grupo de hallazgos, conectando lo visualizado con atributos de calidad.


## 4. Respuesta a la pregunta sobre degradación de atributos

Score:
7.5 out of 10 points


Se presenta una aproximación inicial a los atributos degradados, enfocándose principalmente en mantenibilidad, acoplamiento y calidad del código. Se menciona que algunos archivos presentan deuda técnica, y se insertan capturas que muestran métricas generales. No obstante, el análisis se limita a la observación, sin desarrollar una lectura más profunda sobre cómo estos aspectos afectan la operación o evolución del sistema.

Faltó incluir un análisis detallado del impacto técnico u organizacional de esas degradaciones, como mayor tiempo de mantenimiento, mayor probabilidad de errores en producción o dificultad de escalar ciertas funcionalidades. Tampoco se clasificaron formalmente los atributos afectados (como seguridad, desempeño o confiabilidad) ni se estimó su severidad. Incluir esa reflexión, respaldada por datos concretos, habría fortalecido significativamente el argumento técnico.


## 5. Motivador de negocio 

Score:
5 out of 5 points

Se plantea una necesidad razonable de mejorar el acceso a información clínica, trazabilidad de los resultados y seguridad de los datos, lo cual está alineado con los atributos que se han mencionado como problemáticos. El argumento general es válido y muestra que se busca un sistema más funcional y confiable.

Sin embargo, el motivador permanece en un plano general y no se vincula de forma explícita con los hallazgos técnicos previos. Faltó establecer una relación directa entre el motivador y atributos específicos como mantenibilidad, escalabilidad o disponibilidad, y explicar cómo estos afectan los objetivos de negocio. También se pudo haber incluido una proyección de valor esperado tras la modernización (por ejemplo, mayor capacidad de respuesta, menor dependencia técnica o reducción de incidentes).

# 6. Estrategia de modernización 

Score:
7 out of 10 points

Se menciona la intención de migrar a microservicios y realizar pruebas con arquitectura orientada a servicios. Sin embargo, la propuesta se presenta sin argumentación técnica sólida ni análisis comparativo. No se discuten otras estrategias posibles ni se explica por qué esta es la más adecuada para el sistema actual. Tampoco se identifican riesgos, complejidades ni requisitos previos para llevarla a cabo.

Faltó desarrollar una justificación técnica concreta, vinculando los problemas detectados con las capacidades de la nueva arquitectura. También habría sido necesario mostrar cómo esta estrategia responde al motivador de negocio y permite mejorar atributos de calidad. La ausencia de alternativas evaluadas (como encapsulamiento, refactorización o replatforming) limita la solidez de la decisión.

## 7. Diagrama de componentes 

Score:
15 out of 15 points

 

El diagrama cumple plenamente con los requerimientos de la rúbrica. Presenta los componentes funcionales actuales, representa las relaciones entre ellos, identifica gráficamente cuáles serán modernizados y lo hace con un nivel técnico adecuado. Además, se apoya con una leyenda textual clara que contextualiza la imagen.

Este nivel de representación supera lo esperado para una entrega de medio proyecto, ya que demuestra dominio conceptual de arquitectura de software, uso de herramientas de documentación visual y claridad en la delimitación del alcance.

## 8. Tabla de funcionalidades 

Score:
14 out of 15 points

 Falta de priorización explícita: no se indica si alguna funcionalidad es más crítica o si hay dependencias entre ellas (por ejemplo, que “crear usuario” sea previo a “asociar perfil”).  

 No se menciona si las funcionalidades fueron seleccionadas con base en hallazgos técnicos previos (como deuda técnica, problemas de seguridad o bajo desempeño)  


## 9. Post tablero colaborativo 

Score:
5 out of 5 points

Ok, agregar la url al documento.