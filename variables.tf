variable "subscription_id" {
  type        = string
  description = "ID de l'abonnement Azure de notre VM"
}

variable "location" {
  type        = string
  description = "Localisation de notre VM"
  default = "Switzerland North"
}

variable "resource_group_name" {
  type        = string
  description = "Nom de notre groupe de ressources"
  default     = "rg"
}

variable "vm_size" {
  type        = string
  description = "Taille de la VM"
  default     = "Standard_B2as_v2"
}

variable "allowed_ssh_ip" {
  type        = string
  description = "IP de notre machine local qui pourra se connecter en SSH à notre VM"
}

variable "vnet_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type        = string
  description = "IP de notre sous réseau"
  default     = "10.0.1.0/24"
}

variable "admin_username" {
    type        = string
    default     = "azureuser"
}

# Admin123!
variable "admin_password" {
    type        = string
    sensitive   = true
}

variable "tags" {
  type = map(string)
  default = {
    environment = "dev"
    project     = "terraform-ia"
  }
}
