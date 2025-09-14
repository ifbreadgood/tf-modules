variable "name" {
  type = string
}

variable "aws_secret" {
  type = object({
    backend             = string
    policy              = string
    credentials_type    = string
    policy_capabilities = set(string)
  })
  default = null
}

variable "kv_secret" {
  type = object({
    backend             = string
    secrets             = map(string)
    policy_capabilities = set(string)
  })
  default = null
}

variable "kubernetes_role" {
  type = object({
    backend                          = string
    bound_service_account_names      = set(string)
    bound_service_account_namespaces = set(string)
    token_ttl                        = number
    token_max_ttl                    = number
  })
  default = null
}

variable "database_secret" {
  type = object({
    backend                  = string
    verify_connection        = bool

    postgresql = optional(object({
      connection_url = string
    }))
  })
  default = null
}