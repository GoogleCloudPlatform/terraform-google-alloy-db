// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "cluster_id" {
  description = "The ID of the alloydb cluster"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.cluster_id))
    error_message = "ERROR: Cluster ID must contain only Letters(lowercase), number, and hyphen"
  }
}

variable "cluster_location" {
  description = "Location where AlloyDb cluster will be deployed."
  type        = string
  # default     = "us-central1"
}

variable "cluster_labels" {
  description = "User-defined labels for the alloydb cluster"
  type        = map(string)
  default     = {}
}

variable "cluster_display_name" {
  description = "Human readable display name for the Alloy DB Cluster"
  type        = string
  default     = null
}

variable "cluster_initial_user" {
  description = "Alloy DB Cluster Initial User Credentials"
  type = object({
    user     = optional(string),
    password = string
  })
  default = null
}

variable "cluster_encryption_key_name" {
  description = "The fully-qualified resource name of the KMS key for cluster encryption. Each Cloud KMS key is regionalized and has the following format: projects/[PROJECT]/locations/[REGION]/keyRings/[RING]/cryptoKeys/[KEY_NAME]"
  type        = string
  default     = null
}

variable "automated_backup_policy" {
  description = "The automated backup policy for this cluster. If no policy is provided then the default policy will be used. The default policy takes one backup a day, has a backup window of 1 hour, and retains backups for 14 days"
  type = object({
    location      = optional(string)
    backup_window = optional(string)
    enabled       = optional(bool)

    weekly_schedule = optional(object({
      days_of_week = optional(list(string))
      start_times  = list(string)
    })),

    quantity_based_retention_count = optional(number)
    time_based_retention_count     = optional(string)
    labels                         = optional(map(string))
    backup_encryption_key_name     = optional(string)
  })
  default = null
}

variable "continuous_backup_enable" {
  type        = bool
  description = "Whether continuous backup recovery is enabled. If not set, defaults to true"
  default     = true
}

variable "continuous_backup_recovery_window_days" {
  type        = number
  description = "The numbers of days that are eligible to restore from using PITR (point-in-time-recovery). Defaults to 14 days. The value must be between 1 and 35"
  default     = 14
}

variable "continuous_backup_encryption_key_name" {
  type        = string
  description = "The fully-qualified resource name of the KMS key. Cloud KMS key should be in same region as Cluster and has the following format: projects/[PROJECT]/locations/[REGION]/keyRings/[RING]/cryptoKeys/[KEY_NAME]"
  default     = null
}

variable "primary_instance" {
  description = "Primary cluster configuration that supports read and write operations."
  type = object({
    instance_id       = string,
    display_name      = optional(string),
    database_flags    = optional(map(string))
    labels            = optional(map(string))
    annotations       = optional(map(string))
    gce_zone          = optional(string)
    availability_type = optional(string)
    machine_cpu_count = optional(number, 2),
  })
  validation {
    condition     = can(regex("^(2|4|8|16|32|64|96)$", var.primary_instance.machine_cpu_count))
    error_message = "cpu count must be one of [2 4 8 16 32 64 96]"
  }
  validation {
    condition     = can(regex("^[a-z]([a-z0-9-]{0,61}[a-z0-9])?$", var.primary_instance.instance_id))
    error_message = "Primary Instance ID should satisfy the following pattern ^[a-z]([a-z0-9-]{0,61}[a-z0-9])?$"
  }
}

variable "read_pool_instance" {
  description = "List of Read Pool Instances to be created"
  type = list(object({
    instance_id       = string
    display_name      = string
    node_count        = optional(number, 1)
    database_flags    = optional(map(string))
    availability_type = optional(string)
    gce_zone          = optional(string)
    machine_cpu_count = optional(number, 2)
  }))
  default = []
}

variable "primary_cluster_name" {
  type        = string
  description = "Primary cluster name. Required for creating cross region secondary cluster. Not needed for primary cluster"
  default     = null
}

variable "network_self_link" {
  description = "Network ID where the AlloyDb cluster will be deployed."
  type        = string
}

variable "allocated_ip_range" {
  type        = string
  description = "The name of the allocated IP range for the private IP AlloyDB cluster. For example: google-managed-services-default. If set, the instance IPs for this cluster will be created in the allocated range"
  default     = null
}
