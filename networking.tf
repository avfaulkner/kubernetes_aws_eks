# VPC
resource "aws_vpc" "eks-vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.owner}-eks-vpc"
  }
}

# Route tables
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

resource "aws_route_table" "eks-rt-private-1" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.owner}-eks-rt-private-${var.region}a"
  }
}

resource "aws_route_table" "eks-rt-private-2" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.owner}-eks-rt-private-${var.region}c"
  }
}

#route table associations
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.subnet-public-1.id
  route_table_id = aws_route_table.eks-rt-public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.subnet-public-2.id
  route_table_id = aws_route_table.eks-rt-public.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.subnet-private-1.id
  route_table_id = aws_route_table.eks-rt-private-1.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.subnet-private-2.id
  route_table_id = aws_route_table.eks-rt-private-2.id
}

#subnets public
resource "aws_subnet" "subnet-public-1" {
  cidr_block              = var.public_subnet_block_1
  vpc_id                  = aws_vpc.eks-vpc.id
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.owner}-eks-public-${var.region}a"
  }
}

resource "aws_subnet" "subnet-public-2" {
  cidr_block              = var.public_subnet_block_2
  vpc_id                  = aws_vpc.eks-vpc.id
  availability_zone       = "${var.region}c"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.owner}-eks-public-${var.region}c"
  }
}

#subnets private
resource "aws_subnet" "subnet-private-1" {
  cidr_block        = var.private_subnet_block_1
  vpc_id            = aws_vpc.eks-vpc.id
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.owner}-eks-private-${var.region}a"
  }
}

resource "aws_subnet" "subnet-private-2" {
  cidr_block        = var.private_subnet_block_2
  vpc_id            = aws_vpc.eks-vpc.id
  availability_zone = "${var.region}c"

  tags = {
    Name = "${var.owner}-eks-private-${var.region}c"
  }
}

#internet gateway
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
  subnet_id     = aws_subnet.subnet-private-1.id

  tags = {
    "Name" = "${var.owner}-eks-nat"
  }
}

# The subnet resource below will dynamically create one subnet in each availibility zone (obtained from the data resource below)
# within the chosen region.
# The chosen region is placed in terraform.tfvars and used in the AWS provider in providers.tf.
# Dynamic subnets will be useful for node groups that contain multiple EC2 instances.

data "aws_availability_zones" "zones" {
  state = "available"
}

# node group
resource "aws_subnet" "nodes" {
  count = length(data.aws_availability_zones.zones.names)

  availability_zone = data.aws_availability_zones.zones.names[count.index]
  cidr_block        = cidrsubnet(aws_vpc.eks-vpc.cidr_block, 8, count.index)
  vpc_id            = aws_vpc.eks-vpc.id

  tags = {
    "kubernetes.io/cluster/${aws_eks_cluster.cluster.name}" = "shared"
  }
}
