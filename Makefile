include .env

run:
	docker compose -p ${SHARED_COMPOSE_PROJECT_NAME} -f docker-compose-run.yml up -d