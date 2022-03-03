variable "vpc_cidr_block" {
  description = "VPC CIDR block of cluster"
}

variable "owner" {
  description = "Owner of resources"
}

variable "private_subnet_block_1" {
  description = "Private subnet"
}

variable "private_subnet_block_2" {
  description = "Private subnet"
}

variable "public_subnet_block_1" {
  description = "Public subnet"
}

variable "public_subnet_block_2" {
  description = "Public subnet"
}

variable "region" {
  description = "Region in which the cluster is placed"
}

variable "cluster_name" {
  type        = string
  description = "(optional) describe your variable"
}