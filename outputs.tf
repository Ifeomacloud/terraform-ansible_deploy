output "instance_ids" {
  description = "IDs of the created EC2 instances"
  value       = aws_instance.vm[*].id
}

output "public_ips" {
  description = "Public IPs of the created EC2 instances (empty if not assigned)"
  value       = aws_instance.vm[*].public_ip
}

output "private_ips" {
  description = "Private IPs of the created EC2 instances"
  value       = aws_instance.vm[*].private_ip
}

output "instance_private_dns" {
  description = "Private DNS names"
  value       = aws_instance.vm[*].private_dns
}
