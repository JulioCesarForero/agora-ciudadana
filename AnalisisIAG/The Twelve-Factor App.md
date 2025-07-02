https://12factor.net/es/

# Introducción
En estos tiempos, el software se está distribuyendo como un servicio: se le denomina web apps, o software as a service (SaaS). “The twelve-factor app” es una metodología para construir aplicaciones SaaS que:

Usan formatos declarativos para la automatización de la configuración, para minimizar el tiempo y el coste que supone que nuevos desarrolladores se unan al proyecto;
Tienen un contrato claro con el sistema operativo sobre el que trabajan, ofreciendo la máxima portabilidad entre los diferentes entornos de ejecución;
Son apropiadas para desplegarse en modernas plataformas en la nube, obviando la necesidad de servidores y administración de sistemas;
Minimizan las diferencias entre los entornos de desarrollo y producción, posibilitando un despliegue continuo para conseguir la máxima agilidad;
Y pueden escalar sin cambios significativos para las herramientas, la arquitectura o las prácticas de desarrollo.
La metodología “twelve-factor” puede ser aplicada a aplicaciones escritas en cualquier lenguaje de programación, y cualquier combinación de ‘backing services’ (bases de datos, colas, memoria cache, etc).

## Contexto
Los colaboradores de este documento han estado involucrados directamente en el desarrollo y despliegue de cientos de aplicaciones, y han sido testigos indirectos del desarrollo, las operaciones y el escalado de cientos de miles de aplicaciones mediante nuestro trabajo en la plataforma Heroku.

Este documento sintetiza toda nuestra experiencia y observaciones en una amplia variedad de aplicaciones SaaS. Es la triangulación entre practicas ideales para el desarrollo de aplicaciones, prestando especial atención a las dinámicas del crecimiento natural de una aplicación a lo largo del tiempo, las dinámicas de colaboración entre desarrolladores que trabajan en el código base de las aplicaciones y evitando el coste de la entropía del software.

Nuestra motivación es mejorar la concienciación sobre algunos problemas sistémicos que hemos observado en el desarrollo de las aplicaciones modernas, aportar un vocabulario común que sirva para discutir sobre estos problemas, y ofrecer un conjunto de soluciones conceptualmente robustas para esos problemas acompañados de su correspondiente terminología. El formato está inspirado en los libros de Martin Fowler Patterns of Enterprise Application Architecture y Refactoring.

## ¿Quién debería leer este documento?
Cualquier desarrollador que construya aplicaciones y las ejecute como un servicio. Ingenieros de operaciones que desplieguen y gestionen dichas aplicaciones.

---

Twelve Factors
I. Código base (Codebase)
Un código base sobre el que hacer el control de versiones y multiples despliegues
II. Dependencias
Declarar y aislar explícitamente las dependencias
III. Configuraciones
Guardar la configuración en el entorno
IV. Backing services
Tratar a los “backing services” como recursos conectables
V. Construir, desplegar, ejecutar
Separar completamente la etapa de construcción de la etapa de ejecución
VI. Procesos
Ejecutar la aplicación como uno o más procesos sin estado
VII. Asignación de puertos
Publicar servicios mediante asignación de puertos
VIII. Concurrencia
Escalar mediante el modelo de procesos
IX. Desechabilidad
Hacer el sistema más robusto intentando conseguir inicios rápidos y finalizaciones seguras
X. Paridad en desarrollo y producción
Mantener desarrollo, preproducción y producción tan parecidos como sea posible
XI. Historiales
Tratar los historiales como una transmisión de eventos
XII. Administración de procesos
Ejecutar las tareas de gestión/administración como procesos que solo se ejecutan una vez

---

https://12factor.net/es/codebase

# I. Código base (Codebase)
Un código base sobre el que hacer el control de versiones y multiples despliegues
Una aplicación “twelve-factor” se gestiona siempre con un sistema de control de versiones, como Git, Mercurial, o Subversion. A la copia de la base de datos de seguimiento de versiones se le conoce como un repositorio de código, a menudo abreviado como repo de código o simplemente repo.

El código base es cualquier repositorio (en un sistema de control de versiones centralizado como Subversion), o cualquier conjunto de repositorios que comparten un commit raíz (en un sistema de control de versiones descentralizado como Git).

El código base se usa en muchos despliegues

Siempre hay una relación uno a uno entre el código base y la aplicación:

