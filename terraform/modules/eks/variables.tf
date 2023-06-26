variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "jokes-cluster"
}

variable "eks_cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.24"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnets" {
  description = "Public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnets"
  type        = list(string)
}

variable "sg_id" {
  description = "Security group ID"
  type        = string
}
