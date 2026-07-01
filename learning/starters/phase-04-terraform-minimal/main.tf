# Phase 4 minimal starter — single EC2 in default VPC.
# Grow this into the full terraform/ stack in later phases.

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_security_group" "app" {
  name        = "${var.project_name}-phase4-sg"
  description = "Phase 4 learning — SSH and app port"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  ingress {
    description = "Flask app"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.app.id]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y python3-venv python3-pip git
    sudo -u ubuntu git clone https://github.com/<you>/my-cloud-workload-status.git /home/ubuntu/app
    cd /home/ubuntu/app
    sudo -u ubuntu python3 -m venv venv
    sudo -u ubuntu venv/bin/pip install Flask gunicorn
    sudo -u ubuntu venv/bin/gunicorn -b 0.0.0.0:${var.app_port} app:app &
  EOF

  tags = {
    Name    = "${var.project_name}-phase4"
    Project = var.project_name
  }
}

output "public_ip" {
  value = aws_instance.app.public_ip
}

output "health_url" {
  value = "http://${aws_instance.app.public_ip}:${var.app_port}/health"
}