* Si hay multiples códigos base, no es una aplicación – es un sistema distribuido. Cada componente en un sistema distribuido es una aplicación, y cada uno, individualmente, puede cumplir los requisitos de una aplicación “twelve-factor”.
* Compartir código en varias aplicaciones se considera una violación de la metodología “twelve factor”. La solución en este caso es separar el código compartido en librerías que pueden estar enlazadas mediante un gestor de dependencias.

El código base de la aplicación es único, sin embargo, puede haber tantos despliegues de la aplicación como sean necesarios. Un despliegue es una instancia de la aplicación que está en ejecución. Normalmente, se ejecuta en un entorno de producción, y uno o varios entornos de pruebas. Además, cada desarrollador tiene una instancia en su propio entorno de desarrollo, los cuales se consideran también como despliegues.

El código base es el mismo en todos los despliegues, aunque pueden ser diferentes versiones en cada despliegue. Por ejemplo, un desarrollador tiene algunos commits sin desplegar en preproducción; preproducción tiene algunos commits que no están desplegados en producción. Pero todos ellos comparten el mismo código base, de este modo todos son identificables como diferentes despliegues de la misma aplicación.

---

https://12factor.net/es/dependencies

# II. Dependencias
Declarar y aislar explícitamente las dependencias
La mayoría de los lenguajes de programación tienen un sistema de gestión de paquetes para distribuir sus librerías, como CPAN en Perl o Rubygems en Ruby. Las librerías instaladas a través de estos sistemas se pueden instalar en el sistema (también conocido como “site packages”) o limitarse al directorio que contiene la aplicación (también conocido como “vendoring” o “bundling”).

Una aplicación “twelve-factor” no depende nunca de la existencia explícita de paquetes instalados en el sistema. Declara todas sus dependencias, completamente y explícitamente, mediante un manifiesto de declaración de dependencias. Además, usa herramientas de aislamiento de dependencias durante la ejecución para asegurar que las dependencias, implícitamente, no afectan al resto del sistema. La especificación de dependencias completa y explícita se aplica de la misma manera tanto en producción como en desarrollo.

Por ejemplo, la Bundler de Ruby tiene el formato de su manifiesto Gemfile para declarar sus dependencias y bundle exec para aislar sus dependencias. En Python existen dos herramientas independientes para estas tareas – Pip se usa para la declaración de dependencias y Virtualenv para el aislamiento. Incluso C tiene Autoconf para la declaración de sus dependencias, y el enlace estático proporciona aislamiento de sus dependencias. No importa qué conjunto de herramientas se use, la declaración y el aislamiento de dependencias se deben usar siempre juntas, usar solo una o la otra no es suficiente para satisfacer las condiciones de “twelve-factor”.

Uno de los beneficios de la declaración explícita de dependencias es que simplifica la configuración para los nuevos desarrolladores de la aplicación. Cualquier desarrollador que se incorpore al equipo debe poder probar el código base de la aplicación en su máquina de desarrollo. Tan solo debe tener instalados el entorno de ejecución del lenguaje y el gestor de dependencias como prerequisitos. Lo cual permitirá configurar todo lo necesario para ejecutar el código de la aplicación con un mandato para construir. Por ejemplo, el mandato para construir en Ruby/Bundler es bundle install, mientras que en Clojure/Leiningen es lein deps.

Las aplicaciones “Twelve-factor” tampoco dependen de la existencia de ninguna herramienta en el sistema. Por ejemplo, ejecutar mandatos como ImageMagick o curl. Aunque estas herramientas pueden existir en muchos, o incluso en la mayoría de los sistemas, no existen garantías de que vayan a existir en todos los sistemas donde la aplicación pueda ser ejecutada en un futuro, ni de que las versiones futuras de un sistema vayan a ser compatibles con la aplicación. Si la aplicación necesita ejecutar una herramienta del sistema, dicha herramienta debería estar incluida dentro de la aplicación.

---

https://12factor.net/es/config

# III. Configuración
Guardar la configuración en el entorno
La configuración de una aplicación es todo lo que puede variar entre despliegues (entornos de preproducción, producción, desarrollo, etc), lo cual incluye:

* Recursos que manejan la base de datos, Memcached, y otros “backing services”
* Credenciales para servicios externos tales como Amazon S3 o Twitter
* Valores de despliegue como por ejemplo el nombre canónico del equipo para el despliegue

A veces las aplicaciones guardan configuraciones como constantes en el código, lo que conduce a una violación de la metodología “twelve-factor”, que requiere una estricta separación de la configuración y el código. La configuración varía sustancialmente en cada despliegue, el código no.

