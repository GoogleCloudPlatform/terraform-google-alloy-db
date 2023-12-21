# Changelog

## [2.0.0](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/compare/v1.1.2...v2.0.0) (2023-11-15)


### ⚠ BREAKING CHANGES

* **TPG >=5.5:** add support for cross region replica cluster ([#47](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/47))

### Features

* **TPG >=5.5:** add support for cross region replica cluster ([#47](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/47)) ([a467efa](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/a467efa1414728f396472d7c1f6ef669bccc2d1a))

## [1.1.2](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/compare/v1.1.1...v1.1.2) (2023-11-09)


### Bug Fixes

* fix bug when accessing gce_zone value in for_each ([#43](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/43)) ([f9e8593](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/f9e8593b1586b017671bbf2762d4d7f588eb9d0f))
* make examples pass `gce_zone` values for read pool instance into module ([#45](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/45)) ([1e9f8bf](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/1e9f8bfcd8225cb665e041e814b8b737b69caa80))

## [1.1.1](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/compare/v1.1.0...v1.1.1) (2023-10-23)


### Bug Fixes

* **deps:** Update Terraform Google Provider to allow v5 (major) ([#34](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/34)) ([15c13f4](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/15c13f440e0c77e64758b9abe2e6c411897f0ae1))

## [1.1.0](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/compare/v1.0.0...v1.1.0) (2023-09-19)


### Features

* increase maximum CPU count allowed in machine_cpu_count validation to 96 ([#31](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/31)) ([e2dcf60](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/e2dcf60b424345327ed1a44798b673bd3a157ea7))

## [1.0.0](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/compare/v0.2.0...v1.0.0) (2023-08-24)


### ⚠ BREAKING CHANGES

* **TPG >=4.77:** add support for continuous backup ([#23](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/23))

### Features

* **TPG >=4.77:** add support for continuous backup ([#23](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/23)) ([83a2dfc](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/83a2dfc1ee2aadcb0c65102beb9ff1c55cb68c28))

## [0.2.0](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/compare/v0.1.0...v0.2.0) (2023-06-13)


### ⚠ BREAKING CHANGES

* **TPG >= 4.64:** added cmek support ([#13](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/13))

### Features

* **TPG >= 4.64:** added cmek support ([#13](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/13)) ([8972ee1](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/8972ee1a75d5f0d18fe0ea35a15edcdb81238e24))

## 0.1.0 (2023-04-10)


### ⚠ BREAKING CHANGES

* **TPG >= 4.58:** fixed integration test ([#6](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/6))

### Bug Fixes

* **TPG >= 4.58:** fixed integration test ([#6](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/6)) ([efd0df9](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/efd0df910cf1e9dd4dab76b2d91856e5338999de))

## Changelog

All notable changes to this project will be documented in this file.

The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).
This changelog is generated automatically based on [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).
