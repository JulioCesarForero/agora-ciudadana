# Análisis de Arquitectura de Software - Agora Ciudadana

## Respuestas

### 1. Apps de Django y sus responsabilidades

Las aplicaciones Django identificadas son:

#### Aplicaciones Principales:
- **`agora_site.agora_core`**: Aplicación principal del dominio, contiene:
  - Modelos centrales: `Agora`, `Election`, `CastVote`, `Profile`
  - Lógica de votación y delegación
  - API REST con Tastypie
  - Sistema de permisos con django-guardian
  - Tareas asíncronas con Celery

- **`agora_site.accounts`**: Gestión de cuentas de usuario:
  - Autenticación y registro
  - Formularios personalizados: `AccountSignupForm`, `AcccountAuthForm`
  - Integración con userena para perfiles de usuario
  - Activación de cuentas y recuperación de contraseñas

- **`agora_site.misc`**: Utilidades transversales:
  - Context processors personalizados (`agora_site.misc.context_processor`)
  - Decoradores de utilidad
  - Funciones auxiliares

#### Aplicaciones Externas Incluidas:
- **`actstream`**: Sistema de actividades y seguimiento de acciones
- **`haystack`**: Motor de búsqueda con backend Whoosh
- **`userena`**: Gestión de perfiles de usuario y autenticación

#### Interrelaciones:
- `agora_core` importa y usa `actstream` para seguimiento de actividades
- `accounts` extiende `userena` con formularios personalizados
- `agora_core.models.__init__.py` importa desde `agora.py`, `election.py`, `castvote.py`
- Las señales Django conectan automáticamente creación de perfiles con usuarios

### 2. Despliegue en producción

#### Configuración WSGI:
```python
# agora_site/wsgi.py
from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()
```

#### Servidor de aplicación:
- Configurado para WSGI estándar de Django
- No se encontraron configuraciones específicas de Gunicorn, Daphne o Uvicorn en el código

#### Contenedores:
- No se encontraron archivos Docker (Dockerfile, docker-compose.yml) en la estructura del proyecto

#### Servicios Externos:
- **RabbitMQ**: Para Celery (`BROKER_URL = 'amqp://guest:guest@localhost:5672/'`)
- **SMTP**: Para notificaciones email (`EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'` en desarrollo)
- **Whoosh**: Motor de búsqueda local (`HAYSTACK_CONNECTIONS` con `WhooshEngine`)

### 3. Interacción con fuentes de datos

#### ORM y Base de Datos:
- **Motor**: SQLite por defecto (`django.db.backends.sqlite3`)
- **Archivo**: `db.sqlite` en desarrollo, `testdb.sqlite` para tests
- **Migraciones**: South para Django 1.5.5 (`south==0.7.6`)

#### Modelos Principales:
- **`Profile`**: Extiende `UserenaLanguageBaseProfile` con campos como `short_description`, `biography`, `extra` (JSONField)
- **`Agora`**: Modelo central con políticas de membresía, votación y comentarios
- **`Election`**: Sistema de votaciones con múltiples tipos de votación
- **`CastVote`**: Registros de votos emitidos

#### Consultas Complejas:
```python
# Ejemplo en agora.py líneas 130-136
def get_open_elections_with_name_start(self, name):
    return self.elections.filter(
        Q(voting_extended_until_date__gt=timezone.now()) |
            Q(voting_extended_until_date=None,
                voting_starts_at_date__lt=timezone.now()),
        Q(is_approved=True, archived_at_date__isnull=True),
        Q(pretty_name__icontains=name))
```

#### Cache y Servicios:
- **Celery**: Para tareas asíncronas (`djcelery` configurado)
- **Haystack**: Para búsqueda con índices Whoosh
- Sin configuración Redis explícita encontrada

### 4. Patrones y tácticas de arquitectura

#### Patrones Identificados:
- **MVT (Model-View-Template)**: Patrón estándar de Django
- **Repository Pattern**: A través del ORM y managers personalizados
- **Observer Pattern**: Sistema de señales Django (`post_save`, `action`)
- **Strategy Pattern**: Sistemas de votación intercambiables (`VOTING_METHODS`)
- **Command Pattern**: Comandos de gestión Django (`manage.py`)

