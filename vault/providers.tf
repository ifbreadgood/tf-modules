terraform {
  required_version = "~> 1.12.0"
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "~> 5.0.0"
    }
  }
}

provider "vault" {
  address = var.address
}