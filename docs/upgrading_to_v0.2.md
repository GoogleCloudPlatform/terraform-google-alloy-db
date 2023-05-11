# Upgrading to v0.2

The v0.2 release contains backwards-incompatible changes.

## Miimum Provider version change
This update requires upgrading the minimum provider version from `4.58` to `4.64`.

## [Terraform](https://www.terraform.io/downloads.html) >= 1.3.0 is required as attributes and objects are made optional
Since [optional attributes](https://developer.hashicorp.com/terraform/language/expressions/type-constraints#optional-object-type-attributes) is a version 1.3 feature, the configuration will fail if the pinned version is < 1.3.


## instance_type removed from primary_instance and read_pool_instance variables
Since the value `instance_type` is fixed for primary instance `PRIMARY` and replica pool `READ_POOL`, it is removed and hard coded to avoid any confusion.


## Default value change

- `cluster_display_name` variable default value changed to `null` from ""
- `cluster_initial_user` variable default value changed to `null`
- `automated_backup_policy` variable default value changed to `null`
- `machine_cpu_count` is optional in `primary_instance` and `read_pool_instance` and default value will be `2`
- `node_count` is optional in `read_pool_instance` and default value will be `1`
