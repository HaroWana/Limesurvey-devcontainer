# LimeSurvey Dev Container

This repository provides a fully-configured, containerized development environment for [LimeSurvey](https://github.com/LimeSurvey/LimeSurvey) using **VS Code Dev Containers**, **Docker Compose**, and **PostgreSQL**.

It supports backend and frontend development, unit and functional testing (PHPUnit + Selenium), Xdebug, and includes several helper scripts and tasks.

---

## 🚀 Quick Start

### Requirements

- [Docker](https://docs.docker.com/get-docker/)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Dev Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### Setup

1. Clone the repository
2. Open it in VS Code
3. When prompted, click **“Reopen in Container”**
4. Wait for the build and setup to complete

Visit: [http://localhost:8080/admin](http://localhost:8080/admin)  
Use credentials:  
**Username:** `admin`  
**Password:** `password`

---

## 🧪 Testing

### Run all PHPUnit functional tests

```bash
./.devcontainer/scripts/php-unit-tests.sh
```

Or via VS Code task:

```
Ctrl+Shift+P → Tasks: Run Task → LimeSurvey: Run functional tests
```

---

## 🧼 Clear Cache

Clear LimeSurvey’s runtime cache and restart services:

```bash
./.devcontainer/scripts/clear-cache.sh
```

Also available as a VS Code task:  
**LimeSurvey: Clear cache and restart services**

---

## 🔄 Full Environment Reset

Reset the dev container, volumes, DB, and reinstall everything:

```bash
./.devcontainer/scripts/reset-dev.sh
```

---

## 🧰 Helper Scripts

| Script                   | Purpose                                  |
|--------------------------|------------------------------------------|
| `setup.sh`               | Runs at container init, installs LS      |
| `clear-cache.sh`         | Clears cache + restarts nginx/php-fpm    |
| `php-unit-tests.sh`      | Runs PHPUnit tests                       |
| `reset-dev.sh`           | Full environment reset                   |

---

## ⚙️ Services

Defined in `docker-compose.yml`:

- **app**: PHP 8.1 + Nginx + Composer + Xdebug + Supervisor
- **db**: PostgreSQL 14 with persistent volume
- **selenium**: Optional Firefox driver for browser testing

---

## ⚙️ Configuration Overview

- **PHP Config**: `.devcontainer/php.ini`
- **Xdebug**: `.devcontainer/xdebug.ini`
- **Nginx Site**: `.devcontainer/default.conf`
- **Supervisor**: `.devcontainer/supervisord.conf`

---

## 🐞 Debugging

### Xdebug Support

- Port: `9003`
- Automatically connects on request
- Configured via `.vscode/launch.json`

To debug:

1. Set breakpoints
2. Run `Listen for Xdebug` in VS Code debugger
3. Trigger a request via browser or terminal

---

## 🧠 VS Code Settings & Tasks

- **Editor**: auto formats on save
- **Excluded folders**: `vendor`, `node_modules`
- **Tasks**: run tests, clear cache, restart services
- **Debug**: works with Xdebug out-of-the-box

---

## 📁 Folder Structure

```
.
├── .devcontainer/
│   ├── devcontainer.json
│   ├── docker-compose.yml
│   ├── Dockerfile
│   ├── supervisord.conf
│   ├── php
│       ├── php.ini
│       └── xdebug.ini
│   ├── nginx
│       └── default.conf
│   └── scripts/
│       ├── setup.sh
│       ├── clear-cache.sh
│       ├── php-unit-tests.sh
│       └── reset-dev.sh
├── .vscode/
│   ├── launch.json
│   ├── settings.json
│   └── tasks.json
├── .env
├── workspace.code-workspace
└── limesurvey/            # Source code from LimeSurvey repo
```

---

## 🧹 Tips

- PostgreSQL and Composer cache are mounted volumes — deleted during full reset
- Xdebug log (if enabled): `/tmp/xdebug.log` inside the container
- `supervisorctl restart all` restarts services without rebuilding

---

## 🙌 Contributors

- Initial setup: [HaroWana](https://github.com/HaroWana)
