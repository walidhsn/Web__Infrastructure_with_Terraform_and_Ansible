output "vm_public_ips" {
  value = [for ip in azurerm_public_ip.vm : ip.ip_address]
}