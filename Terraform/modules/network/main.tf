resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.resource_group_name}"
  address_space       = ["10.10.10.0/24", "80.190.10.0/28"]
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_subnet" "main" {
  name                 = "main-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.10.0/24"]
  depends_on = [azurerm_virtual_network.vnet]
}

resource "azurerm_subnet" "lb" {
  name                 = "lb-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["80.190.10.0/28"]
  depends_on = [azurerm_virtual_network.vnet]
}

resource "azurerm_network_security_group" "web" {
  name                = "nsg-web"
  location            = var.location
  resource_group_name = var.resource_group_name

   security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
 
}

# Associate NSG with subnets
resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.web.id
}

resource "azurerm_subnet_network_security_group_association" "lb" {
  subnet_id                 = azurerm_subnet.lb.id
  network_security_group_id = azurerm_network_security_group.web.id
}

resource "azurerm_network_security_rule" "allow_lb_probes" {
  name                        = "AllowLBProbes"
  priority                    = 105  
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "AzureLoadBalancer"  # Allow LB health probes
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.web.name
}