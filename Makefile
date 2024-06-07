include .env

# Need to override here so we don't pick up values set up off-server
override DOCKER_COMPOSE_RUN=docker compose -p off_shared -f docker-compose.yml -f docker-compose-run.yml

run:
# Make sure the import and dbadata directories are owned by the host, not docker
	@mkdir -p ./import
	@mkdir -p ${MONGODB_DATA_DIR}
	${DOCKER_COMPOSE_RUN} up -d

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
	${DOCKER_COMPOSE_RUN} exec -T mongodb sh -c "cd /data/db && mongorestore --drop --gzip --archive=/import/openfoodfacts-mongodbdump.gz"
	@rm ./import/openfoodfacts-mongodbdump.gz && rm ./import/gz-sha256sum

livecheck:
	@echo "🥫 Running livecheck …"
	docker/docker-livecheck.sh

prune:
	@echo "🥫 Pruning unused Docker artifacts (save space) …"
	docker system prune -af
