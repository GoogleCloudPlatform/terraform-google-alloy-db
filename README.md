# terraform-google-alloy-db

##
This module handles Google Cloud Platform [AlloyDB](https://cloud.google.com/alloydb) cluster creation and configuration with Automated Backup Policy, Primary node instance and Read Node Pools.
The resources that this module will create are:

- Creates an AlloyDB Cluster with/without automated backup policy
- Creates a Primary Instance
- Creates a pool of Read Instances


## Usage

- Usage of this module for creating a AlloyDB Cluster with a scheduled automated backup policy

```hcl
module "alloy-db" {
  source               = "../.."
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
  source               = "../.."
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

| Name | Description                                                            | Type | Default | Required |
|------|------------------------------------------------------------------------|------|---------|:--------:|
| automated\_backup\_policy | The automated backup policy for this cluster.                          | <pre>object({<br>    location      = optional(string),<br>    backup_window = optional(string),<br>    enabled       = optional(bool),<br>    weekly_schedule = object({<br>      days_of_week = optional(list(string)),<br>      start_times  = list(string),<br>    }),<br>    quantity_based_retention_count = optional(number),<br>    time_based_retention_count     = optional(string),<br>    labels                         = optional(map(string))<br>  })</pre> | <pre>{<br>  "backup_window": "1800s",<br>  "enabled": false,<br>  "labels": {<br>    "test": "alloydb-cluster"<br>  },<br>  "location": "us-central1",<br>  "quantity_based_retention_count": 1,<br>  "time_based_retention_count": "null",<br>  "weekly_schedule": {<br>    "days_of_week": [<br>      "FRIDAY"<br>    ],<br>    "start_times": [<br>      "2:00:00:00"<br>    ]<br>  }<br>}</pre> | no |
| cluster\_display\_name | Display Name for AlloyDB Cluster                                       | `string` | `""` | no |
| cluster\_id | ID of the AlloyDB cluster.                                             | `string` | n/a | yes |
| cluster\_initial\_user | AlloyDB Cluster Initial User Credentials                               | <pre>object({<br>    user     = optional(string),<br>    password = string<br>  })</pre> | <pre>{<br>  "password": "alloydb-cluster-full",<br>  "user": "alloydb-cluster-full"<br>}</pre> | no |
| cluster\_labels | Labels to identify the AlloyDB Cluster                                 | `map(string)` | `{}` | no |
| cluster\_location | Location where AlloyDB cluster will be deployed.                       | `string` | `"us-central1"` | no |
| network\_self\_link | Network ID where the AlloyDB cluster will be deployed.                 | `string` | n/a | yes |
| primary\_instance | Primary cluster configuration that supports read and write operations. | <pre>object({<br>    instance_id       = string,<br>    instance_type     = string,<br>    machine_cpu_count = number,<br>    display_name      = string,<br>    database_flags    = map(string)<br>  })</pre> | n/a | yes |
| project\_id | The project ID to deploy to.                                           | `string` | n/a | yes |
| read\_pool\_instance | List of Read Pool Instances to be created                              | <pre>list(object({<br>    instance_id       = string,<br>    display_name      = string,<br>    instance_type     = string,<br>    node_count        = number,<br>    database_flags    = map(string),<br>    availability_type = string,<br>    ZONE              = string,<br>    machine_cpu_count = number<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_id | ID of the AlloyDB Cluster created |
| primary\_instance\_id | ID of the primary instance created |
| read\_instance\_ids | ID's of the read instances created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v0.13
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v3.0

### Service Account

A service account with the following roles must be used to provision
the resources of this module:

- Storage Admin: `roles/alloydb.admin`

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

