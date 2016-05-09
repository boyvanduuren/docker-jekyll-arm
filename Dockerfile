FROM armbuild/debian

MAINTAINER Boy van Duuren "boy@vanduuren.xyz"

ENV DEBIAN_FRONTEND noninteractive

RUN \
	apt-get update && \
	apt-get -y install \
		cron \
		nginx-light \
		runit \
		git

COPY dockerentrypoint.sh /tmp/dockerentrypoint.sh
COPY nginx.conf /etc/nginx/nginx.conf
COPY jekyll.conf /etc/nginx/conf.d/jekyll.conf
COPY dhparams.pem /etc/ssl/dhparams.pem
COPY service/nginx /etc/service/nginx/run
COPY service/cron /etc/service/cron/run
COPY www-data /var/spool/cron/crontabs/www-data

RUN \
	ln -sf /dev/stdout /var/log/nginx/access.log && \
	ln -sf /dev/stderr /var/log/nginx/error.log

RUN \
	chmod +x /tmp/dockerentrypoint.sh && \
	chmod +x /etc/service/nginx/run && \
	chmod +x /etc/service/cron/run && \
	chown root:crontab /var/spool/cron/crontabs/www-data && \
	chmod 0600 /var/spool/cron/crontabs/www-data

EXPOSE 80 443

CMD ["/tmp/dockerentrypoint.sh"]
