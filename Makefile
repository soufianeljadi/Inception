all: build up

build:
	mkdir -p ../data/wordpress ../data/mariadb
	docker compose -f ./srcs/docker-compose.yml build

up:
	docker compose -f ./srcs/docker-compose.yml up -d

down:
	docker compose -f ./srcs/docker-compose.yml down

clean: down
	docker system prune -a --force

fclean: clean
	docker volume prune --force
	docker network prune --force
	sudo rm -rf ../data

re: fclean all

.PHONY: all build up down clean fclean re