# AMI : Amazon machine image
## Récupération de l'image que l'on va faire tourner sur l'instance
data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  owners = ["amazon"]
}

data "aws_security_group" "default_sg" {
  filter {
    name   = "group-name"
    values = ["${var.project_name}-Default"]
  }

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

## VPC's instance Security Group to access VPC by SSH
resource "aws_security_group" "allow_ssm_sg" {
  name        = "${var.project_name}-Allow-ssm"
  description = "Security group to allow ssm"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}SsmSecurityGroup"
    Module      = "Instance"
  }
}

# EC2

locals {
  userdata = templatefile("modules/instance/user_data.sh", {
    ssm_cloudwatch_config = aws_ssm_parameter.cw_agent.name,
    aws_region = var.region,
    project_name = var.project_name
  })
}

## L'instance sur laquelle on va faire tourner notre app
resource "aws_instance" "apps_server" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t3a.small"
  vpc_security_group_ids = [data.aws_security_group.default_sg.id, aws_security_group.allow_ssm_sg.id]
  subnet_id              = var.public_subnet_id
  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name

  # root_block_device {
  #   volume_type = "gp3"
  #   volume_size = 20
  # }

  # Test in console
  # ssm command, then `sudo su` to be root

  user_data = local.userdata

  tags = {
    Name   = "${var.project_name}Instance"
    Module = "Instance"
  }

  lifecycle {
    ignore_changes = [ami]
  }
}
