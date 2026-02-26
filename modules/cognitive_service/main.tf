data "azurerm_client_config" "current" {}

resource "azurerm_cognitive_account" "vision" {
    name                = var.cognitive_name
    location            = var.location
    resource_group_name = var.resource_group_name
    kind                = "ComputerVision"
    sku_name            = var.sku_name
    tags                = var.tags
}

resource "azurerm_key_vault_secret" "cognitive_key" {
    name         = "cognitive-vision-key"
    value        = azurerm_cognitive_account.vision.primary_access_key
    key_vault_id = var.keyvault_id
    depends_on   = [azurerm_cognitive_account.vision]
}
