data "azurerm_client_config" "current" {}

resource "random_string" "unique" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_key_vault" "vault" {
  name                        = "kv-${random_string.unique.result}"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = false
  soft_delete_retention_days  = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge"
    ]
  }
  depends_on = [
    var.resource_group_name,
    var.virtual_network
  ]
}