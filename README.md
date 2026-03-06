# Open Food Facts shared services

This repository holds the docker compose files for core dependencies that provide shared state between a number of Open Food Facts projects.

It is deployed in various way:
* on the developper machine, it's [a dependency of](https://github.com/openfoodfacts/.github/blob/main/docs/service-dependencies.md) of different projects, mainly [openfoodfacts-auth](https://github.com/openfoodfacts/openfoodfacts-auth/), [product opener (aka openfoodfacts-server)](https://github.com/openfoodfacts/openfoodfacts-server/) and [openfoodfacts-query](https://github.com/openfoodfacts/openfoodfacts-query)
* on the staging and production environment, where it is used by the same projects

It provides the following services:
* MongoDB instance, that contains current products (openfoodfacts-server)
* A Postgres instance, which is used by Open Food Facts [minions services](https://openfoodfacts.github.io/openfoodfacts-server/dev/how-to-develop-using-docker/#running-minion-jobs) (openfoodfacts-server), and Keycloak (openfoodfacts-auth)
* A Redis instance mainly used to have streams of events (and also some% sync primitives)
