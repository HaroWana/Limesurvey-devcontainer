#!/bin/bash
set -e

php application/commands/console.php flushassets
supervisorctl restart php-fpm
supervisorctl restart nginx

echo "✅ Cache cleared and services restarted!"