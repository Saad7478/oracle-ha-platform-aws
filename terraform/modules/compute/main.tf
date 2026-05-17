#AMI Amazon Linux
/*data "aws_ami" "oracle_linux_8" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Oracle-Linux-8*"]
  }

   owners = ["131827586825"]
}
*/
# -------------------
# EC2 Instance
# -------------------

resource "aws_instance" "bastion" {

  #ami           = data.aws_ami.oracle_linux_8.id
  # You must accept the licence before using this ami
  ami = "ami-00f1df1db4bc83fd1"

  instance_type = var.bastion_instance_type

  key_name = var.key_name

  subnet_id = var.public_subnets[0]

  vpc_security_group_ids = [
    var.bastion_sg_id
  ]

  tags = merge(var.tags, {
    Name = "${var.name}-Bastion"
  })
}
/*
resource "aws_instance" "primary_db" {

  #ami           = data.aws_ami.oracle_linux_8.id
  ami = "ami-00f1df1db4bc83fd1"

  instance_type = var.oracle_instance_type

  subnet_id = var.private_primary[0]

  vpc_security_group_ids = [
    var.oracle_sg_id
  ]

  root_block_device {
    volume_size = 30
  }

  tags = merge(var.tags, {
    Name = "${var.name}-primary-db"
  })
}

resource "aws_instance" "standby_db" {

  #ami           = data.aws_ami.oracle_linux_8.id
  ami = "ami-00f1df1db4bc83fd1"

  instance_type = var.oracle_instance_type

  subnet_id = var.private_standby[0]

  vpc_security_group_ids = [
    var.oracle_sg_id
  ]

  key_name = var.key_name

  root_block_device {
    volume_size = 30
  }

  tags = merge(var.tags, {
    Name = "${var.name}-standby-db"
  })
}
*/