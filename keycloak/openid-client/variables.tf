variable "realm_name" {
  type = string
}

variable "client_name" {
  type = string
}

variable "client_id" {
  type = string
}

variable "enabled" {
  type    = bool
  default = true
}

variable "access_type" {
  type = string
  default = "CONFIDENTIAL"
  validation {
    condition = contains(["CONFIDENTIAL", "PUBLIC"], var.access_type)
    error_message = "valid values are CONFIDENTIAL and PUBLIC"
  }
}

variable "valid_redirect_uris" {
  type = set(string)
}

variable "extra_configs" {
  type    = map(string)
  default = {}
}

variable "standard_flow_enabled" {
  type    = bool
  default = true
}

variable "service_account_enabled" {
  type    = bool
  default = false
}

variable "oauth2_device_authorization_grant_enabled" {
  type    = bool
  default = false
}

variable "pkce_code_challenge_method" {
  type    = string
  default = null
  validation {
    condition     = var.pkce_code_challenge_method == null || contains(["S256", "plain"], var.pkce_code_challenge_method)
    error_message = "valid values are S256 and plain"
  }
}

variable "valid_post_logout_redirect_uris" {
  type    = list(string)
  default = []
}

variable "web_origins" {
  type    = list(string)
  default = []
}

variable "root_url" {
  type    = string
  default = ""
}

variable "base_url" {
  type    = string
  default = ""
}