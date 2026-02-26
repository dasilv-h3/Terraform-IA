data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
    name                        = var.keyvault_name
    location                    = var.location
    resource_group_name         = var.resource_group_name
    tenant_id                   = data.azurerm_client_config.current.tenant_id
    sku_name                    = "standard"
    purge_protection_enabled    = false
    tags                        = var.tags
}

resource "azurerm_key_vault_access_policy" "allow_secrets" {
    key_vault_id = azurerm_key_vault.kv.id
    tenant_id    = data.azurerm_client_config.current.tenant_id
    object_id    = data.azurerm_client_config.current.object_id

    secret_permissions = [
        "Get",
        "List",
        "Set",
        "Delete"
    ]
}

resource "azurerm_application_insights" "app_insights" {
    name                = var.app_insights_name
    location            = var.location
    resource_group_name = var.resource_group_name
    application_type    = "web"
    retention_in_days   = 30
    tags                = var.tags
}

resource "azurerm_key_vault_secret" "storage_account_key" {
    name         = "storage-account-key"
    value        = var.storage_account_primary_key
    key_vault_id = azurerm_key_vault.kv.id
    depends_on   = [azurerm_key_vault_access_policy.allow_secrets]
}

resource "azurerm_key_vault_secret" "vm_admin_password" {
    name         = "vm-admin-password"
    value        = var.admin_password
    key_vault_id = azurerm_key_vault.kv.id
    depends_on   = [azurerm_key_vault_access_policy.allow_secrets]
}