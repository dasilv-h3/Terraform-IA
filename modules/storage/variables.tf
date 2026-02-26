variable "location" {}
variable "resource_group_name" {}
variable "tags" {}
variable "storage_account_name_prefix" {
    type        = string
    description = "Préfixe du nom du storage account"
    default     = "storageacct"
}