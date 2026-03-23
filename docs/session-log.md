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

---

## Session 8 — Runtime Directory Git Strategy Investigation  
### 03/16/2026

- Investigated MailWizz installer failure caused by missing runtime directories after cloning the repository

- Identified likely root cause:
  - `.gitignore` rules currently ignore entire runtime directories
  - Git does not track empty directories, which can cause required folders to be absent after cloning

- Confirmed MailWizz expects several runtime paths to exist during installation, including:

```
apps/common/runtime/
backend/assets/cache/
customer/assets/cache/
customer/assets/files/
frontend/assets/cache/
frontend/assets/files/
frontend/assets/gallery/
```

- Determined that ignoring directories directly may prevent these required paths from existing in a clean clone

- Evaluated correct Git strategy for handling framework runtime directories:
  - Ignore **directory contents**, not the directory itself
  - Preserve required folder structure using `.gitkeep` placeholder files

- Drafted revised `.gitignore` pattern to support this approach:

```
folder/*
!folder/.gitkeep
```

- Planned to add `.gitkeep` files to required runtime directories in the next development session

- Created **GitHub Issue #1** to formally track the repository structure fix

- Reviewed repository architecture to confirm correct separation of responsibilities:

```
mailwizz-infra-stack  → Docker infrastructure and runtime environment
mailwizz-source       → MailWizz application source code
```

- Confirmed `web/` is intentionally ignored in the infrastructure repository because it represents a **bind-mounted application directory**

- Verified that the MailWizz application source is tracked separately within the `mailwizz-source` repository

- Confirmed vendor tracking workflow within the source repository:

```
master   → customization branch
upstream → clean vendor reference
```

- Ensured both branches currently share an identical baseline commit to allow future comparison between upstream code and custom modifications

- Reinforced understanding of Git behavior relevant to framework projects:
  - Git tracks files, not directories
  - Ignoring a directory prevents Git from evaluating nested `.gitignore` rules
  - Runtime directories in many frameworks must be preserved even when their contents are ignored

- Session concluded with repository structure analysis complete and fix strategy planned for implementation in the next development session

---

## Session 9 — Runtime Directory Fix & Repository Architecture Clarification  
### 03/17/2026

- Diagnosed MailWizz installer failure caused by missing runtime directories  
- Identified root cause:
  - `.gitignore` excluded entire directories instead of only their contents  
  - Git does not track empty directories, causing required paths to be missing after clone  

- Implemented fix using `.gitkeep` pattern:
  - Preserved required directory structure
  - Ignored runtime-generated files
  - Restored installer compatibility  

- Cleaned up unintended filesystem artifacts:
  - Removed incorrectly created nested `git-gitkeep` directories  
  - Rebuilt directory structure in a controlled manner  

- Verified repository integrity:
  - Confirmed required directories exist and are tracked via `.gitkeep`  
  - Validated no source files were lost (`~6300+ files tracked`)  

- Investigated `.gitignore` impact on upstream:
  - Confirmed no critical files were excluded from version control  
  - Distinguished between source files and runtime/generated assets  

- Analyzed branch structure and responsibilities:
  - Determined `upstream` branch was unintentionally mixed with environment files  
  - Identified need for separation between:
    - **vendor source (upstream)**
    - **working environment (master)**  

- Began refactoring repository architecture:
  - Isolated environment-specific files (`.gitignore`, `.gitkeep`, Docker configs)  
  - Prepared to clean upstream branch to maintain pure source reference  

- Reinforced key engineering concepts:
  - Git tracks files, not directories  
  - Separation of source code vs runtime environment  
  - Importance of validating filesystem state during debugging  
  - Maintaining clean repository boundaries for long-term scalability  

---

## Session 10 — Organization Setup, Branding, and Production Deployment Planning  
### 03/20/2026

- Established **MailNoder** as a formal project identity:
  - Selected naming convention:
    - Brand: **MailNoder**
    - System/infra: `mailnoder`
  - Evaluated naming consistency across:
    - GitHub organization
    - domain planning
    - future email infrastructure  

- Initiated transition from personal development to **organization-based architecture**:
  - Created GitHub organization under **“business or institution”**
  - Defined separation between:
    - personal account (developer identity)
    - organization (product identity)

- Designed initial repository structure for scalability:
  - Planned core repositories:
    - `infra` → Docker, nginx, networking
    - `platform` → application logic, configuration
    - `ops` → automation, scripts
    - `mailwizz-upstream` → isolated vendor source
  - Reinforced importance of:
    - separating vendor code from system logic
    - maintaining clean architectural boundaries

