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

module "alloydb_source" {
  source  = "GoogleCloudPlatform/alloy-db/google"
  version = "~> 8.0"

  deletion_protection = false

  cluster_id = "source-cluster-${var.region_central}"
  location   = var.region_central
  project_id = var.project_id

  network_self_link = "projects/${var.project_id}/global/networks/${var.network_name}"

  primary_instance = {
    instance_id        = "source-cluster-${var.region_central}-instance1",
    require_connectors = false
    ssl_mode           = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
  }

  depends_on = [
    google_service_networking_connection.vpc_connection,
  ]
}

resource "google_alloydb_backup" "source" {
  project      = var.project_id
  backup_id    = "alloydb-backup"
  location     = "us-central1"
  cluster_name = module.alloydb_source.cluster_name

  depends_on = [module.alloydb_source]
}

module "alloydb_restore_from_backup" {
  source  = "GoogleCloudPlatform/alloy-db/google"
  version = "~> 8.0"

  deletion_protection = false

  cluster_id = "bkup-restored-cluster-${var.region_central}"
  location   = var.region_central
  project_id = var.project_id

  network_self_link = "projects/${var.project_id}/global/networks/${var.network_name}"

  restore_cluster = {
    restore_backup_source = {
      backup_name = google_alloydb_backup.source.name
    }
  }
  primary_instance = {
    instance_id        = "bkup-restored-cluster-${var.region_central}-instance1",
    require_connectors = false
    ssl_mode           = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
  }

  depends_on = [
    google_service_networking_connection.vpc_connection,
  ]
}
