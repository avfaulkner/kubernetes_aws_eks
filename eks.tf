module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.5.1"
  cluster_name                    = "trust-center"
  cluster_version                 = "1.21"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
}