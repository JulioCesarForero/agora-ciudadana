# Ejecutar Pruebas en Deploy con Docker

Este documento explica cómo integrar las pruebas de agora en el proceso de deploy usando Docker.

## Opciones Disponibles

### Opción 1: Variable de Entorno (Recomendada) ⭐

**Ventajas**: Flexible, fácil de controlar, no afecta deploy normal
**Desventajas**: Las pruebas se ejecutan en runtime, no en build time

#### Uso:

```bash
# Deploy normal (sin pruebas)
docker-compose up

# Deploy con pruebas
RUN_TESTS=true docker-compose up

# O definir la variable en docker-compose:
# environment:
#   - RUN_TESTS=true
```

### Opción 2: Servicio Separado

**Ventajas**: Aislamiento completo, logs separados
**Desventajas**: Requiere modificar docker-compose.yml

#### Uso:

```bash
# Ejecutar solo las pruebas
docker-compose up tests

# Deploy completo (incluye pruebas automáticamente)
docker-compose up
```

### Opción 3: Multi-stage Dockerfile

**Ventajas**: Pruebas en build time, falla rápido si hay errores
**Desventajas**: Requiere rebuild completo para cada cambio

#### Uso:

```bash
# Build solo el stage de testing
docker build --target testing -t agora-tests .

# Build completo (incluye testing automáticamente)
docker build --target production -t agora-prod .
```

## Scripts Auxiliares

### Ejecutar Pruebas Localmente

```bash
# Hacer el script ejecutable
chmod +x run-agora-tests.sh

# Ejecutar
./run-agora-tests.sh
```

### Ejecutar en Contenedor

```bash
# Opción 1: Usando docker run
docker run --rm -v $(pwd):/app agora-tests ./run-agora-tests.sh

# Opción 2: Usando docker exec (si el contenedor está corriendo)
docker exec agora-container ./run-agora-tests.sh
```

## Configuración de CI/CD

### GitHub Actions
```yaml
name: Test and Deploy
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Run tests
      run: |
        docker build --target testing -t agora-tests .
    
  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
    - name: Deploy
      run: |
        docker-compose up -d
```

### GitLab CI
```yaml
stages:
  - test
  - deploy

test:
  stage: test
  script:
    - docker build --target testing -t agora-tests .

deploy:
  stage: deploy
  script:
    - RUN_TESTS=true docker-compose up -d
  only:
    - main
```

## Recomendaciones

1. **Para desarrollo**: Usa la **Opción 1** con `RUN_TESTS=true`
2. **Para CI/CD**: Usa la **Opción 3** (multi-stage) para fallar rápido
3. **Para producción**: Usa la **Opción 1** sin `RUN_TESTS` (deploy rápido)

## Troubleshooting

### Error de dependencias
```bash
# Asegúrate de que las dependencias estén instaladas
docker-compose exec web pip install -r requirements.txt
```

### Error de base de datos
```bash
# Las pruebas usan SQLite, asegúrate que test_settings.py esté configurado
docker-compose exec web python manage.py migrate --settings=agora_site.test_settings
```

### Logs detallados
```bash
# Ver logs de pruebas con más detalle
docker-compose logs tests
``` 