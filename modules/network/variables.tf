variable "location" {}
variable "resource_group_name" {}
variable "vnet_cidr" {}
variable "subnet_cidr" {}
variable "allowed_ssh_ip" {
    type = string
}
variable "tags" {
    type = map(string)
}