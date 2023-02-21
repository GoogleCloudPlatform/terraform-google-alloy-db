variable "cluster" {
  type = object({
    cluster_id    = string,
    location      = string,
    backup_window = string,
    enabled       = bool
    }),
    quantity_based_retention = object({
      count = number
    }),
  })
}


variable "automated_backup_policy"{
  type = object({
      days_of_week = list(string),
      start_times = object({
        hours   = number,
        minutes = number,
        seconds = number,
        nanos   = number
      })
}
variable "instance" {
  type = list(object({
    instance_id   = string,
    instance_type = string,
    machine_config = object({
      cpu_count = number,
    }),
  }))
}

variable "read_pool_instance" {
  type = list(object({
    instance_id   = string,
    instance_type = string,
    read_pool_config = object({
      node_count = number,
    }),
  }))

}
