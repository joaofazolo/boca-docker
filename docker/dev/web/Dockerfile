# Build base image
FROM boca-base

COPY docker/dev/web/init.sh /
RUN chmod 777 /init.sh
COPY . /var/www/boca

RUN cd /var/www/boca && install tools/boca-fixssh /usr/sbin/ && \
	install tools/cron-boca-fixssh /etc/cron.d/ && \
	chmod 700 /usr/sbin/boca-fixssh && \
    cp tools/000-boca.conf /etc/apache2/sites-enabled/000-boca.conf && \
    chown -R www-data.www-data /var/www/boca && \
    chmod -R go-rwx /var/www/boca/src/private

EXPOSE 80
 
WORKDIR /var/www/boca

ENTRYPOINT ["/init.sh"]
