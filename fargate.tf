resource "aws_eks_fargate_profile" "cluster" {
  cluster_name           = aws_eks_cluster.cluster.name
  fargate_profile_name   = "${var.owner}-${var.cluster_name}"
  pod_execution_role_arn = aws_iam_role.eks-fargate.arn
  subnet_ids             = [
    aws_subnet.subnet-private-1.id,
    aws_subnet.subnet-private-2.id,
    # aws_subnet.subnet-public-1.id,
    # aws_subnet.subnet-public-2.id
  ]

  selector {
    namespace = "trust-center"
  }
}

resource "aws_iam_role" "eks-fargate" {
  name = "eks-fargate-profile"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.eks-fargate.name
}