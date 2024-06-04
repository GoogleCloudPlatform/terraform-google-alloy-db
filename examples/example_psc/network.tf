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

resource "google_compute_network" "psc_vpc" {
  name    = "psc-endpoint-vpc"
  project = var.attachment_project_id
}

resource "google_compute_subnetwork" "psc_subnet" {
  project       = var.attachment_project_id
  name          = "psc-endpoint-subnet"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region_central
  network       = google_compute_network.psc_vpc.id
}

resource "google_compute_address" "psc_consumer_address" {
  name    = "psc-consumer-address"
  project = var.attachment_project_id
  region  = var.region_central

  subnetwork   = google_compute_subnetwork.psc_subnet.name
  address_type = "INTERNAL"
  address      = "10.2.0.10"
}

resource "google_compute_forwarding_rule" "psc_fwd_rule_consumer" {
  name    = "psc-fwd-rule-consumer-endpoint"
  region  = var.region_central
  project = var.attachment_project_id

  target                  = module.alloydb_central.primary_instance.psc_instance_config[0].service_attachment_link
  load_balancing_scheme   = "" # need to override EXTERNAL default when target is a service attachment
  network                 = google_compute_network.psc_vpc.name
  ip_address              = google_compute_address.psc_consumer_address.id
  allow_psc_global_access = true
}