La prueba de fuego para saber si una aplicación tiene toda su configuración correctamente separada del código es comprobar que el código base puede convertirse en código abierto en cualquier momento, sin comprometer las credenciales.

Hay que resaltar que la definición de “configuración” no incluye las configuraciones internas de la aplicación, como config/routes.rb en Rails, o como se conectan los módulos en Spring. Este tipo de configuraciones no varían entre despliegues, y es por eso que están mejor en el código.

Otra estrategia de configuración es el uso de ficheros de configuración que no se guardan en el control de versiones, como ocurre con el config/database.yml de Rails. Esto supone una gran mejora con respecto a las constantes que se guardan en el repositorio, aunque todavía tiene ciertas debilidades: es fácil guardar un fichero de configuración en el repo por error; se tiende a desperdigar los ficheros de configuración en diferentes sitios y con distintos formatos, siendo más difícil la tarea de ver y gestionar toda la configuración en un solo sitio. Además, el formato tiende a ser específico del lenguaje o del framework.

Las aplicaciones “twelve-factor” almacenan la configuración en variables de entorno (abreviadas normalmente como env vars o env). Las variables de entorno se modifican fácilmente entre despliegues sin realizar cambios en el código; a diferencia de los ficheros de configuración, en los que existe una pequeña posibilidad de que se guarden en el repositorio de código accidentalmente; y a diferencia de los ficheros de configuración personalizados u otros mecanismos de configuración, como los System Properties de Java, son un estándar independiente del lenguaje y del sistema operativo.

Otro aspecto de la gestión de la configuración es la clasificación. A veces, las aplicaciones clasifican las configuraciones en grupos identificados (a menudo llamados “entornos” o “environments”) identificando después despliegues específicos, como ocurre en Rails con los entornos development, test, y production. Este método no escala de una manera limpia: según se van creando despliegues de la aplicación, se van necesitando nuevos entornos, tales como staging o qa. Según va creciendo el proyecto, los desarrolladores van añadiendo sus propios entornos especiales como joes-staging, resultando en una explosión de combinaciones de configuraciones que hacen muy frágil la gestión de despliegues de la aplicación.

En una aplicación “twelve-factor”, las variables de entorno son controles granulares, cada una de ellas completamente ortogonales a las otras. Nunca se agrupan juntas como “entornos”, pero en su lugar se gestionan independientemente para cada despliegue. Este es un modelo que escala con facilidad según la aplicación se amplía, naturalmente, en más despliegues a lo largo de su vida.

---

https://12factor.net/es/backing-services

# IV. Backing services
Tratar a los “backing services” como recursos conectables
Un backing service es cualquier recurso que la aplicación puede consumir a través de la red como parte de su funcionamiento habitual. Entre otros ejemplos, podemos encontrar bases de datos (como MySQL o CouchDB), los sistemas de mensajería y de colas (como RabbitMQ o Beanstalkd), los servicios SMTP de email (como Postfix), y los sistemas de cache (como Memcached).

Tradicionalmente, los “backing services” (como las bases de datos) han sido gestionadas por los mismos administradores de sistemas que despliegan la aplicacion en producción. Además de esos servicios gestionados localmente, las aplicaciones también pueden usar servicios proporcionados y gestionados por terceros, como por ejemplo los servicios SMTP (Postmark), los servicios de recopilación de métricas (como New Relic o Loggly), los servicios de activos binarios (como Amazon S3), e incluso servicios que se consumen accediendo a ellos mediante un API (como Twitter, Google Maps, o Last.fm).

El código de una aplicación “twelve-factor” no hace distinciones entre servicios locales y de terceros. Para la aplicación, ambos son recursos conectados, accedidos mediante una URL u otro localizador o credencial almacenado en la config. Un despliegue de una aplicación “twelve-factor” debería ser capaz de reemplazar una base de datos local MySQL por una gestionada por un tercero (como Amazon RDS) sin ningún cambio en el código de la aplicación. Igualmente, un servidor SMTP local se podría cambiar por un servicio de terceros (como Postmark) sin modificaciones en el código. En ambos casos, solo el manejador del recurso necesita cambiar en la configuración.

Cada “backing service” distinto es un recurso. Por ejemplo, una base de datos MySQL es un recurso; dos bases de datos MySQL (usadas para “sharding” en la capa de aplicación) les convierte en dos recursos distintos. Una aplicación “twelve factor” trata esas bases de datos como recursos conectados, lo que demuestra su bajo acoplamiento al despliegue al que se unen.

