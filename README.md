# Open Food Facts Shared Services

This repository holds the Docker Compose files for core dependencies that provide shared state between a number of Open Food Facts projects. It enables consistent local development environments and shared infrastructure for various Open Food Facts services.

## Table of Contents

- [Overview](#overview)
- [Services Included](#services-included)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Usage](#usage)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Overview

This repository centralizes the configuration of shared services used across the Open Food Facts ecosystem. It includes Compose files to spin up essential databases and other core dependencies required by different microservices and apps in the Open Food Facts family.

## Services Included

The main services orchestrated by the Docker Compose files include:

- **Redis**: In-memory data structure store, used as a database, cache, and message broker.
- **MongoDB**: NoSQL document database, primary storage for several Open Food Facts projects mostly Product Opener, and other that mostly read from it.
- **PostgreSQL**: Relational database, referenced in some Compose files.
- Additional services as referenced in custom Compose or local overrides.

Configuration for these services can be found in:
- [`docker-compose.yml`](docker-compose.yml): Main Compose file, includes core service definitions.
- [`docker-compose-run.yml`](docker-compose-run.yml): Additional Compose configuration for running certain tasks or environments.
- [`.env`](.env): Environment variable overrides for service configuration.

## Getting Started

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

### Quick Start

1. Clone this repository:

   ```bash
   git clone https://github.com/openfoodfacts/openfoodfacts-shared-services.git
   cd openfoodfacts-shared-services
   ```

2. Copy the example environment file and edit as needed:

   ```bash
   cp .env .env.local
   # Edit .env.local for your configuration
   ```

3. Start the core services:

   ```bash
   docker compose up -d
   ```

   Or, for custom setups:

   ```bash
   docker compose -f docker-compose.yml -f docker-compose-run.yml up -d
   ```

## Configuration

- Environment variables are managed via the `.env` file.
- Service-specific configuration (ports, volumes, credentials) is defined in the Compose files.
- You can override or extend services by creating your own Compose override files.

## Usage

- The services will be available on their default ports as configured in the Compose files.
- For development, connect your applications to the services using the addresses and ports defined in `.env`.

## Development

- The [`Makefile`](Makefile) provides shortcuts for common development tasks.
- To stop all services:

  ```bash
  docker compose down
  ```

- For advanced Docker Compose commands or troubleshooting, refer to the [Docker Compose documentation](https://docs.docker.com/compose/).

## Contributing

Contributions are welcome! Please open issues or pull requests for improvements, bug fixes, or additional service configurations.

## License

This repository is distributed under the terms of the [Apache 2.0 License](LICENSE).

## Contact

- [Open Food Facts website](https://openfoodfacts.org/)
- For questions or support, open an issue in this repository.
- We meet regulary [on Mondays for productopener](https://github.com/openfoodfacts/openfoodfacts-server), and [monthly for the infrastructure meeting](https://github.com/openfoodfacts/openfoodfacts-infrastructure)
