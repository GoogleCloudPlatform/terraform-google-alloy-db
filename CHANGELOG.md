# Changelog

## [8.0.1](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/compare/v8.0.0...v8.0.1) (2025-09-16)


### Bug Fixes

* added missing validations ([#166](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/166)) ([f2a8b50](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/f2a8b5061f92ceb4a49c348fcc6d557b6633a67b))

## [8.0.0](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/compare/v7.0.1...v8.0.0) (2025-09-08)


### ⚠ BREAKING CHANGES

* **TPG>=7.0:** added deletion protection ([#170](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/170))

### Features

* **TPG>=7.0:** added deletion protection ([#170](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/170)) ([47cf0f7](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/47cf0f7ff389baf434ea2f65faa8311308c9c21b))

## [7.0.1](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/compare/v7.0.0...v7.0.1) (2025-07-22)


### Bug Fixes

* Updating description for adding VPC peering requirement ([#162](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/162)) ([9a85d33](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/9a85d3347f8930c1248bd31cdde189deaab02c97))

## [7.0.0](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/compare/v6.1.0...v7.0.0) (2025-07-17)


### ⚠ BREAKING CHANGES

* **TPG>=6.44:** Adding regex validation to cluster_id and instance_id #157
* **TPG>6.35:** allow psc auto connections ([#154](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/154))

### Features

* **TPG>=6.44:** Adding regex validation to cluster_id and instance_id [#157](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/157) ([29ed94a](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/29ed94a3ed85f9f2d9e9dcbd93da8530d3ea5f63))
* **TPG>6.35:** allow psc auto connections ([#154](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/154)) ([09669c1](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/09669c1944bc258b17bad5f5e4ea3118e4891887))

## [6.1.0](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/compare/v6.0.0...v6.1.0) (2025-06-25)


### Features

* Exposing IPs of read replicas ([#152](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/152)) ([6fab74b](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/6fab74b79959fd54d35ed4e5f2700069b2a240b4))


### Bug Fixes

* Granular permissions ([#146](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/146)) ([1ef6b62](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/1ef6b62dd951466833f87131c8bf5796d35d2f00))

## [6.0.0](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/compare/v5.0.1...v6.0.0) (2025-06-20)


### ⚠ BREAKING CHANGES

* Updating cluster_location variable to location for ADC compliance ([#148](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/148))

### Features

* Updating cluster_location variable to location for ADC compliance ([#148](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/148)) ([a7cab02](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/a7cab0254ad4470c36adef70dbb28cca45719370))

## [5.0.1](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/compare/v5.0.0...v5.0.1) (2025-06-18)


### Bug Fixes

* Exposing env variables to be consumed in ADC ([#143](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/143)) ([1db4c26](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/1db4c26da0b1cb1d4bea85c88ba88f82d23e7912))
* output type fix ([#147](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/147)) ([6825d56](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/6825d56904a5703dd75bd174ea7261f35dbd0eef))

## [5.0.0](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/compare/v4.1.0...v5.0.0) (2025-05-29)


### ⚠ BREAKING CHANGES

* **TPG>6.36:** Allow primary and read pool machine_type.  CPU count can be 1. ([#135](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/135))

### Features

* AlloyDB user management and usability fixes ([#130](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/130)) ([e04b16e](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/e04b16e1dc474debd6d0241b80e0280fe4bda2dc))
* **TPG>6.36:** Allow primary and read pool machine_type.  CPU count can be 1. ([#135](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/135)) ([454206d](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/454206d7bcdba93cbd14dc260107345a7dc13cf9))

## [4.1.0](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/compare/v4.0.0...v4.1.0) (2025-05-08)


### Features

* added restore cluster capability ([#131](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/131)) ([4d3cf12](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/4d3cf12c03b91b19a937c51340a46b03549b40ed))

## [4.0.0](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/compare/v3.3.0...v4.0.0) (2025-03-14)


### ⚠ BREAKING CHANGES

* **TPG>= 6.25:** added psc interfaces for outbound connectivity ([#123](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/123))
* **TPG>= 6.18:** added skip_await_major_version_upgrade, subscription_type, enable_outbound_public_ip ([#120](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/120))

### Features

* **TPG>= 6.18:** added skip_await_major_version_upgrade, subscription_type, enable_outbound_public_ip ([#120](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/120)) ([b758cce](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/b758cce8767e4d045a436959e42beab32f20e955))
* **TPG>= 6.25:** added psc interfaces for outbound connectivity ([#123](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/123)) ([d8d99a7](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/d8d99a734a3a65202147ad31ca5e11003c49de1b))

## [3.3.0](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/compare/v3.2.1...v3.3.0) (2025-02-10)


### Features

* Add Maintenance Update Policy ([#108](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/108)) ([80e4fa7](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/80e4fa7f9af58220601a2182e9f418096ab90904))


### Bug Fixes

* improve guidance and examples for connecting with PSC ([#116](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/116)) ([89ed688](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/89ed68884e76a555ab3a300419259ee87a39b29a))
* perma diff for network_config ([#115](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/115)) ([8de2e80](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/8de2e80c61f38331bb62c72a93e299756a06093c))

## [3.2.1](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/compare/v3.2.0...v3.2.1) (2024-11-11)


### Bug Fixes

* Correct read pool PSC DNS name reference ([#104](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/104)) ([a20453d](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/a20453d60ba70941097d210f28fa7c32d7ffe88c))

## [3.2.0](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/compare/v3.1.0...v3.2.0) (2024-09-11)


### Features

* **deps:** Update Terraform google to v6 ([#99](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/99)) ([2e8d5fd](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/2e8d5fd3561c675e90804f92fcaf3b12c1731a06))

## [3.1.0](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/compare/v3.0.0...v3.1.0) (2024-08-12)


### Features

* add ability to create public read instance ([#90](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/90)) ([3eb87e2](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/3eb87e250ec2bd6c7a6831a039120b140697b05e))
* added doc for switchover between clusters ([#94](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/94)) ([abcb346](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/abcb3466b11fb61287214c295317566c7fa19fef))

## [3.0.0](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/compare/v2.3.0...v3.0.0) (2024-06-10)


### ⚠ BREAKING CHANGES

* **TPG >=5.32:** added support for private service connect ([#85](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/85))

### Features

* enable public ip and authorized external networks ([#82](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/82)) ([5b774b9](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/5b774b97e3634427facc25aa64e97d9e16b5d43a))
* **TPG >=5.32:** added support for private service connect ([#85](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/85)) ([56e9fc9](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/56e9fc97725fe7bdefe8717b027b8a2b63ac1122))

## [2.3.0](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/compare/v2.2.0...v2.3.0) (2024-03-26)


### Features

* add support for query insights support ([#71](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/71)) ([3287298](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/328729820f67a0e51d04ba3a4a0ea7f50e0d61e7))


### Bug Fixes

* continuous_backup_config and automated_backup_policy issue for failover replica ([#72](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/72)) ([3cf0cc4](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/3cf0cc42affe43dd228ad77ae76f917cf5bbf560))

## [2.2.0](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/compare/v2.1.0...v2.2.0) (2024-02-14)


### Features

* Enable support for database version ([#65](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/65)) ([8a03b9d](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/8a03b9ded36c22da5af695c12e2f76bd0372047c))

## [2.1.0](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/compare/v2.0.0...v2.1.0) (2024-02-12)


### Features

* 128 vCPU support for instances ([#64](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/64)) ([2e9402d](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/2e9402db75129c99f1f597a1ab1a446d51f385d2))
* Add support for SSL enforcement modes ([#59](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/issues/59)) ([a946b67](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/commit/a946b67b9d4d5cc99695fbd390e14e501250ed1a))

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
