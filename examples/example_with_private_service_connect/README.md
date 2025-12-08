# Example AlloyDB with private service connect (PSC) enabled

This example illustrates how to use the `alloy-db` module to deploy a cluster with private service connect (PSC) enabled. This example creates:

- VPC and subnet in project passed in `attachment_project_id`.
- Creates a network attachment in `attachment_project_id` to which the AlloyDB PSC interface will be linked. Needed only if AlloyDB needs to connect outbound
- alloyDB cluster/instances in region us-central1 in project passed in `project_id`.
- alloyDB cross region replica cluster/instances in region us-east1 in project passed in `project_id`.
- Creates consumer psc endpoint using alloyDB psc attachment in project passed in `attachment_project_id`.

## Usage

To run this example you need to execute:

```bash
export TF_VAR_project_id="your_project_id"
export TF_VAR_attachment_project_id="project_id_for_psc_endpoint"
export TF_VAR_attachment_project_number="project_number_for_psc_endpoint"
```

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

## Additional resources deployed outside of the module

In order to [connect to Alloydb with language connectors](https://cloud.google.com/alloydb/docs/connect-language-connectors#python-pg8000_1), additional networking resources are required.

In addition to setting the flag `psc_enabled = true` in this module, you must must create the following network resources outside of the module:

- `google_compute_address`
- `google_compute_forwarding_rule`
- `google_dns_managed_zone`
- `google_dns_record_set`

For details, see [main.tf](./main.tf) in this example folder.

## Failover to Instance 2

There are two clusters deployed in this example. `cluster east` is the primary cluster and `cluster central` is the failover replica. Steps to promote `cluster east` as primary and change `cluster central` as failover replica

1. remove `primary_cluster_name` from `cluster east` and Execute `terraform apply`

```diff
module "alloydb_east" {
  source  = "GoogleCloudPlatform/alloy-db/google"
  version = "~> 8.0"

  ## Comment this out in order to promote cluster as primary cluster
-  primary_cluster_name = module.alloydb_central.cluster_name
}
```

2. Remove cluster 1 by removing cluster 1 code and Execute `terraform apply`

```diff
- module "alloydb_central" {
-   source  = "GoogleCloudPlatform/alloy-db/google"
-   version = "~> 2.0"
-   cluster_id       = "cluster-${var.region_central}-psc"
-   location         = var.region_central
-   project_id       = var.project_id
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

3. Create cluster 1 as failover replica by adding cluster 1 code with following additional line and Execute `terraform apply`

```diff
module "alloydb_central" {
  source  = "GoogleCloudPlatform/alloy-db/google"
  version = "~> 2.0"

+  primary_cluster_name = module.alloydb_east.cluster_name

  cluster_id       = "cluster-1"
  location         = var.region1
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
| attachment\_project\_id | The ID of the project in which attachment will be provisioned | `string` | n/a | yes |
| attachment\_project\_number | The project number in which attachment will be provisioned | `string` | n/a | yes |
| project\_id | The ID of the project in which to provision resources. | `string` | n/a | yes |
| region\_central | The region for cluster in central us | `string` | `"us-central1"` | no |
| region\_east | The region for cluster in east us | `string` | `"us-east1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_central | cluster |
| cluster\_east | cluster created |
| cluster\_id\_central | ID of the Alloy DB Cluster created |
| cluster\_id\_east | ID of the Alloy DB Cluster created |
| cluster\_name\_central | The name of the cluster resource |
| kms\_key\_name\_central | he fully-qualified resource name of the KMS key |
| kms\_key\_name\_east | he fully-qualified resource name of the Secondary clusterKMS key |
| primary\_instance\_central | primary instance created |
| primary\_instance\_east | primary instance created |
| primary\_instance\_id\_central | ID of the primary instance created |
| primary\_psc\_attachment\_link\_central | The private service connect (psc) attachment created for primary instance |
| project\_id | Project ID of the Alloy DB Cluster created |
| psc\_attachment | The network attachment resource created in the consumer project to which the PSC interface will be linked |
| psc\_consumer\_fwd\_rule\_ip | Consumer psc endpoint created |
| psc\_dns\_name\_central | he DNS name of the instance for PSC connectivity. Name convention: ...alloydb-psc.goog |
| read\_instance\_ids\_central | IDs of the read instances created |
| read\_psc\_attachment\_links\_central | n/a |
| region\_central | The region for primary cluster |
| region\_east | The region for cross region replica secondary cluster |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
