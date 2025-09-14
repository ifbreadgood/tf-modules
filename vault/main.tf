resource "vault_aws_secret_backend" "this" {
  for_each                  = var.aws_backends
  access_key                = each.value.access_key_id
  secret_key                = each.value.secret_access_key
  iam_endpoint              = each.value.iam_endpoint
  sts_endpoint              = each.value.sts_endpoint
  region                    = each.value.region
  default_lease_ttl_seconds = each.value.ttl
  max_lease_ttl_seconds     = each.value.ttl
  path                      = each.key
}

resource "vault_auth_backend" "kubernetes" {
  count = var.kubernetes_service_host != null ? 1 : 0
  type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "kubernetes" {
  count = var.kubernetes_service_host != null ? 1 : 0
  kubernetes_host = var.kubernetes_service_host
  depends_on = [vault_auth_backend.kubernetes[0]]
}

resource "vault_mount" "this" {
  for_each = var.kv
  path    = each.key
  type    = "kv"
  options = { version = "2" }
}

resource "vault_kv_secret_backend_v2" "this" {
  for_each = var.kv
  mount        = vault_mount.this[each.key].path
  max_versions = each.value.max_version
}

resource "vault_kv_secret_v2" "this" {
  for_each = var.kv
  data_json = each.value.secrets.content
  mount     = vault_mount.this[each.key].path
  name      = each.key
}

resource "vault_jwt_auth_backend" "jwt" {
  description        = "Demonstration of the Terraform JWT auth backend"
  path               = "oidc"
  type               = "oidc"
  default_role       = "test-role"
  oidc_discovery_url = "https://keycloak.trial.studio/realms/my-realm"
  oidc_client_id     = "test-client"
  oidc_client_secret = "bi2M2Ma7blIXb15muBiIvstqawTYzzMO"
  # bound_issuer        = "https://keycloak.trial.studio/realms/my-realm"
}

resource "vault_jwt_auth_backend_role" "role" {
  backend               = vault_jwt_auth_backend.jwt.path
  role_name             = "test-role"
  token_policies        = ["default"]
  user_claim            = "sub"
  role_type             = "oidc"
  allowed_redirect_uris = ["https://vault.trial.studio/ui/vault/auth/oidc/oidc/callback"]
}