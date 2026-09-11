variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "oficina_db"
}

variable "db_username" {
  description = "Usuário do banco de dados"
  type        = string
  default     = "oficina_admin"
}

variable "db_password" {
  description = "Senha do banco de dados"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Ambiente (dev, prod)"
  type        = string
  default     = "prod"
}
