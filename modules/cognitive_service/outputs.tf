output "cognitive_service_name" {
    value = azurerm_cognitive_account.vision.name
}

output "cognitive_endpoint" {
    value = azurerm_cognitive_account.vision.endpoint
}

output "keyvault_secret_id" {
    value = azurerm_key_vault_secret.cognitive_key.id
    sensitive = true
}

output "primary_key" {
    value     = azurerm_cognitive_account.vision.primary_access_key
    sensitive = true
}