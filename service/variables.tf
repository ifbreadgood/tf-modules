variable "name" {
  type = string
}

variable "authentik" {
  type = object({
    authentik_url   = string
    group           = optional(string, "default")
    open_in_new_tab = optional(bool, true)

    oauth2_client_type       = optional(string, "confidential")
    oauth2_redirect_url      = optional(set(string))
    oauth2_subject_mode      = optional(string)
    oauth2_property_mappings = optional(set(string), ["default"])
    refresh_token_validity   = optional(string, "hours=1")

    icon = optional(string, "")
  })
  default = null
}

variable "aws_secret" {
  type = object({
    backend             = string
    policy              = string
    credentials_type    = optional(string, "iam_user")
    policy_capabilities = optional(set(string), ["read"])
  })
  default = null
}

variable "kv_secret" {
  type = object({
    backend             = string
    secrets             = optional(map(string), {})
    policy_capabilities = optional(set(string), ["read"])
  })
  default = null
}

variable "database_secret" {
  type = object({
    backend                  = string
    verify_connection        = optional(bool, false)

    postgresql = optional(object({
      connection_url = string
    }))
  })
  default = null
}

variable "database_s3_backup" {
  type = object({
    bucket     = optional(string)
    expiration = optional(string, "60d")
  })
  default = {}
}

variable "buckets" {
  type = object({
    names = set(string)
    expiration = optional(string, "60d")
  })
  default = null
}

variable "kubernetes_role" {
  type = object({
    backend                          = string
    bound_service_account_names      = set(string)
    bound_service_account_namespaces = set(string)
    token_ttl                        = optional(number, 60 * 60 * 4)
    token_max_ttl                    = optional(number, 60 * 60 * 24)
  })
  default = null
}