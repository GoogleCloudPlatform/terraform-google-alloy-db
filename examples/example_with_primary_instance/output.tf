output "project_id" {
  description = "The Project id"
  value       = var.project_id
}

output "cluster_id" {
  description = "The AlloyDB Cluster id"
  value       = module.alloy-db.cluster_id
}

output "primary_instance_id" {
  description = "The Primary Instance ID"
  value       = module.alloy-db.primary_instance_id
}
