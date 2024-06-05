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

output "cluster" {
  description = "cluster"
  value       = module.alloy-db.cluster
}

output "primary_instance" {
  description = "primary instance created"
  value       = module.alloy-db.primary_instance
}

output "primary_instance_public_ip_address" {
  description = "primary instance public IP"
  value       = module.alloy-db.primary_instance.public_ip_address
}
