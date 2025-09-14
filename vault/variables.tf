variable "kubernetes_service_host" {
  type = string
  default = null
}

variable "kv" {
  type = map(object({
    secrets = map(object({
      content = string
      ignore_content_changes = optional(bool, false)
    }))
    max_version = optional(number, 2)
  }))
  default = {}
}

variable "aws_backends" {
  type = map(object({
      access_key_id     = string
      secret_access_key = string
      iam_endpoint      = string
      sts_endpoint      = string
      region            = string
      ttl               = number
    }))
  default = {}
}

variable "address" {
  type = string
}
#
# variable "oidc" {
#   type = object({
#     url           = string
#     redirect_urls = set(string)
#     id            = string
#     secret        = string
#   })
#   default = null
# }