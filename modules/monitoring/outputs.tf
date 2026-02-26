output "app_insights_name" {
    value = azurerm_application_insights.app_insights.name
}

output "app_insights_instrumentation_key" {
    value     = azurerm_application_insights.app_insights.instrumentation_key
    sensitive = true
}

output "keyvault_id" {
    value = azurerm_key_vault.kv.id
}

output "keyvault_uri" {
    value = azurerm_key_vault.kv.vault_uri
}

output "app_insights_key" {
    value = azurerm_application_insights.app_insights.instrumentation_key
}