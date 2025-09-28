FROM debian:bookworm

RUN apt-get update  && apt-get install -y curl git wget php php-fpm php-mysql

RUN mkdir -p /var/www/html/

COPY conf/wp_config.sh /

RUN chmod +x /wp_config.sh

WORKDIR /var/www/html

RUN mkdir -p /run/php

ENTRYPOINT [ "/wp_config.sh" ]
