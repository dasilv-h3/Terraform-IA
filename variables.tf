variable "subscription_id" {
  type = string
}

variable "location" {
  default = "Italy North"
}

variable "resource_group_name" {
  default = "rg"
}

variable "vm_size" {
  default = "Standard_B2as_v2"
}

variable "allowed_ssh_ip" {
  type = string
}

variable "vnet_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "tags" {
  type = map(string)
  default = {
    environment = "dev"
    project     = "terraform-ia"
  }
}
