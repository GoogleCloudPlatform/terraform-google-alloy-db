/**
 * Copyright 2023 Google LLC
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

locals {
  read_pool_instance = (
    var.read_pool_instance != null ?
    { for read_pool_instances in var.read_pool_instance : read_pool_instances["instance_id"] => read_pool_instances } : {}
  )

  quantity_based_retention_count = (
    var.automated_backup_policy != null ? (var.automated_backup_policy.quantity_based_retention_count != null ? [var.automated_backup_policy.quantity_based_retention_count] : []) : []
  )

  time_based_retention_count = (
    var.automated_backup_policy != null ? (var.automated_backup_policy.time_based_retention_count != null ? [var.automated_backup_policy.time_based_retention_count] : []) : []
  )

  is_secondary_cluster = var.primary_cluster_name != null
}

resource "google_alloydb_cluster" "default" {
  cluster_id      = var.cluster_id
  location        = var.cluster_location
  display_name    = var.cluster_display_name
  project         = var.project_id
  labels          = var.cluster_labels
  cluster_type    = local.is_secondary_cluster ? "SECONDARY" : "PRIMARY"
  deletion_policy = local.is_secondary_cluster ? "FORCE" : null

  network_config {
    network            = var.network_self_link
    allocated_ip_range = var.allocated_ip_range
  }

  # N/A for secondary cluster
  dynamic "automated_backup_policy" {
    for_each = var.automated_backup_policy != null && !local.is_secondary_cluster ? [var.automated_backup_policy] : []
    content {
      location      = automated_backup_policy.value.location
      backup_window = automated_backup_policy.value.backup_window
      enabled       = automated_backup_policy.value.enabled
      labels        = automated_backup_policy.value.labels


      weekly_schedule {
        days_of_week = automated_backup_policy.value.weekly_schedule.days_of_week
        dynamic "start_times" {
          for_each = { for i, time in automated_backup_policy.value.weekly_schedule.start_times : i => {
            hours   = tonumber(split(":", time)[0])
            minutes = tonumber(split(":", time)[1])
            seconds = tonumber(split(":", time)[2])
            nanos   = tonumber(split(":", time)[3])
            }
          }
          content {
            hours   = start_times.value.hours
            minutes = start_times.value.minutes
            seconds = start_times.value.seconds
            nanos   = start_times.value.nanos
          }
        }
      }

      dynamic "quantity_based_retention" {
        for_each = local.quantity_based_retention_count
        content {
          count = quantity_based_retention.value
        }
      }

      dynamic "time_based_retention" {
        for_each = local.time_based_retention_count
        content {
          retention_period = time_based_retention.value
        }
      }

      dynamic "encryption_config" {
        for_each = automated_backup_policy.value.backup_encryption_key_name == null ? [] : ["encryption_config"]
        content {
          kms_key_name = automated_backup_policy.value.backup_encryption_key_name
        }
      }

    }

  }

  # N/A for secondary cluster
  dynamic "continuous_backup_config" {
    for_each = var.continuous_backup_enable && !local.is_secondary_cluster ? ["continuous_backup_config"] : []
    content {
      enabled              = var.continuous_backup_enable
      recovery_window_days = var.continuous_backup_recovery_window_days
      dynamic "encryption_config" {
        for_each = var.continuous_backup_encryption_key_name == null ? [] : ["cont_backup_encryption_config"]
        content {
          kms_key_name = var.continuous_backup_encryption_key_name
        }
      }

    }
  }

  dynamic "initial_user" {
    for_each = var.cluster_initial_user == null ? [] : ["cluster_initial_user"]
    content {
      user     = var.cluster_initial_user.user
      password = var.cluster_initial_user.password
    }
  }

  dynamic "encryption_config" {
    for_each = var.cluster_encryption_key_name == null ? [] : ["encryption_config"]
    content {
      kms_key_name = var.cluster_encryption_key_name
    }
  }

  ## Needed for Secondary Cluster
  dynamic "secondary_config" {
    for_each = local.is_secondary_cluster ? ["secondary_config"] : []
    content {
      primary_cluster_name = var.primary_cluster_name
    }
  }

}

resource "google_alloydb_instance" "primary" {
  cluster           = google_alloydb_cluster.default.name
  instance_id       = var.primary_instance.instance_id
  instance_type     = google_alloydb_cluster.default.cluster_type
  display_name      = var.primary_instance.display_name
  database_flags    = var.primary_instance.database_flags
  labels            = var.primary_instance.labels
  annotations       = var.primary_instance.annotations
  availability_type = var.primary_instance.availability_type
  gce_zone          = var.primary_instance.availability_type == "ZONAL" ? var.primary_instance.gce_zone : null

  machine_config {
    cpu_count = var.primary_instance.machine_cpu_count
  }

  lifecycle {
    ignore_changes = [instance_type]
  }

}

# Cannot create for secondary cluster
resource "google_alloydb_instance" "read_pool" {
  for_each          = local.read_pool_instance
  cluster           = google_alloydb_cluster.default.name
  instance_id       = each.key
  instance_type     = "READ_POOL"
  availability_type = each.value.availability_type
  gce_zone          = each.value.availability_type == "ZONAL" ? each.value.gce_zone : null
  labels            = var.primary_instance.labels
  annotations       = var.primary_instance.annotations

  read_pool_config {
    node_count = each.value.node_count
  }

  database_flags = each.value.database_flags
  machine_config {
    cpu_count = each.value.machine_cpu_count
  }


  depends_on = [google_alloydb_instance.primary]
}
