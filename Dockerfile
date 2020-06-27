# Build base image
FROM ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive

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
RUN echo "Etc/UTC" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

RUN ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log
 
WORKDIR /var/www