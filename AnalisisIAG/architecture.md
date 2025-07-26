# Análisis Arquitectónico - Agora Ciudadana

## Introducción

Este documento presenta un análisis arquitectónico exhaustivo de **Agora Ciudadana**, una aplicación web legada construida en Python que facilita la participación ciudadana a través de ágoras (espacios de participación) y elecciones con sistemas de votación directa y por delegación.

## 1. Componentes Funcionales y sus Relaciones

### Componentes Principales

- **Núcleo de Ágora (agora_core)**: Gestiona ágoras, elecciones, votaciones y delegaciones
- **Sistema de Usuarios (accounts)**: Manejo de perfiles, autenticación y autorización
- **Sistema de Actividades (actstream)**: Stream de actividades y seguimiento social
- **Sistema de Búsqueda (haystack)**: Indexación y búsqueda de contenido
- **Sistema de Mensajería (userena)**: Gestión de comunicaciones entre usuarios
- **APIs REST (tastypie)**: Exposición de servicios web RESTful
- **Tareas Asíncronas (celery)**: Procesamiento de tareas en segundo plano

### Relaciones entre Componentes

```
Frontend (Backbone.js + Bootstrap)
    ↓
API REST Layer (Django Tastypie)
    ↓
Business Logic Layer (Django Views/Models)
    ↓
Data Access Layer (Django ORM)
    ↓
Database (SQLite/PostgreSQL)

Celery Workers ← RabbitMQ → Django Application
```

## 2. Despliegue en Entorno Productivo

### Arquitectura de Despliegue

**Contenedores Docker**:
- **Web Container**: Aplicación Django + Celery worker
- **RabbitMQ Container**: Message broker para tareas asíncronas
- **Database**: SQLite (desarrollo) / PostgreSQL (producción recomendada)

**Infraestructura Requerida**:
- **Servidor Web**: Apache/Nginx + WSGI
- **Base de Datos**: PostgreSQL (recomendado para producción)
- **Message Broker**: RabbitMQ para Celery
- **Almacenamiento**: Sistema de archivos para media files y whoosh index
- **Email Service**: SMTP para notificaciones
- **Cache**: Redis/Memcached (opcional pero recomendado)

**Puertos y Servicios**:
- Puerto 8000: Aplicación Django
- Puerto 5672: RabbitMQ AMQP
- Puerto 15672: RabbitMQ Management UI

## 3. Interacción con Fuentes de Datos

### Bases de Datos

**ORM Django**: Abstracción principal para acceso a datos
- **Modelos principales**: User, Profile, Agora, Election, CastVote, Comment, Action
- **Migraciones**: Gestionadas con South (Django 1.5.x)
- **Relaciones**: ForeignKey, ManyToMany con permisos granulares

### Sistemas de Persistencia

- **Base de Datos Relacional**: Datos transaccionales y estructura principal
- **Whoosh Index**: Motor de búsqueda basado en archivos para Haystack
- **Sistema de Archivos**: Almacenamiento de avatares y archivos media
- **Cache**: Django cache framework (configurable)

### Acceso a Datos Externos

- **APIs de Autenticación Social**: Facebook, Twitter, Google, GitHub
- **Servicios de Email**: SMTP para notificaciones
- **GeoIP**: Localización geográfica de usuarios
- **Gravatar**: Avatares externos de usuarios

## 4. Patrones y Tácticas de Arquitectura

### Patrones Arquitectónicos Identificados

- **MVC/MTV Pattern**: Estructura Model-Template-View de Django
- **Repository Pattern**: Implementado a través del ORM de Django
- **Observer Pattern**: Sistema de señales Django para eventos
- **Strategy Pattern**: Diferentes sistemas de votación implementados
- **Command Pattern**: Tareas Celery como comandos asíncronos
- **Decorator Pattern**: Decoradores para permisos y autorización

### Tácticas de Arquitectura

- **Separación de Capas**: Presentación, Lógica de Negocio, Acceso a Datos
- **API-First Design**: APIs REST para comunicación frontend-backend
- **Event-Driven**: Sistema de actividades basado en eventos
- **Modularización**: Apps Django como módulos independientes
- **Delegación de Responsabilidades**: Tareas pesadas en Celery workers

## 5. Tecnologías y Frameworks

### Backend (Python)

- **Django 1.5.5**: Framework web principal
- **django-tastypie 0.9.12**: APIs REST
- **django-userena**: Gestión de usuarios y perfiles
- **django-guardian 1.2.5**: Sistema de permisos granulares
- **django-activity-stream 0.6.1**: Stream de actividades sociales
- **django-social-auth 0.7.28**: Autenticación social
- **django-haystack 2.1.0**: Framework de búsqueda
- **south 0.7.6**: Migraciones de base de datos
- **celery 3.0.12**: Tareas asíncronas
- **whoosh 2.4.1**: Motor de búsqueda

