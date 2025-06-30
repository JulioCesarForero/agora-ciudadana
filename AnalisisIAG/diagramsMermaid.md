# Diagramas Arquitectónicos en Mermaid.js - Proyecto Django (Agora Ciudadana)

## 1. Diagrama de Componentes

```mermaid
graph TD
    %% OWASP Critical: Django 1.5.5 extremely outdated with known CVEs
    %% OWASP Critical: SECRET_KEY hardcoded in settings.py
    
    subgraph "Agora Ciudadana Platform"
        subgraph "Django Project (agora_site)"
            AC[agora_core<br/>Main Domain Logic]
            ACC[accounts<br/>User Management]
            MISC[misc<br/>Cross-cutting Utilities]
        end
        
        subgraph "External Django Apps"
            AS[actstream<br/>Activity System]
            HS[haystack<br/>Search Engine]
            UN[userena<br/>User Profiles]
        end
        
        subgraph "Infrastructure Services"
            RMQ[RabbitMQ<br/>Message Broker]
            WHOOSH[Whoosh<br/>Search Index]
            SQLITE[(SQLite Database<br/>⚠️ Not suitable for high concurrency)]
            SMTP[SMTP Backend<br/>Email Notifications]
        end
        
        subgraph "API Layer"
            TP[Tastypie v1<br/>REST API Framework]
        end
    end
    
    %% Main Application Dependencies
    AC --> AS
    AC --> HS
    ACC --> UN
    
    %% Infrastructure Connections
    AC --> SQLITE
    AC --> RMQ
    AC --> WHOOSH
    ACC --> SMTP
    
    %% API Connections
    TP --> AC
    TP --> ACC
    
    %% External Service Dependencies
    AS --> SQLITE
    HS --> WHOOSH
    UN --> SQLITE
    
    %% OWASP Security Notes
    AC -.->|"⚠️ Contains hardcoded SECRET_KEY"| MISC
    SQLITE -.->|"⚠️ Scalability Risk"| AC
```

## 2. Diagrama de Despliegue

```mermaid
graph TD
    %% OWASP Critical: DEBUG=True enabled by default
    %% OWASP Critical: Admin interface enabled for production
    
    subgraph "Production Environment"
        subgraph "Web Server Layer"
            WSGI[WSGI Application Django Standard]
            WS[Web Server ⚠️ No specific config found]
        end
        
        subgraph "Application Layer"
            DJ[Django 1.5.5 ⚠️ CRITICAL: Extremely Outdated]
            MIDDLEWARE[Security Middleware CSRF, XSS Protection]
            ADMIN[Django Admin ⚠️ Enabled in Production]
        end
        
        subgraph "Task Processing"
            CELERY[Celery Workers v3.0.12]
            CELERYBR[Celery Beat Scheduled Tasks]
        end
        
        subgraph "Data Layer"
            DB[(SQLite Database ⚠️ Development Only)]
            SEARCH[(Whoosh Index Local File System)]
        end
        
        subgraph "Message Queue"
            RABBIT[RabbitMQ amqp://guest:guest@localhost:5672]
        end
        
        subgraph "Configuration Files"
            SETTINGS[settings.py ⚠️ SECRET_KEY Hardcoded]
            WSGICONF[wsgi.py WSGI Entry Point]
        end
    end
    
    %% Deployment Flow
    WS --> WSGI
    WSGI --> DJ
    DJ --> MIDDLEWARE
    DJ --> ADMIN
    
    %% Task Processing Flow
    DJ --> CELERY
    CELERY --> RABBIT
    CELERYBR --> RABBIT
    
    %% Data Access
    DJ --> DB
    DJ --> SEARCH
    CELERY --> DB
    
    %% Configuration
    DJ --> SETTINGS
    WSGI --> WSGICONF
    
    %% Security Vulnerabilities
    SETTINGS -.->|"⚠️ Data Leakage Risk"| DJ
    DB -.->|"⚠️ Concurrency Limitations"| DJ
    ADMIN -.->|"⚠️ Security Risk"| DJ

```

## 3. Diagrama de Flujo de Datos

