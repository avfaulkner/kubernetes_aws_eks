# cluster
resource "aws_eks_cluster" "cluster" {
  name     = "${var.owner}-${var.cluster_name}"
  role_arn = aws_iam_role.cluster-role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.subnet-public-1.id,
      aws_subnet.subnet-private-1.id,
      aws_subnet.subnet-public-2.id,
      aws_subnet.subnet-private-2.id
    ]
    # endpoint_private_access = true
    endpoint_public_access = true
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSVPCResourceController,
  ]
}

# worker node group
resource "aws_eks_node_group" "node-group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.owner}-nodes"
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids = [
    # aws_subnet.subnet-private-1.id,
    # aws_subnet.subnet-private-2.id,
    aws_subnet.subnet-public-1.id,
    aws_subnet.subnet-public-2.id
  ]
  instance_types = ["t3.2xlarge"] # 8 vCPU, 32G RAM
  disk_size      = 60
  ami_type       = "AL2_x86_64"
  capacity_type  = "ON_DEMAND"

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  # don't recreate the node group after scaling
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = {
    "kubernetes.io/cluster/${aws_eks_cluster.cluster.name}" = "owned"
    Name = "${var.owner}-eks-nodes"
  }
}
