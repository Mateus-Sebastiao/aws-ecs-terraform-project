provider "aws" {
  region = var.region
}

module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  azs             = ["us-east-1a", "us-east-1b"]
}

module "security_groups" {
  source   = "./modules/security_groups"
  vpc_id   = module.vpc.vpc_id
  app_port = 8080
}

module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets_ids
  alb_sg_id      = module.security_groups.alb_sg_id
  target_port    = 8080
}

module "ecs" {
  source             = "./modules/ecs"
  region             = var.region
  image_url          = "${module.ecr.repository_url}:latest"
  execution_role_arn = module.iam.execution_role_arn
  container_port     = 8080
  cpu                = 256
  memory             = 512
  private_subnets    = module.vpc.private_subnets_ids
  service_sg_id      = module.security_groups.app_sg_id
  target_group_arn   = module.alb.target_group_arn
}

module "iam" {
  source = "./modules/iam"
}

module "ecr" {
  source          = "./modules/ecr"
  repository_name = "flask-app"
}