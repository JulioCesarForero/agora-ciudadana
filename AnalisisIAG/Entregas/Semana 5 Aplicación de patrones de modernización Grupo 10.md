

# Ejemplo de aplicación de patrones de modernización Semana 5

- Número del grupo: 10

- Nombres de los miembros del grupo
  o Julio César Forero Orjuela
  o Juan Fernando Copete Mutis
  o Jorge Iván Puyo
  o Cristhian Camilo Delgado Pazos

## Principales similitudes y diferencias identificadas

| Dimensión                            | Coincidencias clave                                                                                                                            | Diferencias clave                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Punto de partida: entender el legado | Ambos enfoques comienzan por obtener una fotografía fiel del sistema tal como está ("as-is") y de los resultados que se persiguen del negocio. | El artículo de Thoughtworks lo plantea como un paso preliminar ("Understand the outcomes") de alcance amplio.<br/><br/>El curso lo desglosa en actividades formales de ingeniería inversa apoyadas en herramientas de cartografía como CodeScene y AQL.                                                                                                                                                                                                                 |
| Estrategia incremental               | Coinciden en evitar "big-bang" y promover migraciones graduales (Strangler, Branch-by-Abstraction, refactorización incremental)                | El curso baja la estrategia a un plan métododico paso a paso con entregables desde el entendimiento del sistema AS-IS además de (alcances, experimentos, transformaciones), mientras que el artículo se centra en patrones de arquitectura que dominan en esta clase de proyecto de desplazamiento sin necesariamente un entregable de artefactos de base, aunque si se muestran vistas de arquitectura de alto nivel que permiten la comprensión del patrón a aplicar. |
| Motivadores                          | Reducir costo del cambio, eliminar                                                                                                             | El curso introduce explícitamente la                                                                                                                                                                                                                                                                                                                                                                                                                                    |




---



# Motivación del proyecto

1. Reducción de vulnerabilidades y riesgos
1. La plataforma está construida en Python 2.7 y Django 1.5.5 (fin de soporte en 2020), lo que genera exposición a vulnerabilidades y problemas de seguridad.
2. Configuraciones sensibles embebidas en el código (e.g., SECRET_KEY, SMTP) y uso de SQLite en producción aumentan el riesgo operativo.
2. Mejora de la calidad y buenas prácticas de software
1. Actualmente incumple principios Twelve-Factor App (e.g., falta de logging estructurado, ausencia de contenedorización, cache deshabilitado).
2. La adopción de Docker permitirá:
1. Paridad Dev/Prod (Factor X): entornos consistentes.
2. Separación Build/Release/Run (Factor V): mejor ciclo de vida de despliegue.
3. Escalabilidad y resiliencia
1. El monolito actual es difícil de escalar horizontalmente.
2. Modernizar permitirá desacoplar funcionalidades hacia microservicios y serverless en AWS, soportando mayor resiliencia ante fallas y demandas variables.



---



4. Eficiencia operativa y costos
   a. Automatizar despliegues mediante contenedores reducirá tiempos manuales y
      errores humanos.
   b. Menores costos de operación y eliminación de dependencias obsoletas.
5. Ventaja competitiva y oportunidades futuras
   a. Modularizar y dockerizar la gestión de usuarios.
   b. Habilita el uso de JWT para autenticación distribuida.
   c. Facilita el onboarding de nuevos desarrolladores.
   d. Establece bases para un modelo portable y escalable, habilitando pruebas
      automatizadas y despliegues en múltiples ambientes (on-premise, nube, CI/CD).

## Lista de patrones que se pueden aplicar al proyecto concreto, acompañando cada ítem de una justificación

| Patrón propuesto                     | Cómo se aplicaría sobre Ágora                                                                                                                                                                      | Beneficio directo                                                                                                             |
| ------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| Strangler Fig con Event Interception | Añadir un middleware de enrutamiento en Django Signals o RabbitMQ; cada evento de autenticación/usuarios se duplica hacia el nuevo microservicio de "Identity" mientras el monolito sigue operando | Permite migrar gradualmente el módulo accounts/userena sin tiempo fuera de servicio y sin "Detener o Congelar" el repositorio |
| Branch by Abstraction                | Introducir una interfaz UserRepository y adaptadores (SQLite ↔ PostgreSQL) bajo agora\_core.infrastructure, manteniendo la misma API de dominio                                                    | Reduce el acoplamiento a User (91 referencias) y habilita la sustitución transparente de la base de datos medinte un ORM      |
| Legacy Mimic / API Facade            | Levantar un contenedor FlaskAPI o FastAPI que reproduzca los endpoints actuales de gestión de usuarios, pero ya autenticados con JWT, el monolito invoca la fachada como si fuera local            | Introduce JWT sin tocar código legacy y crea el punto de entrada para futuras apps móviles o SPA                              |




---


# Mover

SECRET_KEY, SMTP y URLs a Externalize variables de entorno administradas por Docker Compose y Secrets Manager

# Elimina vulnerabilidades, cumple Twelve-Factor III y facilita despliegues multi-entorno

# Replace

# Database / Revert-to-Source

Migrar de SQLite a PostgreSQL: arranca ambos motores; todas las escrituras pasan por PostgreSQL y se replican a SQLite hasta completar la transición

Quita el cuello de botella de concurrencia sin interrumpir operaciones ni romper consultas existentes

# Container-First CI/CD Pipeline

Definir Dockerfile, docker-compose y un workflow GitHub Actions que construya, ejecute pruebas y publique imágenes

Alinea con Twelve-Factor V &#x26; X, habilita despliegues canarios y roll-back rápidos

# Segmentation by Product (feature toggle)

Usar flags por tipo de elección para enviar gradualmente tráfico al nuevo servicio de conteo de votos basado en AWS Lambda

Minimiza riesgo al probar la lógica crítica de cómputo en producción con un subconjunto de procesos

# Observability Mesh (Aggregator Crítico)

Centralizar logs y métricas de los contenedores en Prometheus + Grafana; exponer dashboards para facilitar detección temprana de regresiones de performance tras cada corte de estrangulación

# Pilot Protegido (cambio organizacional al)

Crear un squad dedicado a la modernización con gobierno liviano; su éxito se mide por despliegues frecuentes y reducción de bugs en el módulo de usuarios

Mitiga los “anticuerpos corporativos” y demuestra valor antes de escalar la práctica al resto del proyecto, el equipo funcionaría como un SQUAD para los servicios a modernizar.

