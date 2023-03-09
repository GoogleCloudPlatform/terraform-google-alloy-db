output "project_id" {
  description = "The cluster id"
  value       = var.project_id
}

output "cluster_id" {
  description = "The cluster id"
  value       = module.example_with_primary_instance.cluster_id
}

output "primary_instance_id" {
  description = "The Spanner Database details."
  value       = module.example_with_primary_instance.primary_instance_id
}