```mermaid
flowchart TD
    %% OWASP: Secure data handling and validation points
    
    START([HTTP Request]) --> MIDDLEWARE{Django Middleware}
    
    %% Security Layer
    MIDDLEWARE -->|"CSRF Validation"| CSRF{CSRF Check}
    CSRF -->|"Valid"| AUTH{Authentication}
    CSRF -->|"Invalid"| REJECT1[403 Forbidden]
    
    %% Authentication Flow
    AUTH -->|"Authenticated"| PERM{Permission Check}
    AUTH -->|"Anonymous"| ANON[Anonymous Access]
    PERM -->|"Authorized"| VIEW[Django View]
    PERM -->|"Unauthorized"| REJECT2[401/403 Response]
    
    %% Main Processing Flow
    VIEW --> TASTYPIE{Tastypie Resource?}
    TASTYPIE -->|"API Request"| SERIALIZER[Tastypie Serializer<br/>⚠️ Validate Sensitive Data]
    TASTYPIE -->|"Web Request"| FORM[Django Form<br/>⚠️ Clean & Validate Input]
    
    %% Data Validation
    SERIALIZER --> VALIDATE{Data Validation}
    FORM --> VALIDATE
    VALIDATE -->|"Valid"| MODEL[Model Layer]
    VALIDATE -->|"Invalid"| ERROR[Validation Error Response]
    
    %% Database Operations
    MODEL --> ORM[Django ORM]
    ORM --> SQLITE[(SQLite Database<br/>⚠️ Concurrent Access Risk)]
    
    %% Side Effects
    MODEL --> SIGNAL[Django Signals]
    SIGNAL --> CELERY[Celery Task Queue]
    CELERY --> RABBIT[RabbitMQ]
    
    %% Search Integration
    MODEL --> HAYSTACK[Haystack Search]
    HAYSTACK --> WHOOSH[(Whoosh Index)]
    
    %% Activity Tracking
    MODEL --> ACTSTREAM[Activity Stream]
    ACTSTREAM --> SQLITE
    
    %% Response Generation
    SQLITE --> RESPONSE[HTTP Response]
    WHOOSH --> RESPONSE
    ERROR --> RESPONSE
    REJECT1 --> RESPONSE
    REJECT2 --> RESPONSE
    ANON --> VIEW
    
    %% Final Response
    RESPONSE --> END([Client Response])
    
    %% OWASP Security Notes
    VALIDATE -.->|"⚠️ Sanitize for Data Leakage"| MODEL
    SQLITE -.->|"⚠️ No Concurrent Write Protection"| ORM
    SERIALIZER -.->|"⚠️ Prevent Injection Attacks"| VALIDATE
```

## 4. Diagramas de Clases (por app)

### Agora Core

```mermaid
classDiagram
    %% OWASP: Domain models with security considerations

    class User {
        +username: CharField
        +email: EmailField
        +password: CharField
    }

    class Profile {
        +user: OneToOneField
        +short_description: CharField
        +biography: TextField
        +last_activity_read_date: DateTimeField
        +lang_code: CharField
        +email_updates: BooleanField
        +extra: JSONField
        +get_fullname()
        +get_initials()
        +add_to_agora(request, agora_name, agora_id)
        +has_perms(permission_name, user)
        +get_perms(user)
        +count_direct_votes()
    }
    
    class Agora {
        +creator: ForeignKey
        +delegation_election: ForeignKey
        +created_at_date: DateTimeField
        +archived_at_date: DateTimeField
        +name: CharField
        +pretty_name: CharField
        +url: URLField
        +short_description: CharField
        +biography: TextField
        +image_url: URLField
        +is_vote_secret: BooleanField
        +election_type: CharField
        +eligibility: JSONField
        +membership_policy: CharField
        +comments_policy: CharField
        +delegation_policy: CharField
        +members: ManyToManyField
        +admins: ManyToManyField
        +extra_data: JSONField
        +create_name(creator)
        +get_open_elections()
        +has_perms(permission_name, user)
        +get_delegated_vote_for_user(user)
    }
    
    class Election {
        +hash: CharField
        +tiny_hash: CharField
        +uuid: CharField
        +url: CharField
        +agora: ForeignKey
        +creator: ForeignKey
        +electorate: ManyToManyField
        +parent_election: ForeignKey
        +created_at_date: DateTimeField
        +is_vote_secret: BooleanField
        +is_approved: BooleanField
        +comments_policy: CharField
        +voting_starts_at_date: DateTimeField
        +voting_ends_at_date: DateTimeField
        +voting_extended_until_date: DateTimeField
        +result: TextField
        +pretty_name: CharField
        +name: CharField
        +short_description: CharField
        +description: TextField
        +questions: JSONField
        +delegated_votes: ManyToManyField
        +election_type: CharField
        +eligibility: JSONField
        +extra_data: JSONField
        +get_serializable_data()
        +create_hash()
        +has_started()
        +has_ended()
        +is_archived()
        +is_frozen()
        +is_tallied()
        +has_perms(permission_name, user)
        +compute_result()
    }
    
    class CastVote {
        +voter: ForeignKey
        +election: ForeignKey
        +created_at_date: DateTimeField
        +is_direct: BooleanField
        +is_counted: BooleanField
        +invalidated_at_date: DateTimeField
        +data: TextField
        +casted_at_date: DateTimeField
        +hash: CharField
        +tiny_hash: CharField
        +voter_secret: CharField
        +get_serializable_data()
        +create_hash()
        +has_perms(permission_name, user)
    }
    
    class DelegateElectionCount {
        +election: ForeignKey
        +delegate: ForeignKey
        +count: IntegerField
        +count_percentage: FloatField
        +created_at_date: DateTimeField
    }
    
    %% Relationships
    Profile --|> User : "extends"
    Agora "1" o-- "*" Election : "contains"
    Election "1" o-- "*" CastVote : "receives"
    Election "1" o-- "*" DelegateElectionCount : "tracks"
    Profile "*" -- "*" Agora : "member of"
    Profile "*" -- "*" Agora : "admin of"
    CastVote "*" --> "1" Profile : "cast by"
```

