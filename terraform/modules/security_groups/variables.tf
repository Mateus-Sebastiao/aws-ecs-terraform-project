variable "vpc_id" {
  description = "ID da VPC onde os SGs serão criados"
  type        = string
}

variable "app_port" {
  description = "Porta do container da aplicação"
  type        = number
  default     = 8080
}

variable "project" {
  type = string
  default = "challenge"
}