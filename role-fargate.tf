# Reference: https://docs.aws.amazon.com/eks/latest/userguide/pod-execution-role.html

data "aws_iam_policy_document" "assume_role_fargate" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["eks-fargate-pods.amazonaws.com"]
    }
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "fargate" {
  name               = format("eks-%s-fargate-pods-role", trimprefix(var.name, "eks-"))
  assume_role_policy = data.aws_iam_policy_document.assume_role_fargate.json
}

resource "aws_iam_role_policy_attachment" "AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate.name
}
