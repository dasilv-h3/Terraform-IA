resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.storage_account_name_prefix}${random_string.suffix.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}
resource "random_string" "suffix" {
  length  = 6
  lower   = true    # lettres minuscules
  numeric = true    # inclut les chiffres
  upper   = false   # pas de majuscules
  special = false   # pas de caractères spéciaux
}
resource "azurerm_storage_container" "images" {
  name                  = "images"
  storage_account_id    = azurerm_storage_account.storage_account.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "results" {
  name                  = "results"
  storage_account_id    = azurerm_storage_account.storage_account.id
  container_access_type = "private"
}