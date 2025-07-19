1.
Question 1
Arquitectura to-be y experimento: deben desarrollarse a través de los ítems que se describen a continuación: 

Diagrama de despliegue de la arquitectura to-be incluyendo componentes de software modernizados (y legados si aplica), patrones y tácticas. Además, debe acompañar el diagrama de una descripción detallada de los elementos de arquitectura (y sus interacciones) y una justificación de los patrones/ tácticas escogidas. En este ítem deben reportar la respuesta a la pregunta: ¿Qué prácticas observadas en los recursos Apigee podría extrapolar a su arquitectura to-be? ¿Por qué? 

Pre-experimento, a saber:  

Propósito: describa la intención del experimento 

Requisitos: escoja “n” requisitos a modernizar, donde n es el resultado de la división entera del número de integrantes del grupo entre 2. Los requisitos que escojan deben estar entre aquellos listados en la tabla de la entrega 2 del proyecto  

Descripción: especifique lo siguiente 

tecnología y/o framework destino, describiendo los elementos estructurales de dichas tecnologías 

mapeos que se realizarán entre los elementos de la aplicación legado y la aplicación modernizada. Acompañar los mapeos de una descripción  

ejemplos del código legado y su correspondiente código modernizado para los requisitos escogidos. No es obligatorio incluir todas las instrucciones de código solo fragmentos que visibilicen lo que se debe reescribir. El código debe explicarse 

diagrama de la infraestructura computacional que se usará, acompañado de una descripción. Si la infraestructura computacional es de nube es importante describir qué servicios particulares del proveedor se usarán  

cómo planea instrumentar el experimento y qué métricas se podrían recolectar. En otras palabras, debe enunciar qué tipos de pruebas y métricas se podrían usar para evaluar el cumplimiento de los atributos de calidad deseables en la aplicación destino. El tipo de prueba depende de los atributos de calidad que se plantearon como deseables en las entregas previas. Por ej., para desempeño/escalabilidad puede ser una prueba de carga, para mantenibilidad métricas de SonarQube (o herramienta similar), para usabilidad encuestas, etc. El desarrollo de las pruebas está fuera del alcance de estas últimas entregas  

qué interesados se podrían ver involucrados en las pruebas 

Diseño detallado: incluya al menos 2 diagramas de diseño (diferentes al de componentes y despliegue solicitados previamente) que ayuden a entender mejor el funcionamiento de la arquitectura to-be. Explique cada diagrama  

Estimación de esfuerzo: estime el esfuerzo de modernización para los requisitos escogidos y otras tareas de modernización (por ej., despliegue de infraestructura). Realice la estimación en la unidad que desee (i.e., puntos de historia o puntos de función), pero justifique por qué seleccionó una u otra. Para la selección tenga en cuenta las siguientes preguntas orientadoras: 

¿Cuál de las siguientes técnicas ágiles prefiere para estimar: analogía, desagregación y/o juicio de expertos? ¿Por qué? 

¿Ha clasificado las funciones de un software en términos de "datos" y "transacciones"? ¿Cuáles son las ventajas y desventajas de este método de estimación de tamaño? 

Post-experimento, a saber:  

Recomendaciones: reporte si SÍ o NO la arquitectura to-be (e implementación correspondiente) hacen que la modernización sea viable desde un punto de vista técnico. Justifique su afirmación o negación. En caso de que NO analice qué alternativas se pueden explorar. Si observó alguna desviación con respecto a lo esperado, repórtela y enuncie algunas recomendaciones  

Esfuerzo real: reporte el esfuerzo real en horas para cada los requisitos modernizados y otras tareas. Si el esfuerzo real de algún requisito/tarea no está acorde con el tamaño en puntos, explique el porqué  

Enlace del repositorio del código modernizado: es preferible un repositorio público, pero si desea dejarlo privado compártalo al usuario Github: modernizacionsoft 


