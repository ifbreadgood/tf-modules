data "authentik_scope_mapping" "default" {
  managed_list = [
    "goauthentik.io/providers/oauth2/scope-email",
    "goauthentik.io/providers/oauth2/scope-openid",
    "goauthentik.io/providers/oauth2/scope-profile"
  ]
}

locals {
  oauth2_property_mapping_options = {
    default = data.authentik_scope_mapping.default.ids
  }
}

data "authentik_certificate_key_pair" "default" {
  name = "authentik Self-signed Certificate"
}

data "authentik_flow" "default-authorization-flow" {
  slug = "default-provider-authorization-implicit-consent"
}

resource "random_string" "oauth_client_id" {
  length  = 50
  special = false
}

resource "random_password" "oauth_client_secret" {
  length  = 50
  special = false
}

resource "authentik_provider_oauth2" "oauth2" {
  name                   = var.authentik.slug
  client_id              = random_string.oauth_client_id.result
  client_secret          = var.authentik.oauth2_client_type
  authorization_flow     = data.authentik_flow.default-authorization-flow.id
  property_mappings      = setunion(flatten([for mapping in var.authentik.oauth2_property_mappings : local.oauth2_property_mapping_options[mapping]]))
  redirect_uris          = var.authentik.oauth2_redirect_url
  sub_mode               = coalesce(var.authentik.oauth2_subject_mode, "user_email")
  signing_key            = data.authentik_certificate_key_pair.default.id
  refresh_token_validity = var.authentik.refresh_token_validity
}

resource "authentik_application" "application" {
  name              = var.authentik.slug
  slug              = coalesce(var.authentik.slug, var.authentik.slug)
  group             = var.authentik.group
  open_in_new_tab   = var.authentik.open_in_new_tab
  protocol_provider = authentik_provider_oauth2.oauth2.id
  meta_icon         = var.authentik.icon
}