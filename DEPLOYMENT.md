# Deployment Guide

## 1. Local development (SQLite)

```bash
cd backend
python3 -m venv venv
source venv/bin/activate          # Windows: venv\Scripts\activate
pip install -r requirements.txt
cp .env.example .env               # defaults already work for local dev
python manage.py migrate
python manage.py loaddata questions_seed   # loads the 101-question starter bank
python manage.py seed_demo_data            # creates admin@ltoreviewer.local / examinee@ltoreviewer.local
python manage.py runserver 0.0.0.0:8000
```

Visit `http://localhost:8000/admin/` (Django admin) or
`http://localhost:8000/api/docs` (Swagger UI).

## 2. Production deployment (PostgreSQL + Gunicorn + Nginx)

### 2.1 Provision PostgreSQL

```bash
sudo -u postgres createuser lto_reviewer -P
sudo -u postgres createdb lto_reviewer -O lto_reviewer
```

### 2.2 Configure environment

Copy `.env.example` to `.env` on the server and set at minimum:

```
SECRET_KEY=<long random string>
DEBUG=False
ALLOWED_HOSTS=api.yourdomain.com
USE_POSTGRES=True
DB_NAME=lto_reviewer
DB_USER=lto_reviewer
DB_PASSWORD=<the password you set above>
DB_HOST=localhost
DB_PORT=5432
CORS_ALLOW_ALL_ORIGINS=False
CORS_ALLOWED_ORIGINS=https://yourdomain.com
EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend
EMAIL_HOST=smtp.gmail.com
EMAIL_HOST_USER=you@gmail.com
EMAIL_HOST_PASSWORD=<app password>
DEFAULT_FROM_EMAIL=LTO Exam Reviewer <no-reply@yourdomain.com>
FRONTEND_BASE_URL=https://api.yourdomain.com
```

Generate a secret key:

```bash
python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
```

### 2.3 Install, migrate, collect static

```bash
python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
python manage.py migrate
python manage.py loaddata questions_seed   # first deploy only
python manage.py createsuperuser
python manage.py collectstatic --noinput
```

### 2.4 Run with Gunicorn

```bash
gunicorn config.wsgi:application --bind 0.0.0.0:8000 --workers 3
```

A minimal systemd unit (`/etc/systemd/system/lto-reviewer.service`):

```ini
[Unit]
Description=LTO Exam Reviewer API
After=network.target postgresql.service

[Service]
User=www-data
WorkingDirectory=/opt/lto-reviewer/backend
EnvironmentFile=/opt/lto-reviewer/backend/.env
ExecStart=/opt/lto-reviewer/backend/venv/bin/gunicorn config.wsgi:application \
    --bind unix:/run/lto-reviewer.sock --workers 3
Restart=always

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now lto-reviewer
```

### 2.5 Nginx reverse proxy + TLS

```nginx
server {
    listen 80;
    server_name api.yourdomain.com;

    location /static/ {
        alias /opt/lto-reviewer/backend/staticfiles/;
    }
    location /media/ {
        alias /opt/lto-reviewer/backend/media/;
    }
    location / {
        proxy_pass http://unix:/run/lto-reviewer.sock;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Then get a certificate with `certbot --nginx -d api.yourdomain.com`.

### 2.6 Media storage

Uploaded question images are written to `MEDIA_ROOT` (`backend/media/` by
default) and served by Nginx as configured above. For a multi-server or
ephemeral-disk deployment (Heroku, most container platforms), point
Django at S3-compatible storage instead - add `django-storages` and set:

```
STORAGES["default"]["BACKEND"] = "storages.backends.s3.S3Storage"
```

plus the relevant `AWS_*` / bucket environment variables.

## 3. Flutter app

```bash
cd mobile_app
flutter pub get
flutter run --dart-define=API_BASE_URL=https://api.yourdomain.com/api
```

To build release binaries:

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://api.yourdomain.com/api
flutter build ipa --release --dart-define=API_BASE_URL=https://api.yourdomain.com/api
```

See `mobile_app/README.md` for emulator networking notes (why the
default `API_BASE_URL` is `10.0.2.2`, not `localhost`).

## 4. Post-deploy checklist

- [ ] `DEBUG=False` and a real `SECRET_KEY` are set
- [ ] `ALLOWED_HOSTS` / `CORS_ALLOWED_ORIGINS` are locked down to real domains
- [ ] Real SMTP credentials are set (not the console backend) so
      registration/verification/password-reset/exam-completion emails
      actually send
- [ ] HTTPS is enforced (Nginx/TLS as above, or your platform's equivalent)
- [ ] Database backups are configured for PostgreSQL
- [ ] The answer key has been reviewed - see the disclaimer in
      `API_DOCUMENTATION.md` and `answer_key_review_NEEDS_VERIFICATION.csv`
      before treating this as a trustworthy exam prep tool
