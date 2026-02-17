FROM python:3.11-slim

WORKDIR /app

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Dependencias del sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 libjpeg62-turbo zlib1g bash \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Hacer ejecutable el script de inicio
RUN chmod +x start.sh

# Collectstatic en build
RUN DATABASE_URL= SECRET_KEY=build python manage.py collectstatic --noinput --no-color 2>/dev/null || true

# Usar el script de inicio
CMD ["./start.sh"]
