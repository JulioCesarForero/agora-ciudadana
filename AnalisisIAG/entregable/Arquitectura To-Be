Arquitectura To - Be
1.
Question 1
Arquitectura to-be y experimento: deben desarrollarse a través de los ítems que se describen a continuación:


Diagrama de despliegue de la arquitectura to-be incluyendo componentes de software modernizados (y legados si aplica), patrones y tácticas. Además, debe acompañar el diagrama de una descripción detallada de los elementos de arquitectura (y sus interacciones) y una justificación de los patrones/ tácticas escogidas. En este ítem deben reportar la respuesta a la pregunta: ¿Qué prácticas observadas en los recursos Apigee podría extrapolar a su arquitectura to-be? ¿Por qué? 

<img width="1966" height="714" alt="Diagrama sin título drawio (1)" src="https://github.com/user-attachments/assets/61a7e62c-2e8a-4560-970c-9e9ef73d9f88" />

# Diagrama de despliegue de la arquitectura To-Be

## Descripción detallada

Este despliegue refleja una arquitectura híbrida donde coexisten componentes modernizados y componentes legados, utilizando el patrón **Strangler Fig** para facilitar la migración progresiva y reducir el riesgo de fallos disruptivos.

### Componentes y sus interacciones

1. **API Gateway (Façade):**
   - Recibe todas las peticiones a `/agoras/*`.
   - Rutea dinámicamente entre el servicio modernizado (Lambda) y el servicio legado (EC2), permitiendo autenticación, throttling, transformación de payload y logging centralizado.

2. **Lambda Nano-servicio (AgoraService):**
   - Microservicio desplegado como contenedor Docker en AWS Lambda.
   - Encargado de la lógica de creación y edición de ágoras.
   - Opera sobre **DynamoDB** y obtiene credenciales/tokens de **AWS Secrets Manager**.

3. **DynamoDB:**
   - Base de datos NoSQL utilizada para almacenar y consultar información estructurada sobre ágoras.
   - Proporciona alta disponibilidad y escalabilidad al servicio modernizado.

4. **EC2 Legacy Instance:**
   - Instancia Ubuntu (`ami-020cba7c55df1f615`, 1 vCPU, Ubuntu 24.04).
   - Ejecuta el monolito legacy a través de Docker Compose.
   - Mantiene funcionalidades que aún no han sido migradas.

5. **LegacyAgoraMonolith (servicio legado):**
   - Recibe solicitudes HTTP desde el nuevo microservicio para operaciones no modernizadas.
   - Permite la coexistencia controlada de lógica antigua y nueva.

6. **AWS Secrets Manager:**
   - Gestiona de manera segura los secretos y credenciales utilizados por el nanoservicio.
   - Permite rotación y control granular de acceso.

7. **Interacciones:**
   - Flechas en el diagrama representan comunicaciones REST/HTTP, operaciones de almacenamiento y acceso a secretos.
   - Los artefactos se despliegan según las dependencias indicadas.

---

## Justificación de patrones y tácticas empleadas

### Strangler Fig Pattern
Permite migrar funcionalidades de forma incremental, limitando el riesgo y facilitando pruebas y rollbacks. Solo las operaciones de creación y edición de ágoras se migran inicialmente, mientras el monolito sigue en producción para el resto.

### API Gateway como Façade
Centraliza la gestión de acceso, seguridad, monitoreo y enrutamiento. Facilita la transición entre el legado y lo moderno y permite aplicar políticas de control y observabilidad sin impactar al cliente.

### Persistencia desacoplada
DynamoDB permite que los nuevos servicios evolucionen de forma independiente, asegurando escalabilidad y flexibilidad.

### Gestión centralizada de secretos
AWS Secrets Manager asegura el manejo seguro de tokens y credenciales, facilitando la rotación y control de acceso.

---

## Prácticas extrapoladas de Apigee a esta arquitectura

1. **Proxy y enrutamiento granular**
   - Igual que Apigee, API Gateway funciona como proxy y punto único para aplicar seguridad, transformación y gestión centralizada de tráfico, tanto para el legado como para lo modernizado.

2. **Flujos y políticas unificadas**
   - API Gateway permite definir reglas y validaciones de manera declarativa, similar a los "policies" en Apigee, asegurando un tratamiento uniforme y seguro de las APIs.

3. **Monitoreo y control centralizados**
   - CloudWatch y API Gateway permiten observabilidad y auditoría en todo el ecosistema, replicando el control y visibilidad que ofrece Apigee sobre las APIs expuestas.

---

## Resumen

Esta arquitectura permite una migración incremental y segura usando el patrón Strangler Fig y una fachada centralizada (API Gateway). Las prácticas clave de Apigee —proxy avanzado, políticas centralizadas, monitoreo unificado— son replicadas en AWS para asegurar un proceso de modernización robusto, flexible y con mínimo impacto para el usuario final.

---
