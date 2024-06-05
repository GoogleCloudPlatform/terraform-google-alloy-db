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

resource "random_string" "key_suffix" {
  length  = 3
  special = false
  upper   = false
}

resource "google_kms_key_ring" "keyring" {
  project  = var.project_id
  name     = "alloydb-keyring-example-${random_string.key_suffix.result}"
  location = "us-central1"
}

resource "google_kms_crypto_key" "key" {
  name     = "crypto-key-example-${random_string.key_suffix.result}"
  key_ring = google_kms_key_ring.keyring.id
}

resource "google_project_service_identity" "alloydb_sa" {
  provider = google-beta

  project = var.project_id
  service = "alloydb.googleapis.com"
}

resource "google_kms_crypto_key_iam_member" "alloydb_sa_iam" {
  crypto_key_id = google_kms_crypto_key.key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_project_service_identity.alloydb_sa.email}"
}
