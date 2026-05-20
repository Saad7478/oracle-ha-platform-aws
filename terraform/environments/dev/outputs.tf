output "bastion_public_ip" {
  value = module.compute.bastion_public_ip
}

output "bastion_eip" {
  value =  module.compute.bastion_eip
}

output "primary_private_ip" {
  value = module.compute.primary_private_ip
}

output "standby_private_ip" {
  value = module.compute.standby_private_ip
}

output "bastion_instance_id" {
  value = module.compute.bastion_instance_id
}

output "primary_instance_id" {
  value = module.compute.primary_instance_id
}

output "standby_instance_id" {
  value = module.compute.standby_instance_id
}