#!/bin/bash
DOCKER_APP = app-movie
DOCKER_DB = app-db-movie
UID = $(shell id -u)

help: ## Show this help message
	@echo 'usage: make [target]'
	@echo
	@echo 'targets:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

run: ## Start the containers
	U_ID=${UID} docker-compose up -d
	U_ID=${UID} docker exec -it ${DOCKER_APP} php vendor/bin/phpunit

stop: ## Stop the containers
	U_ID=${UID} docker exec -it ${DOCKER_APP} php vendor/bin/phpunit
	U_ID=${UID} docker-compose down

restart: ## Restart the containers
	U_ID=${UID} docker-compose down && U_ID=${UID} docker-compose up -d

build: ## Rebuilds all the containers
	U_ID=${UID} docker-compose build

ssh-app: ## ssh's into the be container
	U_ID=${UID} docker exec -it ${DOCKER_APP} bash

log-app: ## log app
	U_ID=${UID} docker-compose logs -f -t ${DOCKER_APP}

ssh-db: ## ssh's into the be container
	U_ID=${UID} docker exec -it ${DOCKER_DB} bash

log-db: ## log app
	U_ID=${UID} docker-compose logs -f -t ${DOCKER_DB}

test: ## execute test
	U_ID=${UID} docker exec -it ${DOCKER_APP} php vendor/bin/phpunit

ps: ## view docker processes
	U_ID=${UID} docker ps

services: ## debug:autowiring
	U_ID=${UID} docker exec -it ${DOCKER_APP} bin/console debug:autowiring

fixture: ## fixtures
	U_ID=${UID} docker exec -it ${DOCKER_APP} bin/console doctrine:fixtures:load --append

project-init: ## Init project First
	U_ID=${UID} docker-compose up -d && docker exec -it ${DOCKER_APP} composer install
	U_ID=${UID} docker exec -it ${DOCKER_APP} bin/console doctrine:database:create
	U_ID=${UID} docker exec -it ${DOCKER_APP} bin/console doctrine:schema:create
	U_ID=${UID} docker exec -it ${DOCKER_APP} bin/console doctrine:fixtures:load --append

.PHONY: run stop restart build ssh-app log-app ps composer-install test services project-init fixture
