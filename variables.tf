// Copyright 2025 Google LLC
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
  nullable    = false
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.cluster_id))
    error_message = "ERROR: Cluster ID must contain only Letters(lowercase), number, and hyphen"
  }
}

variable "cluster_type" {
  description = "The type of cluster. If not set, defaults to PRIMARY. Default value is PRIMARY. Possible values are: PRIMARY, SECONDARY"
  type        = string
  default     = "PRIMARY"
}

variable "location" {
  description = "Location where AlloyDb cluster will be deployed"
  type        = string
  nullable    = false
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

variable "skip_await_major_version_upgrade" {
  description = "Set to true to skip awaiting on the major version upgrade of the cluster. Possible values: true, false. Default value: true"
  type        = bool
  default     = true
}

variable "subscription_type" {
  description = "The subscription type of cluster. Possible values are: TRIAL, STANDARD"
  type        = string
  default     = "STANDARD"
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

variable "maintenance_update_policy" {
  description = "defines the policy for system updates"
  type = object({
    maintenance_windows = object({
      day = string
      start_time = object({
        hours = number
      })
    })
  })
  default = null
}

variable "continuous_backup_encryption_key_name" {
  type        = string
  description = "The fully-qualified resource name of the KMS key. Cloud KMS key should be in same region as Cluster and has the following format: projects/[PROJECT]/locations/[REGION]/keyRings/[RING]/cryptoKeys/[KEY_NAME]"
  default     = null
}

variable "network_self_link" {
  description = "Network ID where the AlloyDb cluster will be deployed. If network_self_link is set then psc_enabled should be set to false. The resource link should point to a VPC network in the same project as the cluster, where the cluster resources are created and accessed via Private IP. Any network used, including the default network (if none is specified), must have VPC peering enabled. Learn more at https://cloud.google.com/alloydb/docs/configure-connectivity"
  type        = string
  default     = null
}

variable "primary_instance" {
  description = "Configure primary instance. Every AlloyDB cluster has one primary instance, providing a read or write access point to your data. See https://cloud.google.com/alloydb/docs/reference/rest/v1/projects.locations.clusters.instances for more details."
  type = object({
    instance_id        = string,
    display_name       = optional(string),
    database_flags     = optional(map(string))
    labels             = optional(map(string))
    annotations        = optional(map(string))
    gce_zone           = optional(string)
    availability_type  = optional(string)
    machine_cpu_count  = optional(number, 2)
    machine_type       = optional(string)
    ssl_mode           = optional(string)
    require_connectors = optional(bool)
    query_insights_config = optional(object({
      query_string_length     = optional(number)
      record_application_tags = optional(bool)
      record_client_address   = optional(bool)
      query_plans_per_minute  = optional(number)
    }))
    enable_public_ip          = optional(bool, false)
    enable_outbound_public_ip = optional(bool, false)
    cidr_range                = optional(list(string))
  })
  nullable = false
  validation {
    condition     = contains([1, 2, 4, 8, 16, 32, 64, 96, 128], var.primary_instance.machine_cpu_count)
    error_message = "machine_cpu_count must be one of [1, 2, 4, 8, 16, 32, 64, 96, 128]"
  }
  validation {
    condition     = can(regex("^[a-z]([a-z0-9-]{0,61}[a-z0-9])?$", var.primary_instance.instance_id))
    error_message = "Primary Instance ID should satisfy the following pattern ^[a-z]([a-z0-9-]{0,61}[a-z0-9])?$"
  }
  validation {
    condition = var.primary_instance.query_insights_config == null || (
      try(var.primary_instance.query_insights_config.query_string_length, 0) >= 256 &&
      try(var.primary_instance.query_insights_config.query_string_length, 0) <= 4500
    )
    error_message = "Query string length must be between 256 and 4500. The default value is 1024."
  }
  validation {
    condition = var.primary_instance.query_insights_config == null || (
      try(var.primary_instance.query_insights_config.query_plans_per_minute, 0) >= 0 &&
      try(var.primary_instance.query_insights_config.query_plans_per_minute, 0) <= 20
    )
    error_message = "Query plans per minute must be between 0 and 20. The default value is 5."
  }
}

variable "read_pool_instance" {
  description = "List of Read Pool Instances to be created"
  type = list(object({
    instance_id        = string
    display_name       = string
    node_count         = optional(number, 1)
    database_flags     = optional(map(string))
    machine_cpu_count  = optional(number, 2)
    machine_type       = optional(string)
    ssl_mode           = optional(string)
    require_connectors = optional(bool)
    query_insights_config = optional(object({
      query_string_length     = optional(number)
      record_application_tags = optional(bool)
      record_client_address   = optional(bool)
      query_plans_per_minute  = optional(number)
    }))
    enable_public_ip = optional(bool, false)
    cidr_range       = optional(list(string))
  }))
  nullable = false
  default  = []
  validation {
    condition     = alltrue([for rp in var.read_pool_instance : contains([1, 2, 4, 8, 16, 32, 64, 96, 128], rp.machine_cpu_count)])
    error_message = "machine_cpu_count must be one of [1, 2, 4, 8, 16, 32, 64, 96, 128]"
  }
}

variable "primary_cluster_name" {
  type        = string
  description = "Primary cluster name. Required for creating cross region secondary cluster. Not needed for primary cluster"
  default     = null
}

variable "allocated_ip_range" {
  type        = string
  description = "The name of the allocated IP range for the private IP AlloyDB cluster. For example: google-managed-services-default. If set, the instance IPs for this cluster will be created in the allocated range"
  default     = null
}

variable "database_version" {
  type        = string
  description = "The database engine major version. This is an optional field and it's populated at the Cluster creation time. This field cannot be changed after cluster creation. Possible valus: POSTGRES_14, POSTGRES_15"
  default     = null
}

variable "psc_enabled" {
  type        = bool
  description = "Create an instance that allows connections from Private Service Connect endpoints to the instance. If psc_enabled is set to true, then network_self_link should be set to null, and you must create additional network resources detailed under `examples/example_with_private_service_connect`"
  default     = false
}

variable "psc_allowed_consumer_projects" {
  type        = list(string)
  description = "List of consumer projects that are allowed to create PSC endpoints to service-attachments to this instance. These should be specified as project numbers only."
  default     = []
}

variable "psc_auto_connections" {
  type = list(object({
    consumer_network = string
    consumer_project = string
  }))
  description = "List of PSC auto connections. Each connection specifies the consumer network and project for automatic PSC endpoint creation."
  default     = []
}

variable "deletion_policy" {
  type        = string
  description = "Policy to determine if the cluster should be deleted forcefully. Deleting a cluster forcefully, deletes the cluster and all its associated instances within the cluster"
  default     = null
}

variable "network_attachment_resource" {
  type        = string
  description = "The network attachment resource created in the consumer project to which the PSC interface will be linked. Needed for AllloyDB outbound connectivity. This is of the format: projects/{CONSUMER_PROJECT}/regions/{REGION}/networkAttachments/{NETWORK_ATTACHMENT_NAME}. The network attachment must be in the same region as the instance"
  default     = null
}

variable "restore_cluster" {
  description = "restore cluster from a backup source. Only one of restore_backup_source or restore_continuous_backup_source should be set"
  type = object({
    restore_backup_source = optional(object({
      backup_name = string
    }))
    restore_continuous_backup_source = optional(object({
      cluster       = string
      point_in_time = string
    }))
  })
  default = null
}

variable "deletion_protection" {
  type        = bool
  description = "Whether Terraform will be prevented from destroying the cluster. When the field is set to true or unset in Terraform state, a terraform apply or terraform destroy that would delete the cluster will fail. When the field is set to false, deleting the cluster is allowed"
  default     = true
}
