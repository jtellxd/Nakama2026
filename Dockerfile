# Build: solo instala dependencias. No ejecuta Django → no necesita SECRET_KEY.
# SECRET_KEY y DATABASE_URL se usan solo al arrancar (runtime).
FROM python:3.13-slim

WORKDIR /app

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Dependencias del sistema para psycopg2
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt gunicorn

COPY . .

# No ejecutamos migrate/collectstatic aquí; se hacen al arrancar con las variables ya disponibles.
EXPOSE 8000
CMD python manage.py migrate --noinput && \
    python manage.py collectstatic --noinput && \
    gunicorn control_asistencia.wsgi --bind 0.0.0.0:${PORT:-8000}
