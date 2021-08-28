module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  version          = "2.64.0"
  name             = "${var.project}-${terraform.workspace}-vpc"
  cidr             = var.cidr_block
  azs              = data.aws_availability_zones.available.names
  database_subnets = var.private_subnet
  public_subnets   = [var.public_subnet]

  create_database_subnet_group = true
  enable_nat_gateway           = false
  single_nat_gateway           = false
}

module "app_server_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${terraform.workspace}-app-server-sg"
  description = "Security group for instances in VPC"
  vpc_id      = module.vpc.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "db_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${terraform.workspace}-db-server-sg"
  description = "Security group for db servers in VPC"
  vpc_id      = module.vpc.vpc_id
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.app_server_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%*"
}

resource "aws_db_instance" "database" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t2.micro"
  identifier             = "${var.project}-${terraform.workspace}-db-instance"
  name                   = "db"
  username               = "admin"
  password               = random_password.password.result
  db_subnet_group_name   = module.vpc.database_subnet_group
  vpc_security_group_ids = [module.db_sg.security_group_id]
  skip_final_snapshot    = true
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.app_server_sg.security_group_id]
  key_name               = "smx-prod-ec2"
  user_data              = data.cloudinit_config.config.rendered

  tags = {
    "Name"        = "${var.project}-${terraform.workspace}-instance"
    "Project"     = "${var.project}"
    "Technology"  = "Terraform"
    "Environment" = "${terraform.workspace}"
  }
}
