# -------------------
# General
# -------------------

variable "name" {
  description = "Project name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

# -------------------
# Networking
# -------------------

variable "cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_azs" {
  description = "Availability Zones"

  type = list(string)
}

variable "primary_azs" {
  description = "Availability Zones"

  type = list(string)
}

variable "standby_azs" {
  description = "Availability Zones"

  type = list(string)
}

variable "public_subnets" {
  description = "Public subnet CIDRs"

  type = list(string)
}

variable "private_primary" {
  description = "Private application subnet CIDRs"

  type = list(string)
}

variable "private_standby" {
  description = "Private database subnet CIDRs"

  type = list(string)
}

# -------------------
# Security
# -------------------# -------------------

variable "admin_cidr" {
  description = "Admin IP allowed for SSH"

  type = string
}

# -------------------
# Bastion instance type
# -------------------

variable "instance_type" {
  description = "Bastion instance type"

  type = string
}

# -------------------
# Tags
# -------------------

variable "tags" {
  description = "Common tags"

  type = map(string)

  default = {}
}