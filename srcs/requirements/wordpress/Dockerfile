FROM debian:bookworm

RUN apt-get update  && apt-get install -y curl git wget php php-fpm php-mysql 

COPY conf/auto_config.sh /

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

RUN chmod +x /auto_config.sh

WORKDIR /var/www/wordpress
RUN mkdir -p /run/php

EXPOSE 9000

ENTRYPOINT [ "bash", "/auto_config.sh" ]

CMD ["php-fpm8.2", "-F"]
