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
# hadolint ignore=DL3006
FROM --platform=${BUILDPLATFORM:-linux/amd64} ${BASE_IMAGE}

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH

LABEL authors="Joao Vitor Alves Fazolo, Rodrigo Laiola Guimaraes"
ENV CREATED_AT 2020-06-26
ENV UPDATED_AT 2023-06-01

# Redundant but to ensure we are not going to break anything
# https://github.com/cassiopc/boca/tree/master/tools
# hadolint ignore=DL3002
USER root

# Install dependencies
# hadolint ignore=DL3008,DL3015
RUN apt-get -y update \
    && apt-get -y install \
        # Package: boca-autojudge
        # https://github.com/cassiopc/boca/blob/master/debian/control
        # Depends:
        build-essential \
        debootstrap \
        makepasswd \
        quotatool \
        schroot \
    && rm -rf /var/lib/apt/lists/*

# https://bugs.launchpad.net/ubuntu/+source/ca-certificates-java/+bug/2019908
COPY boca/tools/boca-createjail /var/www/boca/tools/

WORKDIR /var/www/boca
RUN \
    # install-bocaautojudge
    # https://github.com/cassiopc/boca/blob/master/Makefile
    mkdir -p /usr/sbin/ \
    && mkdir -p /usr/bin/ \
    && mkdir -p /etc/ \
    && gcc tools/safeexec.c -o tools/safeexec \
    && install tools/safeexec /usr/bin/safeexec \
    && install tools/boca-createjail /usr/sbin/boca-createjail \
    && install tools/boca-autojudge.sh /usr/sbin/boca-autojudge \
    && chmod 4555 /usr/bin/safeexec \
    && chmod 700 /usr/sbin/boca-createjail \
    && chmod 700 /usr/sbin/boca-autojudge
    # boca-autojudge.postinst
    # https://github.com/cassiopc/boca/blob/master/debian/boca-autojudge.postinst
    # Done before
    # && chmod 4555 /usr/bin/safeexec \
    # && chmod 700 /usr/sbin/boca-createjail \
    # && chmod 700 /usr/sbin/boca-autojudge

RUN boca-createjail || true

# Workaround: Java installation with chroot does not work as expected
RUN cp -rf /home/bocajail/usr/lib/jvm/java-11-openjdk-amd64/bin/* /home/bocajail/usr/bin/ \
    && cp -rf /home/bocajail/usr/lib/jvm/java-11-openjdk-amd64/lib/* /home/bocajail/usr/lib/

COPY --chmod=755 docker/dev/jail/init.sh /

# Add HEALTHCHECK instruction to the container image
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=5 \
    CMD ps ax | grep -v grep | grep php | grep autojudging.php > /dev/null || exit 1

ENTRYPOINT ["/init.sh"]
