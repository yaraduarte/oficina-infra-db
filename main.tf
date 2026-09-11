terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5"

  backend "s3" {
    bucket = "oficina-marimb0ndo-tfstate"
    key    = "infra-db/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

# Busca a VPC default da conta
data "aws_vpc" "default" {
  default = true
}

# Busca as subnets da VPC default
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group — permite acesso ao PostgreSQL apenas dentro da VPC
resource "aws_security_group" "rds_sg" {
  name        = "oficina-rds-sg"
  description = "Security group para o RDS PostgreSQL da Oficina Marimbondo"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
    description = "PostgreSQL dentro da VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "oficina-rds-sg"
    Environment = var.environment
    Project     = "oficina-marimb0ndo"
  }
}

# Subnet Group para o RDS
resource "aws_db_subnet_group" "oficina" {
  name       = "oficina-db-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name        = "oficina-db-subnet-group"
    Environment = var.environment
    Project     = "oficina-marimb0ndo"
  }
}

# RDS PostgreSQL 15 — db.t3.micro (free tier)
resource "aws_db_instance" "oficina_postgres" {
  identifier        = "oficina-marimb0ndo-db"
  engine            = "postgres"
  engine_version    = "15"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.oficina.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible     = false
  multi_az                = false
  backup_retention_period = 7
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = {
    Name        = "oficina-marimb0ndo-db"
    Environment = var.environment
    Project     = "oficina-marimb0ndo"
  }
}
