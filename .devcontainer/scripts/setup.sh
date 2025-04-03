#!/bin/bash
set -e

echo "📦 Setting up LimeSurvey..."

# Clone LimeSurvey if not present
if [ ! -d "/workspace/limesurvey" ]; then
  echo "Cloning LimeSurvey..."
  git clone https://github.com/LimeSurvey/LimeSurvey.git /workspace/limesurvey # Change this line for your target repo
fi

cd /workspace/limesurvey
# git checkout $GIT_BRANCH # Uncomment if you want to switch to a specific branch

# Install PHP dependencies (with dev packages for PHPUnit)
if [ ! -d "vendor" ]; then
  echo "Installing Composer dependencies..."
  composer install
fi

# Set correct permissions
chown -R www-data:www-data /workspace/limesurvey

# Wait for DB
echo "Waiting for database..."
until pg_isready -h db -p 5432 -U limeuser; do
  sleep 2
done

# Optional: Restore DB dump
if [ -f /workspace/limesurvey.sql ]; then
  echo "Importing initial database..."
  PGPASSWORD=limepass psql -h db -U limeuser -d limesurvey -f /workspace/limesurvey.sql
fi

echo "✅ LimeSurvey setup complete!"
