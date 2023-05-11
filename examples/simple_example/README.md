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
| region | The region to apply resources within | `string` | `"us-central1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_id | ID of the Alloy DB Cluster created |
| primary\_instance\_id | ID of the primary instance created |
| project\_id | Project ID of the Alloy DB Cluster created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
