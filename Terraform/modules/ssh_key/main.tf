terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.12.0"
    }
  }
}
resource "random_pet" "ssh_key_name" {
  prefix    = "ssh"
  separator = ""
}

resource "azapi_resource" "ssh_public_key" {
  type      = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  name      = random_pet.ssh_key_name.id
  location  = var.location
  parent_id = var.resource_group_id
  depends_on = [
    var.key_vault_id
  ]
}

resource "azapi_resource_action" "ssh_key_gen" {
  type        = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  resource_id = azapi_resource.ssh_public_key.id
  action      = "generateKeyPair"
  method      = "POST"
  response_export_values = ["publicKey", "privateKey"]
}

resource "azurerm_key_vault_secret" "private_key" {
  name         = "vm-ssh-private-key"
  value        = jsondecode(azapi_resource_action.ssh_key_gen.output).privateKey
  key_vault_id = var.key_vault_id
}