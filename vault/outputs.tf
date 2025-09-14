output "aws_backend_paths" {
  value = { for k, v in vault_aws_secret_backend.this : k => v.path }
}

output "kubernetes_auth_backend_path" {
  value = try(vault_auth_backend.kubernetes[0].path, null)
}

output "kv_paths" {
  value = { for k, v in vault_mount.this: k => v.path }
}

# output "database_secrets_path" {
#   value = vault_mount.database.path
# }