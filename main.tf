terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "4.61.0"
        }
    }
}

provider "azurerm" {
    features {}
    subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
    name     = var.resource_group_name
    location = var.location
}

module "network" {
    source              = "./modules/network"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    vnet_cidr           = var.vnet_cidr
    subnet_cidr         = var.subnet_cidr
    allowed_ssh_ip      = var.allowed_ssh_ip
    tags                = var.tags
}

module "storage" {
  source               = "./modules/storage"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_name = var.storage_account_name
  tags                 = var.tags
}
