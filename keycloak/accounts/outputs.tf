output "accounts" {
  value = {for user in keycloak_user.this: user.username => random_password.this[user.username].result}
  sensitive = true
}