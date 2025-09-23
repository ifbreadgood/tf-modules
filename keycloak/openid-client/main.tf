data "keycloak_realm" "this" {
  realm = var.realm_name
}

resource "keycloak_openid_client" "this" {
  realm_id  = data.keycloak_realm.this.id
  client_id = var.client_id

  name                       = var.client_name
  enabled                    = var.enabled
  access_type                = var.access_type
  pkce_code_challenge_method = var.pkce_code_challenge_method
  extra_config               = var.extra_configs

  standard_flow_enabled                     = var.standard_flow_enabled
  service_accounts_enabled                  = var.service_account_enabled
  implicit_flow_enabled                     = false
  direct_access_grants_enabled              = false
  oauth2_device_authorization_grant_enabled = var.oauth2_device_authorization_grant_enabled

  valid_redirect_uris             = var.valid_redirect_uris
  valid_post_logout_redirect_uris = var.valid_post_logout_redirect_uris
  web_origins                     = concat([var.root_url], var.web_origins)
  root_url                        = var.root_url
  base_url                        = var.base_url

  lifecycle {
    precondition {
      condition = var.pkce_code_challenge_method == null || (var.pkce_code_challenge_method != null && var.access_type == "PUBLIC")
      error_message = "If pkce code challenge is not null, then access type must be public"
    }
  }
}

# resource "keycloak_openid_client_service_account_role" "this" {
#   client_id               = keycloak_openid_client.openid_client.id
#   realm_id                = keycloak_openid_client.openid_client.realm_id
#   role                    = data.keycloak_role.admin
#   service_account_user_id = keycloak_openid_client.openid_client.service_account_user_id
# }
#
# data "keycloak_role" "admin" {
#   name     = "admin"
#   realm_id = keycloak_realm.realm.id
# }

resource "keycloak_openid_client_default_scopes" "client_default_scopes" {
  realm_id  = data.keycloak_realm.this.id
  client_id = keycloak_openid_client.this.id

  default_scopes = [
    "profile",
    "email",
    "roles",
    "web-origins",
    "basic",
    "groups",
  ]
}