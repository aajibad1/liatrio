output "cluster_name" {
    description = "Kubernetes Cluster Name"
    value = aws_eks_cluster.liatrio.name
}
output "cluster_id" {
    description = "Kubernetes Cluster Name"
    value = aws_eks_cluster.liatrio.id
}
output "region" {
  description = "AWS region"
  value       = var.AWS_REGION
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.liatrio.endpoint
}

#output "cluster_ca_certificate" {
#  value = aws_eks_cluster.liatrio.certificate_authority[0].data
#}
