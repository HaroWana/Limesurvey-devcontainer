#!/bin/bash
if grep -qE 'docker|containerd' /proc/1/cgroup; then
  echo "❌ This script must be run on the host, not inside a dev container."
  exit 1
fi

set -e

echo "🧨 Stopping and removing containers + volumes..."
docker compose down -v

# echo "🧹 Optionally deleting the LimeSurvey source..."
# rm -rf limesurvey
# git clone https://github.com/LimeSurvey/LimeSurvey.git limesurvey

echo "🔁 Rebuilding containers..."
docker compose up --build -d

echo "⏳ Waiting for the database to become ready..."
until docker exec limesurvey-dev_app_1 pg_isready -h db -p 5432 -U limeuser; do
  sleep 1
done

echo "🧱 Reinstalling LimeSurvey schema via CLI..."
docker exec limesurvey-dev_app_1 bash -c "
  cd /workspace/limesurvey &&
  touch enabletests && \
  DBENGINE=INNODB \
  php application/commands/console.php install $POSTGRES_USER $POSTGRES_PASSWORD admin@example.com verbose
"

echo "✅ Full environment reset complete."
