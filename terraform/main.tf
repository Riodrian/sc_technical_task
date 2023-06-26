provider "aws" {
  region = var.region
}

module "networking" {
  source   = "./modules/networking"
  vpc_name = var.vpc_name
}

resource "aws_ecr_repository" "jokes-repository" {
  name = var.repository_name
}

module "eks_cluster" {
  source           = "./modules/eks"
  vpc_id           = module.networking.vpc_id
  public_subnets   = module.networking.public_subnets
  private_subnets  = module.networking.private_subnets
  eks_cluster_name = var.eks_cluster_name
  sg_id            = module.networking.sg_id
}

module "github" {
  source = "./modules/github"
}
