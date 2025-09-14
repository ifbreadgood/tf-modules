output "credential" {
  value = {
    oidc-url           = "${var.authentik.authentik_url}/application/o/${var.authentik.slug}/"
    oidc-url-authorize = "${var.authentik.authentik_url}/application/o/authorize/"
    oidc-url-token     = "${var.authentik.authentik_url}/application/o/token/"
    oidc-url-userinfo  = "${var.authentik.authentik_url}/application/o/userinfo/"
    oidc-icon          = "${var.authentik.authentik_url}/static/dist/assets/icons/icon.png"
    oidc-id            = authentik_provider_oauth2.oauth2.client_id,
    oidc-secret        = authentik_provider_oauth2.oauth2.client_secret
  }
  sensitive = true
}