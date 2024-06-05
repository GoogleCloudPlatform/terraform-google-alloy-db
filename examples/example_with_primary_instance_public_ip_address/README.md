# AlloyDBCluster and primary instance with public IP address

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
| network\_name | The name of the vpc network | `string` | `"primary-instance"` | no |
| project\_id | project ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cluster | cluster |
| cluster\_id | The AlloyDB Cluster id |
| primary\_instance | primary instance created |
| primary\_instance\_id | The Primary Instance ID |
| primary\_instance\_public\_ip\_address | primary instance public IP |
| project\_id | The Project id |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
