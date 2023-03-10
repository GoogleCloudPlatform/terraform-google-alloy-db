output "project_id" {
  description = "The Project ID."
  value       = var.project_id
}

output "cluster_id" {
  description = "ID of the AlloyDB cluster created."
  value       = module.example_with_primary_instance.cluster_id
}

output "primary_instance_id" {
  description = "The ID of the primary instance created."
  value       = module.example_with_primary_instance.primary_instance_id
}
