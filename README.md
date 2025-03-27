# LimeSurvey Dev Container

This is a ready-to-go development environment for [LimeSurvey](https://github.com/LimeSurvey/LimeSurvey), powered by VS Code Dev Containers, Docker Compose, and PostgreSQL.

---

## 📦 Features

- PHP 8.1 with Xdebug & Composer
- Nginx + PHP-FPM
- PostgreSQL 14 (via Docker volume)
- Selenium sidecar container (optional)
- Full PHPUnit & browser test support
- `supervisord` for process management
- Automatic install of LimeSurvey schema on reset

---

## 🚀 Getting Started

### 1. Open in VS Code

Make sure you have:

- [Docker](https://docs.docker.com/get-docker/)
- [VS Code](https://code.visualstudio.com/)
- [Remote - Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

Then:

1. Clone this repo
2. Open it in VS Code
3. When prompted, click **"Reopen in Container"**

The dev container will build, install dependencies, and install LimeSurvey automatically via CLI.

> Default admin credentials:  
> `admin` / `password`

---

## 🧪 Running Tests

Use the helper script:

```bash
./.devcontainer/scripts/php-unit-test.sh
```

Or manually inside the container:

```bash
cd /workspace/limesurvey
DOMAIN=localhost PASSWORD=password ./vendor/bin/phpunit
```

> Make sure `enabletests` file exists in `/limesurvey`.

---

## 🧼 Clear Cache

Use the helper script:

```bash
./.devcontainer/scripts/clear-cache.sh
```

This will:
- Clear LimeSurvey's runtime/cache
- Restart PHP-FPM and Nginx using `supervisorctl`

---

## 🛠 Reset the Environment

To wipe and rebuild everything (containers, volumes, DB, etc):

```bash
./.devcontainer/scripts/reset-dev.sh
```

This will:

- Stop containers
- Wipe database volume
- Rebuild the environment
- Reinstall LimeSurvey from CLI

---

## ⚙️ Setup Script

Runs on container creation or manually:

```bash
./.devcontainer/scripts/setup.sh
```

This will:

- Wait for DB
- Install PHP dependencies
- Enable test mode
- Run LimeSurvey CLI installer

---

## 🌐 Accessing LimeSurvey

Once the container is running:

- Open: [http://localhost:8080/admin](http://localhost:8080/admin)
- Login: `admin`
- Password: `password`

---

## 🧩 Dev Notes

- Code lives in `/workspace/limesurvey`
- Xdebug is installed and configured (port 9003)
- PostgreSQL credentials come from `.env` file
- Use `supervisorctl restart nginx/php-fpm` to restart services
- Cache clearing:
  ```bash
  php application/commands/console.php clearcache
  ```

---

## 🐛 Troubleshooting

- Can’t reach `localhost:8080`?
  - Check that port 80 is exposed in `docker-compose.yml` as `8080:80`
  - Make sure services are running (`docker ps`)
- DB errors?
  - Try resetting schema:
    ```bash
    PGPASSWORD=limepass psql -h db -U limeuser -d limesurvey -c 'DROP SCHEMA public CASCADE; CREATE SCHEMA public;'
    ```

---

## 📁 Folder Structure

```
.
├── .devcontainer/
│   ├── devcontainer.json
│   ├── docker-compose.yml
│   ├── Dockerfile
│   └── scripts/
│       ├── setup.sh
│       ├── clear-cache.sh
│       ├── php-unit-test.sh
│       └── reset-dev.sh
├── limesurvey/         # Git clone of LimeSurvey repo
├── .vscode/
│   └── tasks.json
└── README.md
```

---

## 🙋‍♀️ Maintainers

- LimeSurvey setup: HaroWana  
- Dev Container config: HaroWana  
- Based on official LimeSurvey + Docker + PHPUnit documentation
