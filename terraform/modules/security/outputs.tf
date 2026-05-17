# -------------------
# Bastion Security Group
# -------------------

output "bastion_sg_id" {
  description = "Bastion security group ID"
  value       = aws_security_group.bastion_sg.id
}

output "oracle_sg_id" {
  description = "Oracle security group ID"
  value       = aws_security_group.oracle_sg.id
}