Video de demostración: muestre en EJECUCIÓN cada requisito en el legado y su correspondencia en lo modernizado. La demostración debe estar acompañada de una descripción oral detallada. Este video debe cargarse en alguna plataforma de streaming que facilite su visualización. 


Se espera que el equipo consolide la arquitectura to-be, pre/post experimento y URL del video de demostración en un documento que debe cargarse en esta asignación. Recuerde agregar una sección sobre el uso de IAG en su entregable, en dicha sección debe responder las preguntas indicadas en el programa del curso.



nstructions
Overview
En esta actividad los equipos terminarán de diseñar la arquitectura to-be y construir el experimento del proyecto de modernización del curso.  

La entrega será evaluada teniendo en cuenta las dimensiones a continuación:

Claro, aquí tienes el cuadro en formato Markdown.

| Dimensión | Subdimensión | Descripción | Puntos |
| :--- | :--- | :--- | :--- |
| **Arquitectura to-be** | Diagrama de despliegue | Incluye componentes de software modernizados (y legados si aplica), patrones y tácticas. Los patrones y tácticas usados están alineados con el atributo de calidad declarado en el motivador de la entrega del proyecto 2 | 10 |
| | Respuesta a las preguntas sobre APIGEE | Las respuestas son claras y coherentes | 2 |
| **Pre-experimento** | Propósito | La intención es clara | 2 |
| | Requisitos | Cada requisito tiene una descripción y unos criterios de aceptación claros. El número de requisitos es el resultado de la división entera del número de integrantes del grupo entre 2 | 2 |
| | Tecnología y/o framework destino | Enuncia la tecnología/framework destino y describe los elementos estructurados de dichas tecnologías | 4 |
| | Mapeos | Especifica los mapeos entre los elementos de la aplicación legado y la aplicación modernizada, acompañando con una descripción y la cardinalidad del mapeo (uno a uno, uno a muchos, muchos a uno) | 6 |
| | Ejemplos de código | Incluye fragmentos de código de la app. legada y modernizada, acompañando con descripciones | 12 |
| | Instrumentación y datos | Enuncia qué tipo de pruebas y métricas se podrían realizar/recolectar para evaluar el cumplimiento del atributo de calidad declarado | 4 |
| | Interesados | Enuncia quiénes podrían estar involucrados en las pruebas | 2 |
| | Diseño detallado | Incluye al menos 2 diagramas de diseño alternativos al de despliegue y componentes, acompañando con una explicación | 8 |
| | Selección de unidad de estimación | Indica la unidad seleccionada y el por qué apoyándose en su pericia, ventajas/desventajas ofrecidas por las técnicas de estimación vistas en el curso | 4 |
| | Estimación de esfuerzo | Estima el esfuerzo necesario para los requisitos seleccionados y otras tareas de modernización | 6 |
| **Post-experimento** | Recomendaciones | Reporta Sí o No la arquitectura to-be es viable, acompañándo de una justificación. Da recomendaciones. Reconoce desviaciones de la implementación con respecto al diseño to-be. Si la arquitectura No es viable menciona alternativas | 8 |
| | Esfuerzo real | Reporta el esfuerzo real para requisitos y otras tareas de modernización | 4 |
| **Enlace repositorio** | N/A | Incluye enlace y el enlace lleva efectivamente al código modernizado previamente descrito | 2 |
| **Video demostración**| Contenido | Incluye una demostración de los requisitos en el legado | 6 |
| | | Incluye una demostración de los requisitos en la app. Modernizada | 10 |
| | Formato | El formato de presentación transmite el contenido de manera clara y ordenada | 3 |
| | Calidad | Buena calidad (audio e imagen) | 3 |
| **Tablero patrones Thoughworks**| N/A | Hay un post del grupo en el tablero colaborativo sobre los patrones de modernización Thoughtworks de semana 5. El post es claro y fue realizado en la semana 5 | 2 |