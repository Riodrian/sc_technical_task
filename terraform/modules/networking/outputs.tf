output "vpc_id" {
  description = "VPC id"
  value = module.vpc.vpc_id
}

output "sg_id" {
  description = "Security group id"
  value = aws_security_group.eks_sg.id
}

output "public_subnets" {
  description = "Public subnets"
  value = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Private subnets"
  value = module.vpc.private_subnets
}
