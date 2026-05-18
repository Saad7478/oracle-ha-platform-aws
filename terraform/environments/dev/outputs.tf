output "bastion_public_ip" {
  value = module.compute.bastion_public_ip
}

output "primary_private_ip" {
  value = module.compute.primary_private_ip
}

output "standby_private_ip" {
  value = module.compute.standby_private_ip
}