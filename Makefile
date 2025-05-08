include .env
-include .envrc

export

run: create_external_networks
# Make sure the import directy is owned by the host, not docker
	@mkdir -p ./import
	docker compose up -d

import_prod_data: run
	@echo "🥫 Importing production data (~2M products) into MongoDB …"
	@echo "🥫 This might take up to 10 mn, so feel free to grab a coffee!"
	@echo "🥫 Removing old archive in case you have one"
	@( rm -f ./import/openfoodfacts-mongodbdump.gz || true ) && ( rm -f ./import/gz-sha256sum || true )
	@echo "🥫 Downloading full MongoDB dump from production …"
# verify sufficient disk space before downloading
# On macOS (Darwin), disk space checks are skipped because macOS handles disk space differently,
# and the check may not be reliable or necessary in this environment.
	@if [ "$$("uname")" = "Darwin" ]; then \
	  echo "🥫 Skipping disk space check on macOS"; \
	else \
	  NEEDED_RAW=$$(curl -sI https://static.openfoodfacts.org/data/openfoodfacts-mongodbdump.gz | awk -F': ' '/[cC]ontent-[lL]ength/ {print $$2}'); \
	  NEEDED_MB=$$((NEEDED_RAW/1048576*2)); \
	  LEFT_RAW=$$(df -k . | tail -1 | awk '{print $$4}'); \
	  LEFT_MB=$$((LEFT_RAW/1024)); \
	  if [ $$LEFT_MB -lt $$NEEDED_MB ]; then \
	    echo "NOT ENOUGH SPACE LEFT ON DEVICE: $$NEEDED_MB MB > $$LEFT_MB MB" >&2; \
	    exit 1; \
	  fi; \
	fi
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
