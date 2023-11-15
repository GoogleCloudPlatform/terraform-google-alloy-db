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

module "alloy-db-secondary" {
  source           = "../.."
  cluster_id       = "alloydb-v6-cluster-secondary"
  cluster_location = var.secondary_region
  project_id       = var.project_id

  network_self_link           = "projects/${var.project_id}/global/networks/${var.network_name}"
  cluster_encryption_key_name = google_kms_crypto_key.key_secondary.id

  primary_instance = {
    instance_id = "primary-instance-sec-1",
  }


  ## Comment this out in order to promote cluster as primary cluster
  primary_cluster_name = module.alloy-db.cluster_name


  # Set this variable to false before promoting cluster as primary cluster
  continuous_backup_enable = false


  ### Uncomment following after the cluster is promoted as primary cluster

  # automated_backup_policy = {
  #   location      = var.secondary_region
  #   backup_window = "1800s"
  #   enabled       = true
  #   weekly_schedule = {
  #     days_of_week = ["FRIDAY"],
  #     start_times  = ["2:00:00:00", ]
  #   }
  #   quantity_based_retention_count = 1
  #   time_based_retention_count     = null
  #   labels = {
  #     test = "alloydb-cluster-with-prim"
  #   }
  #   backup_encryption_key_name = google_kms_crypto_key.key_secondary.id
  # }

  # continuous_backup_recovery_window_days = 10
  # continuous_backup_encryption_key_name  = google_kms_crypto_key.key_secondary.id
  # read_pool_instance = [
  #   {
  #     instance_id  = "read-instance-sec-1",
  #     display_name = "read-instance-sec-1",
  #   }
  # ]

  depends_on = [
    module.alloy-db,
    google_kms_crypto_key_iam_member.alloydb_sa_iam_secondary,
  ]
}

