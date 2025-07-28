# AWS ECS Fargate + Terraform + CI/CD

Este projeto implementa uma aplicação Flask containerizada na AWS utilizando:
- **Docker**
- **ECS (Fargate)**
- **ECR**
- **Application Load Balancer**
- **Terraform**
- **GitHub Actions (CI/CD)**

A infraestrutura é totalmente gerenciada como código, com módulos reutilizáveis e boas práticas de DevOps.

## Estrutura do Repositório

```bash
terraform # Código de infraestrutura
/src # Código da aplicação e Dockerfile
/.github/workflows # Pipeline CI/CD
README.md
```

## Pré-requisitos

1. [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) configurado com credenciais válidas
2. [Terraform](https://developer.hashicorp.com/terraform/downloads)
3. Conta AWS com permissões para ECS, ECR, VPC, IAM, ALB
4. Backend Remoto com S3 + DynamoDB (para `terraform state`)

## Como criar Backend Remoto
Rode no AWS CLI: 

```bash
aws s3api create-bucket --bucket <nome-do-bucket> --endpoint-url https://s3.amazonaws.com
```

```bash
aws dynamodb create-table \
  --table-name <nome-da-tabela> \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

Insira as informações no `backend.tf` consoante as alterações. Mas caso prefera usar o diretório local para salvar o `terraform.tfstate`, apenas comente todo ficheiro `backend.tf`

## Executando o Terraform localmente

```bash
git clone
```

```bash
cd terraform/
```

```bash
terraform init
terraform plan -out plan.tfplan
terraform apply plan.tfplan
```
---

## Acessando a aplicação via Load Balancer

Após o `terraform apply`, copie o DNS do Load Balancer do output:

```bash
terraform output alb_dns_name
```

Acesse via navegador ou use curl:

```bash
curl http://<DNS_DO_ALB>/health
```
---

## Verificando logs no CloudWatch

1. Acesse [AWS CloudWatch → Logs](https://console.aws.amazon.com/cloudwatch/home#logs:)
2. Busque pelo log group: `/ecs/challenge`
3. Clique no stream mais recente para visualizar os logs.

Alternativamente via CLI:

```bash
aws logs tail /ecs/challenge --follow --region us-east-1
```
---

## Executando a pipeline CI/CD com GitHub Actions

A pipeline está definida em `.github/workflows/deploy.yaml`.

Ela realiza os seguintes passos automaticamente ao dar push na branch `main`:

1. Checkout do repositório
2. Execução do Terraform (`init`, `plan`, `apply`)
3. Build da imagem Docker
4. Push para o Amazon ECR

Configure os segredos (`Settings > Secrets and Variables > Actions`):

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`
- `ECR_REPOSITORY`

```yaml
env:
  AWS_REGION: <sua-regiao>
  ECR_REPOSITORY: challenge/flask-app
```
---

## Destruindo a infraestrutura

Execute:

```bash
terraform destroy
```