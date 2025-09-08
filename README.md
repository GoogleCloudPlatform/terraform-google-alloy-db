# terraform-google-alloy-db

##
This module handles Google Cloud Platform [AlloyDB](https://cloud.google.com/alloydb) cluster creation and configuration with Automated Backup Policy, Primary node instance and Read Node Pools.
The resource/resources that this module will create are:

- Creates an AlloyDB Cluster with/without automated backup policy
- Creates a Primary Instance
- Creates a pool of Read Instances

You can also create Cross Region Replica using this module. See example in [cross_region_replica](./examples/simple_example/)

## Compatibility

This module is meant for use with Terraform 1.3+ and tested using Terraform 1.3+. If you find incompatibilities using Terraform >=1.3, please open an issue.

## Version

Current version is 8.X. Upgrade guides:

- [1.X -> 2.0](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/blob/main/docs/upgrading_to_v2.0.md)
- [2.X -> 3.0](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/blob/main/docs/upgrading_to_v3.0.md)
- [3.X -> 4.0](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/blob/main/docs/upgrading_to_v4.0.md)
- [6.X -> 7.0](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/blob/main/docs/upgrading_to_v7.0.md)
- [7.X -> 8.0](https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/blob/main/docs/upgrading_to_v8.0.md)

## Usage

- Functional examples are included in the [examples](./examples/) directory.
- If you want to create a cluster with failover replicas and manage complete lifecycle (including failover and switchover) of primary and DR clusters using this module, follow the example in [simple_example](./examples/simple_example/) folder.
- If you are planning to create cluster/instance with private service connect follow example in [private_service_connect](./examples/example_with_private_service_connect/).


Basic usage of this module is as follows:

```hcl
module "alloy-db" {
  source               = "GoogleCloudPlatform/alloy-db/google"
  version              = "~> 8.0"

  project_id           = <"PROJECT_ID">
  cluster_id           = "alloydb-cluster"
  location             = "us-central1"
  cluster_initial_user = {
    user     = "<USER_NAME>"
    password = "<PASSWORD>"
  }
  network_self_link = "projects/${project_id}/global/networks/${network_name}"

  primary_instance = {
    instance_id = "primary-instance"
  }
}
```

- Usage of this module for creating a AlloyDB Cluster with the automated backup policy, a primary instance, zonal and regional read replica instances:

```hcl
module "alloy-db" {
  source               = "GoogleCloudPlatform/alloy-db/google"
  version              = "~> 8.0"

  project_id           = <PROJECT_ID>
  cluster_id           = "alloydb-cluster-with-primary-instance"
  location             = "us-central1"
  cluster_display_name = "cluster-1"
  cluster_initial_user = {
    user     = "<USER_NAME>"
    password = "<PASSWORD>"
  }
  network_self_link = "projects/${project_id}/global/networks/${network_name}"

  automated_backup_policy = {
    location      = "us-central1"
    backup_window = "1800s"
    enabled       = true
    weekly_schedule = {
      days_of_week = ["FRIDAY"]
      start_times  = ["2:00:00:00"]
    }
    quantity_based_retention_count = 1
    labels = {
      test = "alloydb-cluster"
    }
  }
  primary_instance = null

  read_pool_instance = null

}
```

- Usage of this module for creating a AlloyDB Cluster with a primary instance and a read replica instance

```hcl
module "alloy-db" {
  source               = "GoogleCloudPlatform/alloy-db/google"
  version              = "~> 8.0"
  project_id           = <PROJECT_ID>
  cluster_id           = "alloydb-cluster-with-primary-instance"
  location             = "us-central1"
  cluster_labels       = {}
  cluster_display_name = ""
  cluster_initial_user = {
    user     = "<USER_NAME>",
    password = "<PASSWORD>"
  }
  network_self_link = "projects/${project_id}/global/networks/${network_name}"

  automated_backup_policy = null

  primary_instance = {
    instance_id       = "primary-instance"
    instance_type     = "PRIMARY"
    machine_cpu_count = 2
    display_name      = "alloydb-primary-instance"
  }

  read_pool_instance = [
    {
      instance_id        = "cluster-1-rr-1"
      display_name       = "cluster-1-rr-1"
      node_count         = 1 # automatically zonal
      require_connectors = false
      ssl_mode           = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
    },
    {
      instance_id        = "cluster-1-rr-2"
      display_name       = "cluster-1-rr-2"
      node_count         = 2 # automatically regional
      require_connectors = false
      ssl_mode           = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
    }
  ]
}
```


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
| cluster\_type | The type of cluster. If not set, defaults to PRIMARY. Default value is PRIMARY. Possible values are: PRIMARY, SECONDARY | `string` | `"PRIMARY"` | no |
| continuous\_backup\_enable | Whether continuous backup recovery is enabled. If not set, defaults to true | `bool` | `true` | no |
| continuous\_backup\_encryption\_key\_name | The fully-qualified resource name of the KMS key. Cloud KMS key should be in same region as Cluster and has the following format: projects/[PROJECT]/locations/[REGION]/keyRings/[RING]/cryptoKeys/[KEY\_NAME] | `string` | `null` | no |
| continuous\_backup\_recovery\_window\_days | The numbers of days that are eligible to restore from using PITR (point-in-time-recovery). Defaults to 14 days. The value must be between 1 and 35 | `number` | `14` | no |
| database\_version | The database engine major version. This is an optional field and it's populated at the Cluster creation time. This field cannot be changed after cluster creation. Possible valus: POSTGRES\_14, POSTGRES\_15 | `string` | `null` | no |
| deletion\_policy | Policy to determine if the cluster should be deleted forcefully. Deleting a cluster forcefully, deletes the cluster and all its associated instances within the cluster | `string` | `null` | no |
| deletion\_protection | Whether Terraform will be prevented from destroying the cluster. When the field is set to true or unset in Terraform state, a terraform apply or terraform destroy that would delete the cluster will fail. When the field is set to false, deleting the cluster is allowed | `bool` | `true` | no |
| location | Location where AlloyDb cluster will be deployed | `string` | n/a | yes |
| maintenance\_update\_policy | defines the policy for system updates | <pre>object({<br>    maintenance_windows = object({<br>      day = string<br>      start_time = object({<br>        hours = number<br>      })<br>    })<br>  })</pre> | `null` | no |
| network\_attachment\_resource | The network attachment resource created in the consumer project to which the PSC interface will be linked. Needed for AllloyDB outbound connectivity. This is of the format: projects/{CONSUMER\_PROJECT}/regions/{REGION}/networkAttachments/{NETWORK\_ATTACHMENT\_NAME}. The network attachment must be in the same region as the instance | `string` | `null` | no |
| network\_self\_link | Network ID where the AlloyDb cluster will be deployed. If network\_self\_link is set then psc\_enabled should be set to false. The resource link should point to a VPC network in the same project as the cluster, where the cluster resources are created and accessed via Private IP. Any network used, including the default network (if none is specified), must have VPC peering enabled. Learn more at https://cloud.google.com/alloydb/docs/configure-connectivity | `string` | `null` | no |
| primary\_cluster\_name | Primary cluster name. Required for creating cross region secondary cluster. Not needed for primary cluster | `string` | `null` | no |
| primary\_instance | Configure primary instance. Every AlloyDB cluster has one primary instance, providing a read or write access point to your data. See https://cloud.google.com/alloydb/docs/reference/rest/v1/projects.locations.clusters.instances for more details. | <pre>object({<br>    instance_id        = string,<br>    display_name       = optional(string),<br>    database_flags     = optional(map(string))<br>    labels             = optional(map(string))<br>    annotations        = optional(map(string))<br>    gce_zone           = optional(string)<br>    availability_type  = optional(string)<br>    machine_cpu_count  = optional(number, 2)<br>    machine_type       = optional(string)<br>    ssl_mode           = optional(string)<br>    require_connectors = optional(bool)<br>    query_insights_config = optional(object({<br>      query_string_length     = optional(number)<br>      record_application_tags = optional(bool)<br>      record_client_address   = optional(bool)<br>      query_plans_per_minute  = optional(number)<br>    }))<br>    enable_public_ip          = optional(bool, false)<br>    enable_outbound_public_ip = optional(bool, false)<br>    cidr_range                = optional(list(string))<br>  })</pre> | n/a | yes |
| project\_id | The ID of the project in which to provision resources. | `string` | n/a | yes |
| psc\_allowed\_consumer\_projects | List of consumer projects that are allowed to create PSC endpoints to service-attachments to this instance. These should be specified as project numbers only. | `list(string)` | `[]` | no |
| psc\_auto\_connections | List of PSC auto connections. Each connection specifies the consumer network and project for automatic PSC endpoint creation. | <pre>list(object({<br>    consumer_network = string<br>    consumer_project = string<br>  }))</pre> | `[]` | no |
| psc\_enabled | Create an instance that allows connections from Private Service Connect endpoints to the instance. If psc\_enabled is set to true, then network\_self\_link should be set to null, and you must create additional network resources detailed under `examples/example_with_private_service_connect` | `bool` | `false` | no |
| read\_pool\_instance | List of Read Pool Instances to be created | <pre>list(object({<br>    instance_id        = string<br>    display_name       = string<br>    node_count         = optional(number, 1)<br>    database_flags     = optional(map(string))<br>    machine_cpu_count  = optional(number, 2)<br>    machine_type       = optional(string)<br>    ssl_mode           = optional(string)<br>    require_connectors = optional(bool)<br>    query_insights_config = optional(object({<br>      query_string_length     = optional(number)<br>      record_application_tags = optional(bool)<br>      record_client_address   = optional(bool)<br>      query_plans_per_minute  = optional(number)<br>    }))<br>    enable_public_ip = optional(bool, false)<br>    cidr_range       = optional(list(string))<br>  }))</pre> | `[]` | no |
| restore\_cluster | restore cluster from a backup source. Only one of restore\_backup\_source or restore\_continuous\_backup\_source should be set | <pre>object({<br>    restore_backup_source = optional(object({<br>      backup_name = string<br>    }))<br>    restore_continuous_backup_source = optional(object({<br>      cluster       = string<br>      point_in_time = string<br>    }))<br>  })</pre> | `null` | no |
| skip\_await\_major\_version\_upgrade | Set to true to skip awaiting on the major version upgrade of the cluster. Possible values: true, false. Default value: true | `bool` | `true` | no |
| subscription\_type | The subscription type of cluster. Possible values are: TRIAL, STANDARD | `string` | `"STANDARD"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster | Cluster created |
| cluster\_id | ID of the Alloy DB Cluster created |
| cluster\_name | ID of the Alloy DB Cluster created |
| env\_vars | Exported environment variables |
| primary\_instance | Primary instance created |
| primary\_instance\_id | ID of the primary instance created |
| primary\_instance\_ip | The IP address of the primary AlloyDB instance |
| primary\_psc\_attachment\_link | The private service connect (psc) attachment created for primary instance |
| primary\_psc\_dns\_name | The DNS name of the instance for PSC connectivity created for primary instance |
| read\_instance\_ids | IDs of the read instances created |
| read\_instance\_ips | Replica IPs |
| read\_psc\_attachment\_links | The private service connect (psc) attachment created read replica instances |
| read\_psc\_dns\_names | The DNS names of the instances for PSC connectivity created for replica instances |
| replica\_instances | Replica instances created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v1.3
- [Terraform Provider for GCP][terraform-provider-gcp] plugin >= v7.0+

### Service Account

A service account with the following roles must be used to provision
the resources of this module:

- Cloud AlloyDB Admin: `roles/alloydb.admin`

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

-  `alloydb.googleapis.com`

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.

[iam-module]: https://registry.terraform.io/modules/terraform-google-modules/iam/google
[project-factory-module]: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google
[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html

## Security Disclosures

Please see our [security disclosure process](./SECURITY.md).

