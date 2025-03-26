resource "azurerm_public_ip" "lb" {
  name                = "pip-lb"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "web" {
  name                = "lb-web"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb.id
  }
}

resource "azurerm_lb_backend_address_pool" "web" {
  loadbalancer_id = azurerm_lb.web.id
  name            = "BackEndPool"
  depends_on = [azurerm_lb.web]
}

resource "azurerm_lb_probe" "http" {
  loadbalancer_id = azurerm_lb.web.id
  name            = "HTTP-Probe"
  port            = 80
  protocol        = "Http"
  request_path    = "/"
  interval_in_seconds = 5   # Check every 5 seconds
  number_of_probes    = 2   # Mark as unhealthy after 2 consecutive failures
}

resource "azurerm_lb_rule" "http" {
  loadbalancer_id                = azurerm_lb.web.id
  name                           = "HTTP"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.http.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.web.id]
}