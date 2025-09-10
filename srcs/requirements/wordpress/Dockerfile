FROM debian:bookworm

RUN apt-get update  && apt-get install -y curl git wget php php-fpm php-mysql 

COPY conf/auto_config.sh /

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

RUN chmod +x /auto_config.sh

WORKDIR /var/www/wordpress
RUN mkdir -p /run/php

# EXPOSE 9000

ENTRYPOINT [ "bash", "/auto_config.sh" ]

CMD ["php-fpm7.4", "-F"]
