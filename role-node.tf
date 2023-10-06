# Reference: https://docs.aws.amazon.com/eks/latest/userguide/create-node-role.html

data "aws_iam_policy_document" "assume_role_node" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "node" {
  name               = format("eks-%s-node-role", trimprefix(var.name, "eks-"))
  assume_role_policy = data.aws_iam_policy_document.assume_role_node.json
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}

# The AmazonEKS_CNI_Policy policy must be attached to either this role
# or to a different role that is mapped to the aws-node Kubernetes service account.
resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}
