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

locals {
  read_pool_instance = (
    var.read_pool_instance != null ?
    { for read_pool_instances in var.read_pool_instance : read_pool_instances["instance_id"] => read_pool_instances } : {}
  )

  quantity_based_retention_count = (
    var.automated_backup_policy != null ?
    [var.automated_backup_policy.quantity_based_retention_count] : []
  )

  time_based_retention_count = (
    var.automated_backup_policy != null ?
    [var.automated_backup_policy.time_based_retention_count] : []
  )
}

resource "google_alloydb_cluster" "default" {
  cluster_id   = var.cluster_id
  location     = var.cluster_location
  network      = var.network_id
  display_name = var.cluster_display_name
  project      = var.project_id
  
  dynamic "automated_backup_policy" {
    for_each = var.automated_backup_policy != null ? [var.automated_backup_policy] : []
    content {
      location      = automated_backup_policy.value.location
      backup_window = automated_backup_policy.value.backup_window
      enabled       = automated_backup_policy.value.enabled


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
          count = quantity_based_retention.value.quantity_based_retention_count
        }
      }
      dynamic "time_based_retention" {
        for_each = local.time_based_retention_count
        content {
          retention_period = time_based_retention.value.time_based_retention_count
        }
      }
      labels = automated_backup_policy.value.labels
    }

  }

  labels = var.cluster_labels

  initial_user {
    user     = var.cluster_initial_user.user
    password = var.cluster_initial_user.password
  }

}

resource "google_alloydb_instance" "primary" {
  cluster       = google_alloydb_cluster.default.name
  instance_id   = var.primary_instance.instance_id
  instance_type = var.primary_instance.instance_type

  machine_config {
    cpu_count = var.primary_instance.machine_cpu_count
  }

  database_flags = var.primary_instance.database_flags
}

resource "google_alloydb_instance" "read_pool" {
  for_each      = local.read_pool_instance
  cluster       = google_alloydb_cluster.default.name
  instance_id   = each.key
  instance_type = each.value.instance_type

  read_pool_config {
    node_count = each.value.node_count
  }

  database_flags = each.value.database_flags

  depends_on = [google_alloydb_instance.primary]
}



