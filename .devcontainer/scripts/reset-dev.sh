#!/bin/bash
if grep -qE 'docker|containerd' /proc/1/cgroup; then
  echo "❌ This script must be run on the host, not inside a dev container."
  exit 1
fi

set -e

echo "📦 Loading environment variables from .env..."
set -a
. .env
set +a

# Check required env vars
if [[ -z "$POSTGRES_USER" || -z "$POSTGRES_PASSWORD" || -z "$POSTGRES_DB" || -z "$GIT_BRANCH" ]]; then
  echo "❌ Missing required environment variables in .env (POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB, GIT_BRANCH)"
  exit 1
fi

echo "🧨 Stopping and removing containers + volumes..."
docker compose down -v && cd ..

echo "🧹 Optionally deleting the LimeSurvey source..."
rm -rf limesurvey
git clone https://github.com/HaroWana/LimeSurvey.git limesurvey # Change this line for your target repo
cd limesurvey && git checkout $GIT_BRANCH && cd ..

echo "🔁 Rebuilding containers..."
cd .devcontainer && docker compose up --build -d && cd ..

echo "⏳ Waiting for the database to become ready..."
until docker exec devcontainer-app-1 pg_isready -h db -p 5432 -U limeuser; do
  sleep 1
done

echo "🗑️ Dropping and recreating the limesurvey database..."
docker exec devcontainer-app-1 bash -c '
  export PGPASSWORD=limepass
  psql -h db -U limeuser -d postgres -c "DROP DATABASE IF EXISTS limesurvey;"
  psql -h db -U limeuser -d postgres -c "CREATE DATABASE limesurvey;"
'

echo "🧱 Reinstalling LimeSurvey schema via CLI..."
docker exec devcontainer-app-1 bash -c "
  cd /workspace/limesurvey &&
  touch enabletests && \
  DBENGINE=INNODB \
  php application/commands/console.php install $POSTGRES_USER $POSTGRES_PASSWORD admin@example.com verbose
"

echo "✅ Full environment reset complete."
