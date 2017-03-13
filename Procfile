web: gunicorn -b 0.0.0.0:$PORT smueats_backend.wsgi
celery_beat: celery -A smueats_backend beat -l info
celery_worker: celery -A smueats_backend worker --loglevel=info
