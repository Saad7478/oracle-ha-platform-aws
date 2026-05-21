variable "name" {
  description = "Project name"
  type        = string
}

# -------------------
# EC2
# -------------------

variable "bastion_instance_type" {
  description = "Bastion instance type"
  type        = string
}

variable "oracle_instance_type" {
  description = "Oracle instance type"
  type        = string
}
# -------------------
# Networking
# -------------------

variable "public_subnets" {
  description = "Public subnet IDs"

  type = list(string)
}

variable "private_primary" {
  description = "Private primary database subnet IDs"

  type = list(string)
}

variable "private_standby" {
  description = "Private standby database subnet IDs"

  type = list(string)
}

variable "bastion_sg_id" {
  description = "EC2 security group ID"

  type = string
}

variable "oracle_sg_id" {
  description = "Oracle security group ID"

  type = string
}
# -------------------
# AWS
# -------------------

variable "instance_profile_name" {
  description = "Instance profile name"

  type = string
}

variable "aws_region" {
  description = "AWS region"

  type = string
}

# KEY

variable "key_name" {
  type = string
}

# -------------------
# Tags
# -------------------

variable "tags" {
  description = "Common tags"

  type    = map(string)
  default = {}
}