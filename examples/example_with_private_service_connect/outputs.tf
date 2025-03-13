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
  description = "Project ID of the Alloy DB Cluster created"
  value       = var.project_id
}

output "cluster_central" {
  description = "cluster"
  value       = module.alloydb_central.cluster
}

output "primary_instance_central" {
  description = "primary instance created"
  value       = module.alloydb_central.primary_instance
}

output "cluster_id_central" {
  description = "ID of the Alloy DB Cluster created"
  value       = module.alloydb_central.cluster_id
}

output "primary_instance_id_central" {
  description = "ID of the primary instance created"
  value       = module.alloydb_central.primary_instance_id
}

output "read_instance_ids_central" {
  description = "IDs of the read instances created"
  value       = module.alloydb_central.read_instance_ids
}

output "cluster_name_central" {
  description = "The name of the cluster resource"
  value       = module.alloydb_central.cluster_name
}

output "primary_psc_attachment_link_central" {
  description = "The private service connect (psc) attachment created for primary instance"
  value       = module.alloydb_central.primary_psc_attachment_link
}

output "psc_dns_name_central" {
  description = "he DNS name of the instance for PSC connectivity. Name convention: ...alloydb-psc.goog"
  value       = module.alloydb_central.primary_instance.psc_instance_config[0].psc_dns_name
}

output "read_psc_attachment_links_central" {
  value = module.alloydb_central.read_psc_attachment_links
}

output "cluster_east" {
  description = "cluster created"
  value       = module.alloydb_east.cluster
}

output "primary_instance_east" {
  description = "primary instance created"
  value       = module.alloydb_east.primary_instance
}

output "cluster_id_east" {
  description = "ID of the Alloy DB Cluster created"
  value       = module.alloydb_east.cluster_id
}

output "kms_key_name_central" {
  description = "he fully-qualified resource name of the KMS key"
  value       = google_kms_crypto_key.key_region_central.id
}


output "kms_key_name_east" {
  description = "he fully-qualified resource name of the Secondary clusterKMS key"
  value       = google_kms_crypto_key.key_region_east.id
}

output "psc_consumer_fwd_rule_ip" {
  description = "Consumer psc endpoint created"
  value       = google_compute_address.psc_consumer_address.address
}

output "region_central" {
  description = "The region for primary cluster"
  value       = var.region_central
}

output "region_east" {
  description = "The region for cross region replica secondary cluster"
  value       = var.region_east
}

output "psc_attachment" {
  value       = google_compute_network_attachment.psc_attachment
  description = "The network attachment resource created in the consumer project to which the PSC interface will be linked"
}
