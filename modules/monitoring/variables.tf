variable "location" {}
variable "resource_group_name" {}
variable "admin_password" {}
variable "tags" {}
variable "app_insights_name" {
  type = string
  description = "Nom de l'Application Insights"
}
variable "keyvault_name" {
  type = string
  description = "Nom du Key Vault"
}
variable "storage_account_primary_key" {
  type      = string
  sensitive = true
}
