.PHONY: all build up down clean fclean re

all: build up

build:
	@mkdir -p ../data/wordpress ../data/database
	@docker-compose -f ./srcs/docker-compose.yml build

up:
	@docker-compose -f ./srcs/docker-compose.yml up -d

down:
	@docker-compose -f ./srcs/docker-compose.yml down

clean: down
	@docker system prune -a --force

fclean: clean
	@rm -rf ../data
	@docker volume prune --force
	@docker network prune --force

re: fclean all