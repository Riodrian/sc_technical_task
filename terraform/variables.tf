variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "jokes-vpc"
}

variable "repository_name" {
  description = "ECR repository name"
  type        = string
  default     = "jokes-repository"
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "jokes-cluster"
}
