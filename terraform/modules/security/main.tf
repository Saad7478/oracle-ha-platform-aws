# BASTION SG
resource "aws_security_group" "bastion_sg" {
  name        = "${var.name}-bastion-sg"
  description = "Bastion security group"
  vpc_id      = var.vpc_id

  ingress {
  description = "Allow ping"
  from_port   = -1
  to_port     = -1
  protocol    = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "SSH"

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = [var.admin_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-bastion-sg"
  })
}

resource "aws_security_group" "oracle_sg" {
  name        = "${var.name}-oracle-sg"
  description = "Oracle security group"
  vpc_id      = var.vpc_id

  ingress {
  description = "Allow ping"
  from_port   = -1
  to_port     = -1
  protocol    = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from Bastion"

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    security_groups = [
      aws_security_group.bastion_sg.id
    ]
  }
  
  ingress {
    description = "Oracle SQL*Net"

    from_port = 1567
    to_port   = 1567
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-oracle-sg"
  })
}