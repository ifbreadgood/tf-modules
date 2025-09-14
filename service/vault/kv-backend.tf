resource "vault_mount" "this" {
  path = var.kv_secret.backend
  type = "kv"
  options = { version = "2" }
}

resource "vault_kv_secret_backend_v2" "this" {
  mount        = vault_mount.this.path
  max_versions = 2
}

resource "vault_kv_secret_v2" "this" {
  for_each = var.kv_secret.secrets

  mount     = vault_mount.this.path
  name      = each.key
  data_json = each.value
  # data_json = jsonencode(merge(
  #   var.kv_secret.secrets,
  #   var.database_secret != null ? { init-sql = local.default_postgers_init_sql } : {}
  # ))
}