### Voting Systems (Strategy Pattern)

```mermaid
classDiagram
    %% Strategy Pattern for Voting Methods
    
    class BaseVotingSystem {
        <<abstract>>
        +get_id()
        +get_description()
        +create_answer_set(question)
        +validate_answer_set(question, answer_set)
        +compute_result(question, answers)
    }
    
    class Plurality {
        +get_id()
        +get_description()
        +create_answer_set(question)
        +validate_answer_set(question, answer_set)
        +compute_result(question, answers)
    }
    
    class MeekSTV {
        +get_id()
        +get_description()
        +create_answer_set(question)
        +validate_answer_set(question, answer_set)
        +compute_result(question, answers)
    }
    
    class WrightSTV {
        +get_id()
        +get_description()
        +create_answer_set(question)
        +validate_answer_set(question, answer_set)
        +compute_result(question, answers)
    }
    
    class BaseSTV {
        <<abstract>>
        +create_answer_set(question)
        +validate_answer_set(question, answer_set)
        +compute_result(question, answers)
    }
    
    class JSONReport {
        +generate_report(results)
        +format_output(data)
    }
    
    %% Strategy Pattern Relationships
    BaseVotingSystem <|-- Plurality
    BaseVotingSystem <|-- BaseSTV
    BaseSTV <|-- MeekSTV
    BaseSTV <|-- WrightSTV
    
    %% Utility Relationship
    MeekSTV --> JSONReport : "uses"
    WrightSTV --> JSONReport : "uses"
    
    %% Connection to Election
    Election --> BaseVotingSystem : "uses strategy"
```

### Accounts

```mermaid
classDiagram
    %% User Management and Authentication

    class User {
        +username: CharField
        +email: EmailField
        +password: CharField
    }

    class Profile {
        +user: OneToOneField
        +biography: TextField
    }

    class AccountSignupForm {
        +clean_username()
        +clean_password2()
        +save()
    }
    
    class AcccountAuthForm {
        +clean()
        +check_for_test_cookie()
    }
    
    class AccountPasswordResetForm {
        +clean_email()
        +save()
    }
    
    class AccountSetPasswordForm {
        +clean_password2()
        +save()
    }
    
    class UserView {
        +get_context_data()
        +get_object()
    }
    
    class SignUpCompleteView {
        +get_context_data()
    }
    
    class PasswordResetDoneView {
        +get_context_data()
    }

    %% Django Auth Integration
    User "1" -- "1" Profile : "has profile"
    
    %% Form Relationships
    AccountSignupForm --> User : "creates"
    AcccountAuthForm --> User : "authenticates"
    AccountPasswordResetForm --> User : "resets password"
    AccountSetPasswordForm --> User : "sets password"
    
    %% View Relationships
    UserView --> User : "displays"
    SignUpCompleteView --> User : "confirms signup"
    
    %% OWASP Security Notes
    AcccountAuthForm : ⚠️ Implement brute force protection
    AccountPasswordResetForm : ⚠️ Secure token generation
    User : ⚠️ Validate input sanitization

```

## 5. Diagrama de Paquetes

