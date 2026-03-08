# 🚀 Running the Development Server

This project uses **Docker + Docker Compose** to run MailWizz in a controlled development environment.

The development environment mirrors production as closely as possible while allowing debugging, rebuilds, and safe experimentation.

---

# 📦 Prerequisites

Make sure the following are installed:

- Docker
- Docker Compose (v2+)
- Git
- Linux-based OS (recommended: Ubuntu)

Verify installation:

```bash
docker --version
docker compose version
```

---

# 🐳 Docker Permission Fix (Linux Only)

If you see an error like:

```
permission denied while trying to connect to the Docker daemon socket
```

It means your user is not in the `docker` group.

## 🔧 Fix

Run:

```bash
sudo groupadd docker 2>/dev/null || true
sudo usermod -aG docker $USER
```

Then log out and log back in, or run:

```bash
newgrp docker
```

Verify:

```bash
docker ps
```

If it works without `sudo`, you're good.

---

## 💡 Why This Command Works

```bash
sudo groupadd docker 2>/dev/null || true
```

Breakdown:

- `groupadd docker` → Creates the docker group if it doesn't exist.
- `2>/dev/null` → Suppresses error output if the group already exists.
- `|| true` → Prevents failure if the group already exists.

This makes the setup process **idempotent** (safe to run multiple times).

Without this fix:
- You would need `sudo docker compose up`
- Volume permissions may become inconsistent
- Dev workflow becomes messy

---

# 📁 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/mailwizz.git
cd mailwizz
```

---

# ⚙️ 2. Environment Configuration

If using an environment file:

```bash
cp .env.example .env
```

Update:

- Database credentials
- App URL
- Mail transport settings
- Debug configuration (if applicable)

---

# 🏗️ 3. Build the Containers

Build images defined in:

- `Dockerfile`
- `docker-compose.yml`

```bash
docker compose build
```

Force clean rebuild:

```bash
docker compose build --no-cache
```

---

# ▶️ 4. Start the Development Stack

```bash
docker compose up
```

Detached mode: (best to see logs in dev stack)

```bash
docker compose up -d
```

This starts:

- MailWizz application container
- Database container
- Nginx reverse proxy
- Cron container (`mwcron`)

---

# 🌐 5. Access the Application

Open:

```
http://localhost
```

Or your configured dev domain.

---

### Required Directory Permissions

MailWizz requires write access to several directories.

If permissions are not set correctly, you may see:
- Blank pages
- Asset errors
- Runtime exceptions
- Failed cache writes

Run the following from the project root:

```bash
cd web/

chmod 0777 apps/common/config/
chmod 0777 backend/assets/cache/
chmod 0777 customer/assets/cache/
chmod 0777 frontend/assets/cache/
chmod 0777 frontend/assets/files/
chmod 0777 frontend/assets/gallery/
chmod 0777 apps/extensions/
chmod 0777 apps/common/runtime/
chmod 0777 apps/common/runtime/mutex
```

> Note: `0777` is acceptable for local development only.  
> In production, permissions should be restricted to the web server user.

---

### Database Error on First Visit

If you visit:

```
http://localhost:8080
```

And see a database connection error, this is **expected** on first boot.

MailWizz has not been installed yet, so no database configuration exists.

---

### ✅ Run the Installer

Navigate to:

```
http://localhost:8080/install/
```

Complete the installer steps using:

- Database Host: `mailwizz-mysql`
- Database Name: `mailwizz`
- Username: `mailwizz`
- Password: `mailwizzpassword`

After installation completes, the application will connect properly.

---

### Important: Use HTTP (Not HTTPS)

SSL has not been enabled in the development environment.

Ensure you are using:

```
http://localhost:8080
```

NOT:

```
https://localhost:8080
```

Attempting to use HTTPS will fail because no TLS certificates are configured in the local nginx container.

---

### 🧠 Why This Happens

MailWizz:
- Requires writable runtime directories
- Does not ship with a preconfigured database connection
- Must be installed via the `/install` endpoint before use

These steps are part of the normal MailWizz initialization process.

---

# 📜 6. Viewing Logs

View all services:

```bash
docker compose logs -f
```

Specific service:

```bash
docker compose logs -f mailwizz
```

Logs are critical for debugging:

- Database connection errors
- Permission issues
- Cron failures
- Nginx routing problems

---

# 🔁 7. Restarting After Changes

If you modify:

- `Dockerfile`
- `docker-compose.yml`
- `nginx/nginx.conf`
- `start.sh`
- `mwcron`

Rebuild and restart:

```bash
docker compose down
docker compose up --build
```

---

# 🧪 8. Cron (Development)

MailWizz requires cron jobs to function properly.

If using the cron container:

```bash
docker compose logs -f mwcron
```

Manual test:

```bash
docker exec -it <container_name> php apps/console/console.php send-campaigns
```

---

# 🧹 9. Resetting the Environment

⚠️ This removes volumes (database data will be deleted):

```bash
docker compose down -v
docker compose build --no-cache
docker compose up
```

---

# 🧠 Development Notes

- Dev prioritizes visibility over performance.
- Always rebuild after modifying PHP extensions or Dockerfile.
- Keep production secrets out of the dev `.env`.
- Use Git branches for environment changes.
- Ensure your user belongs to the `docker` group before starting development.

---

# 🛠 Optional: Bootstrap Script (Recommended)

To automate setup, you can create a `bootstrap-dev.sh`:

```bash
#!/bin/bash

echo "Setting up Docker permissions..."
sudo groupadd docker 2>/dev/null || true
sudo usermod -aG docker $USER

echo "Copying environment file..."
cp -n .env.example .env 2>/dev/null || true

echo "Building containers..."
docker compose build

echo "Done. Log out and back in if Docker permissions were just added."
```

Make executable:

```bash
chmod +x bootstrap-dev.sh
./bootstrap-dev.sh
```

This provides a clean, reproducible development setup.
