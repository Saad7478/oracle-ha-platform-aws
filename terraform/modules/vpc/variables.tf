variable "name" {
  type = string
}

variable "cidr" {
  type = string
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)

  validation {
    condition     = length(var.public_subnets) >= 1
    error_message = "At least 2 public subnets are required"
  }
}

variable "private_primary" {
  description = "Private primary database subnet CIDRs"
  type        = list(string)
}

variable "private_standby" {
  description = "Private standby database subnet CIDRs"
  type        = list(string)
}

variable "public_azs" {
  type = list(string)

  validation {
    condition     = length(var.public_azs) >= 1
    error_message = "Au moins 2 AZ sont nécessaires."
  }
}

variable "primary_azs" {
  type = list(string)

  validation {
    condition     = length(var.primary_azs) >= 1
    error_message = "Au moins 2 AZ sont nécessaires."
  }
}

variable "standby_azs" {
  type = list(string)

  validation {
    condition     = length(var.standby_azs) >= 1
    error_message = "Au moins 2 AZ sont nécessaires."
  }
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}