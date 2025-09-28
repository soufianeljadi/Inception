FROM debian:bookworm

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y mariadb-server

#allows external containers to connect to the MariaDB server by making it listen on all interfaces
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./tools/db_config.sh /db_config.sh

RUN chmod +x /db_config.sh

ENTRYPOINT [ "./db_config.sh" ]
