variable "location" {
    type        = string
    description = "Region Azure"
}

variable "resource_group_name" {
    type        = string
    description = "Nom du resource group"
}

variable "storage_account_name" {
    type        = string
    description = "Nom du storage account"
}

variable "tags" {
    type    = map(string)
    default = {}
}
