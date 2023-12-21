/**
 * Copyright 2021 Google LLC
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

output "cluster_id" {
  description = "ID of the Alloy DB Cluster created"
  value       = module.alloy-db.cluster_id
}

output "primary_instance_id" {
  description = "ID of the primary instance created"
  value       = module.alloy-db.primary_instance_id
}

output "project_id" {
  description = "Project ID of the Alloy DB Cluster created"
  value       = var.project_id
}

output "kms_key_name" {
  description = "he fully-qualified resource name of the KMS key"
  value       = google_kms_crypto_key.key.id
}

output "cluster_name" {
  description = "The name of the cluster resource"
  value       = module.alloy-db.cluster_name
}

output "region" {
  description = "The region for primary cluster"
  value       = var.region
}

output "secondary_region" {
  description = "The region for cross region replica secondary cluster"
  value       = var.secondary_region
}

output "secondary_cluster_id" {
  description = "ID of the Secondary Alloy DB Cluster created"
  value       = module.alloy-db-secondary.cluster_id
}

output "secondary_primary_instance_id" {
  description = "ID of the Secondary Cluster primary instance created"
  value       = module.alloy-db-secondary.primary_instance_id
}

output "secondary_kms_key_name" {
  description = "he fully-qualified resource name of the Secondary clusterKMS key"
  value       = google_kms_crypto_key.key_secondary.id
}

output "secondary_cluster_name" {
  description = "The name of the Secondary cluster resource"
  value       = module.alloy-db-secondary.cluster_name
}
