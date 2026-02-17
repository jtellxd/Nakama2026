web: python manage.py migrate --noinput && (python manage.py collectstatic --noinput || true) && gunicorn control_asistencia.wsgi --bind 0.0.0.0:$PORT
