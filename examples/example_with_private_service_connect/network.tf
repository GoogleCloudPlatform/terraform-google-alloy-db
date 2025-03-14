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

# Create attachment for testing psc interfaces
resource "google_compute_network_attachment" "psc_attachment" {
  provider    = google-beta
  name        = "psc-network-attachment"
  region      = var.region_central
  description = "PSC network attachment for PSC testing interface"
  project     = var.attachment_project_id

  subnetworks           = [google_compute_subnetwork.psc_subnet.id]
  connection_preference = "ACCEPT_AUTOMATIC"
}
