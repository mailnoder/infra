#!/bin/bash

set -e

APP_ROOT="${APP_ROOT:-/var/www/web}"

if [ ! -d "$APP_ROOT" ]; then
    echo "MailWizz app root not found at $APP_ROOT" >&2
    exit 1
fi

# Create MailWizz runtime paths inside the bind-mounted app directory so they
# persist on the host in development and have the right permissions set for mailwizz.
for path in \
    "$APP_ROOT/apps/extensions" \
    "$APP_ROOT/apps/common/config" \
    "$APP_ROOT/apps/common/runtime" \
    "$APP_ROOT/apps/common/runtime/mutex" \
    "$APP_ROOT/backend/assets/cache" \
    "$APP_ROOT/customer/assets/cache" \
    "$APP_ROOT/customer/assets/files" \
    "$APP_ROOT/frontend/assets/cache" \
    "$APP_ROOT/frontend/assets/files" \
    "$APP_ROOT/frontend/assets/gallery"
do
    mkdir -p "$path"
    chmod 0777 "$path"
done

# Start cron in the background
service cron start

# Start PHP-FPM in the foreground
exec /usr/sbin/php-fpm8.3 -O
