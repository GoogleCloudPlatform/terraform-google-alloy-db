locals {
        alloydb_cluster = {
            "${var.cluster.cluster_id}" = var.cluster
        }
        instance           = { for instances in var.instance : instances["instance_id"] => instances }
        read_pool_instance = { for read_pool_instances in var.read_pool_instance : read_pool_instances["instance_id"] => read_pool_instances }
}

resource "google_alloydb_instance" "default" {
        provider      = google-beta
        for_each      = local.instance
        cluster       = google_alloydb_cluster.default["${var.cluster.cluster_id}"].name
        instance_id   = each.key
        instance_type = each.value.instance_type

        dynamic "machine_config" {
            for_each = each.value["machine_config"] != null ? [each.value["machine_config"]] : []
            content {
                cpu_count = machine_config.value.cpu_count
            }
        }
        depends_on = [google_service_networking_connection.vpc_connection]
}

resource "google_alloydb_instance" "default1" {
        provider      = google-beta
        for_each      = local.read_pool_instance
        cluster       = google_alloydb_cluster.default["${var.cluster.cluster_id}"].name
        instance_id   = each.key
        instance_type = each.value.instance_type

        dynamic "read_pool_config" {
            for_each = each.value["read_pool_config"] != null ? [each.value["read_pool_config"]] : []
            content {
                node_count = read_pool_config.value.node_count
            }
        }
        depends_on = [google_alloydb_instance.default]
}


resource "google_alloydb_cluster" "default" {
        for_each   = local.alloydb_cluster
        cluster_id = each.value["cluster_id"]
        location   = each.value.location
        network    = "projects/${data.google_project.project.number}/global/networks/${google_compute_network.default.name}"

        initial_user {
            password = "alloydb-cluster"
        }

        automated_backup_policy {
            location      = each.value.location
            backup_window = each.value.backup_window
            enabled       = each.value.enabled


            weekly_schedule {
                days_of_week = each.value["weekly_schedule"].days_of_week
                start_times {
                    hours   = each.value["weekly_schedule"].start_times.hours
                    minutes = each.value["weekly_schedule"].start_times.minutes
                    seconds = each.value["weekly_schedule"].start_times.seconds
                    nanos   = each.value["weekly_schedule"].start_times.nanos
                }
            }


            quantity_based_retention {
                count = each.value["quantity_based_retention"].count
            }
        }

}

data "google_project" "project" {
        provider = google-beta
}

resource "google_compute_network" "default" {
        provider = google-beta
        name     = "alloydb-cluster-network"
}


resource "google_compute_global_address" "private_ip_alloc" {
  name          = "adb-v2"
  address_type  = "INTERNAL"
  purpose       = "VPC_PEERING"
  prefix_length = 16
  network       = google_compute_network.default.id
}

resource "google_service_networking_connection" "vpc_connection" {
  network                 = google_compute_network.default.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}
