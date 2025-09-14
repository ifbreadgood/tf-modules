resource "vault_aws_secret_backend_role" "this" {
  count = var.aws_secret != null ? 1 : 0

  backend         = var.aws_secret.backend
  name            = var.name
  credential_type = var.aws_secret.credentials_type
  policy_document = var.aws_secret.policy
}