## We need to add outputs to use in the test files.

output "cluster_id" {
  description = "The cluster id"
  value       = module.example_with_multiple_readpool.cluster_id
}

output "primary_instance_id" {
  description = "The primary instance id details."
  value       = module.example_with_multiple_readpool.primary_instance_id
}

output "read_instance_ids" {
  description = "The read instance details"
  value       = module.example_with_multiple_readpool.read_instance_ids
}

output "project_id" {
  description = "project id"
  value = module.example_with_multiple_readpool.project_id
  
}