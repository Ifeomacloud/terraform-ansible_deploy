terraform {
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.region
}

# If user didn't provide an AMI, find the latest Amazon Linux 2 AMI (x86_64)
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Lookup default VPC if needed (we use its id for SG and default subnet fallback)
data "aws_vpc" "default" {
  default = true
}

# Get subnets in the default VPC (used only if user didn't pass subnet_id)
data "aws_subnets" "default_vpc" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

locals {
  # choose first default subnet if user didn't provide one
  chosen_subnet_id = var.subnet_id != "" ? var.subnet_id : tolist(data.aws_subnets.default_vpc.ids)[0]
  chosen_ami       = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux.id
}

# Security group allowing SSH and limited egress (modify as needed)
resource "aws_security_group" "sg" {
  name        = "${var.name_prefix}-sg"
  description = "Allow SSH from anywhere (adjust CIDR for production)"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # change to your IP in production
  }

  ingress {
    description = "Allow ICMP (ping)"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-sg" })
}

resource "aws_instance" "vm" {
  count                       = var.instance_count
  ami                         = local.chosen_ami
  instance_type               = var.instance_type
  key_name                    = var.key_name != "" ? var.key_name : null
  subnet_id                   = local.chosen_subnet_id
  associate_public_ip_address = var.associate_public_ip
  vpc_security_group_ids      = [aws_security_group.sg.id]

  tags = merge(
    var.tags,
    {
      Name  = "${var.name_prefix}-${count.index + 1}"
      Index = tostring(count.index + 1)
    }
  )

  # Optional: simple user_data that installs updates (comment out if not desired)
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              EOF
}

# (Optional) Output for SSH command snippets - derived from instance public IPs
output "ssh_commands" {
  description = "SSH command lines to access created instances (if public IPs are assigned)"
  value = [
    for inst in aws_instance.vm :
    format("ssh -i /path/to/your/key.pem ec2-user@%s", inst.public_ip)
    if var.associate_public_ip && inst.public_ip != ""
  ]
}
