output "cluster_id" {
  description = "The AlloyDB Cluster id"
  value       = module.alloy-db.cluster_id
}

output "primary_instance_id" {
  description = "The primary instance id"
  value       = module.alloy-db.primary_instance_id
}

output "read_instance_ids" {
  description = "The read instance ids"
  value       = module.alloy-db.read_instance_ids
}

output "project_id" {
  description = "Project id"
  value = var.project_id
}