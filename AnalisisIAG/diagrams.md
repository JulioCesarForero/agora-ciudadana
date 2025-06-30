# Estructura de carpetas

## Estructura completa y precisa del proyecto Django - Agora Ciudadana

```text
agora-ciudadana-master/                          # Proyecto raíz - plataforma de participación ciudadana
├── .gitignore                                   # Control de versiones - archivos excluidos
├── .gitattributes                              # Configuración de atributos Git
├── .travis.yml                                 # Configuración CI/CD para Travis CI
├── __init__.py                                 # Marca el directorio como paquete Python
├── manage.py                                   # Script principal Django para comandos administrativos
├── requirements.txt                            # Dependencias Python (Django 1.5.5, Celery, etc.)
├── initial_data.json                           # Datos iniciales para fixtures de la aplicación
├── runtests.sh                                 # Script shell para ejecutar suite de pruebas
├── Makefile                                    # Automatización de tareas (build, deploy, test)
├── README.md                                   # Documentación principal del proyecto
├── INSTALL.md                                  # Instrucciones de instalación y configuración
├── LICENSE                                     # Licencia AGPL v3 del proyecto
├── VISION.txt                                  # Visión y objetivos del proyecto
│
├── agora_site/                                 # PAQUETE PRINCIPAL DJANGO - Configuración del proyecto
│   ├── __init__.py                             # Inicialización del paquete Django
│   ├── settings.py                             # ⚠️ CONFIGURACIÓN GLOBAL - contiene SECRET_KEY hardcodeada
│   ├── test_settings.py                        # Configuración específica para testing
│   ├── urls.py                                 # Enrutamiento URL principal del proyecto
│   ├── views.py                                # Vistas globales y utilitarias
│   ├── wsgi.py                                 # Entrada WSGI para servidores de aplicación
│   │
│   ├── agora_core/                             # APLICACIÓN DJANGO PRINCIPAL - Lógica de dominio
│   │   ├── __init__.py                         # Inicialización de la app
│   │   ├── admin.py                            # Configuración del admin de Django
│   │   ├── api.py                              # Definición de API REST con Tastypie v1
│   │   ├── urls.py                             # Endpoints específicos de agora_core
│   │   ├── views.py                            # Controladores HTTP (function/class-based views)
│   │   ├── search_indexes.py                   # Configuración de índices para Haystack
│   │   │
│   │   ├── models/                             # CAPA DE DOMINIO - Entidades de negocio
│   │   │   ├── __init__.py                     # Modelo Profile y configuración de señales
│   │   │   ├── agora.py                        # Modelo Agora - espacios de participación ciudadana
│   │   │   ├── election.py                     # Modelo Election - votaciones y elecciones
│   │   │   ├── castvote.py                     # Modelo CastVote - votos emitidos
│   │   │   ├── delegateelectioncount.py        # Modelo para conteo de delegaciones
│   │   │   └── voting_systems/                 # ESTRATEGIA - Sistemas de votación intercambiables
│   │   │       ├── __init__.py                 # Inicialización de sistemas de votación
│   │   │       ├── base.py                     # Clase base abstracta para sistemas de votación
│   │   │       ├── base_stv.py                 # Base para sistemas Single Transferable Vote
│   │   │       ├── plurality.py               # Sistema de votación por pluralidad
│   │   │       ├── meek_stv.py                 # Sistema Meek STV
│   │   │       ├── wright_stv.py               # Sistema Wright STV
│   │   │       └── json_report.py              # Generación de reportes JSON
│   │   │
│   │   ├── resources/                          # CAPA API - Recursos REST con Tastypie
│   │   │   ├── __init__.py                     # Inicialización de recursos API
│   │   │   ├── agora.py                        # AgoraResource - CRUD y acciones de ágoras
│   │   │   ├── election.py                     # ElectionResource - gestión de elecciones
│   │   │   ├── user.py                         # UserResource - gestión de usuarios
│   │   │   ├── castvote.py                     # CastVoteResource - gestión de votos
│   │   │   ├── delegateelectioncount.py        # DelegateElectionCountResource
│   │   │   └── search.py                       # SearchResource - funcionalidad de búsqueda
│   │   │
│   │   ├── forms/                              # CAPA PRESENTACIÓN - Validación y formularios
│   │   │   ├── __init__.py                     # Configuración base de formularios
│   │   │   ├── agora.py                        # Formularios específicos de ágoras
│   │   │   ├── election.py                     # Formularios de elecciones y votación
│   │   │   ├── user.py                         # Formularios de gestión de usuarios
│   │   │   └── comment.py                      # Formularios de comentarios
│   │   │
│   │   ├── tasks/                              # CAPA INFRAESTRUCTURA - Tareas asíncronas Celery
│   │   │   ├── __init__.py                     # Configuración de tareas
│   │   │   ├── agora.py                        # Tareas asíncronas relacionadas con ágoras
│   │   │   └── election.py                     # Tareas asíncronas de elecciones
│   │   │
│   │   ├── tests/                              # CAPA TESTING - Pruebas unitarias e integración
│   │   │   ├── __init__.py                     # Configuración de testing (CELERY_ALWAYS_EAGER)
│   │   │   ├── agora.py                        # Tests del dominio Agora
│   │   │   ├── election.py                     # Tests del dominio Election
│   │   │   ├── user.py                         # Tests de funcionalidad de usuarios
│   │   │   ├── common.py                       # Utilities comunes para testing
│   │   │   ├── misc.py                         # Tests de utilidades generales
│   │   │   ├── search.py                       # Tests de funcionalidad de búsqueda
│   │   │   ├── action.py                       # Tests del sistema de actividades
│   │   │   └── delegateelectioncount.py        # Tests de conteo de delegaciones
│   │   │
│   │   ├── migrations/                         # INFRAESTRUCTURA DB - Migraciones South
│   │   │   ├── __init__.py                     # Inicialización de migraciones
│   │   │   ├── 0001_initial.py                 # Migración inicial del esquema
│   │   │   ├── 0002_auto__add_field_agora_comments_policy__.py  # Añadir políticas de comentarios
│   │   │   ├── 0003_auto__del_field_election_delegated_votes_result.py
│   │   │   ├── 0004_auto__add_delegateelectioncount__.py
│   │   │   ├── 0005_auto__add_field_delegateelectioncount_created_at_date.py
│   │   │   ├── 0006_auto__add_field_delegateelectioncount_count_percentage__.py
│   │   │   ├── 0007_auto__add_unique_delegateelectioncount_delegate_vote.py
│   │   │   ├── 0008_auto__del_unique_delegateelectioncount_delegate_vote.py
│   │   │   ├── 0009_auto__add_field_agora_url.py
│   │   │   └── 0010_auto__add_field_agora_delegation_policy.py
│   │   │
│   │   ├── management/                         # COMANDOS CLI - Gestión administrativa
│   │   │   ├── __init__.py                     # Inicialización de comandos
│   │   │   ├── api/                            # Comandos relacionados con API
│   │   │   │   └── addtestdata.py              # Comando para añadir datos de prueba
│   │   │   └── commands/                       # Comandos de gestión Django
│   │   │       ├── __init__.py                 # Inicialización de comandos
│   │   │       ├── addtestusers.py             # Comando para crear usuarios de prueba
│   │   │       ├── cleardb.py                  # Comando para limpiar base de datos
│   │   │       ├── compute_results.py          # Comando para cálculo de resultados
│   │   │       ├── exportusers.py              # Comando para exportar usuarios
│   │   │       ├── importusers.py              # Comando para importar usuarios
│   │   │       ├── removeallusers.py           # Comando para eliminar todos los usuarios
│   │   │       └── syncperms.py                # Comando para sincronizar permisos
│   │   │
│   │   ├── backends/                           # CAPA INFRAESTRUCTURA - Backends de autenticación
│   │   │   ├── __init__.py                     # Inicialización de backends
│   │   │   └── fnmt.py                         # Backend para certificados FNMT españoles
│   │   │
│   │   ├── templatetags/                       # PRESENTACIÓN - Template tags personalizados
│   │   │   ├── __init__.py                     # Inicialización de template tags
│   │   │   ├── agora_utils.py                  # Utilities para templates de ágoras
│   │   │   └── string_tags.py                  # Tags para manipulación de strings
│   │   │
│   │   ├── templates/                          # CAPA PRESENTACIÓN - Plantillas HTML
│   │   │   ├── 404.html                        # Página de error 404
│   │   │   ├── 500.html                        # Página de error 500
│   │   │   ├── agora_core/                     # Templates específicos de agora_core
│   │   │   │   ├── agora_activity.html         # Template de actividad de ágora
│   │   │   │   ├── agora_add_members.html      # Template para añadir miembros
│   │   │   │   ├── agora_admin.html            # Template de administración
│   │   │   │   ├── client/                     # Templates del lado cliente
│   │   │   │   │   ├── action_a_user.html      # Templates de acciones de usuario
│   │   │   │   │   ├── action_ao_agora_t_user.html
│   │   │   │   │   ├── action_ao_agora.html
│   │   │   │   │   └── [+31 templates más]     # Múltiples templates de interacciones
│   │   │   │   ├── emails/                     # Templates para emails
│   │   │   │   │   ├── agora_notification.html # Notificaciones de ágora
│   │   │   │   │   ├── agora_notification.txt  # Versión texto plano
│   │   │   │   │   ├── election_archived.html  # Notificación de elección archivada
│   │   │   │   │   └── [+19 templates más]     # Múltiples templates de email
│   │   │   │   └── [+38 templates más]         # Templates adicionales
│   │   │   ├── flatpages/                      # Templates para páginas estáticas
│   │   │   │   └── default.html                # Template por defecto para flatpages
│   │   │   └── search/                         # Templates de búsqueda
│   │   │       ├── include-js-template-agora-profile.html
│   │   │       ├── include-js-template-search-agora.html
│   │   │       ├── include-js-template-search-election.html
│   │   │       ├── indexes/                    # Índices de búsqueda
│   │   │       │   └── agora_core/
│   │   │       │       ├── agora_text.txt      # Índice de texto para ágoras
│   │   │       │       ├── election_text.txt   # Índice de texto para elecciones
│   │   │       │       └── profile_text.txt    # Índice de texto para perfiles
│   │   │       └── [+4 templates más]
│   │   │
│   │   └── fixtures/                           # DATOS INICIALES - Fixtures de la aplicación
│   │       ├── flatpages.json                  # Páginas estáticas iniciales
│   │       ├── test_agoras.json                # Datos de prueba para ágoras
│   │       ├── test_elections.json             # Datos de prueba para elecciones
│   │       └── [+1 archivo más]
│   │
│   ├── accounts/                               # APLICACIÓN DJANGO - Gestión de cuentas de usuario
│   │   ├── __init__.py                         # Inicialización de la app accounts
│   │   ├── forms.py                            # Formularios de autenticación y registro
│   │   ├── urls.py                             # Endpoints de cuentas (signin, signup, etc.)
│   │   ├── views.py                            # Vistas de autenticación y gestión de cuentas
│   │   └── templates/                          # Templates específicos de cuentas
│   │       └── accounts/                       # Subdirectorio de templates
│   │           ├── activate_fail.html          # Template de activación fallida
│   │           ├── auth_basic_form.html        # Formulario básico de autenticación
│   │           ├── auth_forms.html             # Formularios de autenticación
│   │           ├── emails/                     # Templates de emails de cuentas
│   │           │   ├── activation_email_message.txt    # Email de activación
│   │           │   ├── activation_email_subject.txt    # Asunto del email
│   │           │   ├── confirmation_email_message_new.txt
│   │           │   └── [+4 archivos más]       # Templates adicionales de email
│   │           └── [+16 archivos más]          # Templates adicionales de cuentas
│   │
│   ├── misc/                                   # UTILIDADES TRANSVERSALES - Componentes auxiliares
│   │   ├── __init__.py                         # Inicialización de utilities
│   │   ├── context_processor.py                # Context processors personalizados para templates
│   │   ├── decorators.py                       # Decoradores personalizados (@permission_required)
│   │   ├── generic_resource.py                 # Clase base para recursos API
│   │   └── utils.py                            # Funciones de utilidad general
│   │
│   ├── static/                                 # ARCHIVOS ESTÁTICOS - CSS, JS, imágenes
│   │   ├── favicon.ico                         # Icono del sitio
│   │   ├── admin/                              # Archivos estáticos del admin Django
│   │   │   ├── css/                            # Estilos CSS del admin
│   │   │   │   ├── base.css                    # Estilos base
│   │   │   │   ├── changelists.css             # Estilos de listas
│   │   │   │   ├── dashboard.css               # Estilos del dashboard
│   │   │   │   └── [+5 archivos más]
│   │   │   ├── img/                            # Imágenes del admin
│   │   │   │   ├── changelist-bg_rtl.gif
│   │   │   │   ├── changelist-bg.gif
│   │   │   │   ├── gis/                        # Imágenes para GIS
│   │   │   │   │   ├── move_vertex_off.png
│   │   │   │   │   └── move_vertex_on.png
│   │   │   │   └── [+36 archivos más]
│   │   │   └── js/                             # JavaScript del admin
│   │   │       ├── actions.js                  # Scripts de acciones
│   │   │       ├── admin/                      # Scripts específicos del admin
│   │   │       │   ├── DateTimeShortcuts.js    # Widgets de fecha/hora
│   │   │       │   ├── ordering.js             # Funcionalidad de ordenamiento
│   │   │       │   └── RelatedObjectLookups.js # Lookups de objetos relacionados
│   │   │       ├── calendar.js                 # Widget de calendario
│   │   │       └── [+17 archivos más]
│   │   ├── bootstrap/                          # Framework CSS Bootstrap
│   │   │   ├── css/                            # Estilos Bootstrap
│   │   │   │   ├── bootstrap-responsive.css    # Bootstrap responsive
│   │   │   │   ├── bootstrap.css               # Bootstrap base
│   │   │   │   └── [+1 archivo más]
│   │   │   ├── img/                            # Iconos Bootstrap
│   │   │   │   ├── glyphicons-halflings-white.png
│   │   │   │   └── glyphicons-halflings.png
│   │   │   ├── js/                             # JavaScript Bootstrap
│   │   │   │   └── bootstrap.js                # Funcionalidad Bootstrap
│   │   │   ├── less/                           # Archivos LESS source
│   │   │   │   ├── accordion.less              # Estilos de acordeón
│   │   │   │   ├── alerts.less                 # Estilos de alertas
│   │   │   │   ├── badges.less                 # Estilos de badges
│   │   │   │   └── [+33 archivos más]          # Múltiples módulos LESS
│   │   │   └── less-1.3.0.js                   # Compilador LESS
│   │   ├── css/                                # Estilos CSS personalizados
│   │   │   ├── jquery-ui.css                   # Estilos jQuery UI
│   │   │   └── liquidv.css                     # Estilos custom del proyecto
│   │   ├── img/                                # Imágenes del proyecto
│   │   │   ├── agora_default_logo.png          # Logo por defecto de ágoras
│   │   │   ├── agora_house.png                 # Imagen de casa de ágora
│   │   │   ├── agora_new_form_info.png         # Imagen informativa
│   │   │   └── [+41 archivos más]              # Múltiples recursos gráficos
│   │   ├── js/                                 # JavaScript personalizado
│   │   │   ├── agora/                          # Scripts específicos de ágoras
│   │   │   │   ├── ajax.js                     # Funcionalidad AJAX
│   │   │   │   ├── base.js                     # Funcionalidad base
│   │   │   │   ├── libs/                       # Librerías específicas
│   │   │   │   │   └── charts.js               # Funcionalidad de gráficos
│   │   │   │   └── views/                      # Scripts por vista
│   │   │   │       ├── agora_list.js           # Lista de ágoras
│   │   │   │       ├── agora_user_list.js      # Lista de usuarios de ágora
│   │   │   │       ├── agora.js                # Funcionalidad general de ágoras
│   │   │   │       └── [+14 archivos más]      # Scripts de vistas específicas
│   │   │   ├── libs/                           # Librerías JavaScript externas
│   │   │   │   ├── backbone-associations.js    # Extensión Backbone
│   │   │   │   ├── backbone.js                 # Framework MV* Backbone
│   │   │   │   ├── bootstrap.js                # Bootstrap JavaScript
│   │   │   │   ├── css/                        # CSS de librerías
│   │   │   │   │   └── ui-lightness/           # Tema jQuery UI
│   │   │   │   │       └── jquery-ui-1.8.23.custom.css
│   │   │   │   ├── moment-lang/                # Localización de MomentJS
│   │   │   │   │   ├── es.js                   # Localización español
│   │   │   │   │   └── gl.js                   # Localización gallego
│   │   │   │   └── [+17 archivos más]          # Múltiples librerías JS
│   │   │   ├── min/                            # JavaScript minificado
│   │   │   │   ├── agora.min.js                # Código minificado principal
│   │   │   │   ├── main.compat.min.js          # Versión compatible minificada
│   │   │   │   └── main.min.js                 # Main minificado
│   │   │   ├── test/                           # Tests JavaScript
│   │   │   │   └── encryption_test.js          # Tests de encriptación
│   │   │   └── world-countries.json            # Datos de países para UI
│   │   └── less/                               # Archivos LESS del proyecto
│   │       ├── agora.css                       # CSS compilado de ágoras
│   │       ├── agora.less                      # Estilos LESS principales
│   │       └── nv3.css                         # Estilos para visualizaciones
│   │
│   ├── media/                                  # ARCHIVOS MULTIMEDIA - Uploads y media files
│   │   ├── agora_biographyview.svg             # Recursos gráficos SVG
│   │   ├── agora_listsview.svg
│   │   ├── agora_new_form.svg
│   │   ├── agora_searchdelegatessview.svg
│   │   ├── agora_searchvotingsview.svg
│   │   ├── agora_votingsview.svg
│   │   ├── agora.svg
│   │   ├── agoraview.svg
│   │   ├── design.svg
│   │   ├── elections/                          # Directorio para archivos de elecciones
│   │   │   └── empty.txt                       # Placeholder para estructura
│   │   ├── home_anonymous.svg
│   │   ├── home_commentsview.svg
│   │   ├── home_loggedin.svg
│   │   ├── home_login.svg
│   │   ├── home_userbutton.svg
│   │   ├── pngs/                               # Versiones PNG de recursos
│   │   │   ├── agoraview.png
│   │   │   ├── home_anonymous.png
│   │   │   ├── home_loggedin.png
│   │   │   └── [+6 archivos más]
│   │   └── [+12 archivos más]
│   │
│   ├── templates/                              # TEMPLATES GLOBALES
│   │   └── base.html                           # Template base del proyecto
│   │
│   └── locale/                                 # INTERNACIONALIZACIÓN - Traducciones
│       ├── ca/                                 # Catalán
│       │   └── LC_MESSAGES/
│       │       └── django.po                   # Traducciones en catalán
│       ├── es/                                 # Español
│       │   └── LC_MESSAGES/
│       │       ├── django.po                   # Traducciones principales
│       │       ├── djangojs.po                 # Traducciones JavaScript
│       │       ├── djsgettext.po               # Traducciones gettext
│       │       └── [+1 archivo más]
│       ├── eu/                                 # Euskera/Vasco
│       │   └── LC_MESSAGES/
│       │       ├── django.po
│       │       ├── djangojs.po
│       │       └── djsgettext.po
│       └── gl/                                 # Gallego
│           └── LC_MESSAGES/
│               ├── django.po
│               ├── djangojs.po
│               ├── djsgettext.po
│               └── [+1 archivo más]
│
├── actstream/                                  # APLICACIÓN EXTERNA - Sistema de actividades
│   ├── __init__.py                             # Inicialización de actstream
│   ├── admin.py                                # Admin para actividades
│   ├── models.py                               # Modelos de actividades y seguimiento
│   ├── views.py                                # Vistas del sistema de actividades
│   ├── urls.py                                 # URLs de actividades
│   ├── actions.py                              # Acciones del sistema
│   ├── decorators.py                           # Decoradores para actividades
│   ├── exceptions.py                           # Excepciones personalizadas
│   ├── feeds.py                                # Feeds RSS/Atom de actividades
│   ├── gfk.py                                  # Generic Foreign Key utilities
│   ├── managers.py                             # Managers personalizados
│   ├── resources.py                            # Recursos API para actividades
│   ├── serializers.py                          # Serializadores para API
│   ├── settings.py                             # Configuración de actstream
│   ├── signals.py                              # Señales del sistema
│   ├── tests.py                                # Tests del sistema de actividades
│   ├── templatetags/                           # Template tags de actividades
│   │   ├── __init__.py
│   │   └── activity_tags.py                    # Tags para mostrar actividades
│   └── templates/                              # Templates de actividades
│       └── activity/
│           ├── action.html                     # Template de acción
│           ├── actor.html                      # Template de actor
│           ├── detail.html                     # Template de detalle
│           └── [+1 archivo más]
│
├── userena/                                    # APLICACIÓN EXTERNA - Gestión de perfiles
│   ├── __init__.py                             # Inicialización de userena
│   ├── admin.py                                # Admin de perfiles
│   ├── backends.py                             # Backends de autenticación
│   ├── decorators.py                           # Decoradores de userena
│   ├── forms.py                                # Formularios de perfiles
│   ├── managers.py                             # Managers de perfiles
│   ├── middleware.py                           # Middleware de userena
│   ├── models.py                               # Modelos de perfil y configuración
│   ├── settings.py                             # Configuración de userena
│   ├── signals.py                              # Señales de userena
│   ├── urls.py                                 # URLs de userena
│   ├── utils.py                                # Utilidades de userena
│   ├── views.py                                # Vistas de gestión de perfiles
│   ├── contrib/                                # Módulos contribuidos
│   │   ├── __init__.py
│   │   └── umessages/                          # Sistema de mensajería
│   │       ├── __init__.py
│   │       ├── admin.py                        # Admin de mensajes
│   │       ├── fields.py                       # Campos personalizados
│   │       ├── fixtures/                       # Datos iniciales
│   │       │   └── messages.json
│   │       ├── migrations/                     # Migraciones de mensajes
│   │       │   ├── __init__.py
│   │       │   └── 0001_initial.py
│   │       ├── templates/                      # Templates de mensajes
│   │       │   ├── base.html
│   │       │   └── umessages/
│   │       │       ├── base_message.html
│   │       │       ├── message_detail.html
│   │       │       ├── message_form.html
│   │       │       └── [+1 archivo más]
│   │       ├── templatetags/                   # Template tags de mensajes
│   │       │   ├── __init__.py
│   │       │   └── umessages_tags.py
│   │       ├── tests/                          # Tests de mensajería
│   │       │   ├── __init__.py
│   │       │   ├── fields.py
│   │       │   ├── forms.py
│   │       │   └── [+3 archivos más]
│   │       └── [+5 archivos más]
│   ├── fixtures/                               # Datos iniciales de userena
│   │   ├── profiles.json                       # Perfiles de ejemplo
│   │   └── users.json                          # Usuarios de ejemplo
│   ├── locale/                                 # Traducciones de userena
│   │   ├── es/                                 # Español
│   │   │   └── LC_MESSAGES/
│   │   │       └── django.po
│   │   ├── fr/                                 # Francés
│   │   │   └── LC_MESSAGES/
│   │   │       └── django.po
│   │   ├── nl/                                 # Holandés
│   │   │   └── LC_MESSAGES/
│   │   │       └── django.po
│   │   ├── pl/                                 # Polaco
│   │   │   └── LC_MESSAGES/
│   │   │       └── django.po
│   │   └── pt/                                 # Portugués
│   │       └── LC_MESSAGES/
│   │           └── django.po
│   ├── management/                             # Comandos de gestión
│   │   ├── __init__.py
│   │   └── commands/
│   │       ├── __init__.py
│   │       ├── check_permissions.py            # Verificar permisos
│   │       └── clean_expired.py                # Limpiar usuarios expirados
│   ├── migrations/                             # Migraciones de userena
│   │   ├── __init__.py
│   │   └── 0001_initial.py
│   ├── templates/                              # Templates de userena
│   │   ├── base.html
│   │   └── userena/
│   │       ├── activate_fail.html
│   │       ├── base_userena.html
│   │       ├── disabled.html
│   │       ├── emails/                         # Templates de email
│   │       │   ├── activation_email_message.txt
│   │       │   ├── activation_email_subject.txt
│   │       │   ├── confirmation_email_message_new.txt
│   │       │   └── [+4 archivos más]
│   │       └── [+17 archivos más]
│   └── tests/                                  # Tests de userena
│       ├── __init__.py
│       ├── backends.py
│       ├── commands.py
│       ├── profiles/
│       │   ├── __init__.py
│       │   ├── models.py
│       │   └── test.py
│       └── [+9 archivos más]
│
├── haystack/                                   # APLICACIÓN EXTERNA - Motor de búsqueda
│   ├── __init__.py                             # Inicialización con validaciones de configuración
│   ├── admin.py                                # Admin para índices de búsqueda
│   ├── constants.py                            # Constantes del sistema de búsqueda
│   ├── exceptions.py                           # Excepciones de Haystack
│   ├── fields.py                               # Campos de índices de búsqueda
│   ├── forms.py                                # Formularios de búsqueda
│   ├── indexes.py                              # Definición de índices
│   ├── inputs.py                               # Inputs de búsqueda
│   ├── models.py                               # Modelos de resultados
│   ├── panels.py                               # Paneles de debug toolbar
│   ├── query.py                                # Construcción de queries
│   ├── routers.py                              # Enrutamiento de backends
│   ├── urls.py                                 # URLs de búsqueda
│   ├── views.py                                # Vistas de búsqueda
│   ├── backends/                               # Backends de motores de búsqueda
│   │   ├── __init__.py
│   │   ├── elasticsearch_backend.py            # Backend Elasticsearch
│   │   ├── simple_backend.py                   # Backend simple
│   │   └── [+3 archivos más]
│   ├── management/                             # Comandos de gestión de índices
│   │   ├── __init__.py
│   │   └── commands/
│   │       ├── __init__.py
│   │       ├── build_solr_schema.py            # Construir schema Solr
│   │       ├── clear_index.py                  # Limpiar índices
│   │       └── [+3 archivos más]
│   ├── templates/                              # Templates de Haystack
│   │   ├── panels/
│   │   │   └── haystack.html                   # Panel debug toolbar
│   │   └── search_configuration/
│   │       └── solr.xml                        # Configuración Solr
│   ├── templatetags/                           # Template tags de búsqueda
│   │   ├── __init__.py
│   │   ├── highlight.py                        # Highlighting de resultados
│   │   └── more_like_this.py                   # Funcionalidad "more like this"
│   └── utils/                                  # Utilidades de Haystack
│       ├── __init__.py
│       ├── decorators.py                       # Decoradores de búsqueda
│       ├── geo.py                              # Utilidades geográficas
│       └── [+3 archivos más]
│
└── docs/                                       # DOCUMENTACIÓN DEL PROYECTO
    ├── Makefile                                # Automatización de documentación
    ├── conf.py                                 # Configuración Sphinx
    ├── index.rst                               # Índice principal de documentación
    ├── api.rst                                 # Documentación de API REST
    ├── _static/                                # Archivos estáticos de documentación
    │   └── diagrams/                           # Diagramas del proyecto
    │       ├── data_model.pdf                  # Diagrama del modelo de datos
    │       ├── front_agora.pdf                 # Diagrama del frontend ágoras
    │       ├── front_election.pdf              # Diagrama del frontend elecciones
    │       └── [+2 archivos más]
    └── diagrams/                               # Fuentes de diagramas
        ├── data_model.dia                      # Fuente del modelo de datos
        ├── front_agora.dia                     # Fuente del frontend ágoras
        ├── front_election.dia                  # Fuente del frontend elecciones
        └── [+2 archivos más]
```

