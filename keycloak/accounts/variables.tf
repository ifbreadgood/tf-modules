variable "realm_name" {
  type = string
}

variable "groups" {
  type = map(object({
    members    = optional(list(string), [])
    attributes = optional(map(string), {})
  }))
}

variable "users" {
  type = map(object({
    enabled    = optional(bool, true)
    email      = optional(string)
    first_name = string
    last_name  = string
  }))
}