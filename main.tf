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

locals {
  read_pool_instance = {
    for read_pool_instances in var.read_pool_instance :
    read_pool_instances["instance_id"] => read_pool_instances
  }

  quantity_based_retention_count = (
    var.automated_backup_policy != null ? (var.automated_backup_policy.quantity_based_retention_count != null ? [var.automated_backup_policy.quantity_based_retention_count] : []) : []
  )

  time_based_retention_count = (
    var.automated_backup_policy != null ? (var.automated_backup_policy.time_based_retention_count != null ? [var.automated_backup_policy.time_based_retention_count] : []) : []
  )

  is_secondary_cluster = var.primary_cluster_name != null
}

resource "google_alloydb_cluster" "default" {
  cluster_id                       = var.cluster_id
  location                         = var.location
  display_name                     = var.cluster_display_name
  project                          = var.project_id
  labels                           = var.cluster_labels
  cluster_type                     = local.is_secondary_cluster ? "SECONDARY" : var.cluster_type
  deletion_policy                  = local.is_secondary_cluster ? "FORCE" : var.deletion_policy
  database_version                 = var.database_version
  skip_await_major_version_upgrade = var.skip_await_major_version_upgrade
  deletion_protection              = var.deletion_protection

  subscription_type = var.subscription_type

  dynamic "network_config" {
    for_each = var.network_self_link == null ? [] : ["network_config"]
    content {
      network            = var.network_self_link
      allocated_ip_range = var.allocated_ip_range
    }
  }

  dynamic "psc_config" {
    for_each = var.psc_enabled ? ["psc_config"] : []
    content {
      psc_enabled = var.psc_enabled
    }
  }

  dynamic "automated_backup_policy" {
    for_each = var.automated_backup_policy != null ? [var.automated_backup_policy] : []
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

  continuous_backup_config {
    enabled              = var.continuous_backup_enable
    recovery_window_days = var.continuous_backup_recovery_window_days
    dynamic "encryption_config" {
      for_each = var.continuous_backup_encryption_key_name == null ? [] : ["cont_backup_encryption_config"]
      content {
        kms_key_name = var.continuous_backup_encryption_key_name
      }
    }

  }

  dynamic "maintenance_update_policy" {
    for_each = var.maintenance_update_policy != null ? [var.maintenance_update_policy] : []
    content {
      maintenance_windows {
        day = maintenance_update_policy.value.maintenance_windows.day
        start_time {
          hours   = maintenance_update_policy.value.maintenance_windows.start_time.hours
          minutes = 0
          seconds = 0
          nanos   = 0
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

  dynamic "restore_continuous_backup_source" {
    for_each = var.restore_cluster != null && try(var.restore_cluster.restore_continuous_backup_source != null, false) ? ["restore_continuous_backup_source"] : []
    content {
      cluster       = var.restore_cluster.restore_continuous_backup_source.cluster
      point_in_time = var.restore_cluster.restore_continuous_backup_source.point_in_time
    }
  }

  dynamic "restore_backup_source" {
    for_each = var.restore_cluster != null && try(var.restore_cluster.restore_backup_source != null, false) ? ["restore_backup_source"] : []
    content {
      backup_name = var.restore_cluster.restore_backup_source.backup_name
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

  dynamic "network_config" {
    for_each = var.primary_instance.enable_public_ip ? ["network_config"] : []
    content {
      enable_public_ip          = var.primary_instance.enable_public_ip
      enable_outbound_public_ip = var.primary_instance.enable_outbound_public_ip
      dynamic "authorized_external_networks" {
        for_each = var.primary_instance.cidr_range == null ? [] : toset(var.primary_instance.cidr_range)
        content {
          cidr_range = authorized_external_networks.value
        }
      }
    }
  }

  dynamic "psc_instance_config" {
    for_each = var.psc_enabled ? ["psc_instance_config"] : []
    content {
      allowed_consumer_projects = var.psc_allowed_consumer_projects

      dynamic "psc_interface_configs" {
        for_each = var.network_attachment_resource == null ? [] : ["psc_interface_configs"]
        content {
          network_attachment_resource = var.network_attachment_resource
        }
      }

      dynamic "psc_auto_connections" {
        for_each = var.psc_auto_connections
        content {
          consumer_network = psc_auto_connections.value.consumer_network
          consumer_project = psc_auto_connections.value.consumer_project
        }
      }
    }
  }

  machine_config {
    cpu_count    = var.primary_instance.machine_cpu_count
    machine_type = var.primary_instance.machine_type
  }

  dynamic "client_connection_config" {
    for_each = lookup(var.primary_instance, "ssl_mode", null) != null || lookup(var.primary_instance, "require_connectors", null) != null ? ["client_connection_config"] : []

    content {
      require_connectors = try(var.primary_instance.require_connectors, null)
      ssl_config {
        ssl_mode = try(var.primary_instance.ssl_mode, null)
      }
    }
  }

  dynamic "query_insights_config" {
    for_each = lookup(var.primary_instance, "query_insights_config", null) != null ? ["query_insights_config"] : []

    content {
      query_string_length     = try(var.primary_instance.query_insights_config.query_string_length, null)
      record_application_tags = try(var.primary_instance.query_insights_config.record_application_tags, null)
      record_client_address   = try(var.primary_instance.query_insights_config.record_client_address, null)
      query_plans_per_minute  = try(var.primary_instance.query_insights_config.query_plans_per_minute, null)
    }
  }

  lifecycle {
    ignore_changes = [instance_type]
  }
}

# Read pool (instance_type = "READ_POOL") cannot be created for secondary cluster
# and does not support the following attributes:
# * availability_type: Because 1 node pool (read_pool_config.node_count) is always zonal, two or more is always regional.
# * gce_zone
# * network_config.enable_outbound_public_ip
resource "google_alloydb_instance" "read_pool" {
  for_each      = local.read_pool_instance
  cluster       = google_alloydb_cluster.default.name
  instance_id   = each.key
  instance_type = "READ_POOL"
  labels        = var.primary_instance.labels
  annotations   = var.primary_instance.annotations

  dynamic "network_config" {
    for_each = each.value.enable_public_ip ? ["network_config"] : []
    content {
      enable_public_ip = each.value.enable_public_ip
      dynamic "authorized_external_networks" {
        for_each = each.value.cidr_range == null ? [] : toset(each.value.cidr_range)
        content {
          cidr_range = authorized_external_networks.value
        }
      }
    }
  }

  read_pool_config {
    node_count = each.value.node_count
  }

  database_flags = each.value.database_flags
  machine_config {
    cpu_count    = each.value.machine_cpu_count
    machine_type = each.value.machine_type
  }

  dynamic "client_connection_config" {
    for_each = lookup(each.value, "ssl_mode", null) != null || lookup(each.value, "require_connectors", null) != null ? ["client_connection_config"] : []
    content {
      require_connectors = try(each.value.require_connectors, null)
      ssl_config {
        ssl_mode = try(each.value.ssl_mode, null)
      }
    }
  }

  dynamic "query_insights_config" {
    for_each = lookup(each.value, "query_insights_config", null) != null ? ["query_insights_config"] : []

    content {
      query_string_length     = try(each.value.query_insights_config.query_string_length, null)
      record_application_tags = try(each.value.query_insights_config.record_application_tags, null)
      record_client_address   = try(each.value.query_insights_config.record_client_address, null)
      query_plans_per_minute  = try(each.value.query_insights_config.query_plans_per_minute, null)
    }
  }

  dynamic "psc_instance_config" {
    for_each = var.psc_enabled ? ["psc_instance_config"] : []
    content {
      allowed_consumer_projects = var.psc_allowed_consumer_projects

      dynamic "psc_auto_connections" {
        for_each = var.psc_auto_connections
        content {
          consumer_network = psc_auto_connections.value.consumer_network
          consumer_project = psc_auto_connections.value.consumer_project
        }
      }
    }
  }

  depends_on = [google_alloydb_instance.primary]
}
