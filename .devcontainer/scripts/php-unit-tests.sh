#!/bin/bash
set -e

DOMAIN=localhost PASSWORD=admin ./vendor/bin/phpunit tests/functional

echo "✅ PHP Unit tests completed!"c