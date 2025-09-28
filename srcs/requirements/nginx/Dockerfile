FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && apt-get install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout \
    /etc/nginx/ssl/inception.key -subj "/C=MO/ST=KH/L=KH/O=42/OU=1337/CN=sel-jadi.42.fr/UID=sel-jadi"

COPY conf/nginx.conf /etc/nginx/nginx.conf

ENTRYPOINT ["nginx", "-g", "daemon off;"]