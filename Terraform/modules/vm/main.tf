resource "azurerm_network_interface" "main" {
  count               = var.vm_count
  name                = "nic-main-${var.vm_name_prefix}-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.main_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm[count.index].id
  }
}

resource "azurerm_network_interface" "lb" {
  count               = var.vm_count
  name                = "nic-lb-${var.vm_name_prefix}-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "lb-ip"
    subnet_id                     = var.lb_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "lb" {
  count                   = var.vm_count
  network_interface_id    = azurerm_network_interface.main[count.index].id 
  ip_configuration_name   = "internal"  
  backend_address_pool_id = var.backend_pool_id
}

resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "${var.vm_name_prefix}-${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.main[count.index].id,
    azurerm_network_interface.lb[count.index].id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

resource "azurerm_public_ip" "vm" {
  count               = var.vm_count
  name                = "pip-${var.vm_name_prefix}-${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"    # Required for Standard SKU
  sku                 = "Standard"  # Must match Load Balancer SKU
}