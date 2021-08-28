output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "sg_ids" {
  description = "A map containing IDs of security groups"
  value = {
    app_server_sg = module.app_server_sg.security_group_id
    db_sg         = module.db_sg.security_group_id
  }
}

output "db_config" {
  description = "A map containing details about the DB configuration"
  value = {
    user     = aws_db_instance.database.username
    password = aws_db_instance.database.password
    database = aws_db_instance.database.name
    hostname = aws_db_instance.database.address
    port     = aws_db_instance.database.port
  }
  sensitive = true
}

output "instance_id" {
  description = "The ID of the instance"
  value       = aws_instance.app.id
}

output "public_ip" {
  description = "The public IP address of the instance"
  value       = aws_instance.app.public_ip
}
