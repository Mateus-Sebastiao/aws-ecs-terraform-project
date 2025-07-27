variable "region" {
  type = string
}

variable "image_url" {
  type = string
}

variable "container_port" {
  type = number
  default = 8080
}

variable "cpu" {
  type = number
  default = 256
}

variable "memory" {
  type = number
  default = 512
}

variable "execution_role_arn" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "service_sg_id" {
  type = string
}

variable "project" {
  type = string
  default = "challenge"
}