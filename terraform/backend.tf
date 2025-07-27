terraform {
  backend "s3" {
    bucket         = "meu-bucket-terraform-20250727"
    key            = "infra/producao/terraform.tfstate"
    region         = var.region
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}