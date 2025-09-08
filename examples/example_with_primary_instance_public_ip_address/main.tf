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

module "alloy-db" {
  source  = "GoogleCloudPlatform/alloy-db/google"
  version = "~> 8.0"

  deletion_protection = false

  project_id = var.project_id
  cluster_id = "alloydb-cluster-with-prim"
  location   = "us-central1"

  network_self_link           = "projects/${var.project_id}/global/networks/${var.network_name}"
  cluster_encryption_key_name = google_kms_crypto_key.key.id

  primary_instance = {
    instance_id       = "primary-instance"
    instance_type     = "PRIMARY"
    machine_cpu_count = 2

    database_flags = {
      "google_columnar_engine.scan_mode" = "2"
      "password.enforce_complexity"      = "on" # parameter is needed for instance with public IP address
    }

    display_name       = "alloydb-primary-instance"
    enable_public_ip   = true
    require_connectors = false
    ssl_mode           = "ENCRYPTED_ONLY"
  }

  depends_on = [
    google_compute_network.default,
    google_compute_global_address.private_ip_alloc,
    google_service_networking_connection.vpc_connection,
    google_kms_crypto_key_iam_member.alloydb_sa_iam
  ]
}

resource "google_compute_network" "default" {
  name    = var.network_name
  project = var.project_id
}


resource "google_compute_global_address" "private_ip_alloc" {
  project       = var.project_id
  name          = "adb-private-ip"
  address_type  = "INTERNAL"
  purpose       = "VPC_PEERING"
  prefix_length = 16
  network       = google_compute_network.default.id
}

resource "google_service_networking_connection" "vpc_connection" {
  network                 = google_compute_network.default.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
  deletion_policy         = "ABANDON"
}
