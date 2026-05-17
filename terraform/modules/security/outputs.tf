# -------------------
# Bastion Security Group
# -------------------

output "bastion_sg_id" {
  description = "Bastion security group ID"
  value       = aws_security_group.bastion_sg.id
}