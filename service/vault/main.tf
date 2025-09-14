resource "vault_policy" "this" {
  count = var.kubernetes_role != null ? 1 : 0

  name   = var.name
  policy = <<-EOF
    %{ for k, v in var.kv_secret.secrets }
    path "${var.kv_secret.backend}/data/${k}" {
      capabilities = ${jsonencode(var.kv_secret.policy_capabilities)}
    }
    %{ endfor }
    %{ if var.aws_secret != null }
    path "${var.aws_secret.backend}/creds/${vault_aws_secret_backend_role.this[0].name}" {
      capabilities = ${jsonencode(var.aws_secret.policy_capabilities)}
    }
    %{ endif }
    %{ if var.database_secret != null }
    path "${var.database_secret.backend}/data/test" {
      capabilities = ["read"]
    }
    %{ endif }
    EOF
}

resource "vault_kubernetes_auth_backend_role" "this" {
  count = var.kubernetes_role != null ? 1 : 0

  backend                          = var.kubernetes_role.backend
  bound_service_account_names      = var.kubernetes_role.bound_service_account_names
  bound_service_account_namespaces = var.kubernetes_role.bound_service_account_namespaces
  token_policies                   = [vault_policy.this[0].name]
  token_ttl                        = var.kubernetes_role.token_ttl
  token_max_ttl                    = var.kubernetes_role.token_max_ttl
  role_name                        = var.name
}