### Frontend

- **Backbone.js**: Framework MVC del lado cliente
- **Bootstrap**: Framework CSS responsivo
- **jQuery**: Manipulación DOM y AJAX
- **Underscore.js**: Utilidades JavaScript
- **Charts.js/D3.js**: Visualización de datos

### Infraestructura

- **RabbitMQ**: Message broker
- **Docker**: Contenedorización
- **SQLite/PostgreSQL**: Base de datos
- **WSGI**: Interfaz servidor web

## 6. Módulos o Capas Principales

### Estructura de Capas

```
┌─────────────────────────────────────┐
│          Presentation Layer         │
│  (Templates, Static Files, JS)      │
├─────────────────────────────────────┤
│           API Layer                 │
│     (Tastypie Resources)            │
├─────────────────────────────────────┤
│        Business Logic Layer        │
│    (Views, Forms, Models)           │
├─────────────────────────────────────┤
│         Service Layer               │
│    (Tasks, Utils, Decorators)       │
├─────────────────────────────────────┤
│        Data Access Layer           │
│    (ORM, Managers, Migrations)      │
├─────────────────────────────────────┤
│         Infrastructure              │
│  (Database, Cache, Message Queue)   │
└─────────────────────────────────────┘
```

### Módulos Principales

- **agora_site.agora_core**: Lógica principal de ágoras y elecciones
- **agora_site.accounts**: Gestión de cuentas de usuario
- **agora_site.misc**: Utilidades comunes y decoradores
- **actstream**: Sistema de actividades
- **userena**: Gestión avanzada de usuarios
- **haystack**: Motor de búsqueda

## 7. Dependencias entre Servicios/Módulos

### Dependencias Explícitas

```
agora_core → accounts (Users/Profiles)
agora_core → actstream (Activity tracking)
agora_core → userena (User management)
accounts → userena (Profile extension)
API layer → All core modules
Frontend → API layer
```

### Dependencias Implícitas

- **Celery Tasks** dependen de modelos de agora_core
- **Sistema de permisos** se extiende a través de todos los módulos
- **Templates** dependen de contexto de múltiples apps
- **Static files** compartidos entre módulos

## 8. Gestión de Seguridad y Autenticación

### Mecanismos de Autenticación

- **Session-based**: Autenticación tradicional Django
- **Token-based**: ApiKey para APIs REST
- **Social Authentication**: OAuth con proveedores externos
- **Email Verification**: Verificación obligatoria de email

### Sistema de Autorización

- **django-guardian**: Permisos granulares a nivel de objeto
- **Decoradores personalizados**: `@permission_required`
- **Middleware de autenticación**: Validación en cada request
- **CSRF Protection**: Tokens anti-CSRF en formularios

### Características de Seguridad

```python
# Ejemplo de verificación de permisos
@permission_required('admin', (Agora, 'id', 'agoraid'))
def admin_action(self, request, agoraid):
    # Solo usuarios con permisos de admin pueden ejecutar
    pass
```

- **Password Hashing**: BCrypt como hasher principal
- **SQL Injection Protection**: ORM Django
- **XSS Protection**: Template engine de Django
- **Rate Limiting**: Implementable a nivel de decorador

## 9. Mecanismos de Escalabilidad y Balanceo de Carga

### Escalabilidad Horizontal

- **Separación de servicios**: Web servers y Celery workers independientes
- **Message Queue**: RabbitMQ permite múltiples workers
- **Database separation**: Lectura/escritura pueden separarse
- **Static file serving**: CDN compatible

### Estrategias de Rendimiento

- **Cache Framework**: Django cache (Redis/Memcached)
- **Database optimization**: Índices, select_related, prefetch_related
- **Asset optimization**: Minificación y compresión de JS/CSS
- **Pagination**: Limitación de resultados en APIs

### Limitaciones Identificadas

- **Django 1.5.x**: Versión legada limita opciones de escalabilidad
- **SQLite por defecto**: No apto para alta concurrencia
- **Sincronización**: Algunas operaciones no están optimizadas para concurrencia

## 10. Manejo de Errores y Resiliencia

### Estrategias de Manejo de Errores

- **Exception handling**: Try-catch en vistas críticas
- **HTTP status codes**: Códigos de respuesta apropiados en APIs
- **Logging**: Sistema de logs Django
- **Error templates**: 404.html, 500.html personalizadas

### Mecanismos de Resiliencia

- **Task retries**: Celery retry en tareas fallidas
- **Database transactions**: Atomicidad en operaciones críticas
- **Graceful degradation**: Funcionalidad básica sin JavaScript
- **Health checks**: Docker healthchecks configurados

