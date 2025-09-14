variable "cluster_name" {
  type = string
}

variable "controller_endpoint" {
  type = string
}

variable "controller_ips" {
  type = set(string)
}

variable "worker_ips" {
  type = set(string)
}

variable "talos_version" {
  type = string
}

variable "kube_config_destination" {
  type = string
}