#### Referencias en Código:
- Strategy en `agora_site.agora_core.models.voting_systems.base.parse_voting_methods()`
- Observer en `agora_site.agora_core.models.__init__.py` línea 341: `post_save.connect(create_user_profile, sender=User)`

### 5. Tecnologías y frameworks

#### Framework Principal:
- **Django 1.5.5**: Framework web principal

#### Dependencias Principales (requirements.txt):
```
Django==1.5.5
south==0.7.6 (migraciones)
django-guardian (permisos a nivel objeto)
django-activity-stream (sistema actividades)
django-social-auth>=0.7.7 (autenticación social)
django-crispy-forms (formularios)
django-haystack (búsqueda)
django-tastypie==0.9.12 (API REST)
celery==3.0.12 (tareas asíncronas)
django-celery==3.0.11
whoosh==2.4.1 (motor búsqueda)
```

#### Librerías Adicionales:
- `easy_thumbnails` (imágenes)
- `textile`, `markdown` (formateo texto)
- `pygeoip` (geolocalización)
- `django-secure==1.0` (seguridad)

### 6. Principales capas o módulos

#### Capa de Presentación:
- **Templates**: `agora_site/templates/` con plantillas HTML
- **Static files**: `agora_site/static/` con CSS, JavaScript, imágenes
- **Forms**: `agora_site/agora_core/forms/` y `agora_site/accounts/forms.py`

#### Capa de Dominio:
- **Models**: `agora_site/agora_core/models/` con entidades de negocio
- **Business Logic**: Métodos en modelos como `add_to_agora()`, `has_perms()`

#### Capa de Infraestructura:
- **API**: `agora_site/agora_core/api.py` y `resources/`
- **Tasks**: `agora_site/agora_core/tasks/` para Celery
- **Backends**: `agora_site/agora_core/backends/`

#### Capa de Tests:
- **Tests**: `agora_site/agora_core/tests/` con tests unitarios e integración

### 7. Dependencias entre servicios

#### Arquitectura Monolítica:
- Una sola aplicación Django sin microservicios
- Comunicación interna a través de importaciones directas Python

#### APIs Externas:
- **Twitter API**: Configurada pero sin claves (`TWITTER_CONSUMER_KEY = ''`)
- **FNMT**: Sistema certificados digitales españoles (deshabilitado por defecto)

### 8. Gestión de seguridad

#### Autenticación:
```python
# settings.py líneas 254-270
AUTHENTICATION_BACKENDS = (
    'social_auth.backends.twitter.TwitterBackend',
    'userena.backends.UserenaAuthenticationBackend',
    'django.contrib.auth.backends.ModelBackend',
    'guardian.backends.ObjectPermissionBackend',
)
```

#### Autorización:
- **django-guardian**: Permisos a nivel de objeto
- **Custom permissions**: En meta classes de modelos
- **Decoradores**: `@permission_required` en `agora_site.misc.decorators`

#### Seguridad Web:
```python
# settings.py líneas 400-420
SECURE_CONTENT_TYPE_NOSNIFF = True
SECURE_FRAME_DENY = True
SECURE_BROWSER_XSS_FILTER = True
SECURE_HSTS_SECONDS = 2
```

#### Middleware de Seguridad:
- `djangosecure.middleware.SecurityMiddleware`
- `django.middleware.csrf.CsrfViewMiddleware`
- `django.middleware.clickjacking.XFrameOptionsMiddleware`

#### Vulnerabilidades Potenciales:
- **Django 1.5.5**: Versión obsoleta con vulnerabilidades conocidas
- **Secret Key**: Hardcodeada en settings.py (línea 77)
- **Debug Mode**: Activado por defecto (`DEBUG = True`)
- **Admin Interface**: Habilitada en producción (comentario en línea 178)

### 9. Escalabilidad y balanceo de carga

