locals {
        alloydb_cluster = {
            "${var.cluster.cluster_id}" = var.cluster
        }
        primary_instance = {
            "${var.primary_instance.instance_id}" = var.primary_instance
        }
        read_pool_instance = {
            "${var.read_pool_instance.instance_id}" = var.read_pool_instance
        }
}

resource "google_alloydb_instance" "default" {
        provider      = google-beta
        for_each      = local.primary_instance
        cluster       = google_alloydb_cluster.default["${var.cluster.cluster_id}"].name
        instance_id   = each.key
        instance_type = each.value.instance_type

        machine_config {
                cpu_count = var.primary_instance.machine_config.cpu_count
        }
}

resource "google_alloydb_instance" "default1" {
        provider      = google-beta
        for_each      = local.read_pool_instance
        cluster       = google_alloydb_cluster.default["${var.cluster.cluster_id}"].name
        instance_id   = each.key
        instance_type = each.value.instance_type

        read_pool_config {
            node_count = var.read_pool_instance.read_pool_config.node_count
        }
        depends_on = [google_alloydb_instance.default]
}


resource "google_alloydb_cluster" "default" {
        for_each   = local.alloydb_cluster
        cluster_id = each.value["cluster_id"]
        location   = each.value.location
        network    = var.network_self_link

        initial_user {
            password = "alloydb-cluster"
        }

        automated_backup_policy {
            location      = each.value.location
            backup_window = var.automated_backup_policy.backup_window
            enabled       = var.automated_backup_policy.enabled


            weekly_schedule {
                days_of_week = var.automated_backup_policy.days_of_week
                start_times {
                    hours   = var.automated_backup_policy.start_times.hours
                    minutes = var.automated_backup_policy.start_times.minutes
                    seconds = var.automated_backup_policy.start_times.seconds
                    nanos   = var.automated_backup_policy.start_times.nanos
                }
            }


            quantity_based_retention {
                count = var.automated_backup_policy.quantity_based_retention.count
            }
        }

}

data "google_project" "project" {
        provider = google-beta
}


