resource "azurerm_virtual_network" "example" {
  name                = "casdemo-vn-${var.environment}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  tags = {
    yor_trace = "15401726-12e8-4be3-a8fb-46da56928d3e"
  }
}

resource "azurerm_subnet" "example" {
  name                 = "casdemo-${var.environment}"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_interface" "ni_linux" {
  name                = "casdemo-linux-${var.environment}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    yor_trace = "a22143c2-2e71-4657-a29a-7bfe5219d337"
  }
}

resource "azurerm_network_interface" "ni_win" {
  name                = "casdemo-win-${var.environment}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    yor_trace = "c3169558-f5b0-4196-8dc1-81a9d1139ce6"
  }
}

resource azurerm_network_security_group "bad_sg" {
  location            = var.location
  name                = "casdemo-${var.environment}"
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "AllowSSH"
    priority                   = 200
    protocol                   = "TCP"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_port_range     = "22-22"
    destination_address_prefix = "*"
  }

  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "AllowRDP"
    priority                   = 300
    protocol                   = "TCP"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_port_range     = "3389-3389"
    destination_address_prefix = "*"
  }
  tags = {
    yor_trace = "285f8010-4425-4e33-a323-2ded64a068b5"
  }
}

resource azurerm_network_watcher "network_watcher" {
  location            = var.location
  name                = "casdemo-network-watcher-${var.environment}"
  resource_group_name = azurerm_resource_group.example.name
  tags = {
    yor_trace = "e357daa3-6473-48d5-901b-08be1f45efc0"
  }
}

resource azurerm_network_watcher_flow_log "flow_log" {
  enabled                   = false
  network_security_group_id = azurerm_network_security_group.bad_sg.id
  network_watcher_name      = azurerm_network_watcher.network_watcher.name
  resource_group_name       = azurerm_resource_group.example.name
  storage_account_id        = azurerm_storage_account.example.id
  retention_policy {
    enabled = false
    days    = 10
  }
  tags = {
    yor_trace = "bafda0e8-15d0-4388-85f9-6034510ebcce"
  }
}