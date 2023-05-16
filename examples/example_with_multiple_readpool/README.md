# Cluster with primary instance and multiple readpool

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
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| network\_name | n/a | `string` | `"multiple-readpool"` | no |
| project\_id | n/a | `string` | `"multiple-readpool"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_id | The AlloyDB Cluster id |
| primary\_instance\_id | The primary instance id |
| project\_id | Project id |
| read\_instance\_ids | The read instance ids |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
