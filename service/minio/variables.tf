variable "name" {
  type = string
}

variable "buckets" {
  type = set(string)
}

variable "expiration" {
  type = string
}