```python
# Ejemplo de manejo de errores en API
try:
    agora = Agora.objects.get(pk=agora_id)
    # Operación
except Agora.DoesNotExist:
    raise ImmediateHttpResponse(response=http.HttpNotFound())
```

## 11. Comunicación con la Aplicación

### APIs REST Expuestas

La aplicación expone una API REST completa a través de `/api/v1/` con los siguientes endpoints:

#### Endpoints Principales

| Recurso | URL Base | Descripción |
|---------|----------|-------------|
| User | `/api/v1/user/` | Gestión de usuarios |
| Agora | `/api/v1/agora/` | Gestión de ágoras |
| Election | `/api/v1/election/` | Gestión de elecciones |
| CastVote | `/api/v1/castvote/` | Gestión de votos |
| DelegateElectionCount | `/api/v1/delegateelectioncount/` | Conteo de delegaciones |
| Follow | `/api/v1/follow/` | Sistema de seguimiento |
| Action | `/api/v1/action/` | Stream de actividades |
| Search | `/api/v1/search/` | Búsqueda global |

### Ejemplos de Uso con cURL

#### 1. Autenticación - Login de Usuario

```bash
# Login
curl -X POST http://localhost:8000/api/v1/user/login/ \
  -H "Content-Type: application/json" \
  -d '{
    "identification": "usuario1",
    "password": "mipassword"
  }'
```

#### 2. Registro de Nuevo Usuario

```bash
# Registro
curl -X POST http://localhost:8000/api/v1/user/register/ \
  -H "Content-Type: application/json" \
  -d '{
    "username": "nuevousuario",
    "email": "nuevo@ejemplo.com",
    "password1": "password123",
    "password2": "password123",
    "first_name": "Nombre",
    "last_name": "Apellido"
  }'
```

#### 3. Gestión de Ágoras

```bash
# Listar ágoras
curl -X GET http://localhost:8000/api/v1/agora/ \
  -H "Accept: application/json"

# Crear nueva ágora

## Esta Presentando novedad 

curl -X POST http://localhost:8000/api/v1/agora/ \
  -H "Content-Type: application/json" \
  -H "Authorization: ApiKey usuario1:su_api_key_aqui" \
  -d '{
    "pretty_name": "Mi Nueva Ágora",
    "short_description": "Descripción corta de la ágora",
    "membership_policy": "ANYONE_CAN_JOIN",
    "comments_policy": "ANYONE_CAN_COMMENT"
  }'

# Obtener ágora específica
curl -X GET http://localhost:8000/api/v1/agora/1/ \
  -H "Accept: application/json"

# Unirse a ágora
curl -X POST http://localhost:8000/api/v1/agora/1/action/ \
  -H "Content-Type: application/json" \
  -H "Authorization: ApiKey usuario1:su_api_key_aqui" \
  -d '{"action": "join"}'
```

#### 4. Gestión de Elecciones

```bash
# Listar elecciones de una ágora
curl -X GET http://localhost:8000/api/v1/election/?agora=1 \
  -H "Accept: application/json"

# Crear nueva elección
curl -X POST http://localhost:8000/api/v1/election/ \
  -H "Content-Type: application/json" \
  -H "Authorization: ApiKey usuario1:su_api_key_aqui" \
  -d '{
    "agora": "/api/v1/agora/1/",
    "pretty_name": "Elección de Prueba",
    "description": "Una elección de ejemplo",
    "questions": [
      {
        "question": "¿Cuál es tu opción preferida?",
        "answers": [
          {"value": "Opción A"},
          {"value": "Opción B"},
          {"value": "Opción C"}
        ]
      }
    ],
    "election_type": "PLURALITY_AT_LARGE",
    "voting_starts_at_date": "2024-01-15T10:00:00Z",
    "voting_ends_at_date": "2024-01-20T18:00:00Z"
  }'

# Obtener elección específica
curl -X GET http://localhost:8000/api/v1/election/1/ \
  -H "Accept: application/json"
```

#### 5. Sistema de Votación

```bash
# Emitir voto directo
curl -X POST http://localhost:8000/api/v1/castvote/ \
  -H "Content-Type: application/json" \
  -H "Authorization: ApiKey usuario1:su_api_key_aqui" \
  -d '{
    "election": "/api/v1/election/1/",
    "question": 0,
    "answer": "Opción A",
    "is_direct": true
  }'

# Delegar voto
curl -X POST http://localhost:8000/api/v1/castvote/ \
  -H "Content-Type: application/json" \
  -H "Authorization: ApiKey usuario1:su_api_key_aqui" \
  -d '{
    "election": "/api/v1/election/1/",
    "delegate": "/api/v1/user/2/",
    "is_direct": false
  }'
```

#### 6. Sistema de Seguimiento

