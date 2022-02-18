data "aws_availability_zones" "zones" {
  state = "available"
}

# VPC
resource "aws_vpc" "eks-vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.owner}-eks-vpc"
  }
}

resource "aws_route_table" "eks-rt-public" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.owner}-eks-rt-public"
  }
}

resource "aws_route_table" "eks-rt-private" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.owner}-eks-rt-private"
  }
}

resource "aws_subnet" "subnet-public" {
  cidr_block = var.public_subnet_block
  vpc_id = aws_vpc.eks-vpc.id
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.owner}-eks-public"
  }
}

resource "aws_subnet" "subnet-private" {
  cidr_block = var.private_subnet_block
  vpc_id = aws_vpc.eks-vpc.id
  availability_zone = "${var.region}c"

  tags = {
    Name = "${var.owner}-eks-private"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks-vpc.id

  tags = {
    Name = "${var.owner}-eks-igw"
  }
}

resource "aws_eip" "eip-nat" {
  vpc = true

  tags = {
    Name = "${var.owner}-eks-eip-nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip-nat.id
  subnet_id = aws_subnet.subnet-private.id
}


#node group
# resource "aws_subnet" "nodes" {
#   count = 2

#   availability_zone = data.aws_availability_zones.zones.names[count.index]
#   cidr_block        = cidrsubnet(aws_vpc.eks-vpc.cidr_block, 8, count.index)
#   vpc_id            = aws_vpc.eks-vpc.id

#   tags = {
#     "kubernetes.io/cluster/${aws_eks_cluster.cluster.name}" = "shared-by-nodes"
#   }
# }
