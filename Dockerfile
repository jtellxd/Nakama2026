# Build: solo instala dependencias. No ejecuta Django → no necesita SECRET_KEY.
# SECRET_KEY y DATABASE_URL se usan solo al arrancar (runtime).
FROM python:3.13-slim

WORKDIR /app

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Dependencias: psycopg2 + Pillow (libjpeg, zlib)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 libjpeg62-turbo zlib1g \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt gunicorn

COPY . .

# Collectstatic en build (solo para esta línea: sin DATABASE_URL usa SQLite) → arranque más rápido en runtime.
RUN DATABASE_URL= SECRET_KEY=build python manage.py collectstatic --noinput --no-color 2>/dev/null || true

# Railway inyecta PORT dinamicamente
CMD python manage.py migrate --noinput && gunicorn control_asistencia.wsgi:application --bind 0.0.0.0:${PORT:-8000} --workers 2 --timeout 120 --log-level info