- Explored branding system for project-wide consistency:
  - Generated initial **MailNoder logo and asset concepts**
  - Defined need for production-ready assets:
    - logo variants (light/dark)
    - icon + favicon
    - email header + branding badge
  - Established `/brand` as a reusable asset layer across:
    - frontend (future)
    - MailWizz UI
    - email campaigns

- Clarified asset pipeline limitations:
  - Identified difference between:
    - design mockups (composed images)
    - production assets (separate usable files)
  - Planned transition to clean asset exports for integration

- Evaluated project identity infrastructure:
  - Debated use of:
    - personal email vs project email
  - Chose to **defer domain-based email setup**
    - avoided premature infrastructure complexity
    - prioritized development momentum

- Defined production deployment requirements:
  - Identified need for `docker-compose.prod.yml`
  - Distinguished dev vs production concerns:
    - persistent storage (volumes)
    - SSL (HTTPS via reverse proxy)
    - network exposure (public access)
  - Planned minimal production architecture:
    - nginx (SSL termination)
    - MailWizz container
    - database with persistent volume

- Established core deployment objective:
  - Transition from:
    - local-only development environment
  - To:
    - publicly accessible demo instance (`mailnoder.<domain>`)

- Reinforced key engineering concepts:
  - Separation of development vs production environments
  - Importance of persistence in containerized systems
  - Reverse proxy role in modern web architecture
  - Branding as part of system design, not just aesthetics
  - Organizations as a structural layer for scalable projects

- Defined next milestone:
  - Deploy first live, accessible MailNoder instance
  - Validate:
    - login access
    - dashboard functionality
    - basic email campaign flow

---

## Session 11 — Repo Strategy, Upstream Integrity, and Dev Identity Positioning  
### 03/21/2026

- Refined **repository strategy for MailWizz integration**:
  - Clarified separation between:
    - upstream (vendor source of truth)
    - platform (custom logic + modifications)
  - Resolved confusion around:
    - committing distribution vs source versions
  - Confirmed approach:
    - upstream repo contains **full distributed MailWizz package**
    - includes `vendor/` to preserve exact dependency state

- Solidified **branching model for vendor control**:
  - Established structure:
    - `main` → reference / pointer to latest usable version
    - version branches (e.g. `v2.6.x`) → actual upstream snapshots
  - Reinforced importance of:
    - not modifying upstream directly
    - preserving clean upgrade path

- Addressed **dependency management concerns**:
  - Evaluated role of `composer.json` vs `vendor/`
  - Concluded:
    - relying solely on composer introduces uncertainty
    - including `vendor/` = **“baked-in dependencies”**
  - Strengthened understanding of:
    - reproducible builds vs dynamic installs

- Debugged **Git issues related to `.gitignore` and runtime files**:
  - Encountered conflict between:
    - ignoring runtime directories
    - preserving required folder structure
  - Implemented solution:
    - use `.gitkeep` for empty required directories
    - avoid polluting upstream with environment-specific rules
  - Learned impact of:
    - `.gitignore` changes on tracked files and history

- Practiced **Linux file and directory inspection techniques**:
  - Used tools like `diff -qr` to compare distributions
  - Explored ways to:
    - list directory structures
    - identify hidden differences between versions
  - Improved ability to audit large codebases efficiently

- Clarified **distribution vs source concepts**:
  - Distribution:
    - pre-packaged, ready-to-run (includes vendor + compiled assets)
  - Source:
    - requires build steps (composer, asset compilation)
  - Confirmed MailWizz operates as a **distribution-first system**

- Evaluated **GitHub organization structure vs personal repos**:
  - Weighed branding consistency vs simplicity
  - Confirmed organization approach aligns with:
    - long-term product vision
    - multi-repo architecture

- Explored **developer identity and exposure strategy**:
  - Identified importance of:
    - GitHub
    - LinkedIn
    - visible project work
  - Learned terminology:
    - “developer positioning” / “building in public”
  - Connected idea of:
    - real projects → real opportunities

- Reviewed **developer tooling for secrets and credentials**:
  - Identified tools like:
    - Bitwarden (selected)
  - Reinforced importance of:
    - secure storage for:
      - API keys
      - login credentials
      - infrastructure access

- Continued **Linux environment workflow improvements**:
  - Installed `.deb` packages manually (Bitwarden)
  - Troubleshot permission-related apt warnings
  - Gained familiarity with:
    - package installation outside of Snap ecosystem

