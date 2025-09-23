FROM debian:bookworm

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y mariadb-server

COPY ./tools/db_config.sh /db_config.sh

RUN chmod +x /db_config.sh

ENTRYPOINT [ "./db_config.sh" ]
