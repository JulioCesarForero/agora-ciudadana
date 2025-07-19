Últimas entregas del proyecto

El propósito de esta lectura es describir las últimas entregas del proyecto del curso las cuales están relacionadas con las siguientes actividades del proceso de modernización:

1. Diseñar arquitectura destino
2. Realizar experimento (vale la pena resaltar que se hará un pequeño ejercicio de estimación durante el experimento)

A continuación, se describe lo que se espera para cada actividad.

# 1° Diseñar arquitectura destino

La actividad “Diseñar arquitectura destino” consiste en enriquecer las vistas funcionales del software (obtenidas en las etapas anteriores) con patrones y tácticas que contribuyan a la satisfacción de los atributos de calidad deseables. Así, el equipo debe elaborar un diagrama de despliegue de la arquitectura to-be incluyendo: componentes de software modernizados (y legados si aplica), patrones y tácticas. Además, debe acompañar el diagrama de una descripción detallada de los elementos de arquitectura (y sus interacciones) y una justificación de los patrones/ tácticas escogidas.

En función de la estrategia de modernización y el alcance definidos por el equipo, la arquitectura to-be puede abarcar componentes de software legados que interoperan con los componentes modernizados a través de los patrones de diseños vistos en el curso. Esto también debe describirse si aplica.

# 2° Realizar experimento

El propósito del experimento es validar la funcionalidad de la arquitectura destino y explorar las tecnologías escogidas para la aplicación modernizada. Lo que se espera para esta actividad se describe a continuación:

- Elabore cada una de las partes del pre-experimento, a saber:



---


# Requisitos

escoja “n” requisitos a modernizar, donde n es el resultado de la división entera del número de integrantes del grupo entre 2. Los requisitos que escojan deben estar entre aquellos listados en la tabla de la entrega 2 del proyecto y deben ser independientes entre sí, por ej., un listado de elementos, una búsqueda por identificador, una creación de elemento, etc.

# Descripción

especifique lo siguiente

