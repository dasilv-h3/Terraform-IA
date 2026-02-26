resource "azurerm_virtual_network" "vnet" {
    name                = "vnet"
    location            = var.location
    resource_group_name = var.resource_group_name
    address_space       = [var.vnet_cidr]
    tags = var.tags
}

resource "azurerm_subnet" "subnet" {
    name                 = "subnet"
    resource_group_name  = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = [var.subnet_cidr]
}

resource "azurerm_public_ip" "pip" {
    name                = "vm-public-ip"
    location            = var.location
    resource_group_name = var.resource_group_name
    allocation_method   = "Static"
    sku                 = "Standard"
}

resource "azurerm_network_security_group" "nsg" {
    name                = "vm-nsg"
    location            = var.location
    resource_group_name = var.resource_group_name

    security_rule {
        name                       = "SSH"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_address_prefix      = var.allowed_ssh_ip
        destination_port_range     = "22"
        source_port_range          = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "HTTP"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_address_prefix      = "*"
        destination_port_range     = "80"
        source_port_range          = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "DockerHTTP"
        priority                   = 120
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_address_prefix      = var.allowed_ssh_ip
        destination_port_range     = "8080"
        source_port_range          = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface" "nic" {
    name                = "vm-nic"
    location            = var.location
    resource_group_name = var.resource_group_name

    ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.pip.id
    }
}

resource "azurerm_network_interface_security_group_association" "assoc" {
    network_interface_id      = azurerm_network_interface.nic.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}