variable "vpc_cidr_block" {
  description = "VPC CIDR block of cluster"
}

variable "owner" {
  description = "Owner of resources"
}

variable "region" {
  description = "Region in which the cluster is placed"
}

variable "cluster_name" {
  type        = string
  description = "(optional) describe your variable"
}