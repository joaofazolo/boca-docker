#========================================================================
# Copyright Universidade Federal do Espirito Santo (Ufes)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
# 
# This program is released under license GNU GPL v3+ license.
#
#========================================================================

# This stage clones BOCA's repository
FROM ubuntu:focal as bocarepo
RUN apt-get -y update \
    && apt-get -y install \
        git
WORKDIR /
RUN git clone https://github.com/cassiopc/boca.git

# Build base image using ubuntu:focal
# Snap did not build boca-jail properly on ubuntu:bionic 
# error: cannot list snaps: cannot communicate with server: Get http://localhost/v2/snaps: dial unix /run/snapd.socket: connect: no such file or directory
# https://groups.google.com/g/boca-users/c/QrgnJl-KAKw/m/uSuRO64_CQAJ
FROM ubuntu:focal

LABEL authors="Joao Vitor Alves Fazolo, Rodrigo Laiola Guimaraes"
ENV CREATED_AT 2020-06-26
ENV UPDATED_AT 2023-04-10

# No interactive frontend during docker build
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

# Locale and encoding settings
ENV LANG_WHICH en
ENV LANG_WHERE US
ENV ENCODING UTF-8
ENV LC_ALL C.${ENCODING}
ENV LANGUAGE ${LANG_WHICH}_${LANG_WHERE}.${ENCODING}
ENV LANG ${LANGUAGE}

# Timezone settings
# Full list at https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
# e.g. "US/Pacific" for Los Angeles, California, USA
# e.g. ENV TZ "US/Pacific"
ENV TZ America/Sao_Paulo

ENV APACHE_RUN_USER  www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE  /var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR   /var/run/apache2
ENV APACHE_LOCK_DIR  /var/lock/apache2
ENV APACHE_LOG_DIR   /var/log/apache2

RUN apt-get -y update \
    && apt-get -y dist-upgrade \
    && apt-get -y install \
        apache2 \
        debootstrap \
        gcc \
        libapache2-mod-php \
        locales \
        make \
        php \
        php-pgsql \
        php-zip \
        postgresql-client \
        quotatool \
        schroot \
        software-properties-common \
        tzdata \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p $APACHE_LOCK_DIR && \
    mkdir -p $APACHE_LOG_DIR && \
    mkdir -p $APACHE_RUN_DIR

RUN echo "Setting time zone to '${TZ}'" ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && echo "Etc/UTC" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

RUN ln -sf /proc/self/fd/1 ${APACHE_LOG_DIR}/access.log \
    && ln -sf /proc/self/fd/1 ${APACHE_LOG_DIR}/error.log

WORKDIR /var/www/boca
# Copy BOCA repository from base image
COPY --from=bocarepo --chown="$APACHE_RUN_USER:$APACHE_RUN_GROUP" /boca/src /var/www/boca/src
COPY --from=bocarepo --chown="$APACHE_RUN_USER:$APACHE_RUN_GROUP" /boca/tools /var/www/boca/tools
# Copy modified local source code file(s)
COPY --chown="$APACHE_RUN_USER:$APACHE_RUN_GROUP" src/private/conf.php /var/www/boca/src/private
COPY --chown="$APACHE_RUN_USER:$APACHE_RUN_GROUP" src/private/createdb.php /var/www/boca/src/private

RUN install tools/boca-fixssh /usr/sbin/ \
	&& install tools/cron-boca-fixssh /etc/cron.d/ \
	&& chmod 700 /usr/sbin/boca-fixssh \
    && cp tools/000-boca.conf /etc/apache2/sites-enabled/000-boca.conf \
    && chown -R "$APACHE_RUN_USER:$APACHE_RUN_GROUP" /var/www/boca \
    && chmod -R go-rwx /var/www/boca/src/private \
    && chown -R "$APACHE_RUN_USER:$APACHE_RUN_GROUP" "$APACHE_LOCK_DIR" \
    && chown -R "$APACHE_RUN_USER:$APACHE_RUN_GROUP" "$APACHE_LOG_DIR" \
    && chown -R "$APACHE_RUN_USER:$APACHE_RUN_GROUP" "$APACHE_RUN_DIR"
