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
ARG BASE_IMAGE=boca-base
FROM ${BASE_IMAGE}

LABEL authors="Joao Vitor Alves Fazolo, Rodrigo Laiola Guimaraes"
ENV CREATED_AT 2020-06-26
ENV UPDATED_AT 2023-04-10

WORKDIR /var/www/boca
RUN gcc tools/safeexec.c -o tools/safeexec \
    && install tools/safeexec /usr/bin/safeexec \
    && install tools/boca-createjail /usr/sbin/boca-createjail \
    && install tools/boca-autojudge.sh /usr/sbin/boca-autojudge \
    && install tools/boca-config-dbhost.sh /usr/sbin/boca-config-dbhost \
    && chmod 700 /usr/sbin/boca-config-dbhost \
    && chmod 4555 /usr/bin/safeexec \
    && chmod 700 /usr/sbin/boca-createjail \
    && chmod 700 /usr/sbin/boca-autojudge \
    && chmod 700 /usr/sbin/boca-config-dbhost \
    && chmod 700 /usr/sbin/boca-fixssh \
    && cp tools/boca.conf /etc/

RUN boca-createjail || true

COPY --chmod=755 --chown="$APACHE_RUN_USER:$APACHE_RUN_GROUP" docker/dev/jail/init.sh /

ENTRYPOINT ["/init.sh"]
