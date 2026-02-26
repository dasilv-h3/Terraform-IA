variable "location" {}
variable "resource_group_name" {}
variable "tags" {}
variable "cognitive_name" {
    type        = string
    description = "Nom du Cognitive Service"
}
variable "sku_name" {
    type        = string
    default     = "S1"
    description = "SKU du service Cognitive (S1 pour Computer Vision)"
}
variable "keyvault_id" {
    type        = string
    description = "ID du Key Vault pour stocker la clé"
}