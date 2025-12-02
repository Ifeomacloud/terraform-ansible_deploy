terraform {
  required_version = ">= 1.0.0"
}

variable "region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "us-east-1"
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 3
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "Optional AMI id to use. If empty, we will lookup the latest Amazon Linux 2 AMI for the region."
  type        = string
  default     = ""
}

variable "key_name" {
  description = "Name of an existing EC2 key pair in the region for SSH access"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "Optional subnet id to launch instances into (if empty, launches into default subnet for the VPC)"
  type        = string
  default     = ""
}

variable "associate_public_ip" {
  description = "Whether to assign public IP addresses to instances (true or false)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Map of tags to add to created resources"
  type        = map(string)
  default     = {
    Project = "terraform-vm-demo"
    Owner   = "terraform-user"
  }
}

variable "name_prefix" {
  description = "Name prefix for EC2 instances"
  type        = string
  default     = "demo-vm"
}
