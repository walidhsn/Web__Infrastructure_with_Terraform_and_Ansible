resource "azurerm_resource_group" "rg" {
  name     = "rg-tum-webapp-${var.environment}"
  location = var.location
}

module "network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}
module "key_vault" {
  source              = "./modules/key_vault"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  virtual_network = {
    id = module.network.vnet_id
  }
}

module "ssh_key" {
  source           = "./modules/ssh_key"
  key_vault_id     = module.key_vault.vault_id
  resource_group_id = azurerm_resource_group.rg.id
  location         = azurerm_resource_group.rg.location
}

module "load_balancer" {
  source              = "./modules/load_balancer"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

module "web_vms" {
  source              = "./modules/vm"
  vm_count            = 2
  vm_name_prefix      = "web"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  main_subnet_id      = module.network.main_subnet_id
  lb_subnet_id        = module.network.lb_subnet_id
  ssh_public_key      = module.ssh_key.public_key
  admin_username      = var.admin_username
  backend_pool_id     = module.load_balancer.backend_pool_id
}