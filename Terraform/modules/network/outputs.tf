output "main_subnet_id" {
  value = azurerm_subnet.main.id
}

output "lb_subnet_id" {
  value = azurerm_subnet.lb.id
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}