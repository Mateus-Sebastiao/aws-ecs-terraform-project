variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "alb_sg_id" {
  description = "Security Group do ALB"
  type        = string
}

variable "public_subnets" {
  description = "Lista de subnets públicas"
  type        = list(string)
}

variable "target_port" {
  description = "Porta da aplicação containerizada"
  type        = number
  default     = 8080
}

variable "project" {
  type = string
  default = "challenge"
}