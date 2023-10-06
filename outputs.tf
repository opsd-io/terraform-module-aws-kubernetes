output "id" {
  value = aws_eks_cluster.main.id
}

output "arn" {
  value = aws_eks_cluster.main.arn
}

output "name" {
  value = aws_eks_cluster.main.name
}

output "endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "version" {
  value = aws_eks_cluster.main.version
}

output "cluster_ca" {
  value = base64decode(aws_eks_cluster.main.certificate_authority[0].data)
}

output "oidc_issuer" {
  value = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "openid_arn" {
  value = aws_iam_openid_connect_provider.eks_cluster.arn
}

output "openid_sub" {
  value = format("%s:sub", trimprefix(aws_iam_openid_connect_provider.eks_cluster.url, "https://"))
}

output "cluster_role_arn" {
  value = aws_iam_role.cluster.arn
}

output "cluster_role_name" {
  value = aws_iam_role.cluster.name
}

output "node_role_arn" {
  value = aws_iam_role.node.arn
}

output "node_role_name" {
  value = aws_iam_role.node.name
}

output "fargate_role_arn" {
  value = aws_iam_role.fargate.arn
}

output "fargate_role_name" {
  value = aws_iam_role.fargate.name
}
