# Simple Example

This example illustrates how to use the `alloy-db` module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| network\_name | The ID of the network in which to provision resources. | `string` | `"simple"` | no |
| project\_id | The ID of the project in which to provision resources. | `string` | n/a | yes |
| region | The region to apply resources within | `string` | `"us-central1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_id | ID of the Alloy DB Cluster created |
| primary\_instance\_id | ID of the primary instance created |
| read\_instance\_ids | IDs of the read instances created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
