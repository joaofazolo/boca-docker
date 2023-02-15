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

# Build base image using ubuntu:focal
# Snap did not build boca-jail properly on ubuntu:bionic 
# error: cannot list snaps: cannot communicate with server: Get http://localhost/v2/snaps: dial unix /run/snapd.socket: connect: no such file or directory
# https://groups.google.com/g/boca-users/c/QrgnJl-KAKw/m/uSuRO64_CQAJ
FROM ubuntu:focal

LABEL authors="Joao Vitor Alves Fazolo, Rodrigo Laiola Guimaraes"
ENV CREATED_AT 2020-06-26
ENV UPDATED_AT 2021-11-09

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
RUN echo "Setting time zone to '${TZ}'" \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

ENV APACHE_RUN_USER  www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR   /var/log/apache2
ENV APACHE_PID_FILE  /var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR   /var/run/apache2
ENV APACHE_LOCK_DIR  /var/lock/apache2
ENV APACHE_LOG_DIR   /var/log/apache2

RUN mkdir -p $APACHE_RUN_DIR
RUN mkdir -p $APACHE_LOCK_DIR
RUN mkdir -p $APACHE_LOG_DIR

RUN apt-get -y update
RUN apt-get -y install tzdata locales software-properties-common \
    apache2 \
    make \
    gcc \
    php \
    php-pgsql \
    libapache2-mod-php \
    php-zip \
    quotatool \
    debootstrap \
    schroot 
RUN apt-get -y upgrade
RUN apt-get -y clean
RUN echo "Etc/UTC" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

RUN ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log
 
WORKDIR /var/www
