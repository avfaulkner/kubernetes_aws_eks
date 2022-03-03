#controlplane SG
resource "aws_security_group" "control" {
  name        = "control-plane-SG"
  description = "Communication between the control plane and worker nodegroups"
  vpc_id      = aws_vpc.eks-vpc.id

  tags = {
    Name = "${var.owner}-sg-eks-controlplane"
  }
}

resource "aws_security_group_rule" "control-out" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.control.id
}

#worker node group SG
resource "aws_security_group" "nodes" {
  name        = "node-group-SG"
  description = "Communication between all nodes in the cluster"
  vpc_id      = aws_vpc.eks-vpc.id

  tags = {
    Name = "${var.owner}-sg-eks-nodes"
  }
}

resource "aws_security_group_rule" "nodes-out" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nodes.id
}

resource "aws_security_group_rule" "nodes-in" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "all"
  source_security_group_id = aws_security_group.control.id
  security_group_id        = aws_security_group.control.id
}