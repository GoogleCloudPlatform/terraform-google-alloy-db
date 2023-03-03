variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "cluster_id" {
  description = "Configuration of the AlloyDb cluster."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.cluster_id))
    error_message = "ERROR: Cluster ID must contain only Letters(lowercase), number, and hyphen"
  }
}

variable "cluster_location" {
  description = "Location where AlloyDb cluster will be deployed."
  type        = string
  default     = "us-central1"
}

variable "cluster_labels" {
  type    = map(string)
  default = {}
}

variable "cluster_display_name" {
  type    = string
  default = ""
}

variable "cluster_initial_user" {
  type = object({
    user     = optional(string),
    password = string
  })
  default = {
    password = "alloydb-cluster-full"
    user     = "alloydb-cluster-full"
  }
}

variable "network_self_link" {
  description = "Network ID where the AlloyDb cluster will be deployed."
  type        = string
}

variable "automated_backup_policy" {
  description = "The automated backup policy for this cluster."
  type = object({
    location      = optional(string),
    backup_window = optional(string),
    enabled       = optional(bool),
    weekly_schedule = object({
      days_of_week = optional(list(string)),
      start_times  = list(string),
    }),
    quantity_based_retention_count = optional(number),
    time_based_retention_count     = optional(string),
    labels                         = optional(map(string))
  })
  default = {
    backup_window = "1800s"
    enabled       = false
    labels = {
      "test" = "alloydb-cluster"
    }
    location                       = "us-central1"
    quantity_based_retention_count = 1
    time_based_retention_count     = "null"
    weekly_schedule = {
      days_of_week = ["FRIDAY"],
      start_times  = ["2:00:00:00", ]
    }
  }
}

variable "instance_iam" {
  description = "The list of permissions on alloydb instance"
  type        = list(string)
  default     = []
}


variable "primary_instance" {
  description = "Primary cluster configuration that supports read and write operations."
  type = object({
    instance_id       = string,
    instance_type     = string,
    machine_cpu_count = number,
    display_name      = string,
    database_flags    = map(string)
  })
  validation {
    condition     = can(regex("^(2|4|8|16|32|64)$", var.primary_instance.machine_cpu_count))
    error_message = "cpu count must be one of [2 4 8 16 32 64]"
  }
  validation {
    condition     = can(regex("^[a-z]([a-z0-9-]{0,61}[a-z0-9])?$", var.primary_instance.instance_id))
    error_message = "Primary Instance ID should satisfy the following pattern ^[a-z]([a-z0-9-]{0,61}[a-z0-9])?$"
  }
}

variable "read_pool_instance" {
  type = list(object({
    instance_id       = string,
    display_name      = string,
    instance_type     = string,
    node_count        = number,
    database_flags    = map(string),
    availability_type = string,
    ZONE              = string,
    machine_cpu_count = number
  }))
  default     = []
}