## Análisis de Seguridad y Vulnerabilidades

### ⚠️ Vulnerabilidades Críticas Identificadas (OWASP Top 10):

**Data Leakage:**
- **`agora_site/settings.py`**: Contiene SECRET_KEY hardcodeada en código fuente (línea 77)
- **`agora_site/settings.py`**: DEBUG = True habilitado por defecto (desarrollo)
- **`agora_site/settings.py`**: Configuración de admin habilitada para producción

**Insecure Plugins:**
- **Django 1.5.5**: Versión extremadamente obsoleta con múltiples CVEs conocidos
- **`requirements.txt`**: Dependencias sin versionado específico pueden introducir vulnerabilidades
- **FNMT Backend**: Sistema de certificados digitales con configuración personalizada (`agora_site/agora_core/backends/fnmt.py`)

### Configuraciones de Seguridad Presentes:
- Middleware CSRF habilitado (`django.middleware.csrf.CsrfViewMiddleware`)
- Protección XSS (`SECURE_BROWSER_XSS_FILTER = True`)
- Protección de frame embedding (`SECURE_FRAME_DENY = True`)
- django-guardian para permisos granulares a nivel de objeto

### Arquitectura en Capas Identificada:

**Capa de Presentación:**
- Templates: `agora_site/templates/`, `agora_site/agora_core/templates/`
- Static files: `agora_site/static/`
- Forms: `agora_site/agora_core/forms/`, `agora_site/accounts/forms.py`

**Capa de Dominio:**
- Models: `agora_site/agora_core/models/`
- Business Logic: Métodos en modelos y managers
- Voting Systems: `agora_site/agora_core/models/voting_systems/`

**Capa de Infraestructura:**
- API Resources: `agora_site/agora_core/resources/`
- Tasks: `agora_site/agora_core/tasks/` (Celery)
- Backends: `agora_site/agora_core/backends/`

**Capa de Integración:**
- External Apps: `actstream/`, `haystack/`, `userena/`
- Management Commands: `agora_site/agora_core/management/commands/`