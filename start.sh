#!/bin/bash
set -e

echo "=== Starting Django Application ==="
echo "PORT: ${PORT:-8000}"
echo "DATABASE_URL exists: $([ -n "$DATABASE_URL" ] && echo 'yes' || echo 'no')"

# Run migrations
echo "=== Running migrations ==="
python manage.py migrate --noinput

# Start gunicorn
echo "=== Starting Gunicorn ==="
exec gunicorn control_asistencia.wsgi:application \
    --bind 0.0.0.0:${PORT:-8000} \
    --workers 2 \
    --timeout 120 \
    --log-level info \
    --access-logfile - \
    --error-logfile -
