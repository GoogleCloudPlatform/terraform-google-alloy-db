## We need to add outputs to use in the test files.

output "project_id" {
  description = "The cluster id"
  value       = var.project_id
}

output "cluster_id" {
  description = "The cluster id"
  value       = module.example_with_readpool.cluster_id
}

output "primary_instance_id" {
  description = "The Spanner Database details."
  value       = module.example_with_readpool.primary_instance_id
}

output "read_instance_ids" {
  description = "The Spanner Database details."
  value       = module.example_with_readpool.read_instance_ids
}