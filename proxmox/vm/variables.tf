variable "node_name" {
  type = string
}
variable "name" {
  type = string
}
variable "cpu" {
  type = number
}
variable "memory" {
  type = number
}
variable "iso" {
  type = string
}
variable "volume_size" {
  type = number
}
variable "ip" {
  type = object({
    address = string
    gateway = optional(string)
  })
}
variable "dns" {
  type = set(string)
  default = ["9.9.9.9", "1.1.1.1"]
}
variable "mac_address" {
  type = string
  default = null
}