Un despliegue en producción conectado a cuatro backing services.

Los recursos se pueden conectar y desconectar a voluntad. Por ejemplo, si la base de datos funciona mal debido a un problema en el hardware, el administrador de la aplicación puede cambiar a un nuevo servidor de bases de datos que haya sido restaurado de un backup reciente. La base de datos actual de producción se puede desconectar, y conectar una nueva base de datos sin tener que cambiar nada en el código.

---

https://12factor.net/es/build-release-run

# V. Construir, distribuir, ejecutar
Separar completamente la etapa de construcción de la etapa de ejecución
El código base se transforma en un despliegue (que no es de desarrollo) al completar las siguientes tres etapas:

La etapa de construcción es una transformación que convierte un repositorio de código en un paquete ejecutable llamado construcción (una “build”). En la etapa de construcción se traen todas las dependencias y se compilan los binarios y las herramientas usando una versión concreta del código correspondiente a un commit especificado por el proceso de despliegue.
En la fase de distribución se usa la construcción creada en la fase de construcción y se combina con la configuración del despliegue actual. Por tanto, la distribución resultante contiene tanto la construcción como la configuración y está lista para ejecutarse inmediatamente en el entorno de ejecución.
La fase de ejecución (también conocida como “runtime”) ejecuta la aplicación en el entorno de ejecución, lanzando un conjunto de procesos de una distribución concreta de la aplicación.
El código se convierte en una construcción, que se combina con la configuración para crear una distribución.

Las aplicaciones “twelve-factor” hacen una separación completa de las fases de construcción, de distribución y de ejecución. Por ejemplo, es imposible hacer cambios en el código en la fase de ejecución, porque no hay una manera de propagar dichos cambios a la fase de construcción.

Las herramientas de despliegue ofrecen, normalmente, herramientas de gestión de distribuciones (releases). La capacidad de volver a una versión anterior es especialmente útil. Por ejemplo, la herramienta de despliegues Capistrano almacena distribuciones en un subdirectorio llamado releases, donde la distribución actual es un enlace simbólico al directorio de la distribución actual. Su mandato rollback hace fácil y rápidamente el trabajo de volver a la versión anterior.

Cada distribución debería tener siempre un identificador único de distribución, como por ejemplo una marca de tiempo (timestamp) de la distribución (2011-04-06-20:32:17) o un número incremental (como v100). Las distribuciones son como un libro de contabilidad, al que solo se le pueden agregar registros y no pueden ser modificados una vez son creados. Cualquier cambio debe crear una nueva distribución.

Cada vez que un desarrollador despliega código nuevo se crea una construcción nueva de la aplicación. La fase de ejecución, en cambio, puede suceder automáticamente, por ejemplo, cuando se reinicia un servidor, o cuando un proceso termina inesperadamente siendo reiniciado por el gestor de procesos. Por tanto, la fase de ejecución debería mantenerse lo más estática posible, ya que evita que una aplicación en ejecución pueda causar una interrupción inesperada, en mitad de la noche, cuando no hay desarrolladores a mano. La fase de construcción puede ser más compleja, ya que los errores siempre están en la mente de un desarrollador que dirige un despliegue.

---

https://12factor.net/es/processes

# VI. Procesos
Ejecutar la aplicación como uno o más procesos sin estado
La aplicación se ejecuta como uno o más procesos en el entorno de ejecución.

El caso más sencillo que podemos plantear es que el código es un script independiente, el entorno de ejecución es un portátil de un desarrollador, el compilador o interprete correspondiente del lenguaje está instalado, y el proceso se lanza mediante la linea de mandatos (por ejemplo, python my_script.py). Por otro lado podemos encontrar el caso de un despliegue en producción de una aplicación compleja que puede usar muchos tipos de procesos, instanciados como cero o más procesos en ejecución.

Los procesos “twelve-factor” no tienen estado y son “share-nothing”. Cualquier información que necesite persistencia se debe almacenar en un ‘backing service’ con estado, habitualmente una base de datos.

Tanto el espacio de memoria de un proceso como el sistema de ficheros se pueden usar como si fueran una cache temporal para hacer transacciones. Por ejemplo, descargar un fichero de gran tamaño, realizar alguna operación sobre él, y almacenar sus resultados en una base de datos. Las aplicaciones “twelve-factor” nunca dan por hecho que cualquier cosa cacheada en memoria o en el disco vaya a estar disponible al realizar una petición al ejecutar diferentes procesos. Con muchos procesos de cada tipo ejecutándose al mismo tiempo, existe una gran probabilidad de que otro proceso distinto sirva una petición en el futuro. Incluso cuando solo está corriendo un solo proceso, un reinicio (provocado por el despliegue de código, un cambio de configuración o un cambio de contexto del proceso) normalmente elimina todo el estado local (e.g. memoria y sistema de ficheros).

