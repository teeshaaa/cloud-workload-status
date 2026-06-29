provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_instances" "app" {
  filter {
    name   = "tag:Project"
    values = [var.project_name]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

data "aws_instance" "app" {
  count       = length(data.aws_instances.app.ids) > 0 ? 1 : 0
  instance_id = data.aws_instances.app.ids[0]
}

resource "aws_security_group" "app" {
  name        = "${local.app_name}-sg"
  description = "Allow app traffic from ALB or direct access"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.enable_ssh ? [1] : []

    content {
      description = "SSH from your IP"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.ssh_cidr]
    }
  }

  dynamic "ingress" {
    for_each = var.enable_alb ? [1] : []

    content {
      description     = "App traffic from ALB only"
      from_port       = var.app_port
      to_port         = var.app_port
      protocol        = "tcp"
      security_groups = [aws_security_group.alb[0].id]
    }
  }

  dynamic "ingress" {
    for_each = var.enable_alb ? [] : [1]

    content {
      description = "Direct app access when ALB is disabled"
      from_port   = var.app_port
      to_port     = var.app_port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.app_name}-sg"
  })
}
