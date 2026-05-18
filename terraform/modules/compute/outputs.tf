output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "primary_private_ip" {
  value = aws_instance.primary_db.private_ip
}

output "standby_private_ip" {
  value = aws_instance.standby_db.private_ip
}
