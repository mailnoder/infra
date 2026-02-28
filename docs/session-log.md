# 📌 Session Log

## Session 0 — Initial Repo & Git Setup
### 02/16/2026

- Cloned the MailWizz infra repository locally
- Confirmed `origin` remote is set for GitHub
- Created `.gitignore` to exclude:
  - `web/` (MailWizz source)
  - `ssl/` (certificates)
  - `data/` (database volume)
- Confirmed `README.md` remains in root
- Adopted Conventional Commit messages for infra discipline
- Prepared project folder structure for Docker and MailWizz
- Downloaded and installed Docker CLI

---

## Session 1 — Docker Stack Initialization
### 02/17/2026

- Docker-based MailWizz stack initialized locally
- `web/` folder created and prepared for MailWizz source (currently ignored in Git)
- `.gitignore` updated to ensure:
  - `web/` (vendor source)
  - `ssl/` (certificates)
  - `data/` (database volume)
- Docker Compose file created with services:
  - `mailwizz-php`
  - `mailwizz-mysql`
  - `mailwizz-webserver` (Nginx)
  - `mailwizz-mailhog` (for local email testing)
  - Optional: `mailwizz-redis` and `phpmyadmin`
- CLI-first workflow established for building, running, and debugging containers
- Conventional commit messages applied for infra discipline

### How to Start (Optional)

```bash
docker compose up --build -d
docker compose logs -f
docker exec -it mailwizz-php bash
```

---

## Session 2 — First Successful Container Run & Permission Fix
### 02/21/2026

- Resolved Docker daemon permission error (`/var/run/docker.sock`)
- Added Linux user `dadesigns41` to the `docker` group
- Verified Docker daemon access with `docker ps`
- Successfully built and started full MailWizz stack with:
  - `docker compose up --build`
- Confirmed all containers running:
  - `mailwizz-php`
  - `mailwizz-mysql`
  - `mailwizz-webserver`
  - `mailwizz-mailhog`
  - `mailwizz-redis`
  - `mailwizz-phpmyadmin`
- Verified port mappings:
  - MailWizz → `http://localhost:8080`
  - phpMyAdmin → `http://localhost:8081`
  - MailHog → `http://localhost:8025`
- Confirmed MySQL 8.0 initialized successfully and ready for connections
- Established understanding of when to use `docker compose up` vs `--build`
- Confirmed stack lifecycle workflow:
  - First run → `docker compose up --build -d`
  - Normal restart → `docker compose up -d`
  - Stop → `docker compose down`

  ---

## Session 3 — Versioning, Release Strategy & Repo Maturity  
### 02/21/2026

- Confirmed development server running cleanly  
- Evaluated whether to tag repository after stable local build  
- Reviewed Git tagging strategy for infrastructure projects  
- Established semantic versioning awareness (`v1.0.0` discussion)  

- Learned difference between:
  - Git tag  
  - GitHub Release  
  - Regular commit history  

- Determined that first stable running stack qualifies for initial version tag  

- Reviewed commit message discipline:
  - `refactor:` for config restructuring  
  - `chore:` for build/config additions  
  - `docs:` for README or documentation updates  

- Validated `refactor: docker-compose nginx config` as proper Conventional Commit usage  
- Reinforced repo professionalism for portfolio presentation  
