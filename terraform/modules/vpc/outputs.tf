output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "Public subnet IDs"

  value = [
    for subnet in aws_subnet.public :
    subnet.id
  ]
}

output "private_primary" {
  description = "Private primary oracle database subnet IDs"

  value = [
    for subnet in aws_subnet.private_primary :
    subnet.id
  ]
}

output "private_standby" {
  description = "Private standby oracle database subnet IDs"

  value = [
    for subnet in aws_subnet.private_standby :
    subnet.id
  ]
}