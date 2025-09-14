variable "name" {
  type = string
}
variable "tags" {
  type = map(string)
}
variable "provider_assume_role_arn" {
  type    = string
  default = null
}