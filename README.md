# MailWizz Infrastructure Stack

This repository contains a local-first Docker environment for running MailWizz with a production-minded structure. It is built to make the stack understandable, reproducible, and easy to iterate on while keeping the infrastructure concerns separate from the application runtime.

The current setup focuses on:

- Running MailWizz behind Nginx and PHP-FPM
- Keeping MySQL data persistent with Docker volumes
- Supporting Redis, MailHog, and phpMyAdmin for development
- Bootstrapping MailWizz runtime directories automatically
- Running MailWizz cron jobs inside the PHP container
- Documenting the workflow as the project evolves

## Stack Overview

The Docker Compose stack currently includes:

- `mailwizz-webserver`: Nginx entrypoint for the app on `http://localhost:8080`
- `mailwizz-php`: custom PHP 8.3 FPM image for MailWizz
- `mailwizz-mysql`: MySQL 8.0 with a named Docker volume
- `mailwizz-redis`: Redis 7 for caching/session-related experimentation
- `mailwizz-mailhog`: local SMTP capture and message viewer
- `mailwizz-phpmyadmin`: database UI on `http://localhost:8081`

Mail flow in development:

```text
Browser -> Nginx -> PHP-FPM -> MySQL
                         |
                         -> Redis
                         -> Cron jobs

MailWizz -> MailHog
```

## Repository Layout

```text
.
├── Dockerfile
├── docker-compose.yml
├── start.sh
├── mwcron
├── nginx/
│   └── nginx.conf
├── docs/
│   ├── development.md
│   └── session-log.md
└── web/
    └── MailWizz application files
```

## How This Repo Works

`Dockerfile` builds the PHP-FPM container and installs the PHP extensions MailWizz needs.

`start.sh` prepares required writable runtime paths inside `/var/www/web`, starts cron, and then launches PHP-FPM in the foreground.

`mwcron` defines the MailWizz scheduled tasks such as queue processing, campaign sending, bounce handling, and daily/hourly jobs.

`nginx/nginx.conf` routes requests to the proper MailWizz entrypoints and forwards PHP execution to the `mailwizz-php` service.

## Local Development

Start the stack with:

```bash
docker compose up --build -d
```

Useful URLs:

- MailWizz: `http://localhost:8080`
- MailWizz installer: `http://localhost:8080/install/`
- phpMyAdmin: `http://localhost:8081`
- MailHog: `http://localhost:8025`

Default database settings in the current compose file:

- Host: `mailwizz-mysql`
- Database: `mailwizz`
- Username: `mailwizz`
- Password: `mailwizzpassword`

If you are installing MailWizz for the first time, use those values in the installer.

## Runtime Notes

This stack is optimized for local iteration rather than hardened production deployment.

- Nginx is exposed on port `8080`, not `80`
- SSL is not enabled in the current local config
- Mail is routed to MailHog instead of a real provider
- Cron runs inside the PHP container instead of a dedicated worker container
- MySQL and Redis persist through named Docker volumes

The PHP startup script also creates the writable MailWizz directories that commonly break fresh installs:

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

## Project Direction

The project started as a self-hosted infrastructure exercise and has evolved into a working development stack. The main goal is still the same: build MailWizz in a way that is understandable, deliberate, and documented instead of treating deployment like a black box.

Current emphasis:

- Clean container boundaries
- Repeatable local setup
- Clear service roles
- Persistent state where it matters
- Documentation alongside implementation

## Documentation

Additional project notes live here:

- [docs/development.md](/home/dadesigns41/mailwizz-test/mailwizz-infra-stack/docs/development.md)
- [docs/session-log.md](/home/dadesigns41/mailwizz-test/mailwizz-infra-stack/docs/session-log.md)

## Next Improvements

The README now reflects the current repo, but the stack still has room to grow:

- Move credentials out of `docker-compose.yml` into environment files
- Add health checks for core services
- Separate development and production configuration
- Add backup and restore scripts
- Introduce a production-ready SSL and reverse proxy strategy
- Decide whether MailWizz source should remain vendored here or be managed separately
