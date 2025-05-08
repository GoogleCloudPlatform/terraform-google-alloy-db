# Example with backup and restore cluster

This example illustrates how to use the `alloy-db` module to [create cluster using backups](https://cloud.google.com/alloydb/docs/backup/restore). It creates two clusters, `source` cluster `source-cluster-us-central1` in `us-central1` and a `restored` cluster `bkup-restores-cluster-us-central1` in `us-central1`.

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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| network\_name | The ID of the network in which to provision resources. | `string` | `"adb-bkup-rest"` | no |
| project\_id | The ID of the project in which to provision resources. | `string` | n/a | yes |
| region\_central | The region for cluster in central us | `string` | `"us-central1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| project\_id | Project ID of the Alloy DB source Cluster created |
| region | The region of the clusters |
| restored\_cluster\_id | ID of the restored Alloy DB Cluster created |
| restored\_cluster\_name | The name of the restored cluster resource |
| restored\_primary\_instance\_id | ID of the restored primary instance created |
| source\_cluster\_id | ID of the Alloy DB source Cluster created |
| source\_cluster\_name | The name of the source cluster resource |
| source\_primary\_instance\_id | ID of the source primary instance created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
