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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| network\_name | The ID of the network in which to provision resources. | `string` | `"simple"` | no |
| project\_id | The ID of the project in which to provision resources. | `string` | n/a | yes |
| region | The region for primary cluster | `string` | `"us-central1"` | no |
| secondary\_region | The region for cross region replica secondary cluster | `string` | `"us-east1"` | no |

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