#### Configuraciones de Cache:
```python
# settings.py líneas 440-450
CACHE_MIDDLEWARE_SECONDS = 0  # No cache por defecto
MANY_CACHE_SECONDS = 0
FEW_CACHE_SECONDS = 0
```

#### Limitaciones de Escalabilidad:
- SQLite como base de datos (no adecuada para alta concurrencia)
- Sin configuración de balanceadores de carga
- Sin configuración de CDN

### 10. Manejo de errores y resiliencia

#### Logging:
```python
# settings.py líneas 8-32
LOGGING = {
    'handlers': {
        'mail_admins': {
            'level': 'ERROR',
            'class': 'django.utils.log.AdminEmailHandler'
        }
    }
}
```

#### Estrategias de Manejo:
- Emails automáticos para errores 500
- Django Debug Toolbar para desarrollo
- Captcha después de fallos de login (`MAX_ALLOWED_FAILED_LOGIN_ATTEMPTS = 5`)

#### Sin Configuración de:
- Circuit breakers
- Retry automático
- Health checks

### 11. Capas lógicas

#### Separación de Responsabilidades:
- **agora_core**: Lógica de dominio y persistencia
- **accounts**: Autenticación y gestión usuarios  
- **misc**: Utilidades transversales
- **haystack**: Motor de búsqueda
- **actstream**: Sistema de actividades

#### Aislamiento:
- Apps Django con `app_label` específicos
- Namespace en URLs (`accounts/`, `api/`)
- Context processors para datos globales

### 12. Comunicación con la aplicación

#### API REST Endpoints (Tastypie v1):

**Principales recursos API** (`agora_site/agora_core/api.py`):
- `/api/v1/user/` - UserResource
- `/api/v1/agora/` - AgoraResource  
- `/api/v1/election/` - ElectionResource
- `/api/v1/castvote/` - CastVoteResource
- `/api/v1/delegateelectioncount/` - DelegateElectionCountResource
- `/api/v1/follow/` - FollowResource
- `/api/v1/action/` - ActionResource
- `/api/v1/search/` - SearchResource

**Endpoints Web principales** (`agora_site/urls.py` y `agora_site/agora_core/urls.py`):

**Rutas de autenticación:**
- `GET/POST /accounts/signup/` → `userena_views.signup`
- `GET/POST /accounts/signin/` → `userena_views.signin`
- `POST /accounts/signout/` → `auth_views.logout`
- `GET/POST /accounts/password/reset/` → `auth_views.password_reset`

**Rutas principales:**
- `GET /` → `HomeView.as_view()`
- `GET /agora/new/` → `CreateAgoraView.as_view()`
- `GET /agora/list/` → `AgoraListView.as_view()`
- `GET /elections/list/` → `ElectionListView.as_view()`
- `GET /user/list/` → `UserListView.as_view()`
- `GET /search/` → `SearchView.as_view()`

**Rutas de ágoras:**
- `GET /{username}/{agoraname}/` → `AgoraView.as_view()`
- `GET /{username}/{agoraname}/elections/{filter}/` → `AgoraElectionsView.as_view()`
- `GET /{username}/{agoraname}/members/{filter}/` → `AgoraMembersView.as_view()`
- `POST /{username}/{agoraname}/action/join/` → `AgoraActionJoinView.as_view()`
- `POST /{username}/{agoraname}/action/leave/` → `AgoraActionLeaveView.as_view()`

**Rutas de elecciones:**
- `GET /{username}/{agoraname}/election/new/` → `CreateElectionView.as_view()`
- `GET /{username}/{agoraname}/election/{electionname}/` → `ElectionView.as_view()`
- `GET /{username}/{agoraname}/election/{electionname}/vote/` → `VotingBoothView.as_view()`
- `POST /{username}/{agoraname}/election/{electionname}/action/vote/` → `VoteView.as_view()`

**Otros mecanismos:**
- **Comandos CLI**: Management commands en `agora_site/agora_core/management/commands/`
  - `addtestusers.py`
  - `cleardb.py` 
  - `compute_results.py`
  - `exportusers.py`
  - `importusers.py`
- **WebSockets**: No encontrados en el código
- **GraphQL**: No implementado 