```mermaid
graph TD
    %% OWASP: Package dependencies and security boundaries
    
    subgraph "Django Project Structure"
        subgraph "agora_site (Main Package)"
            subgraph "agora_core (Domain Logic)"
                MODELS[models/<br/>Domain Entities]
                RESOURCES[resources/<br/>API Layer]
                FORMS[forms/<br/>Validation Layer]
                TASKS[tasks/<br/>Async Processing]
                TESTS[tests/<br/>Testing Suite]
                MGMT[management/<br/>CLI Commands]
                BACKENDS[backends/<br/>Auth Backends]
                TEMPLATES[templates/<br/>Presentation]
                VOTING[models/voting_systems/<br/>Strategy Pattern]
            end
            
            subgraph "accounts (User Management)"
                ACC_FORMS[forms.py<br/>Auth Forms]
                ACC_VIEWS[views.py<br/>Auth Views]
                ACC_URLS[urls.py<br/>Auth Routes]
                ACC_TEMPLATES[templates/<br/>Auth UI]
            end
            
            subgraph "misc (Utilities)"
                UTILS[utils.py<br/>Helper Functions]
                DECORATORS[decorators.py<br/>Security Decorators]
                CONTEXT[context_processor.py<br/>Global Context]
                GENERIC[generic_resource.py<br/>Base Classes]
            end
            
            SETTINGS[settings.py<br/>⚠️ Contains SECRET_KEY]
            URLS[urls.py<br/>Main Routing]
            WSGI[wsgi.py<br/>WSGI Entry]
        end
        
        subgraph "External Apps (Integrated)"
            ACTSTREAM[actstream/<br/>Activity Tracking]
            HAYSTACK[haystack/<br/>Search Engine]
            USERENA[userena/<br/>Profile Management]
        end
        
        subgraph "Static Assets"
            STATIC[static/<br/>CSS, JS, Images]
            MEDIA[media/<br/>User Uploads]
        end
        
        subgraph "Infrastructure"
            DOCS[docs/<br/>Documentation]
            LOCALE[locale/<br/>Internationalization]
        end
    end
    
    %% Dependencies between main packages
    MODELS --> VOTING
    RESOURCES --> MODELS
    FORMS --> MODELS
    TESTS --> MODELS
    TESTS --> FORMS
    TESTS --> RESOURCES
    
    %% Cross-app dependencies
    MODELS --> ACTSTREAM
    RESOURCES --> HAYSTACK
    MODELS --> USERENA
    
    %% Accounts dependencies
    ACC_FORMS --> USERENA
    ACC_VIEWS --> ACC_FORMS
    ACC_URLS --> ACC_VIEWS
    
    %% Utilities dependencies
    DECORATORS --> MODELS
    CONTEXT --> SETTINGS
    GENERIC --> RESOURCES
    
    %% Configuration dependencies
    SETTINGS --> MODELS
    SETTINGS --> TASKS
    URLS --> ACC_URLS
    WSGI --> SETTINGS
    
    %% External app dependencies
    ACTSTREAM --> MODELS
    HAYSTACK --> MODELS
    USERENA --> MODELS
    
    %% OWASP Security Boundaries
    SETTINGS -.->|"⚠️ Security Configuration"| MODELS
    DECORATORS -.->|"⚠️ Authorization Layer"| RESOURCES
    BACKENDS -.->|"⚠️ Authentication Layer"| ACC_VIEWS
    
    %% Template Security
    TEMPLATES -.->|"⚠️ XSS Protection Required"| STATIC
    ACC_TEMPLATES -.->|"⚠️ CSRF Protection"| ACC_FORMS
```

## Notas de Seguridad OWASP Top 10

### Vulnerabilidades Críticas Identificadas:

1. **Data Leakage (Clasificación Alta)**
   - SECRET_KEY hardcodeada en `settings.py`
   - DEBUG=True habilitado por defecto
   - Configuración de admin habilitada para producción

2. **Insecure Plugins (Clasificación Alta)**
   - Django 1.5.5: Versión extremadamente obsoleta con CVEs conocidos
   - Dependencias sin versionado específico en `requirements.txt`
   - Backend FNMT personalizado con configuración no validada

3. **Riesgos de Escalabilidad y Concurrencia**
   - SQLite inadecuada para entornos de alta concurrencia
   - Sin configuración de cache habilitada
   - Sin balanceadores de carga configurados

### Recomendaciones de Mitigación:

- Actualizar Django a versión LTS soportada
- Externalizar SECRET_KEY a variables de entorno
- Migrar de SQLite a PostgreSQL para producción
- Implementar configuración adecuada de cache
- Revisar y actualizar todas las dependencias
- Deshabilitar admin interface en producción
- Configurar logging y monitoreo de seguridad 