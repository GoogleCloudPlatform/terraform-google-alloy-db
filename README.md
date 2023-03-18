# terraform-google-alloy-db

##
https://console.developers.google.com/apis/api/servicenetworking.googleapis.com/overview?project=615771372926

https://console.developers.google.com/apis/api/alloydb.googleapis.com/overview?project=615771372926

## Description
### tagline
This is an auto-generated module.

### detailed
This module was generated from [terraform-google-module-template](https://github.com/terraform-google-modules/terraform-google-module-template/), which by default generates a module that simply creates a GCS bucket. As the module develops, this README should be updated.

The resources/services/activations/deletions that this module will create/trigger are:

- Create a GCS bucket with the provided name

### preDeploy
To deploy this blueprint you must have an active billing account and billing permissions.

## Documentation
- [Hosting a Static Website](https://cloud.google.com/storage/docs/hosting-static-website)

## Usage

Basic usage of this module is as follows:

```hcl
module "alloy_db" {
  source  = "terraform-google-modules/alloy-db/google"
  version = "~> 0.1"

  project_id  = "<PROJECT ID>"
  bucket_name = "gcs-test-bucket"
}
```

Functional examples are included in the
[examples](./examples/) directory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| automated\_backup\_policy | The automated backup policy for this cluster. | <pre>object({<br>    location      = optional(string),<br>    backup_window = optional(string),<br>    enabled       = optional(bool),<br>    weekly_schedule = object({<br>      days_of_week = optional(list(string)),<br>      start_times  = list(string),<br>    }),<br>    quantity_based_retention_count = optional(number),<br>    time_based_retention_count     = optional(string),<br>    labels                         = optional(map(string))<br>  })</pre> | <pre>{<br>  "backup_window": "1800s",<br>  "enabled": false,<br>  "labels": {<br>    "test": "alloydb-cluster"<br>  },<br>  "location": "us-central1",<br>  "quantity_based_retention_count": 1,<br>  "time_based_retention_count": "null",<br>  "weekly_schedule": {<br>    "days_of_week": [<br>      "FRIDAY"<br>    ],<br>    "start_times": [<br>      "2:00:00:00"<br>    ]<br>  }<br>}</pre> | no |
| cluster\_display\_name | Display Name for Alloy DB Cluster | `string` | `""` | no |
| cluster\_id | Configuration of the AlloyDb cluster. | `string` | n/a | yes |
| cluster\_initial\_user | Alloy DB Cluster Initial User Credentials | <pre>object({<br>    user     = optional(string),<br>    password = string<br>  })</pre> | <pre>{<br>  "password": "alloydb-cluster-full",<br>  "user": "alloydb-cluster-full"<br>}</pre> | no |
| cluster\_labels | Labels to identify the Alloy DB Cluster | `map(string)` | `{}` | no |
| cluster\_location | Location where AlloyDb cluster will be deployed. | `string` | `"us-central1"` | no |
| network\_self\_link | Network ID where the AlloyDb cluster will be deployed. | `string` | n/a | yes |
| primary\_instance | Primary cluster configuration that supports read and write operations. | <pre>object({<br>    instance_id       = string,<br>    instance_type     = string,<br>    machine_cpu_count = number,<br>    display_name      = string,<br>    database_flags    = map(string)<br>  })</pre> | n/a | yes |
| project\_id | The ID of the project in which to provision resources. | `string` | n/a | yes |
| read\_pool\_instance | List of Read Pool Instances to be created | <pre>list(object({<br>    instance_id       = string,<br>    display_name      = string,<br>    instance_type     = string,<br>    node_count        = number,<br>    database_flags    = map(string),<br>    availability_type = string,<br>    ZONE              = string,<br>    machine_cpu_count = number<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_id | ID of the Alloy DB Cluster created |
| primary\_instance\_id | ID of the primary instance created |
| read\_instance\_ids | IDs of the read instances created |

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

- Storage Admin: `roles/storage.admin`

The [Project Factory module][project-factory-module] and the
[IAM module][iam-module] may be used in combination to provision a
service account with the necessary roles applied.

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- Google Cloud Storage JSON API: `storage-api.googleapis.com`

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
