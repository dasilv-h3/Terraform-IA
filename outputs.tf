output "public_ip" {
    value = module.network.public_ip
}

output "private_ip" {
    value = module.network.private_ip
}

output "vm_username" {
    value = var.admin_username
}