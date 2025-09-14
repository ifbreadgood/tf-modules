data "keycloak_realm" "this" {
  realm = var.realm_name
}

resource "keycloak_group" "this" {
  for_each   = var.groups
  realm_id   = data.keycloak_realm.this.id
  name       = each.key
  attributes = each.value.attributes
}

resource "random_password" "this" {
  for_each = var.users
  length   = 50
  numeric  = true
  special  = true
  upper    = true
}

resource "keycloak_user" "this" {
  for_each = var.users
  realm_id = data.keycloak_realm.this.id
  username = each.key

  initial_password {
    value     = random_password.this[each.key].result
    temporary = false
  }
  enabled = each.value.enabled

  email      = each.value.email
  first_name = each.value.first_name
  last_name  = each.value.last_name
}

resource "keycloak_group_memberships" "group_members" {
  for_each = var.groups
  realm_id = data.keycloak_realm.this.id
  group_id = keycloak_group.this[each.key].id

  members = [for member in each.value.members : keycloak_user.this[member].username]
}