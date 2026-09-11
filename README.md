# oficina-infra-db

Infraestrutura do banco de dados gerenciado da **Oficina Marimbondo** — provisionado via Terraform na AWS.

## Tecnologias

- Terraform >= 1.5
- AWS RDS PostgreSQL 15 (db.t3.micro — free tier)
- AWS S3 (remote state)
- GitHub Actions (CI/CD)

## Arquitetura

```
GitHub Actions
     │
     ▼
Terraform
     │
     ├── aws_db_instance (RDS PostgreSQL 15 db.t3.micro)
     ├── aws_db_subnet_group (subnets da VPC default)
     └── aws_security_group (porta 5432 dentro da VPC)
```

## Pré-requisitos

- AWS CLI configurado (`aws configure`)
- Terraform >= 1.5 instalado
- Bucket S3 `oficina-marimb0ndo-tfstate` criado na conta AWS

## Como executar localmente

```bash
terraform init
terraform plan -var="db_password=SUA_SENHA"
terraform apply -var="db_password=SUA_SENHA"
```

## CI/CD

O pipeline executa automaticamente ao fazer push na branch `main`:

1. `terraform init` — inicializa o backend S3
2. `terraform validate` — valida os arquivos
3. `terraform plan` — exibe as mudanças
4. `terraform apply` — aplica (apenas na branch main)

### Secrets necessários no GitHub

| Secret | Descrição |
|--------|-----------|
| `AWS_ACCESS_KEY_ID` | Access key da AWS |
| `AWS_SECRET_ACCESS_KEY` | Secret key da AWS |
| `DB_PASSWORD` | Senha do banco de dados |

## Outputs

| Output | Descrição |
|--------|-----------|
| `rds_endpoint` | Endpoint completo (host:porta) |
| `rds_host` | Host do RDS |
| `rds_port` | Porta (5432) |
| `rds_db_name` | Nome do banco |
