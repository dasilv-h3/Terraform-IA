terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  subscription_id                 = var.subscription_id
  features {}
}

module "network" {
  source              = "./modules/network"
  location            = var.location
  resource_group_name = var.resource_group_name
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
