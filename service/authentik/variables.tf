variable "authentik" {
  type = object({
    authentik_url = string

    slug            = string
    group           = string
    open_in_new_tab = bool

    oauth2_client_type       = string
    oauth2_redirect_url      = set(string)
    oauth2_subject_mode      = string
    oauth2_property_mappings = set(string)
    refresh_token_validity   = string

    icon = string
  })
}