- Reinforced broader engineering mindset:
  - Architecture decisions early → less pain later
  - Clean separation of concerns = scalability
  - Version control is not just storage, but **system design**
  - Small mistakes (like `.gitignore`) can cascade into structural issues

- Defined next milestone:
  - Finalize clean upstream repository state
  - Establish stable integration path into `mailnoder/platform`
  - Begin preparing **production-ready deployment configuration**

---

## Session 12 — Docker Recovery, Repo Linking, and Runtime Control  
### 03/22/2026

- Resolved **repository rename + local linkage confusion**:
  - Confirmed that:
    - renaming a GitHub repo does NOT break local repo
    - remote URL simply needs updating if issues occur
  - Reinforced understanding of:
    - `origin` as a pointer, not a hard dependency
  - Practiced maintaining continuity between:
    - local repo state
    - remote repository identity

- Recovered from **Docker container naming conflict**:
  - Encountered error:
    - container name already in use (`mailwizz-mailhog`)
  - Diagnosed root cause:
    - previously created container still exists (even if stopped)
  - Executed cleanup workflow:
    - removed conflicting containers
    - reset environment to allow clean startup
  - Strengthened understanding of:
    - Docker container lifecycle (running vs stopped vs removed)

- Established **clean reset workflow for Docker environments**:
  - Learned practical “wipe and restart” strategy:
    - remove containers
    - optionally remove volumes/networks if needed
  - Recognized importance of:
    - avoiding stale state during rapid iteration
  - Built confidence in:
    - recovering broken environments quickly

- Successfully relaunched **MailWizz stack with minimal commands**:
  - Achieved working state using:
    - simplified Docker commands
  - Reinforced goal of:
    - reducing startup friction
    - making environment reproducible

- Clarified **runtime vs source control boundaries**:
  - Revisited question:
    - “Why protect runtime if only pulling?”
  - Internalized that `.gitignore` is about:
    - protecting future commits
    - preventing accidental pollution of source
  - Evaluated idea of:
    - ignoring entire `web/` directory vs selective control
  - Recognized tradeoff:
    - convenience vs long-term maintainability

- Explored **repo structure decisions (infra vs platform)**:
  - Debated placement of `web/` directory:
    - inside `infra` (runtime-focused)
    - inside `platform` (source-focused)
  - Identified emerging architecture direction:
    - `platform` → application + controlled source
    - `infra` → execution layer (Docker, nginx, services)
  - Highlighted need for:
    - clean integration path for upstream updates

- Investigated **strategies for integrating upstream updates**:
  - Considered approaches:
    - manual zip replacement
    - `rsync` syncing
    - git-based workflows
  - Recognized core challenge:
    - maintaining clean diff between:
      - vendor upstream
      - custom modifications
  - Continued moving toward:
    - structured, repeatable update process

- Introduced concept of **bind mounts in Docker**:
  - Learned that bind mounts:
    - map host directories into containers
    - persist data outside container lifecycle
  - Connected concept to:
    - runtime persistence (uploads, cache, logs)
  - Realized:
    - containers can be destroyed/recreated without losing data
  - Identified importance for:
    - production-ready storage strategy

- Mapped **MailWizz directory responsibilities**:
  - Began distinguishing between:
    - code (tracked)
    - runtime (ephemeral / persistent data)
    - cache (rebuildable)
  - Discussed examples:
    - compiled templates (generated from backend templating engine)
  - Clarified role of framework:
    - Yii provides structure + basic caching (not a full caching system like Redis)

- Reinforced understanding of **application frameworks**:
  - Clarified that Yii is:
    - a PHP framework (not a caching engine)
  - Compared conceptually to:
    - other backend frameworks that provide:
      - routing
      - templating
      - basic caching layers

- Strengthened **mental model of system design layers**:
  - Application (MailWizz / Yii)
  - Platform (custom integration + config)
  - Infrastructure (Docker, nginx, networking)
  - Runtime (data persistence layer)

- Reinforced engineering mindset:
  - Fast recovery > perfect setup during early stages
  - Understanding system boundaries is key to scaling
  - Containers are disposable — data is not
  - Repo structure decisions directly impact future velocity

- Defined next milestone:
  - Finalize placement of `web/` within architecture
  - Establish clean upstream update workflow
  - Introduce persistent volumes for production data
  - Move toward stable dev vs production environment separation

---

## Session 13 — Reproducible Build System, Upstream Control & Dev Workflow Design  
### 03/23/2026

