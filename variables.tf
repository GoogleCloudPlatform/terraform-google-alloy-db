variable "network_self_link" {
    type = string
}

variable "cluster" {
  type = object({
    cluster_id    = string,
    location      = string,
  })
}

variable "automated_backup_policy"{
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
    })
}

variable "primary_instance" {
  type = object({
    instance_id   = string,
    instance_type = string,
    machine_config = object({
      cpu_count = number,
    }),
  })
}

variable "read_pool_instance" {
  type = object({
    instance_id   = string,
    instance_type = string,
    read_pool_config = object({
      node_count = number,
    }),
  })

}
