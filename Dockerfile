FROM phpdockerio/php:8.3-fpm

WORKDIR /var/www/web

ARG DEBIAN_FRONTEND=noninteractive

# Install required packages and PHP extensions
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
        cron \
        php8.3-mysql \
        php8.3-bcmath \
        php8.3-bz2 \
        php8.3-gd \
        php8.3-gmp \
        php8.3-imap \
        php8.3-intl \
        php8.3-ldap \
        php8.3-tidy \
        php8.3-xsl \
        php8.3-curl \
        php8.3-mbstring \
        php8.3-zip \
        php8.3-xml \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Setup cron jobs
COPY mwcron /etc/cron.d/mwcron
RUN chmod 0644 /etc/cron.d/mwcron \
    && crontab /etc/cron.d/mwcron

# Copy the MailWizz application into the image for a true production build.
COPY web /var/www/web
RUN chown -R www-data:www-data /var/www/web

# Start both cron and php-fpm
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]