Los compresores de estáticos (como Jammit o django-compressor) usan el sistema de ficheros como una cache para ficheros compilados. En las aplicaciones “twelve-factor” es preferible realizar esta compilación durante la fase de construcción, como con el asset pipeline de Rails, en lugar de hacerlo en tiempo de ejecución.

Algunos sistemas webs dependen de “sticky sessions”, esto quiere decir que cachean la información de la sesión de usuario en la memoria del proceso de la aplicación y esperan peticiones futuras del mismo visitante para redirigirle al mismo proceso. Las “sticky sessions” son una violación de “twelve-factor” y no deberían usarse nunca ni depender de ellas. La información del estado de la sesión es un candidato perfecto para almacenes de información que ofrecen mecanismos de tiempo de expiración, como Memcached o Redis.

---

https://12factor.net/es/port-binding

# VII. Asignación de puertos
Publicar servicios mediante asignación de puertos
Las aplicaciones web se ejecutan a menudo mediante contenedores web. Por ejemplo, las aplicaciones de PHP se suelen ejecutar como módulos del HTTPD de Apache, y las aplicaciones Java en Tomcat.

Las aplicaciones “twelve factor” son completamente auto-contenidas y no dependen de un servidor web en ejecución para crear un servicio web público. Una aplicación web usa HTTP como un servicio al que se le asigna un puerto, y escucha las peticiones que recibe por dicho puerto.

