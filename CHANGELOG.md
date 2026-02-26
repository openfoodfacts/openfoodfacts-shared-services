# Changelog

## [1.1.0](https://github.com/openfoodfacts/openfoodfacts-shared-services/compare/v1.0.0...v1.1.0) (2026-02-26)


### Features

* better ulimits for services in production ([#32](https://github.com/openfoodfacts/openfoodfacts-shared-services/issues/32)) ([cbb5ae7](https://github.com/openfoodfacts/openfoodfacts-shared-services/commit/cbb5ae780531a8dcb46da82a3659655a9788526e))


### Bug Fixes

* Add restart policy to monitoring services ([#28](https://github.com/openfoodfacts/openfoodfacts-shared-services/issues/28)) ([513b196](https://github.com/openfoodfacts/openfoodfacts-shared-services/commit/513b196e265ca95f48ad793f38e9f848104e0e8c))

## 1.0.0 (2026-01-28)


### Features

* Add shared PostgreSQL database ([3317dc0](https://github.com/openfoodfacts/openfoodfacts-shared-services/commit/3317dc01a4a877199f60621077a9298d1310f1fa))
* Add shared PostgreSQL service ([a243081](https://github.com/openfoodfacts/openfoodfacts-shared-services/commit/a243081e5d12f1f9aabd292b02b32b4a32c80750))


### Bug Fixes

* Balance quotes in deployment ([f5f1e24](https://github.com/openfoodfacts/openfoodfacts-shared-services/commit/f5f1e24faf05fe35e947aa142922c8e288979832))
* Balance quotes in deployment ([f7fc282](https://github.com/openfoodfacts/openfoodfacts-shared-services/commit/f7fc282bbc68508ce09c45ef2a1573837dec6d2e))
* Don't expose ports in raw docker-compose as this is used in PO tests ([d6c5394](https://github.com/openfoodfacts/openfoodfacts-shared-services/commit/d6c5394bb619c1d7b969c8722828446afb1f0bf5))
* Don't include PostgreSQL in the docker-compose file refrenced by PO intergration tests ([#12](https://github.com/openfoodfacts/openfoodfacts-shared-services/issues/12)) ([e13773b](https://github.com/openfoodfacts/openfoodfacts-shared-services/commit/e13773b6bff7cb9b78e4c2a512636650f22ce4cd))
* Explicitly set POSTGRES_EXPOSE ([#16](https://github.com/openfoodfacts/openfoodfacts-shared-services/issues/16)) ([dff82c6](https://github.com/openfoodfacts/openfoodfacts-shared-services/commit/dff82c61400a2a0a6bdac4ca4da7416ba917d9e2))
* Postgres not deploying in staging ([#19](https://github.com/openfoodfacts/openfoodfacts-shared-services/issues/19)) ([8100821](https://github.com/openfoodfacts/openfoodfacts-shared-services/commit/810082150e3fb29e5bd5713ba486d3cbfbf79500))
* Set POSTGRES_EXPOSE correctly ([#11](https://github.com/openfoodfacts/openfoodfacts-shared-services/issues/11)) ([edd7d78](https://github.com/openfoodfacts/openfoodfacts-shared-services/commit/edd7d7835bf5a577a5ce4ae559da710190e0a57d))
