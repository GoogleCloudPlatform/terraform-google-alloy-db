provider "google-beta" {
}

module "alloy-db"{
    source = "../.."
    cluster = {
        cluster_id = "alloydb-v-4-cluster", 
        location = "us-central1"
    }
    network_self_link = "projects/${var.project_id}/global/networks/${var.network_name}"
    automated_backup_policy = {
        backup_window ="1800s", 
        enabled =true, 
        days_of_week =["FRIDAY"], 
        start_times ={"hours"=2,"minutes"=0,"seconds"=0,"nanos"=0}, 
        quantity_based_retention ={
            count = 1
        }
        time_based_retention =null
    }
    
    primary_instance = {
        instance_id = "prim-instance-1", 
        instance_type = "PRIMARY", 
        machine_config = {
            cpu_count=2
        }
    }

    read_pool_instance = {
        instance_id = "read-instance-1", 
        instance_type = "READ_POOL", 
        read_pool_config = {
            node_count = 2
        }
    }

    depends_on = [google_compute_network.default, google_compute_global_address.private_ip_alloc, google_service_networking_connection.vpc_connection]
}

resource "google_compute_network" "default" {
        name     = var.network_name
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
