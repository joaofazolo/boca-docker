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

# Build on base image
FROM boca-base

LABEL authors="Joao Vitor Alves Fazolo, Rodrigo Laiola Guimaraes"
ENV CREATED_AT 2020-06-26
ENV UPDATED_AT 2022-07-03

# Basic setup to establish connection with database server
RUN apt-get -y update && \
    apt-get -y dist-upgrade && \
    apt-get -y install \
        git \
        postgresql-client && \
    apt-get clean

# Install libraries
RUN apt-get -y update && \
    apt-get -y install \
        # Required to build ballons \
        php-gd && \
    apt-get -y clean

COPY LICENSE /
COPY docker/dev/web/init.sh /
RUN chmod 777 /init.sh

RUN cd /var/www
# Clone BOCA repository
RUN git clone https://github.com/cassiopc/boca.git

COPY LICENSE /var/www/boca/src/private
# Copy modified source code file(s)
COPY src/private/conf.php /var/www/boca/src/private

RUN cd /var/www/boca && install tools/boca-fixssh /usr/sbin/ && \
	install tools/cron-boca-fixssh /etc/cron.d/ && \
	chmod 700 /usr/sbin/boca-fixssh && \
    cp tools/000-boca.conf /etc/apache2/sites-enabled/000-boca.conf && \
    chown -R www-data.www-data /var/www/boca && \
    chmod -R go-rwx /var/www/boca/src/private

EXPOSE 80
 
WORKDIR /var/www/boca

ENTRYPOINT ["/init.sh"]
