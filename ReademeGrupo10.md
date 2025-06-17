# Ágora Ciudadana - Instrucciones de Despliegue con Docker

Este documento proporciona las instrucciones necesarias para desplegar la aplicación Ágora Ciudadana utilizando Docker.

## Requisitos Previos

- Docker instalado en tu sistema
- Docker Compose instalado en tu sistema
- Git instalado en tu sistema

## Pasos para el Despliegue

1. **Clonar el Repositorio**
   ```bash
   git clone [URL_DEL_REPOSITORIO]
   cd agora-ciudadana
   ```

2. **Configuración del Entorno**
   - Asegúrate de que los puertos 8000, 15672 y 5672 estén disponibles en tu sistema
   - Verifica que tienes permisos de escritura en el directorio del proyecto

3. **Construir y Levantar los Contenedores**
   ```bash
   docker-compose up --build
   ```
   Este comando:
   - Construirá la imagen de la aplicación
   - Descargará la imagen de RabbitMQ
   - Creará y configurará los contenedores
   - Iniciará los servicios

4. **Acceso a la Aplicación**
   - La aplicación web estará disponible en: `http://localhost:8000`
   - La interfaz de administración de RabbitMQ estará disponible en: `http://localhost:15672`
     - Usuario: `agora`
     - Contraseña: `agora`

## Estructura de Contenedores

La aplicación utiliza dos servicios principales:

1. **Web (Aplicación Django)**
   - Puerto: 8000
   - Volúmenes montados:
     - Código fuente de la aplicación
     - Directorio de medios
     - Directorio de datos

2. **RabbitMQ**
   - Puerto de administración: 15672
   - Puerto AMQP: 5672
   - Credenciales por defecto:
     - Usuario: `agora`
     - Contraseña: `agora`

## Comandos Útiles

- **Detener los contenedores:**
  ```bash
  docker-compose down
  ```

- **Ver logs de los contenedores:**
  ```bash
  docker-compose logs -f
  ```

- **Reiniciar los servicios:**
  ```bash
  docker-compose restart
  ```

## Solución de Problemas

1. **Si los contenedores no inician correctamente:**
   - Verifica los logs con `docker-compose logs`
   - Asegúrate de que los puertos necesarios no estén en uso
   - Verifica que tienes suficiente espacio en disco

2. **Si la aplicación no responde:**
   - Verifica que los contenedores estén en ejecución con `docker-compose ps`
   - Revisa los logs de la aplicación
   - Asegúrate de que RabbitMQ esté funcionando correctamente

## Notas Importantes

- Los datos de RabbitMQ se almacenan en un volumen persistente
- La base de datos SQLite se almacena en el directorio `data/`
- Los archivos multimedia se almacenan en `agora_site/media/data/`

## Soporte

Si encuentras algún problema durante el despliegue, por favor:
1. Revisa los logs de los contenedores
2. Verifica que todos los requisitos previos estén instalados
3. Asegúrate de que los puertos necesarios estén disponibles 