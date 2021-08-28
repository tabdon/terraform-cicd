output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.app.vpc_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.app.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.app.public_subnets
}

output "sg_ids" {
  description = "A map containing IDs of security groups"
  value       = module.app.sg_ids
}

output "db_hostname" {
  description = "Database hostname"
  value       = module.app.db_config.hostname
  sensitive = true
}

output "db_password" {
  value     = module.app.db_config.password
  sensitive = true
}

output "instance_id" {
  description = "Instance ID"
  value       = module.app.instance_id
}

output "instance_public_ip" {
  description = "Public IP address of the instance"
  value       = module.app.public_ip
}
