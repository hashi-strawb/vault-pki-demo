terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "2.19.1"
    }
    environment = {
      source  = "EppO/environment"
      version = "1.1.0"
    }
  }
}

provider "vault" {}


# Get the Vault Address, so we can use it in other resources
#
# This relies on the address being set via the VAULT_ADDR environment variable,
# so it's slightly brittle, but I'm not aware of any way of getting the address
# out of the Provider itself

data "environment_variables" "address" {
  filter = "VAULT_ADDR"
}

locals {
  vault_addr = data.environment_variables.address.items["VAULT_ADDR"]
}

output "vault_addr" {
  value = local.vault_addr
}
