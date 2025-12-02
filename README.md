# Terraform + Ansible demo


## Prerequisites
- Terraform (v1.0+)
- AWS credentials configured (AWS CLI or env vars)
- ansible, jq installed on your control node (control node is where you'll run ansible-playbook). This can be your local machine or an EC2 instance acting as control.


## Quick flow
1. Edit `terraform.tfvars` to configure region, instance_count, and optionally `public_key_path` or `key_name`.
- If you set `public_key_path`, Terraform will create a key pair named `${name_prefix}-key` from that public key.
- If you have an existing key pair in AWS, set `key_name`.
2. Run Terraform:
```bash
terraform init
terraform apply -auto-approve