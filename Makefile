-include .env
export $(shell sed 's/=.*//' .env)


.PHONY: env_var
env_var: # Print environnement variables
	@cat .env

.PHONY: env
env: # Create .env and tweak it before init
	cp .env.default .env

.PHONY: init
init:
	mkdir -p config

.PHONY: erase
erase:
	rm -rf config

.PHONY: pull
pull: # Pull the docker image
	docker pull gitlab/gitlab-runner:${GITLAB_RUNNER_TAG}

.PHONY: config
config: # Show docker-compose configuration
	docker-compose -f docker-compose.yml config

.PHONY: up
up: # Start containers and services
	docker-compose -f docker-compose.yml up -d

.PHONY: down
down: # Stop containers and services
	docker-compose -f docker-compose.yml down

.PHONY: start
start: # Start containers
	docker-compose -f docker-compose.yml start

.PHONY: stop
stop: # Stop containers
	docker-compose -f docker-compose.yml stop

.PHONY: restart
restart: # Restart container
	docker-compose -f docker-compose.yml restart

.PHONY: delete
delete: down erase

.PHONY: mount
mount: init up

.PHONY: reset
reset: down up

.PHONY: hard-reset
hard-reset: delete mount

.PHONY: logs
logs:
	docker-compose logs -f

.PHONY: shell
shell: # Open a shell on a started container
	docker exec -it ${GITLAB_RUNNER_CONTAINER} /bin/bash

.PHONY: gitlab-runner
gitlab-runner:
	docker exec -it ${GITLAB_RUNNER_CONTAINER} gitlab-runner ${ARGS}

.PHONY: gitlab-runner-help
gitlab-runner-help:
	docker exec -it ${GITLAB_RUNNER_CONTAINER} gitlab-runner --help

.PHONY: gitlab-runner-register
gitlab-runner-register:
	docker exec -it ${GITLAB_RUNNER_CONTAINER} gitlab-runner register
