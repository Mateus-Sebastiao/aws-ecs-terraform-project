terraform {
  backend "s3" {
    bucket         = "meu-bucket-terraform-20250727"
    key            = "infra/producao/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}