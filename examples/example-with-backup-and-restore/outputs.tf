/**
 * Copyright 2025 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

output "project_id" {
  description = "Project ID of the Alloy DB source Cluster created"
  value       = var.project_id
}

output "source_cluster_id" {
  description = "ID of the Alloy DB source Cluster created"
  value       = module.alloydb_source.cluster_id
}

output "source_primary_instance_id" {
  description = "ID of the source primary instance created"
  value       = module.alloydb_source.primary_instance_id
}

output "source_cluster_name" {
  description = "The name of the source cluster resource"
  value       = module.alloydb_source.cluster_name
}

output "region" {
  description = "The region of the clusters"
  value       = var.region_central
}

output "restored_cluster_id" {
  description = "ID of the restored Alloy DB Cluster created"
  value       = module.alloydb_restore_from_backup.cluster_id
}

output "restored_primary_instance_id" {
  description = "ID of the restored primary instance created"
  value       = module.alloydb_restore_from_backup.primary_instance_id
}

output "restored_cluster_name" {
  description = "The name of the restored cluster resource"
  value       = module.alloydb_restore_from_backup.cluster_name
}
