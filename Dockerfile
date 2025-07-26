# ---- Imagen base (EOL) ----
    FROM python:2.7-slim

    # ---- Configuración de entorno ----
    ENV DEBIAN_FRONTEND=noninteractive \
        PYTHONUNBUFFERED=1 \
        PYTHONDONTWRITEBYTECODE=1 \
        DJANGO_SETTINGS_MODULE=agora_site.settings \
        PYTHONIOENCODING=utf-8 \
        LANG=C.UTF-8 \
        LC_ALL=C.UTF-8
    
    # ---- Repos históricos + firmas caducas ----
    # 1. Cambia mirrors a archive.debian.org
    # 2. Añade un archivo de configuración que desactive la verificación de vigencia
    # 3. Usa la opción -o Acquire::Check-Valid-Until=false en apt-get
    RUN set -eux; \
        sed -i 's|deb.debian.org/debian|archive.debian.org/debian|g' /etc/apt/sources.list && \
        sed -i 's|security.debian.org|archive.debian.org|g' /etc/apt/sources.list && \
        echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99ignore-valid-until && \
        apt-get -o Acquire::Check-Valid-Until=false update && \
        apt-get -o Acquire::Check-Valid-Until=false install -y --no-install-recommends \
            git \
            gettext \
            build-essential \
            libxml2-dev \
            libxslt1-dev \
            libjpeg-dev \
            zlib1g-dev \
            libfreetype6-dev \
            uuid-dev \
            curl \
            wget \
            sqlite3 \
            locales \
            netcat-traditional && \
        rm -rf /var/lib/apt/lists/* && \
        localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
    
# Crea directorio de trabajo
WORKDIR /app

# Copia requirements primero para aprovechar la caché de Docker
COPY requirements.txt /app/

# Instala requirements con pip ya preinstalado
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copia el script de inicialización
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Copia el resto del código
COPY . /app/

# Crea directorios necesarios
RUN mkdir -p /app/agora_site/media/data \
    && mkdir -p /app/data \
    && touch /app/data/db.sqlite \
    && chmod 777 /app/data/db.sqlite

EXPOSE 8000

# Usa el script de inicialización
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
