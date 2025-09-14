terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
    }
    authentik = {
      source  = "goauthentik/authentik"
    }
  }
}