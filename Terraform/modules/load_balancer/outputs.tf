output "backend_pool_id" {
  value = azurerm_lb_backend_address_pool.web.id
}

output "lb_public_ip" {
  value = azurerm_public_ip.lb.ip_address
}