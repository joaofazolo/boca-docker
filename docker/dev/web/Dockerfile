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
FROM --platform=${BUILDPLATFORM:-linux/amd64} ${BASE_IMAGE}

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH

LABEL authors="Joao Vitor Alves Fazolo, Rodrigo Laiola Guimaraes"
ENV CREATED_AT 2020-06-26
ENV UPDATED_AT 2023-04-10

# Redundant but to ensure we are not going to break anything
# https://github.com/cassiopc/boca/tree/master/doc
USER root

# Basic setup
RUN apt-get -y update \
    && apt-get -y install \
        # Required to build ballons \
        php-gd \
    && rm -rf /var/lib/apt/lists/*

COPY --chmod=755 --chown="$APACHE_RUN_USER:$APACHE_RUN_GROUP" docker/dev/web/init.sh /

# Create a non-root user for the container
USER $APACHE_RUN_USER

# Add HEALTHCHECK instruction to the container image
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=5 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:80/boca/ || exit 1

EXPOSE 80

ENTRYPOINT ["/init.sh"]
