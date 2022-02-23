# resource "aws_eks_fargate_profile" "cluster" {
#   cluster_name           = aws_eks_cluster.cluster.name
#   fargate_profile_name   = "example"
#   pod_execution_role_arn = aws_iam_role.example.arn
#   subnet_ids             = aws_subnet.example[*].id

#   selector {
#     namespace = "example"
#   }
# }

# resource "aws_iam_role" "example" {
#   name = "eks-fargate-profile-example"

#   assume_role_policy = jsonencode({
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "eks-fargate-pods.amazonaws.com"
#       }
#     }]
#     Version = "2012-10-17"
#   })
# }

# resource "aws_iam_role_policy_attachment" "example-AmazonEKSFargatePodExecutionRolePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
#   role       = aws_iam_role.example.name
# }