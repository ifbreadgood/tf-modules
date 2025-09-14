# module "authentik" {
#   count     = var.authentik != null ? 1 : 0
#   source    = "./authentik"
#   authentik = merge(var.authentik, { slug : var.name })
# }

module "vault" {
  source = "vault"

  name            = var.name
  kubernetes_role = var.kubernetes_role
  aws_secret      = var.aws_secret
  database_secret = var.database_secret
  kv_secret = var.kv_secret != null ? {
    backend             = var.kv_secret.backend
    policy_capabilities = var.kv_secret.policy_capabilities
    secrets = var.kv_secret.secrets
    # secrets = merge(
    #   var.kv_secret.secrets,
    #   var.authentik != null ? module.authentik[0].credential : {},
    #   var.database_secret != null ? module.database_backup[0].bucket_access : {},
    #   var.buckets != null ? module.buckets[0].bucket_access : {}
    # )
  } : null
}

module "database_backup" {
  count      = var.database_secret != null ? 1 : 0
  source     = "minio"
  name       = coalesce(var.database_s3_backup.bucket, "${var.name}-database-backup")
  expiration = var.database_s3_backup.expiration
  buckets    = []
}

module "buckets" {
  count = var.buckets != null ? 1 : 0
  source = "minio"
  name = var.name
  buckets = var.buckets.names
  expiration = var.buckets.expiration
}