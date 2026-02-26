terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "4.61.0"
        }
    }

    backend "azurerm" {
        resource_group_name   = "rg-tfstate"
        storage_account_name  = "tfstateocrproj2026"
        container_name        = "tfstate"
        key                   = "terraform.tfstate"
    }
}

provider "azurerm" {
    features {}
    subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
    name     = "rg-${terraform.workspace}"
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
    location             = azurerm_resource_group.rg.location
    resource_group_name  = azurerm_resource_group.rg.name
    tags                 = var.tags
}

module "compute" {
    source              = "./modules/compute"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    vm_size             = var.vm_size
    admin_username      = var.admin_username
    admin_password      = var.admin_password
    nic_id              = module.network.nic_id
    tags                = var.tags
}

module "monitoring" {
    source                        = "./modules/monitoring"
    location                      = azurerm_resource_group.rg.location
    resource_group_name           = azurerm_resource_group.rg.name
    app_insights_name             = "ai-ocrproject"
    storage_account_primary_key   = module.storage.primary_access_key
    admin_password                = var.admin_password
    tags                          = var.tags
}

module "cognitive_service" {
    source               = "./modules/cognitive_service"
    location             = azurerm_resource_group.rg.location
    resource_group_name  = azurerm_resource_group.rg.name
    cognitive_name       = "ocrproject-vision"
    keyvault_id          = module.monitoring.keyvault_id
    tags                 = var.tags
    depends_on = [module.monitoring]
}