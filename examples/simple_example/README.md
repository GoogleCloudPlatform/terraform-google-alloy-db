# Simple Example

This example illustrates how to use the `alloy-db` module.

## Usage

To run this example you need to execute:

```bash
export TF_VAR_project_id="your_project_id"
```

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

## Failover to Instance 2

There are two clusters deployed in this example. `cluster east` is the primary cluster and `cluster central` is the failover replica. Steps to promote `cluster east` as primary and change `cluster central` as failover replica

1) remove  `primary_cluster_name` from `cluster east` and Execute `terraform apply`

```diff
module "alloydb_east" {
  source  = "GoogleCloudPlatform/alloy-db/google"
  version = "~> 3.0"

  ## Comment this out in order to promote cluster as primary cluster
-  primary_cluster_name = module.alloydb_central.cluster_name
}
```

2) Remove cluster 1 by removing cluster 1 code and Execute `terraform apply`

```diff
- module "alloydb_central" {
-   source  = "GoogleCloudPlatform/alloy-db/google"
-   version = "~> 2.0"
-   cluster_id       = "cluster-1"
-   cluster_location = var.region1
-   project_id       = var.project_id
-   network_self_link           = "projects/${var.project_id}/global/networks/${var.network_name}"
-   cluster_encryption_key_name = google_kms_crypto_key.key_region1.id
- ...
- }
- output "cluster_id" {
-   description = "ID of the Alloy DB Cluster created"
-   value       = module.alloydb_central.cluster_id
- }
- output "primary_instance_id" {
-   description = "ID of the primary instance created"
-   value       = module.alloydb_central.primary_instance_id
- }
- output "cluster_name" {
-   description = "The name of the cluster resource"
-   value       = module.alloydb_central.cluster_name
- }
```

3) Create cluster 1 as failover replica by adding cluster 1 code with following additional line and Execute `terraform apply`

```diff
module "alloydb_central" {
  source  = "GoogleCloudPlatform/alloy-db/google"
  version = "~> 2.0"

+  primary_cluster_name = module.alloydb_east.cluster_name

  cluster_id       = "cluster-1"
  cluster_location = var.region1
  project_id       = var.project_id

  network_self_link           = "projects/${var.project_id}/global/networks/${var.network_name}"
  cluster_encryption_key_name = google_kms_crypto_key.key_region1.id
...
  depends_on = [
-    module.alloydb_central,
    google_service_networking_connection.vpc_connection,
    google_kms_crypto_key_iam_member.alloydb_sa_iam_secondary,
  ]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| network\_name | The ID of the network in which to provision resources. | `string` | `"simple-adb"` | no |
| project\_id | The ID of the project in which to provision resources. | `string` | n/a | yes |
| region\_central | The region for cluster in central us | `string` | `"us-central1"` | no |
| region\_east | The region for cluster in east us | `string` | `"us-east1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_id | ID of the Alloy DB Cluster created |
| cluster\_name | The name of the cluster resource |
| kms\_key\_name | he fully-qualified resource name of the KMS key |
| primary\_instance\_id | ID of the primary instance created |
| project\_id | Project ID of the Alloy DB Cluster created |
| region | The region for primary cluster |
| secondary\_cluster\_id | ID of the Secondary Alloy DB Cluster created |
| secondary\_cluster\_name | The name of the Secondary cluster resource |
| secondary\_kms\_key\_name | he fully-qualified resource name of the Secondary clusterKMS key |
| secondary\_primary\_instance\_id | ID of the Secondary Cluster primary instance created |
| secondary\_region | The region for cross region replica secondary cluster |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
