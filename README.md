# terraform-google-alloy-db

##
This module handles Google Cloud Platform [AlloyDB](https://cloud.google.com/alloydb) cluster creation and configuration with Automated Backup Policy, Primary node instance and Read Node Pools.
The resource/resources that this module will create are:

- Creates an AlloyDB Cluster with/without automated backup policy
- Creates a Primary Instance
- Creates a pool of Read Instances

## Compatibility

This module is meant for use with Terraform 1.3+ and tested using Terraform 1.3+. If you find incompatibilities using Terraform >=1.3, please open an issue.

## Version

Current version is 2.X. Upgrade guides:

- [0.1 -> 0.2](/docs/upgrading_to_v0.2.md)
- [0.2 -> 1.0](/docs/upgrading_to_v1.0.md)
- [1.X -> 2.0](/docs/upgrading_to_v2.0.md)

## Usage

- Usage of this module for creating a AlloyDB Cluster with a scheduled automated backup policy

```hcl
module "alloy-db" {
  source               = "GoogleCloudPlatform/alloy-db/google"
  version              = "~> 0.1"
  cluster_id           = "alloydb-cluster"
  cluster_location     = "us-central1"
  project_id           = <"PROJECT_ID">
  cluster_labels       = {}
  cluster_display_name = ""
  cluster_initial_user = {
    user     = "<USER_NAME>",
    password = "<PASSWORD>"
  }
  network_self_link = "projects/${project_id}/global/networks/${network_name}"

  automated_backup_policy = {
    location      = "us-central1"
    backup_window = "1800s",
    enabled       = true,
    weekly_schedule = {
      days_of_week = ["FRIDAY"],
      start_times  = ["2:00:00:00", ]
    }
    quantity_based_retention_count = 1,
    time_based_retention_count     = null,
    labels = {
      test = "alloydb-cluster"
    },
  }
  primary_instance = null

  read_pool_instance = null

  depends_on = [google_compute_network.default, google_compute_global_address.private_ip_alloc, google_service_networking_connection.vpc_connection]
}
```

- Usage of this module for creating a AlloyDB Cluster with a primary instance

```hcl
module "alloy-db" {
  source               = "GoogleCloudPlatform/alloy-db/google"
  version              = "~> 0.1"
  project_id           = <PROJECT_ID>
  cluster_id           = "alloydb-cluster-with-primary-instance"
  cluster_location     = "us-central1"
  cluster_labels       = {}
  cluster_display_name = ""
  cluster_initial_user = {
    user     = "<USER_NAME>",
    password = "<PASSWORD>"
  }
  network_self_link = "projects/${project_id}/global/networks/${network_name}"

  automated_backup_policy = null

  primary_instance = {
    instance_id       = "primary-instance",
    instance_type     = "PRIMARY",
    machine_cpu_count = 2,
    database_flags    = {},
    display_name      = "alloydb-primary-instance"
  }
  read_pool_instance = null

  depends_on = [google_compute_network.default, google_compute_global_address.private_ip_alloc, google_service_networking_connection.vpc_connection]
}
```
Functional examples are included in the
[examples](./examples/) directory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allocated\_ip\_range | The name of the allocated IP range for the private IP AlloyDB cluster. For example: google-managed-services-default. If set, the instance IPs for this cluster will be created in the allocated range | `string` | `null` | no |
| automated\_backup\_policy | The automated backup policy for this cluster. If no policy is provided then the default policy will be used. The default policy takes one backup a day, has a backup window of 1 hour, and retains backups for 14 days | <pre>object({<br>    location      = optional(string)<br>    backup_window = optional(string)<br>    enabled       = optional(bool)<br><br>    weekly_schedule = optional(object({<br>      days_of_week = optional(list(string))<br>      start_times  = list(string)<br>    })),<br><br>    quantity_based_retention_count = optional(number)<br>    time_based_retention_count     = optional(string)<br>    labels                         = optional(map(string))<br>    backup_encryption_key_name     = optional(string)<br>  })</pre> | `null` | no |
| cluster\_display\_name | Human readable display name for the Alloy DB Cluster | `string` | `null` | no |
| cluster\_encryption\_key\_name | The fully-qualified resource name of the KMS key for cluster encryption. Each Cloud KMS key is regionalized and has the following format: projects/[PROJECT]/locations/[REGION]/keyRings/[RING]/cryptoKeys/[KEY\_NAME] | `string` | `null` | no |
| cluster\_id | The ID of the alloydb cluster | `string` | n/a | yes |
| cluster\_initial\_user | Alloy DB Cluster Initial User Credentials | <pre>object({<br>    user     = optional(string),<br>    password = string<br>  })</pre> | `null` | no |
| cluster\_labels | User-defined labels for the alloydb cluster | `map(string)` | `{}` | no |
| cluster\_location | Location where AlloyDb cluster will be deployed. | `string` | n/a | yes |
| continuous\_backup\_enable | Whether continuous backup recovery is enabled. If not set, defaults to true | `bool` | `true` | no |
| continuous\_backup\_encryption\_key\_name | The fully-qualified resource name of the KMS key. Cloud KMS key should be in same region as Cluster and has the following format: projects/[PROJECT]/locations/[REGION]/keyRings/[RING]/cryptoKeys/[KEY\_NAME] | `string` | `null` | no |
| continuous\_backup\_recovery\_window\_days | The numbers of days that are eligible to restore from using PITR (point-in-time-recovery). Defaults to 14 days. The value must be between 1 and 35 | `number` | `14` | no |
| network\_self\_link | Network ID where the AlloyDb cluster will be deployed. | `string` | n/a | yes |
| primary\_cluster\_name | Primary cluster name. Required for creating cross region secondary cluster. Not needed for primary cluster | `string` | `null` | no |
| primary\_instance | Primary cluster configuration that supports read and write operations. | <pre>object({<br>    instance_id       = string,<br>    display_name      = optional(string),<br>    database_flags    = optional(map(string))<br>    labels            = optional(map(string))<br>    annotations       = optional(map(string))<br>    gce_zone          = optional(string)<br>    availability_type = optional(string)<br>    machine_cpu_count = optional(number, 2),<br>  })</pre> | n/a | yes |
| project\_id | The ID of the project in which to provision resources. | `string` | n/a | yes |
| read\_pool\_instance | List of Read Pool Instances to be created | <pre>list(object({<br>    instance_id       = string<br>    display_name      = string<br>    node_count        = optional(number, 1)<br>    database_flags    = optional(map(string))<br>    availability_type = optional(string)<br>    gce_zone          = optional(string)<br>    machine_cpu_count = optional(number, 2)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster | Cluster created |
| cluster\_id | ID of the Alloy DB Cluster created |
| cluster\_name | ID of the Alloy DB Cluster created |
| primary\_instance | Primary instance created |
| primary\_instance\_id | ID of the primary instance created |
| read\_instance\_ids | IDs of the read instances created |
| replica\_instances | Replica instances created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v1.3
- [Terraform Provider for GCP][terraform-provider-gcp] plugin >= v4.77

### Service Account

A service account with the following roles must be used to provision
the resources of this module:

- Cloud AlloyDB Admin: `roles/alloydb.admin`

The [Project Factory module][project-factory-module] and the
[IAM module][iam-module] may be used in combination to provision a
service account with the necessary roles applied.

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

-  `alloydb.googleapis.com`

The [Project Factory module][project-factory-module] can be used to
provision a project with the necessary APIs enabled.

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.

[iam-module]: https://registry.terraform.io/modules/terraform-google-modules/iam/google
[project-factory-module]: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google
[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html

## Security Disclosures

Please see our [security disclosure process](./SECURITY.md).

