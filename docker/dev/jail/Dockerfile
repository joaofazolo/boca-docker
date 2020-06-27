# Build base image
FROM boca-base

COPY docker/dev/jail/init.sh /
RUN chmod 777 /init.sh
COPY . /var/www/boca

RUN cd /var/www/boca && install tools/boca-fixssh /usr/sbin/ && \
	install tools/cron-boca-fixssh /etc/cron.d/ && \
	chmod 700 /usr/sbin/boca-fixssh && \
    cp tools/000-boca.conf /etc/apache2/sites-enabled/000-boca.conf && \
    chown -R www-data.www-data /var/www/boca && \
    chmod -R go-rwx /var/www/boca/src/private

RUN cd /var/www/boca && \
    gcc tools/safeexec.c -o tools/safeexec && \
    install tools/safeexec /usr/bin/safeexec && \
	install tools/boca-createjail /usr/sbin/boca-createjail && \
	install tools/boca-autojudge.sh /usr/sbin/boca-autojudge && \
	install tools/boca-config-dbhost.sh /usr/sbin/boca-config-dbhost && \
	chmod 700 /usr/sbin/boca-config-dbhost && \
	chmod 4555 /usr/bin/safeexec && \
	chmod 700 /usr/sbin/boca-createjail && \
	chmod 700 /usr/sbin/boca-autojudge && \
    chmod 700 /usr/sbin/boca-config-dbhost && \
    chmod 700 /usr/sbin/boca-fixssh && \
    cp tools/boca.conf /etc/ && \
    echo "bdserver=postgres-boca" >> /etc/boca.conf && \
    echo "bdcreated=y" >> /etc/boca.conf
    # boca-createjail


EXPOSE 80
 
WORKDIR /var/www/boca

ENTRYPOINT ["/init.sh"]
