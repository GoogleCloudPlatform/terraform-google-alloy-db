output "cluster_id" {
  description = "The cluster id"
  value       = module.alloy-db.cluster_id
}

output "primary_instance_id" {
  description = "The Spanner Database details."
  value       = module.alloy-db.primary_instance_id
}

output "read_instance_ids" {
  description = "The Spanner Database details."
  value       = module.alloy-db.read_instance_ids
}