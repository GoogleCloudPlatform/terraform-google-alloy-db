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

module "alloydb_central" {
  source  = "GoogleCloudPlatform/alloy-db/google"
  version = "~> 8.0"

  deletion_protection = false

  cluster_id = "cluster-${var.region_central}-psc"
  location   = var.region_central
  project_id = var.project_id

  psc_enabled                   = true
  psc_allowed_consumer_projects = [var.attachment_project_number]

  cluster_encryption_key_name = google_kms_crypto_key.key_region_central.id

  network_attachment_resource = google_compute_network_attachment.psc_attachment.id
  automated_backup_policy = {
    location      = var.region_central
    backup_window = "1800s"
    enabled       = true
    weekly_schedule = {
      days_of_week = ["FRIDAY"],
      start_times  = ["2:00:00:00", ]
    }
    quantity_based_retention_count = 1
    labels = {
      test = "alloydb-cluster-with-prim"
    }
    backup_encryption_key_name = google_kms_crypto_key.key_region_central.id
  }

  continuous_backup_recovery_window_days = 10
  continuous_backup_encryption_key_name  = google_kms_crypto_key.key_region_central.id

  primary_instance = {
    instance_id        = "cluster-${var.region_central}-instance1-psc",
    require_connectors = false
    ssl_mode           = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
    database_flags = {
      "alloydb.enable_pgaudit"     = "on"
      "alloydb.iam_authentication" = "on"
      "log_connections"            = "on"
      "log_disconnections"         = "on"
      "log_replication_commands"   = "on"
      "log_statement"              = "all"
      "log_timezone"               = "CET"
      "pgaudit.log"                = "ddl,write"
    }
  }

  read_pool_instance = [
    {
      instance_id        = "cluster-${var.region_central}-r1-psc"
      display_name       = "cluster-${var.region_central}-r1-psc"
      require_connectors = false
      ssl_mode           = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
    }
  ]



  depends_on = [
    google_kms_crypto_key_iam_member.alloydb_sa_iam,
    google_kms_crypto_key.key_region_central,
  ]
}

# Create psc endpoing using alloydb psc attachment

resource "google_compute_address" "psc_consumer_address" {
  name    = "psc-consumer-address"
  project = var.attachment_project_id
  region  = var.region_central

  subnetwork   = google_compute_subnetwork.psc_subnet.name
  address_type = "INTERNAL"
  address      = "10.2.0.10"
}

resource "google_compute_forwarding_rule" "psc_consumer_fwd_rule" {
  name    = "psc-consumer-fwd-rule"
  region  = var.region_central
  project = var.attachment_project_id

  target                  = module.alloydb_central.primary_instance.psc_instance_config[0].service_attachment_link
  load_balancing_scheme   = "" # need to override EXTERNAL default when target is a service attachment
  network                 = google_compute_network.psc_vpc.name
  ip_address              = google_compute_address.psc_consumer_address.id
  allow_psc_global_access = true
}

resource "google_dns_managed_zone" "psc_consumer_dns_zone" {
  name    = "psc-consumer-dns-zone"
  project = var.attachment_project_id

  dns_name    = module.alloydb_central.primary_psc_dns_name
  description = "DNS Zone for PSC access to Alloydb"
  visibility  = "private"
  private_visibility_config {
    networks {
      network_url = google_compute_network.psc_vpc.id
    }
  }
}

resource "google_dns_record_set" "psc_consumer_dns_record" {
  name    = module.alloydb_central.primary_psc_dns_name
  project = var.attachment_project_id

  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.psc_consumer_dns_zone.name
  rrdatas      = [google_compute_address.psc_consumer_address.address]
}
