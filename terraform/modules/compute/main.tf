# -------------------
# EC2 Instance
# -------------------

resource "aws_instance" "bastion" {

  # You must accept the licence before using this ami
  #ami = "ami-00f1df1db4bc83fd1"  # Oracle Linux 8
  #ami = "ami-00a9f44477dd83e3d"   # Amazon Linux 3
  ami = "ami-02391db2758465a87"  # Rocky Linux 8

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

# ELASTIC IP FOR BASTION EC2

resource "aws_eip" "bastion" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.name}-bastion-eip"
  })
}

resource "aws_eip_association" "bastion" {
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.bastion.id
}

resource "aws_instance" "primary_db" {

  #ami = "ami-00f1df1db4bc83fd1"  # Oracle Linux 8
  #ami = "ami-00a9f44477dd83e3d"   # Amazon Linux 3
  ami = "ami-02391db2758465a87"  # Rocky Linux 8

  iam_instance_profile = var.instance_profile_name

  instance_type = var.oracle_instance_type

  subnet_id = var.private_primary[0]

  vpc_security_group_ids = [
    var.oracle_sg_id
  ]

  key_name = var.key_name

  root_block_device {
    volume_size = 30
  }

  tags = merge(var.tags, {
    Name = "${var.name}-primary-db"
  })
}

resource "aws_instance" "standby_db" {

  #ami = "ami-00f1df1db4bc83fd1"  # Oracle Linux 8
  #ami = "ami-00a9f44477dd83e3d"   # Amazon Linux 3
  ami = "ami-02391db2758465a87"  # Rocky Linux 8

  iam_instance_profile = var.instance_profile_name

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