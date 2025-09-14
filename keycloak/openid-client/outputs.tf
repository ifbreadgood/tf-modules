output "realm" {
  value = data.keycloak_realm.this.display_name
}

output "client_id" {
  value = keycloak_openid_client.this.client_id
}

output "openid_client_secret" {
  value     = keycloak_openid_client.this.client_secret
  sensitive = true
}