- Stabilized **MailWizz development environment (v2.6.5)**:
  - Confirmed application runs reliably via Docker
  - Verified installation persists across container restarts
  - Established working baseline for further system design
  - Recognized importance of:
    - locking a known-good version before introducing upgrades

- Clarified **build vs runtime vs system layers**:
  - Distinguished between:
    - Dockerfile → system dependencies (PHP, services)
    - build phase → assembling `/web` from upstream
    - runtime phase → container startup (`start.sh`)
  - Identified prior confusion as:
    - mixing responsibilities across layers
  - Established clean mental model:
    - system → build → runtime

- Formalized **application build process (previously manual)**:
  - Identified prior workflow:
    - manual creation of `web/`
    - manual extraction of upstream files
  - Reframed this as:
    - an implicit “app build phase”
  - Transitioned to:
    - explicit, automated build pipeline

- Implemented first version of **`build.sh` (app assembly layer)**:
  - Automated:
    - cleaning `/web`
    - syncing upstream source into runtime directory
    - starting Docker containers
  - Introduced `rsync` for:
    - clean synchronization
    - removal of stale files
  - Established:
    - repeatable, deterministic environment rebuild

- Validated **separation of concerns across scripts**:
  - `build.sh` → prepares application filesystem
  - `start.sh` → initializes runtime inside container
  - Avoided mixing:
    - file assembly logic with runtime behavior
  - Reinforced principle:
    - each layer should do one job well

- Designed **upstream source control strategy**:
  - Clarified that:
    - build system uses local upstream copy (not GitHub directly)
  - Distinguished between:
    - remote source (GitHub)
    - local source (`mailwizz-upstream/`)
    - runtime build (`web/`)
  - Reinforced importance of:
    - controlling source inputs explicitly

- Introduced **`setup.sh` (source acquisition layer)**:
  - Automated:
    - cloning MailWizz upstream
    - selecting specific version via argument
  - Implemented shallow clone strategy:
    - `--branch <version> --depth 1`
  - Optimized for:
    - snapshot-style versioning
    - minimal disk usage
    - faster setup

- Evaluated **branch vs tag vs commit for version control**:
  - Identified risk:
    - branches can move (non-deterministic)
  - Established best practice:
    - prefer tags or fixed versions for reproducibility
  - Reinforced concept:
    - builds must depend on immutable inputs

- Adopted **artifact-based mindset for upstream repo**:
  - Treated each version as:
    - a complete, isolated snapshot
  - Shifted perspective from:
    - “codebase under development”
    - → “versioned distribution artifact”
  - Enabled:
    - clean version switching via re-clone

- Designed **version-switching workflow**:
  - Established flow:
    - `./setup.sh vX.X.X`
    - `./build.sh`
  - Accepted tradeoff:
    - shallow clone requires re-clone per version
  - Gained:
    - clarity, predictability, and isolation between versions

- Explored **automation boundaries (setup vs build)**:
  - Questioned combining cloning + building
  - Determined:
    - separation improves:
      - debugging clarity
      - execution control
      - performance (avoid unnecessary downloads)
  - Introduced concept of:
    - higher-level wrapper script (`dev.sh`)

- Designed **multi-layer script architecture**:
  - `setup.sh` → fetches source
  - `build.sh` → assembles application
  - `start.sh` → runs services
  - `dev.sh` (planned) → orchestrates workflow
  - Established pattern aligned with:
    - real-world CI/CD pipelines

- Reinforced **reproducibility as primary goal**:
  - Eliminated manual steps from build process
  - Ensured:
    - consistent environment across rebuilds
  - Reduced:
    - human error
    - hidden state issues

- Strengthened understanding of **Docker workflow integration**:
  - Integrated build system with:
    - `docker compose up --build`
  - Recognized difference between:
    - rebuilding containers
    - rebuilding application filesystem
  - Improved confidence in:
    - orchestrating full environment lifecycle

- Identified key architectural milestone:
  - Transition from:
    - “getting MailWizz running”
    - → “building a controlled, reproducible platform”

- Reinforced engineering mindset:
  - Separate concerns before combining them
  - Control inputs before automating outputs
  - Reproducibility > convenience
  - Systems should be rebuildable from zero at any time

- Defined next steps:
  - Implement `dev.sh` wrapper for unified workflow
  - Add flags:
    - `--update`, `--reset-db`, `--no-build`
  - Introduce dev vs production build modes
  - Begin layering custom platform modifications over upstream
  - Prepare for controlled upgrade path (2.6 → 2.7)

---