- tecnología y/o framework destino, describiendo los elementos estructurales de dichas tecnologías
- mapeos que se realizarán entre los elementos de la aplicación legado y la aplicación modernizada. Acompañar los mapeos de una descripción
- ejemplos del código legado y su correspondiente código modernizado para los requisitos escogidos. No es obligatorio incluir todas las instrucciones de código solo fragmentos que visibilicen lo que se debe reescribir. El código debe explicarse
- diagrama de la infraestructura computacional que se usará, acompañado de una descripción. Si la infraestructura computacional es de nube es importante describir qué servicios particulares del proveedor se usarán
- cómo planea instrumentar el experimento y qué métricas se podrían recolectar. En otras palabras, debe enunciar qué tipos de pruebas y métricas se podrían usar para evaluar el cumplimiento de los atributos de calidad deseables en la aplicación destino. El tipo de prueba depende de los atributos de calidad que se plantearon como deseables en las entregas previas. Por ej., para desempeño/escalabilidad puede ser una prueba de carga, para mantenibilidad métricas de SonarQube (o



---


# Desarrollo de Pruebas y Recomendaciones

El desarrollo de las pruebas está fuera del alcance de estas últimas entregas.

# Interesados en las Pruebas

¿Qué interesados se podrían ver involucrados en las pruebas?

# Diseño Detallado

Incluya al menos 2 diagramas de diseño detallado (pueden ser diagramas UML de clases, secuencia, objetos, actividad, etc.) que ayuden a entender mejor el funcionamiento de la arquitectura to-be. Explique cada diagrama. Los diagramas de componentes y despliegue solicitados previamente no aplican para este punto ya que esos son diagramas de nivel de arquitectura o diseño global.

# Estimación de Esfuerzo

Estime el esfuerzo de modernización para los requisitos escogidos y otras tareas de modernización (por ej., despliegue de infraestructura). Realice la estimación en la unidad que desee (i.e., puntos de historia o puntos de función), pero justifique por qué eligió una u otra.

# Post-Experimento

Elabore cada una de las partes del post-experimento, a saber:

# Recomendaciones

Reporte si SÍ o NO la arquitectura to-be (e implementación correspondiente) hacen que la modernización sea viable desde un punto de vista técnico. Justifique su afirmación o negación. En caso de que NO analice qué alternativas se pueden explorar. Si observó alguna desviación con respecto a lo esperado, repórtela y enuncie algunas recomendaciones.

# Esfuerzo Real

Reporte el esfuerzo real en horas para cada los requisitos modernizados y otras tareas. Si el esfuerzo real de algún requisito/tarea no está acorde con el tamaño en puntos, explique el porqué.

Incluya el enlace del repositorio del código modernizado.



---

Adicionalmente, se espera que el equipo realice dos videos como se enuncia a continuación:

# 1. Video de avance del proyecto

El propósito de este video es describir la arquitectura to-be y algunas partes del pre-experimento para recibir retroalimentación antes de la entrega final del proyecto. En particular, las partes del pre-experimento que se deben incluir en este video son: propósito, requisitos y descripción. Adicionalmente, para que se entiendan de mejor manera tanto el diseño de la arquitectura to-be como la planeación del pre-experimento, es necesario que el video incluya algunos apartes de las entregas iniciales del proyecto, a saber: problemática que motiva la modernización, motivador del negocio, resolución a las preguntas de comprensión del equipo a través de la cartografía, estrategia de modernización y justificación, diagrama de componentes de la aplicación legado y su descripción. El video de avance del proyecto debe durar a lo sumo 15 minutos, cargarse en alguna plataforma de streaming que facilite su visualización y entregarse en la semana 7 del curso, de acuerdo con la fecha especificada en Coursera. Especifique la URL del video en la asignación correspondiente.

# 2. Video de demostración

Muestre en EJECUCIÓN cada requisito en el legado y su correspondencia en lo modernizado. La demostración debe estar acompañada de una descripción oral detallada. Este video debe cargarse en alguna plataforma de streaming que facilite su visualización.

Para el desarrollo de estos puntos el equipo puede guiarse de los tutoriales del curso.

Se espera que el equipo consolide los resultados de las actividades 1°, 2° y la URL del video de demostración en un documento que debe cargarse en la asignación de semana 8, de acuerdo con la fecha especificada en Coursera.

---

# Objetivos de Aprendizaje

Diseñar una arquitectura to-be teniendo en cuenta los resultados de la ingeniería inversa y los requerimientos de la modernización.

Construir un experimento que permita validar que la arquitectura to-be es viable técnicamente y satisface los atributos de calidad deseables en el marco del proyecto de modernización.

# Proyecto. Video de avance: arquitectura to-be y pre-experimento

# 1. Question 1

Video de avance del proyecto: el propósito de este video es describir la arquitectura to-be y algunas partes del pre-experimento para recibir retroalimentación antes de la entrega final del proyecto. En particular, las partes del pre-experimento que se deben incluir en este video son: propósito, requisitos y descripción. Adicionalmente, para que se entiendan de mejor manera tanto el diseño de la arquitectura to-be como la planeación del pre-experimento, es necesario que el video incluya algunos apartes de las entregas iniciales del proyecto, a saber: problemática que motiva la modernización, motivador del negocio, resolución a las preguntas de comprensión del equipo a través de la cartografía, estrategia de modernización y justificación, diagrama de componentes de la aplicación legado y su descripción. El video de avance del proyecto debe durar a lo sumo 15 minutos, cargarse en alguna plataforma de streaming que facilite su visualización y entregarse en la semana 7 del curso, de acuerdo con la fecha especificada en Coursera.

Especifique la URL del video en la asignación correspondiente. Adicionalmente, un representante del equipo debe colocar dicha URL en la columna correspondiente de este Excel para facilitar la coevaluación.

---

que se hará en la última semana. Por favor, evite sobreescribir lo que otro grupo ha hecho en el Excel.

Recuerde que el contexto de esta asignación es dado en la lectura ”Últimas entregas del proyecto” de la semana en curso.

En esta actividad los equipos realizarán un video en donde reportarán el diseño de la arquitectura to-be y el pre-experimento del proyecto de modernización del curso.

# Criterios de valoración del video a continuación:

- Comunica y argumenta la totalidad de los elementos solicitados para el video (40 puntos).
- La arquitectura to-be planteada es coherente con el motivador de negocio y los atributos de calidad deseables (20 puntos).
- La descripción y el propósito del pre-experimento son coherentes entre sí (20 puntos)
- El formato de presentación transmite el contenido de manera clara y ordenada (10 puntos).
- Duración esperada respetada (2 puntos).
- Buena calidad (audio e imagen) (8 puntos).