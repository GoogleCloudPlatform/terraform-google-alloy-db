variable "network_self_link" {
    description = "Network ID where the AlloyDb cluster iwll be deployed."
    type = string
}

variable "cluster" {
  description = "Configuration of the AlloyDb cluster."
  type = object({
    cluster_id    = string,
    location      = string,
  })
  validation{
    condition = can(regex("^[a-z0-9-]+$", var.cluster.cluster_id))
    error_message = "ERROR: Cluster ID must contain only Letters(lowercase), number, and hyphen"
  }
}

variable "automated_backup_policy"{
    description = "The automated backup policy for this cluster."
    type = object({
      backup_window = string,
      enabled = bool,
      days_of_week = list(string),
      start_times = object({
        hours   = number,
        minutes = number,
        seconds = number,
        nanos   = number
      }),
      quantity_based_retention = object({
        count = number
      }),
      time_based_retention = optional(object({
          retention_period = string
      }))
    })
    validation {
        condition = can(regex("^(true|false)$",var.automated_backup_policy.enabled))
        error_message = "Invalid input, options: \"true\", \"false\"."
    }
}

variable "primary_instance" {
  description = "Primary cluster configuration that supports read and write operations."
  type = object({
    instance_id   = string,
    instance_type = string,
    machine_config = object({
      cpu_count = number,
    }),
  })
  validation {
      condition = can(regex("^(2|4|8|16|32|64)$", var.primary_instance.machine_config.cpu_count))
      error_message = "cpu count must be one of [2 4 8 16 32 64]"
  }
  validation{
      condition = can(regex("^[a-z]([a-z0-9-]{0,61}[a-z0-9])?$", var.primary_instance.instance_id))
      error_message = "Primary Instance ID should satisfy the following pattern ^[a-z]([a-z0-9-]{0,61}[a-z0-9])?$"
  }
}

variable "read_pool_instance" {
  type = object({
    instance_id   = string,
    instance_type = string,
    read_pool_config = object({
      node_count = number,
    }),
  })
  validation{
      condition = can(regex("^[a-z]([a-z0-9-]{0,61}[a-z0-9])?$", var.read_pool_instance.instance_id))
      error_message = "Read Pool Instance ID should satisfy the following pattern ^[a-z]([a-z0-9-]{0,61}[a-z0-9])?$"
  }
}
