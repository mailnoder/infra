# MailNoder Infrastructure

Production-ready container infrastructure for the MailNoder platform. This repository contains the Docker runtime stack that runs the MailNoder application, built on top of MailWizz as an upstream base with custom modifications.

## Overview

This repository provides a clean, repeatable way to run MailNoder both locally for development and in production. It implements infrastructure best practices specifically tuned for the requirements of this platform.

### Architecture

- **Nginx** as reverse proxy / web server
- **PHP 8.3 FPM** running application code and cron jobs
- **MySQL 8.0** with persistent storage
- **Redis** for cache and session handling
- Optional development tools: MailHog, phpMyAdmin

All runtime services run as isolated Docker containers with proper dependency ordering, health checks, and volume isolation for persistent state.

---

## Repository Responsibilities

This repository owns:
- Container build definitions and startup behavior
- Nginx configurations for development and production
- Database and cache service wiring
- Cron scheduling and runtime initialization
- Volume management for persistent application state
- Production deployment configuration
- Environment separation between development and production

This is the infrastructure layer. Application source code and custom modifications live in the separate `platform` repository.

---

## Environments

### Development

The development stack is built around fast local iteration:

| Service | URL | Purpose |
|---------|-----|---------|
| MailNoder | `http://localhost:8080` | Application |
| phpMyAdmin | `http://localhost:8081` | Database administration |
| MailHog | `http://localhost:8025` | Local email capture |

All application source is bind mounted into the container for live editing without rebuilds.

### Production

The production stack is minimal and hardened:
- No development tools or debug ports exposed
- Application baked into container images (no bind mounts)
- Proper volume isolation for all writable directories
- Health checks with ordered service startup
- Environment variables for all runtime configuration
- Nginx Proxy Manager integration for SSL and domain handling

---

## Repository Layout

```text
.
├── Dockerfile                  # PHP-FPM application container
├── Dockerfile.nginx            # Nginx web server container
├── docker-compose.dev.yml      # Full local development stack
├── docker-compose.prod.yml     # Production deployment stack
├── .env.prod.example           # Production environment template
├── start.sh                    # Container entrypoint and runtime initialization
├── mwcron                      # Application cron schedule
├── nginx/
│   ├── nginx.conf              # Development Nginx config
│   └── nginx.prod.conf         # Production hardened Nginx config
└── web/
    └── MailNoder application (imported from platform repository)
```

---

## Local Development

First ensure you have the MailNoder platform source present in `./web`:

```bash
# Clone platform repository
git clone https://github.com/mailnoder/platform.git web
```

Start the full development stack:
```bash
docker compose -f docker-compose.dev.yml up --build -d
```

**Common commands:**
```bash
# Start stack
docker compose -f docker-compose.dev.yml up -d

# Stop stack
docker compose -f docker-compose.dev.yml down

# View logs
docker compose -f docker-compose.dev.yml logs -f

# Enter application container
docker compose -f docker-compose.dev.yml exec mailwizz-php bash
```

**Installer Database Settings:**
| Setting | Value |
|---------|-------|
| Host | `mailwizz-mysql` |
| Database | `mailwizz` |
| Username | `mailwizz` |
| Password | `mailwizzpassword` |

---

## Production Deployment

Create your production environment file from the example:
```bash
cp .env.prod.example .env.prod
```

Edit `.env.prod` and configure your database credentials, timezone, and application source path.

Start the production stack:
```bash
docker compose --env-file .env.prod -f docker-compose.prod.yml up --build -d
```

Production configuration variables:
- `MYSQL_ROOT_PASSWORD`
- `MYSQL_DATABASE`
- `MYSQL_USER`
- `MYSQL_PASSWORD`
- `MAILWIZZ_APP_PATH`
- `MAILWIZZ_HTTP_PORT`
- `TZ`

---

## Runtime Behavior

On container startup `start.sh` will:
1. Verify application source is present
2. Create all required runtime directories
3. Set correct permissions for writable paths
4. Start cron daemon
5. Launch PHP-FPM

Cron runs inside the PHP container so scheduled tasks execute in the exact same environment as the web application with shared filesystem access.

The following paths are configured as persistent named volumes:
- User uploaded files
- Generated asset cache
- Application configuration
- Runtime data and mutex locks
- Extensions and customizations
- Database and Redis storage

---

## Upstream Relationship

MailNoder is built on top of MailWizz as a stable upstream base. This infrastructure repository is designed to support clean upgrade paths while preserving all custom modifications and platform extensions.

### Key Design Decisions:
- Infrastructure and application source are stored in separate repositories
- Upstream updates flow through the platform repository
- Infrastructure remains generic and reusable across application versions
- Volume layout ensures customizations survive container rebuilds and upstream upgrades
- No upstream code is tracked in this repository

---

## Project Status

✅ **Production Ready**

This infrastructure has been fully validated and deployed. It correctly solves almost every common deployment pitfall that people encounter when running this class of application in containers.

---

## Documentation

- [Session Log](/docs/session-log.md) - Full development history and decision records