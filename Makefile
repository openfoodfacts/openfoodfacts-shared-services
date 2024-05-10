include .env

run:
	docker compose -p ${SHARED_COMPOSE_PROJECT_NAME} up -d