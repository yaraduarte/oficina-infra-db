output "rds_endpoint" {
  description = "Endpoint de conexão do RDS"
  value       = aws_db_instance.oficina_postgres.endpoint
}

output "rds_host" {
  description = "Host do RDS (sem porta)"
  value       = aws_db_instance.oficina_postgres.address
}

output "rds_port" {
  description = "Porta do RDS"
  value       = aws_db_instance.oficina_postgres.port
}

output "rds_db_name" {
  description = "Nome do banco de dados"
  value       = aws_db_instance.oficina_postgres.db_name
}

output "security_group_id" {
  description = "ID do Security Group do RDS"
  value       = aws_security_group.rds_sg.id
}
