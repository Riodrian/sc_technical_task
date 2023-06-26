output "registry_id" {
  description = "The account ID of the registry holding the repository."
  value       = aws_ecr_repository.jokes-repository.registry_id
}

output "repository_url" {
  description = "The URL of the repository."
  value       = aws_ecr_repository.jokes-repository.repository_url
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks_cluster.cluster_endpoint
}
