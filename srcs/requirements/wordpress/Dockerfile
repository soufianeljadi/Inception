FROM debian:bookworm

RUN apt-get update  && apt-get install -y curl git wget php php-fpm php-mysql 

COPY conf/wp_config.sh /

RUN chmod +x /wp_config.sh

WORKDIR /var/www/wordpress

RUN mkdir -p /run/php

ENTRYPOINT [ "bash", "/wp_config.sh" ]