```bash
# Seguir usuario
curl -X POST http://localhost:8000/api/v1/follow/ \
  -H "Content-Type: application/json" \
  -H "Authorization: ApiKey usuario1:su_api_key_aqui" \
  -d '{
    "user": "/api/v1/user/2/",
    "flag": true
  }'

# Seguir ágora
curl -X POST http://localhost:8000/api/v1/follow/ \
  -H "Content-Type: application/json" \
  -H "Authorization: ApiKey usuario1:su_api_key_aqui" \
  -d '{
    "content_type": "agora",
    "object_id": 1,
    "flag": true
  }'
```

#### 7. Stream de Actividades

```bash
# Obtener actividades del usuario
curl -X GET http://localhost:8000/api/v1/action/?actor=1 \
  -H "Accept: application/json" \
  -H "Authorization: ApiKey usuario1:su_api_key_aqui"

# Obtener actividades de una ágora
curl -X GET http://localhost:8000/api/v1/action/?target_content_type=agora&target_object_id=1 \
  -H "Accept: application/json"
```

#### 8. Búsqueda Global

```bash
# Búsqueda general
curl -X GET "http://localhost:8000/api/v1/search/?q=democracia" \
  -H "Accept: application/json"

# Búsqueda específica por tipo
curl -X GET "http://localhost:8000/api/v1/search/?q=eleccion&model=election" \
  -H "Accept: application/json"
```

#### 9. Gestión de Perfil de Usuario

```bash
# Obtener perfil de usuario
curl -X GET http://localhost:8000/api/v1/user/username/usuario1/ \
  -H "Accept: application/json"

# Actualizar configuraciones de usuario
curl -X PUT http://localhost:8000/api/v1/user/settings/ \
  -H "Content-Type: application/json" \
  -H "Authorization: ApiKey usuario1:su_api_key_aqui" \
  -d '{
    "email_updates": true,
    "lang_code": "es"
  }'

# Verificar disponibilidad de username
curl -X GET "http://localhost:8000/api/v1/user/username_available/?username=nuevouser" \
  -H "Accept: application/json"
```

#### 10. Logout

```bash
# Logout
curl -X POST http://localhost:8000/api/v1/user/logout/ \
  -H "Authorization: ApiKey usuario1:su_api_key_aqui"
```

### Flujo de Prueba Automatizada

Para realizar pruebas automatizadas completas, seguir este orden:

1. **Registro de usuario** → 2. **Login** → 3. **Crear ágora** → 4. **Unirse a ágora** → 5. **Crear elección** → 6. **Emitir voto** → 7. **Ver resultados** → 8. **Logout**

### Formatos Soportados

La API soporta múltiples formatos:
- **JSON**: `Accept: application/json` (recomendado)
- **XML**: `Accept: application/xml`
- **YAML**: `Accept: application/yaml`

### Autenticación API

- **Sin autenticación**: Endpoints de solo lectura
- **Session Auth**: Para uso desde JavaScript en la misma aplicación
- **Token Auth**: ApiKey para aplicaciones externas

## Conclusiones Arquitectónicas

### Fortalezas Arquitectónicas

1. **Separación clara de responsabilidades** con el patrón MTV de Django
2. **API REST completa** que permite integración con aplicaciones externas
3. **Sistema de permisos granular** con django-guardian
4. **Arquitectura orientada a eventos** con sistema de actividades
5. **Procesamiento asíncrono** bien implementado con Celery
6. **Modularidad** a través de Django apps independientes

### Áreas de Mejora Identificadas

1. **Versión legada de Django** (1.5.5) requiere actualización urgente
2. **Dependencias desactualizadas** representan riesgos de seguridad
3. **Base de datos SQLite** no es adecuada para producción a escala
4. **Falta de tests automatizados** comprehensivos
5. **Ausencia de API versioning** strategy
6. **Documentación limitada** de APIs y arquitectura

### Recomendaciones para Modernización

1. **Migración incremental** a Django LTS más reciente
2. **Implementación de contenedores** Docker para todos los servicios
3. **Adopción de PostgreSQL** como base de datos principal
4. **Implementación de CI/CD** pipeline
5. **Adición de monitoring** y logging centralizados
6. **Refactoring hacia microservicios** para componentes independientes
7. **Implementación de caching** estratégico con Redis
8. **Adopción de API versioning** y documentación automática

### Valor Arquitectónico

A pesar de ser un sistema legado, Agora Ciudadana demuestra principios arquitectónicos sólidos que facilitan el mantenimiento y la evolución. La separación de capas, el uso de patrones establecidos y la API REST bien estructurada proporcionan una base sólida para futuras modernizaciones.

La arquitectura actual permite escalabilidad horizontal limitada y soporta los requisitos funcionales de participación ciudadana digital, aunque requiere modernización tecnológica para entornos de producción contemporáneos. 