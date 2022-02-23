output "cluster-endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "cluster-id" {
  value = aws_eks_cluster.cluster.id
}

output "cluster-status" {
  value = aws_eks_cluster.cluster.status
}

output "cluster-platform-version" {
  value = aws_eks_cluster.cluster.platform_version
}

output "cluster-vpc-config" {
  value = aws_eks_cluster.cluster.vpc_config
}

output "cluster_name" {
  value = "${var.owner}-${var.cluster_name}"
}

output "region" {
  value = var.region
}