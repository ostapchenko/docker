#!make
include .env
export $(shell sed 's/=.*//' .env)

.PHONY: build
build:
	docker-compose up -d --build
	make composer
	make migrate

.PHONY: up
up:
	docker-compose up -d
	make migrate

.PHONY: down
down:
	docker-compose down

.PHONY: web-bash
web-bash:
	docker-compose exec web bash

.PHONY: mysql
mysql:
	docker-compose exec mysql mysql -u ${MYSQL_USERNAME} -p${MYSQL_PASSWORD}

.PHONY: bash
bash:
	@read -p "ENTER SERVICE NAME: " BASH_SERVICE_NAME \
	&& docker-compose exec $${BASH_SERVICE_NAME} bash

.PHONY: composer
composer:
	docker-compose exec -w ${APP_PATH} web composer install

.PHONY: migrate
migrate:
	docker-compose exec -w ${APP_PATH} web php bin/console db:migrate

.PHONY: ngrok
ngrok:
	ngrok http -host-header=${APP_HOST} 80
