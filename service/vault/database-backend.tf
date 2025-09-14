resource "random_password" "db_admin" {
  count = var.database_secret != null ? 1 : 0
  length  = 50
  special = false
}

#resource "vault_kv_secret_v2" "secret" {
#  mount = var.kv_secrets_path
#  name  = var.kv_secrets_name
#  data_json = jsonencode({
#    access-key = var.access_key
#    secret-key = var.secret_key
#    aws-region = var.s3_region
#    init-sql   = "create role admin with login password '${random_password.admin.result}' superuser;"
#  })
#}
#
#resource "vault_policy" "policy" {
#  name   = "${var.application_name}-cnpg"
#  policy = <<-EOT
#    path "${var.kv_secrets_path}/data/${vault_kv_secret_v2.secret.name}" {
#      capabilities = ["read"]
#    }
#    EOT
#}
#
#resource "vault_kubernetes_auth_backend_role" "database" {
#  backend                          = var.kubernetes_auth_mount
#  bound_service_account_names      = [var.kubernetes_service_account]
#  bound_service_account_namespaces = [var.kubernetes_namespace]
#  role_name                        = "${var.application_name}-cnpg"
#  token_policies                   = [vault_policy.policy.name]
#  token_ttl                        = var.kubernetes_token_ttl
#}

locals {
  default_postgres_root_rotation_statements = ["alter role current_role with password '{{password}}'"]
  default_postgres_allowed_roles = ["${var.name}-read"]
  default_postgers_init_sql = var.database_secret != null ? "create role admin with login password '${random_password.db_admin[0].result}' superuser;" : ""
}

resource "vault_database_secret_backend_connection" "this" {
  count                    = var.database_secret != null ? 1 : 0
  backend                  = var.database_secret.backend
  name                     = var.name
  verify_connection        = var.database_secret.verify_connection
  root_rotation_statements = local.default_postgres_root_rotation_statements
  allowed_roles            = local.default_postgres_allowed_roles

  dynamic "postgresql" {
    for_each = [var.database_secret.postgresql]
    content {
      connection_url = postgresql.value["connection_url"]
      username       = "admin"
      password       = random_password.db_admin[0].result
    }
  }
  #  postgresql {
  #    connection_url = "postgres://{{username}}:{{password}}@${var.application_name}-rw.authentik:5432/${var.application_name}"
  #    username       = "admin"
  #    password       = random_password.admin.result
  #  }
}

#output "connection_name" {
#  value = vault_database_secret_backend_connection.postgres.name
#}