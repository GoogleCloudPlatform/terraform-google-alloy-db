# Upgrading to v8.0

The v8.0 release contains backwards-incompatible changes.

## Minimum Provider version change

This update requires upgrading the minimum provider version to `7.23`. This is needed in order to support [deletion_protection](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/version_7_upgrade#resource-google_alloydb_cluster) and [dataplex_config](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/alloydb_cluster#nested_dataplex_config).
