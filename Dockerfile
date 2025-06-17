FROM python:2.7-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV DJANGO_SETTINGS_MODULE=agora_site.settings
ENV PYTHONIOENCODING=utf-8
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Instala solo lo necesario
RUN apt-get update && apt-get install -y --no-install-recommends \
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
    netcat-traditional \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

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
