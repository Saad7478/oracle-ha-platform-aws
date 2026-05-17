terraform {
  backend "s3" {
    bucket         = "my-terraform-state2478"
    key            = "oracleDG/dev/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-locks"
  }
}

# -------------------
# VPC
# -------------------

module "vpc" {
  source = "../../modules/vpc"

  name = var.name

  cidr = var.cidr

  public_azs = var.public_azs

  primary_azs = var.primary_azs

  standby_azs = var.standby_azs

  public_subnets = var.public_subnets

  private_primary = var.private_primary

  private_standby = var.private_standby

  tags = var.tags
}

# -------------------
# Security
# -------------------

module "security" {
  source = "../../modules/security"

  name = var.name

  vpc_id = module.vpc.vpc_id

  admin_cidr = var.admin_cidr

  tags = var.tags
}
