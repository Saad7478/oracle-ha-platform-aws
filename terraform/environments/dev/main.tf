terraform {
  backend "s3" {
    bucket         = "my-terraform-state2478v1"
    key            = "oracleDG/dev/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-locks"
    profile = "aws2"
  }
}

# Key 

resource "aws_key_pair" "oracle_lab_key" {
  key_name   = "oracle-lab-key"
  public_key = file(pathexpand("~/.ssh/aws-oracle-lab.pub"))
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

module "compute" {
  source = "../../modules/compute"

  name = var.name
  
  key_name = aws_key_pair.oracle_lab_key.key_name

  bastion_instance_type = var.bastion_instance_type

  oracle_instance_type = var.oracle_instance_type

  public_subnets =  module.vpc.public_subnets
  
  private_primary = module.vpc.private_primary

  private_standby = module.vpc.private_standby

  bastion_sg_id = module.security.bastion_sg_id

  oracle_sg_id = module.security.oracle_sg_id

  aws_region = var.aws_region

  tags = var.tags
}