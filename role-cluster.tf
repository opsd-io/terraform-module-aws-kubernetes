# Reference: https://docs.aws.amazon.com/eks/latest/userguide/service_IAM_role.html

data "aws_iam_policy_document" "assume_role_cluster" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cluster" {
  name               = format("eks-%s-cluster-role", trimprefix(var.name, "eks-"))
  assume_role_policy = data.aws_iam_policy_document.assume_role_cluster.json
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}
