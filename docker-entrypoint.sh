#!/usr/bin/env bash
set -eo pipefail        # aborta en errores, pero los controlamos puntualmente

# ------------------- 1. Esperar a RabbitMQ -------------------
echo "Waiting for RabbitMQ..."
while ! nc -z rabbitmq 5672; do sleep 0.3; done
echo "RabbitMQ is ready!"

# ------------------- 2. Directorios y permisos ----------------
mkdir -p /app/agora_site/media/data
mkdir -p /app/data

touch /app/data/db.sqlite
chmod 777 /app/data/db.sqlite    # SQLite sólo para desarrollo

# ------------------- 3. GeoIP (opcional) ----------------------
GEOIP_FILE=/app/agora_site/media/data/GeoLiteCity.dat
if [ ! -f "$GEOIP_FILE" ]; then
  if [ -n "${MAXMIND_KEY:-}" ]; then
    echo "Downloading GeoIP database from MaxMind..."
    cd /app/agora_site/media/data

    TMP_ARCHIVE=$(mktemp)
    # Descarga — si falla, continuamos
    if curl -fsSL \
        "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=${MAXMIND_KEY}&suffix=tar.gz" \
        -o "$TMP_ARCHIVE"; then

      # Intenta extraer el .mmdb
      if tar -xzf "$TMP_ARCHIVE" --wildcards --no-anchored '*.mmdb' --strip-components=1; then
        mv *.mmdb "$GEOIP_FILE"
        echo "GeoIP database ready."
      else
        echo "⚠️  El archivo descargado no se pudo descomprimir correctamente. Continuaré sin GeoIP."
        touch "$GEOIP_FILE"
      fi
    else
      echo "⚠️  Falló la descarga de GeoIP (¿clave incorrecta?). Continuaré sin GeoIP."
      touch "$GEOIP_FILE"
    fi
    rm -f "$TMP_ARCHIVE"
  else
    echo "MAXMIND_KEY no definido; se omite la descarga de GeoIP."
    touch "$GEOIP_FILE"
  fi
fi

# ------------------- 4. Migraciones iniciales -----------------
cd /app
if [ ! -s /app/data/db.sqlite ]; then
  echo "Initializing database..."
  python manage.py syncdb --all --noinput || true
  python manage.py migrate --fake || true
  python manage.py rebuild_index --noinput || true
  python manage.py check_permissions || true
  python manage.py compilemessages || true
fi

# ------------------- 5. Arrancar Celery -----------------------
celery -A agora_site worker -l info -B -S djcelery.schedulers.DatabaseScheduler &

# ------------------- 6. Ejecutar comando principal ------------
exec "$@"