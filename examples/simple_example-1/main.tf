module "alloy-db" {
  source               = "../.."
  cluster_id           = "alloydb-cluster-nrp"
  cluster_location     = "us-central1"
  cluster_labels       = {}
  cluster_display_name = ""
  cluster_initial_user = {
    user     = "alloydb-cluster-full",
    password = "alloydb-cluster-password"
  }
  network_id = "projects/${var.project_id}/global/networks/${var.network_name}"

  automated_backup_policy = null

  primary_instance = {
    instance_id       = "primary-instance-1",
    instance_type     = "PRIMARY",
    machine_cpu_count = 2,
    database_flags    = {},
    display_name      = "alloydb-primary-instance"
  }


  read_pool_instance = null

  depends_on = [google_compute_network.default, google_compute_global_address.private_ip_alloc, google_service_networking_connection.vpc_connection]
}

resource "google_compute_network" "default" {
  name = var.network_name
}


resource "google_compute_global_address" "private_ip_alloc" {
  name          = "adb-nrp"
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
