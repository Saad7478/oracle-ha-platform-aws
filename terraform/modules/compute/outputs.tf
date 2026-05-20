output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "bastion_eip" {
  value =  aws_eip.bastion.public_ip
}

output "primary_private_ip" {
  value = aws_instance.primary_db.private_ip
}

output "standby_private_ip" {
  value = aws_instance.standby_db.private_ip
}

output "bastion_instance_id" {
  value = aws_instance.bastion.id
}

output "primary_instance_id" {
  value =  aws_instance.primary_db.id
}

output "standby_instance_id" {
  value = aws_instance.standby_db.id
}