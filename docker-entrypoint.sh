#!/bin/bash
set -e

# Esperar a que la base de datos esté lista
echo "Waiting for database..."
while ! nc -z rabbitmq 5672; do
  sleep 0.1
done
echo "Database is ready!"

# Asegurar que los directorios necesarios existen
mkdir -p /app/agora_site/media/data
mkdir -p /app/data

# Asegurar que la base de datos SQLite existe y tiene los permisos correctos
touch /app/data/db.sqlite
chmod 777 /app/data/db.sqlite

# Descargar la base de datos GeoIP si no existe
if [ ! -f /app/agora_site/media/data/GeoLiteCity.dat ]; then
    echo "Downloading GeoIP database..."
    cd /app/agora_site/media/data
    wget -q "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=YOUR_LICENSE_KEY&suffix=tar.gz" -O GeoLite2-City.tar.gz || true
    if [ -f GeoLite2-City.tar.gz ]; then
        tar xzf GeoLite2-City.tar.gz
        mv GeoLite2-City_*/GeoLite2-City.mmdb GeoLiteCity.dat
        rm -rf GeoLite2-City_* GeoLite2-City.tar.gz
    else
        echo "Warning: Could not download GeoIP database. Geolocation features will be disabled."
        touch /app/agora_site/media/data/GeoLiteCity.dat
    fi
fi

# Asegurar que estamos en el directorio correcto
cd /app

# Inicializar la base de datos si es necesario
if [ ! -s /app/data/db.sqlite ]; then
    echo "Initializing database..."
    python manage.py syncdb --all --noinput || true
    python manage.py migrate --fake || true
    python manage.py rebuild_index --noinput || true
    python manage.py check_permissions || true
    python manage.py compilemessages || true
fi

# Iniciar Celery en segundo plano
celery -A agora_site worker -l info -B -S djcelery.schedulers.DatabaseScheduler &

# Ejecutar el comando principal
exec "$@" 