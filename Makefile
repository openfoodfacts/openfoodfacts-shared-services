include .env
-include .envrc

export

run: create_external_networks
# Make sure the import directory is owned by the host, not docker
	@mkdir -p ./import
	docker compose up --wait

import_prod_data: run
	@echo "🥫 Importing production data (~2M products) into MongoDB …"
	@echo "🥫 This might take up to 10 mn, so feel free to grab a coffee!"
	@echo "🥫 Removing old archive in case you have one"
	@( rm -f ./import/openfoodfacts-mongodbdump.gz || true ) && ( rm -f ./import/gz-sha256sum || true )
	@echo "🥫 Downloading full MongoDB dump from production …"
# verify we got sufficient space, NEEDED is in octet, LEFT in ko, we normalize to MB and NEEDED is multiplied by two (because it also will be imported)
	@NEEDED=$$(curl -s --head https://static.openfoodfacts.org/data/openfoodfacts-mongodbdump.gz|grep -i content-length: |cut -d ":" -f 2|tr -d " \r\n\t"); \
	  LEFT=$$(df . -k --output=avail |tail -n 1); \
	  NEEDED=$$(($$NEEDED/1048576 * 2)); \
	  LEFT=$$(($$LEFT/1024)); \
	  if [[ $$LEFT -lt $$NEEDED ]]; then >&2 echo "NOT ENOUGH SPACE LEFT ON DEVICE: $$NEEDED MB > $$LEFT MB"; exit 1; fi
	wget --no-verbose https://static.openfoodfacts.org/data/openfoodfacts-mongodbdump.gz -P ./import
	wget --no-verbose https://static.openfoodfacts.org/data/gz-sha256sum -P ./import
	cd ./import && sha256sum --check gz-sha256sum
	@echo "🥫 Restoring the MongoDB dump …"
	docker compose exec -T mongodb sh -c "cd /data/db && mongorestore --drop --gzip --archive=/import/openfoodfacts-mongodbdump.gz"
	@rm ./import/openfoodfacts-mongodbdump.gz && rm ./import/gz-sha256sum

restart_db:
	@echo "🥫 Restarting MongoDB database …"
	docker compose restart mongodb

livecheck:
	@echo "🥫 Running livecheck …"
	docker/docker-livecheck.sh

prune:
	@echo "🥫 Pruning unused Docker artifacts (save space) …"
	docker system prune -af --filter="label=com.docker.compose.project=${COMPOSE_PROJECT_NAME}"

create_external_networks:
	docker network create ${COMMON_NET_NAME} || true

# The escaping for this is complicated as psql needs newlines in the SQL and printf seems to be the only way to get them.
# Need to quadruple escape the backslashes for the psql meta commands (like "\if") as bash interprets them first and then printf second.
# Need -T on docker exec to disable the automatic TTY allocation. Otherwise get "the input device is not a TTY"
create_bootstrap:
	@printf "SELECT NOT EXISTS(SELECT 1 FROM pg_roles WHERE rolname = '${PG_BOOTSTRAP_USERNAME}') AS bootstrap_needed \\\\gset \n\
	\\\\if :bootstrap_needed \n\
 		create role ${PG_BOOTSTRAP_USERNAME} with password '${PG_BOOTSTRAP_PASSWORD}' login createdb createrole; \n\
 	\\\\endif \n" | docker compose exec -T -e PGUSER=${POSTGRES_USER} postgresql psql

# Creates a user and database for a service. Database name is the same as the username
# Usage (typically called from another Makefile):
# cd ${DEPS_DIR}/openfoodfacts-shared-services && $(MAKE) create_user username=${MY_SERVICE_USERNAME} password=${MY_SERVICE_PASSWORD}
create_user: create_bootstrap
# Connect as the bootstrap user to create the service user
	@printf "SELECT NOT EXISTS(SELECT 1 FROM pg_roles WHERE rolname = '${username}') AS user_needed \\\\gset \n\
	\\\\if :user_needed \n\
 		create role ${username} with password '${password}' login createdb; \n\
 	\\\\endif \n" | docker compose exec -T -e PGUSER=${PG_BOOTSTRAP_USERNAME} -e PGDATABASE=${POSTGRES_USER} postgresql psql

# Then connect as the service user to create the service database
	@printf "SELECT NOT EXISTS(SELECT FROM pg_database WHERE datname = '${username}') AS db_needed \\\\gset \n\
	\\\\if :db_needed \n\
 		create database ${username}; \n\
 	\\\\endif \n" | docker compose exec -T -e PGUSER=${username} -e PGDATABASE=${POSTGRES_USER} postgresql psql
