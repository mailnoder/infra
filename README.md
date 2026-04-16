# MailWizz Infra

This repository is the Docker-based runtime for this MailWizz project. Its job is to give us a clear, repeatable way to run MailWizz locally for development and with a leaner compose file for production-style deployment.

The flow of the project is simple:

1. Keep the MailWizz application in `./web`
2. Start the stack with Docker Compose
3. Reach MailWizz through Nginx
4. Let the PHP container handle both PHP-FPM and MailWizz cron jobs

## What This Repo Owns

- Container build and startup behavior
- Nginx config for dev and production
- MySQL and Redis service wiring
- Local mail capture with MailHog in development
- phpMyAdmin access in development
- MailWizz cron scheduling inside the PHP container

This repo is the infrastructure layer that gets the app running consistently.

## Project Flow

### Development

In development, the stack is built around fast local iteration:

- `mailwizz-webserver` serves the app on `http://localhost:8080`
- `mailwizz-php` runs PHP-FPM and cron
- `mailwizz-mysql` stores MailWizz data in a named Docker volume
- `mailwizz-redis` is available for cache/session-related usage
- `mailwizz-mailhog` captures outbound mail locally
- `mailwizz-phpmyadmin` provides database access on `http://localhost:8081`

Mail flow in dev:

```text
Browser -> Nginx -> PHP-FPM -> MySQL
                         |
                         -> Redis
                         -> Cron jobs

MailWizz -> MailHog
```

### Production

The production compose file keeps the stack smaller:

- Nginx
- PHP-FPM
- MySQL
- Redis

It removes development-only services and reads runtime settings from `.env.prod`.

## Repository Layout

```text
.
├── Dockerfile
├── docker-compose.dev.yml
├── docker-compose.prod.yml
├── .env.prod.example
├── start.sh
├── mwcron
├── nginx/
│   ├── nginx.conf
│   └── nginx.prod.conf
├── docs/
│   └── session-log.md
└── web/
    └── MailWizz application files
```

## Key Files

- `Dockerfile`: builds the PHP 8.3 FPM container and installs the PHP extensions MailWizz needs
- `start.sh`: checks that the app exists, creates writable MailWizz runtime directories, starts cron, and launches PHP-FPM
- `mwcron`: schedules the MailWizz console jobs
- `docker-compose.dev.yml`: full local stack with MailHog and phpMyAdmin
- `docker-compose.prod.yml`: slimmer production-style stack with health checks
- `nginx/nginx.conf`: local Nginx config with dev-friendly PHP error display
- `nginx/nginx.prod.conf`: production Nginx config with stricter headers and no debug PHP value override

## Local Setup

Make sure the MailWizz application is present in `./web`, then start the development stack:

```bash
docker compose -f docker-compose.dev.yml up --build -d
```

Useful URLs:

- MailWizz: `http://localhost:8080`
- Installer: `http://localhost:8080/install/`
- phpMyAdmin: `http://localhost:8081`
- MailHog: `http://localhost:8025`

Production notes:

- `docker-compose.prod.yml` now bakes the app code into the PHP image and uses a shared named volume for `/var/www/web`.
- This avoids empty host volume overlays and gives a more production-like build experience.

Default database settings for the installer:

- Host: `mailwizz-mysql`
- Database: `mailwizz`
- Username: `mailwizz`
- Password: `mailwizzpassword`

Common lifecycle commands:

```bash
docker compose -f docker-compose.dev.yml up -d
docker compose -f docker-compose.dev.yml down
docker compose -f docker-compose.dev.yml logs -f
```

## Runtime Behavior

On container startup, `start.sh` creates the writable directories MailWizz commonly expects, including:

- `apps/extensions`
- `apps/common/config`
- `apps/common/runtime`
- `apps/common/runtime/mutex`
- `backend/assets/cache`
- `customer/assets/cache`
- `customer/assets/files`
- `frontend/assets/cache`
- `frontend/assets/files`
- `frontend/assets/gallery`

Cron also starts inside the PHP container, so scheduled MailWizz console tasks run without needing a separate worker service.

## Production-Style Run

Create your production env file from the example:

```bash
cp .env.prod.example .env.prod
```

Then start the production compose stack:

```bash
docker compose --env-file .env.prod -f docker-compose.prod.yml up --build -d
```

`.env.prod.example` includes:

- `MYSQL_ROOT_PASSWORD`
- `MYSQL_DATABASE`
- `MYSQL_USER`
- `MYSQL_PASSWORD`
- `MAILWIZZ_APP_PATH`
- `MAILWIZZ_HTTP_PORT`
- `TZ`

## Notes

- Development maps Nginx to port `8080` instead of `80`
- Development mail is routed to MailHog, not a real provider
- MySQL and Redis data persist through named Docker volumes
- Production mounts the app path from `MAILWIZZ_APP_PATH`
- Production Nginx serves the app read-only from the host mount

## Documentation

- Session notes live in [docs/session-log.md](/home/dadesigns41/Downloads/mailwizz-infra-work/infra/docs/session-log.md)