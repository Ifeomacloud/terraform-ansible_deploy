region             = "us-east-1"
instance_count     = 2
instance_type      = "t3.micro"
# ami_id = ""                # leave blank to auto-select Amazon Linux 2
key_name           = "mykey"  # replace with your EC2 key pair name
# subnet_id = ""            # leave blank to use default subnet
associate_public_ip = true

name_prefix = "my-aws-vm"
tags = {
  Project = "ansible-project"
  Owner   = "Ifeoma"
}
