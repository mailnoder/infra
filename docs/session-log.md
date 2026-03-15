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

---

## Session 4 — Local Stack Stabilization & First Runtime Fixes  
### 02/27/2026  

- Brought MailWizz stack up using `docker compose up -d`  
- Verified MySQL container initialization:
  - Database `mailwizz` created  
  - User `mailwizz` created and granted schema access  
- Confirmed containers running without fatal errors  

- Identified installer warning:
  - `/var/www/web/apps/extensions` directory missing  
  - Application required writable permissions  

- Diagnosed root cause:
  - Directory did not exist inside container  
  - Not a permission issue — structural issue  

- Created missing directory manually (`mkdir extensions`)  
- Ensured correct write permissions for web server process  

- Reinforced lesson:
  - Application runtime errors often stem from missing filesystem expectations  
  - Containerized apps still require correct internal directory structure  

- Confirmed development instance progressing toward clean install state  
- Continued building production-ready discipline even in local dev environment

---

## Session 5 — Installation Persistence, Runtime Awareness & Source Ownership  
### 03/12/2026  

- Restarted MailWizz stack and verified application remained installed after `docker compose down` / `up`  
- Confirmed installation state persists because configuration and data are stored in the MySQL database rather than the filesystem  

- Investigated why targeting the installer directory no longer renders the installer interface  
  - Observed that requests redirect to the main application dashboard  
  - Learned that MailWizz disables installer routes after successful installation  

- Began analyzing where application edits should live inside a containerized environment  
  - Distinguished between infrastructure configuration and application source code  
  - Recognized the difference between container runtime and bind-mounted development files  

- Discussed repository strategy for customizing MailWizz  
  - Source code should be tracked separately from infrastructure configuration  
  - Need to differentiate between:
    - Application **source files**
    - **Runtime state files** (cache, uploads, temp data)
    - **Infrastructure configuration** (Docker, Nginx, Compose)

- Explored customization options for branding MailWizz for business use  
  - Custom logo  
  - CSS styling  
  - Login page appearance  
  - Footer branding (`dadesigns`)  

- Observed that some visible UI elements were difficult to locate via project search  
  - Reinforced understanding that large frameworks generate UI from multiple template layers  

- Reinforced architectural understanding of the stack:
  - **Containers** run the application services  
  - **Bind mounts** expose the application source to the development environment  
  - **Database** stores installation state and operational data  

- Confirmed development environment is now stable enough to support:
  - Application customization  
  - Campaign testing  
  - Continued infrastructure experimentation

  ---

## Session 6 — Dev Infrastructure Release & Repo Scope Definition  
### 03/14/2026

- Finalized first **dev-ready infrastructure milestone** for the MailWizz stack  
- Created GitHub release to capture stable development environment baseline  

- Clarified repository scope:
  - Repo contains **infrastructure only**
  - MailWizz application source will live in a **separate repository**

- Confirmed repository provides everything needed to:
  - extract MailWizz source
  - run Docker build
  - launch development stack with minimal commands

- Cleaned up repository structure to reduce size and keep scope focused

- Moved extended documentation to the **GitHub Wiki**
  - Removed local documentation references from README
  - Prevented repo from becoming documentation-heavy

- Reviewed wording for release notes and milestone naming

- Reinforced goal of maintaining a **clean, professional infrastructure repository**

---

## Session 7 — MailWizz Source Repository & Upstream Tracking Setup  
### 03/15/2026

- Created a new repository dedicated to the **MailWizz application source code**
- Separated application source from infrastructure to maintain a clean architecture:
  - `mailwizz-infra-stack` → Docker, services, runtime environment
  - `mailwizz-source` → MailWizz application code and future customizations

- Imported clean MailWizz **v2.6.5 source baseline** into the new repository
- Created repository documentation explaining:
  - project purpose
  - upstream tracking strategy
  - runtime file exclusion strategy

- Implemented `.gitignore` to exclude runtime-generated directories including:
  - cache directories
  - upload directories
  - logs
  - environment-specific files

- Performed Git index cleanup to ensure ignored files were not tracked:
  - `git rm -r --cached .`
  - `git add .`

- Created initial baseline commit:
  - `chore: import MailWizz v2.6.5 source baseline`

- Implemented vendor tracking structure using two branches:
  - `master` → customization branch
  - `upstream` → clean MailWizz source history

- Tagged baseline version:
  - `mailwizz-2.6.5`

- Pushed repository to GitHub including:
  - `master` branch
  - `upstream` branch
  - version tag

- Encountered GitHub **push protection** triggered by example AWS credential strings inside vendor source
  - Investigated flagged locations
  - Determined they were placeholder examples within MailWizz source

- Replaced credential-like examples with safe placeholders to satisfy GitHub secret scanning:
  - `YOUR_AWS_SMTP_USERNAME`
  - `YOUR_AWS_SMTP_PASSWORD`

- Amended baseline commit to remove flagged values and successfully pushed repository

- Verified final repository state:
  - `master`, `upstream`, and `mailwizz-2.6.5` tag all reference the same clean baseline commit

- Confirmed repository now follows a **professional vendor-tracking workflow** for maintaining upstream software while supporting local customization