En los entornos de desarrollo, los desarrolladores usan una URL del servicio (por ejemplo http://localhost:5000/), para acceder al servicio que ofrece la aplicación. En la fase de despliegue, existe una capa de enrutamiento que se encarga de que las peticiones que llegan a una dirección pública se redirijan hacia el proceso web que tiene asignado su puerto correspondiente.

Esto se implementa, normalmente, usando una declaración de dependencias donde se incluyen librerías de las aplicaciones web, como Tornado para Python, Thin para Ruby, o Jetty para Java y otros lenguajes basados en la Máquina Virtual de Java (JVM). Esto ocurre totalmente en el entorno del usuario, es decir, dentro del código de la aplicación. El contrato con el entorno de ejecución obliga al puerto a servir las peticiones.

HTTP no es el único servicio que usa asignación de puertos. La verdad, es que cualquier servicio puede ejecutarse mediante un proceso al que se le asigna un puerto y queda a la espera de peticiones. Entre otros ejemplos podemos encontrar ejabberd (que usa XMPP), y Redis (que usa el protocolo Redis).

También es cierto que la aproximación de asignación de puertos ofrece la posibilidad de que una aplicación pueda llegar a ser un “backing service” para otra aplicación, usando la URL de la aplicación correspondiente como un recurso declarado en la configuración de la aplicación que consume este “backing service”.

---

https://12factor.net/es/concurrency

# VIII. Concurrencia
Escalar mediante el modelo de procesos
Todo programa de ordenador, al ejecutarse, se encuentra representado en memoria por uno o más procesos. Las aplicaciones web se pueden ejecutar de diferentes formas desde el punto de vista del modelo de procesos que usan. Por ejemplo, los procesos PHP se ejecutan como procesos pesados (o simplemente procesos), hijos del proceso Apache, creándolos bajo demanda a causa de la cantidad de peticiones si es necesario. Los procesos Java funcionan de forma distinta, la Máquina Virtual de Java (JVM) proporciona un conjunto de procesos que reservan al principio una gran cantidad de recursos del sistema (CPU y memoria), gestionando la concurrencia internamente mediante procesos ligeros (threads). En ambos casos, los procesos en ejecución son prácticamente transparentes para los desarrolladores de la aplicación.

La escalabilidad está representada por el número de procesos en ejecución, mientras que la diversidad de carga de trabajo lo está por los tipos de procesos.

En las aplicaciones “twelve-factor”, los procesos son ciudadanos de primera clase. Los procesos de las aplicaciones “twelve-factor” se inspiran en el modelo de procesos de unix para ejecutar demonios. Usando este modelo, el desarrollador puede distribuir la ejecución de su aplicación para gestionar diversas cargas de trabajo asignando cada tipo de trabajo a un tipo de proceso. Por ejemplo, las peticiones HTTP se pueden procesar con un proceso y las tareas con mucha carga de trabajo con hilos.

Esto no exime a los procesos de gestionar su propia división interna mediante threads en la ejecución de la máquina virtual o mediante un modelo asíncrono o por eventos con herramientas como EventMachine, Twisted, o Node.js. No obstante, una máquina virtual aislada tiene una capacidad de crecimiento limitada, así que la aplicación debe ser capaz de dividirse en multiples procesos que se puedan ejecutar en múltiples máquinas físicas.

El modelo de procesos muestra todo su potencial cuando llega el momento de escalar. La naturaleza “share-nothing”, divide horizontalmente los procesos de las aplicaciones “twelve-factor” y se traduce en un aumento de la concurrencia como una operación simple y fiable. El conjunto de tipos de procesos y el número de procesos de cada tipo es conocido como juego de procesos.

Los procesos de las aplicaciones “twelve-factor” nunca deberían ser demonios ni escribir ficheros de tipo PID. En su lugar, se debería confiar en un gestor de procesos del sistema operativo (como systemd, un gestor de procesos distribuido en una plataforma en la nube, o una herramienta como Foreman en desarrollo) para gestionar los historiales, responder a procesos que terminen inesperadamente, y gestionar los reinicios y apagados provocados por los usuarios.

---

https://12factor.net/es/disposability

# IX. Desechabilidad
Hacer el sistema más robusto intentando conseguir inicios rápidos y finalizaciones seguras
Los procesos de las aplicaciones “twelve-factor” son desechables, lo que significa que pueden iniciarse o finalizarse en el momento que sea necesario. Esto permite un escalado rápido y flexible, un despliegue rápido del código y de los cambios de las configuraciones, y despliegues más robustos en producción.

Los procesos deberían intentar conseguir minimizar el tiempo de arranque. En el mejor de los casos, un proceso necesita unos pocos segundos desde que se ejecuta el mandato hasta que arranca y está preparado para recibir peticiones o trabajos. Mejorar el tiempo de arranque proporciona mayor agilidad en el proceso de distribución y escalado; y lo hace más robusto, porque el gestor de procesos puede mover procesos de forma segura entre máquinas físicas más fácilmente.

Los procesos se paran de manera segura cuando reciben una señal SIGTERM desde el gestor de procesos. Un proceso web para de manera segura cuando deja de escuchar el puerto asociado al servicio (así rechaza cualquier nueva petición), permitiendo que cualquier petición termine de procesarse y pueda finalizar sin problemas. Implícitamente, según este modelo, las peticiones HTTP son breves (no duran más de unos pocos segundos) y, en el caso de un sondeo largo, el cliente debería intentar reconectar una y otra vez cuando se pierda la conexión.

Para finalizar de manera segura, un trabajador (o “worker”) debe devolver el trabajo actual a una cola de trabajos. Por ejemplo, en RabbitMQ un trabajador puede mandar un NACK; en Beanstalkd, el trabajo se devuelve a una cola automáticamente en el momento en el que el trabajador finaliza. Los sistemas de exclusión mutua como Delayed Job necesitan estar seguros para liberar su candado en el registro de trabajos. Implícitamente, según este modelo, todos los trabajos son reentrantes, lo que se consigue normalmente generando los resultados de manera transaccional, o convirtiendo la operación en idempotente.

Los procesos deberían estar preparados contra finalizaciones inesperadas, como en el caso de un fallo a nivel hardware. Aunque es un caso más raro que una finalización mediante la señal SIGTERM, se puede dar el caso. Lo recomendable es usar un sistema de colas robusto, como Beanstalkd, que devuelve los trabajos a su cola cuando los clientes se desconectan o expira su tiempo de espera (“timeout”). En cualquier caso, una aplicación “twelve-factor” es una arquitectura que trata finalizaciones inesperadas y peligrosas. El diseño Crash-only lleva este concepto a su conclusión lógica.

---

https://12factor.net/es/dev-prod-parity

X. Igualdad entre desarrollo y producción
Mantener desarrollo, preproducción y producción tan parecidos como sea posible
Históricamente, han existido dos tipos de entorno muy diferenciados: desarrollo (donde un desarrollador puede editar en vivo en un despliegue local de la aplicación) y producción (un despliegue en el que la aplicación está en ejecución disponible para que lo usen los usuarios). Estas diferencias se pueden clasificar en tres tipos:

Diferencias de tiempo: Un desarrollador puede estar trabajando en un código durante días, semanas o incluso meses antes de que llegue a producción.
Diferencias de personal: Los desarrolladores escriben el código y los ingenieros de operaciones lo despliegan.
Diferencias de herramientas: Los desarrolladores pueden usar una pila como Nginx, SQLite y OS X, mientras que en producción se usa Apache, MySQL y Linux.
** Las aplicaciones “twelve-factor” están diseñadas para hacer despliegues continuos que reducen las diferencias entre los entornos de desarrollo y producción.** Teniendo en cuenta las tres diferencias descritas anteriormente:

Reducir las diferencias de tiempo: Un desarrollador puede escribir código y tenerlo desplegado en tan solo unas horas, o incluso, minutos más tarde.
Reducir las diferencias de personal: Los desarrolladores que escriben el código están muy involucrados en el despliegue y observan su comportamiento en producción.
Reducir las diferencias de herramientas: tratar de hacer que desarrollo y producción sean tan parecidos como sea posible.

Resumiendo lo anterior en una tabla:

|                                      | Aplicaciones tradicionales     | Aplicaciones "twelve-factor"         |
|--------------------------------------|--------------------------------|--------------------------------------|
| **Tiempo entre despliegues**         | Semanas                        | Horas                                |
| **Desarrolladores vs Ingenieros de operaciones** | Diferentes personas              | Mismas personas                      |
| **Entorno de desarrollo vs entorno de producción** | Divergentes                      | Lo más parecidos posibles            |



Los “backing services”, como la base de datos de la aplicación, el sistema de colas, o la caché, es donde la igualdad en los entornos de desarrollo y producción es importante. Muchos lenguajes ofrecen librerías en las que se simplifica el acceso a los servicios de respaldo, incluidos adaptadores para diferentes tipos de servicios. Se pueden observar algunos ejemplos en la siguiente tabla.

| Tipo         | Lenguaje       | Librería              | Adaptador                                  |
|--------------|----------------|-----------------------|--------------------------------------------|
| Base de datos| Ruby/Rails     | ActiveRecord          | MySQL, PostgreSQL, SQLite                  |
| Colas        | Python/Django  | Celery                | RabbitMQ, Beanstalkd, Redis                |
| Caché        | Ruby/Rails     | ActiveSupport::Cache  | Memoria, sistema de ficheros, Memcached    |


Los desarrolladores, a veces, caen en la tentación de usar “backing services” ligeros en sus entornos de desarrollo, mientras que en producción se usan los más serios y robustos. Por ejemplo, se usa SQLite en desarrollo y PostgreSQL en producción; o memoria local para la caché en desarrollo y Memcached en producción.

Un desarrollador “twelve-factor” no cae en la tentación de usar diferentes “backing services” en desarrollo y producción, incluso cuando los adaptadores teóricamente abstractos están lejos de cualquier diferencia en “backing services”. Las diferencias entre los servicios de respaldo tienen que ver con las pequeñas incompatibilidades que surgen de la nada, causando que el código que funciona y pasa los tests en desarrollo o en preproducción, falle en producción. Este tipo de errores provocan conflictos que desincentivan la filosofía del despliegue continuo. El coste de estos conflictos y el enfriamiento subsiguiente del despliegue continuo es extremadamente alto cuando se hace balance del total de tiempo de vida de una aplicación.

Los servicios ligeros locales son menos atractivos que antes. Los “backing services” modernos como Memcached, PostgreSQL, y RabbitMQ no son difíciles de instalar y ejecutar gracias a los sistemas de gestión de paquetes modernos, como Homebrew y apt-get. Al mismo tiempo, las herramientas de gestión de la configuración como Chef y Puppet combinadas con entornos virtuales ligeros como Docker o Vagrant permiten a los desarrolladores ejecutar entornos locales que son muy parecidos a los entornos de producción. El coste de instalar y usar estos sistemas es bajo comparado con el beneficio que se puede obtener de la paridad entre desarrollo y producción y del despliegue continuo.

Los adaptadores de los “backing services” todavía son de gran utilidad, porque hacen que cambiar de unos a otros sea un trámite relativamente poco doloroso. No obstante, todos los despliegues de una aplicación (en entornos de desarrollo, preproducción y producción) deberían usar el mismo tipo y versión de cada uno de los “backing services”.

---

https://12factor.net/es/logs

XI. Historiales
Tratar los historiales como una transmisión de eventos
Los historiales permiten observar el comportamiento de la aplicación durante su ejecución. En entornos basados en servidores es muy común escribir un fichero en disco (un “fichero de histórico”) pero este, es tan solo un posible formato de salida.

Los historiales son la transmisión de un conjunto de eventos ordenados y capturados de la salida de todos los procesos en ejecución y de los “backing services”. En bruto, los historiales suelen estar en formato texto y tienen un evento por línea (aunque las trazas de excepciones suelen estar en varias líneas). Los historiales no tienen un principio y un final fijo, sino que fluyen continuamente mientras la aplicación está en funcionamiento.

Una aplicación “twelve-factor” nunca se preocupa del direccionamiento o el almacenamiento de sus transmisiones de salida. No debería intentar escribir o gestionar ficheros de historial. En su lugar, cada proceso en ejecución escribe sus eventos a la salida estándar (o stdout). Durante el desarrollo, los desarrolladores verán el flujo en su terminal para observar el comportamiento de la aplicación.

En despliegues de preproducción y producción, cada transmisión del proceso será capturada por el entorno de ejecución, siendo capturadas junto con todos los otros flujos de la aplicación, y redirigidas a uno o más destinos finales para ser revisadas y archivadas. Estos destinos donde se archivan no son visibles o configurables por la aplicación, se gestionan totalmente por el entorno de ejecución. Las herramientas de código abierto que capturan y almacenan los historiales (como Logplex y Fluentd) se usan con este objetivo.

Las transmisiones de eventos para una aplicación pueden ser redirigidas a un fichero u observadas en tiempo real mediante un “tail” en un terminal. Cabe destacar que la transmisión se puede enviar a un sistema de análisis e indexado como Splunk, o a un sistema de almacenamiendo de datos de propósito general como Hadoop/Hive. Estos sistemas se tienen en cuenta por el gran poder y la flexibilidad para inspeccionar el comportamiento de la aplicación a lo largo del tiempo, incluyendo:

* Encontrar eventos específicos del pasado.
* Gráficas de tendencia a gran escala (como las peticiones por minuto).
* Activación de alertas de acuerdo con heurísticas definidas por el usuario (como una alerta cuando la cantidad de errores por minuto sobrepasa un cierto límite).

---

https://12factor.net/es/admin-processes

# XII. Administración de procesos

Ejecutar las tareas de gestión/administración como procesos que solo se ejecutan una vez
El juego de procesos es el conjunto de procesos que se usa para hacer las tareas habituales de la aplicación (como procesar las peticiones web). Por otro lado, es frecuente que los desarrolladores quieran ejecutar procesos de administración o mantenimiento una sola vez, como por ejemplo:

* Ejecutar migraciones de las bases de datos (e.g. manage.py migrate de Django, rake db:migrate de Rails).
* Ejecutar una consola (también conocidas como REPL) para ejecutar código arbitrario o inspeccionar los modelos de la aplicación en una base de datos con datos reales. La mayoría de los lenguajes proporcionan un interprete del tipo REPL si se ejecuta el mismo mandato sin ningún argumento (e.g. python o perl) pero en algunos casos tienen un mandato distinto (e.g. irb en Ruby, rails console en Rails).
* Ejecutar scripts incluidos en el repositorio de la aplicación (e.g. php scripts/fix_bad_records.php).

Los procesos de este tipo deberían ejecutarse en un entorno idéntico al que se usa normalmente en los procesos habituales de la aplicación. Estos procesos se ejecutan en una distribución concreta, usando el mismo código base y la misma configuración que cualquier otro proceso que ejecuta esa distribución. El código de administración se debe enviar con el código de la aplicación para evitar problemas de sincronización.

Se deberían usar las mismas técnicas de aislamiento de dependencias en todos los tipos de procesos. Por ejemplo, si un proceso web Ruby usa el mandato bundle exec thin start, entonces una migración de la base de datos debería usar bundle exec rake db:migrate. De la misma manera, un programa Python que usa Virtualenv debería usar bin/python para ejecutar tanto el servidor web Tornado como cualquier proceso de administración manage.py.

“Twelve-factor” recomienda encarecidamente lenguajes que proporcionan una consola del tipo REPL, ya que facilitan las tareas relacionadas con la ejecución de scripts que solo han de usarse una vez. En un despliegue local, se invocarán los procesos de administración con un mandato directo en la consola dentro del directorio de la aplicación. En un despliegue de producción, se puede usar ssh u otro mecanismo de ejecución de mandatos remoto proporcionado por el entorno de ejecución del despliegue para ejecutar dichos procesos.

---
