output "id" {
  description = "The ID of the cluster."
  value       = aws_eks_cluster.main.id
}

output "arn" {
  description = "The ARN of the cluster."
  value       = aws_eks_cluster.main.arn
}

output "name" {
  description = "The name of the cluster."
  value       = aws_eks_cluster.main.name
}

output "endpoint" {
  description = "Endpoint for your Kubernetes API server."
  value       = aws_eks_cluster.main.endpoint
}

output "version" {
  description = "The Kubernetes master version."
  value       = aws_eks_cluster.main.version
}

output "region" {
  description = "The region of the state storage resources."
  value       = data.aws_region.current.name
}

output "cluster_ca" {
  description = "Decoded CA certificate of the cluster."
  value       = base64decode(aws_eks_cluster.main.certificate_authority[0].data)
}

output "oidc_issuer" {
  description = "Issuer URL for the OpenID Connect identity provider."
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "openid_arn" {
  description = "The ARN assigned by AWS for IAM OpenID Connect of the cluster."
  value       = aws_iam_openid_connect_provider.eks_cluster.arn
}

output "openid_sub" {
  description = "The URL of the identity provider. Corresponds to the iss claim."
  value       = format("%s:sub", trimprefix(aws_iam_openid_connect_provider.eks_cluster.url, "https://"))
}

output "cluster_role_arn" {
  description = "The ARN of the IAM role that provides permissions for the Kubernetes control plane."
  value       = aws_iam_role.cluster.arn
}

output "cluster_role_name" {
  description = "The name of the IAM role that provides permissions for the Kubernetes control plane."
  value       = aws_iam_role.cluster.name
}

output "node_role_arn" {
  description = "The ARN of the IAM Role that provides permissions for the EKS Node Group."
  value       = aws_iam_role.node.arn
}

output "node_role_name" {
  description = "The name of the IAM Role that provides permissions for the EKS Node Group."
  value       = aws_iam_role.node.name
}

output "fargate_role_arn" {
  description = "The ARN of the IAM Role that provides permissions for the EKS Fargate Profile."
  value       = aws_iam_role.fargate.arn
}

output "fargate_role_name" {
  description = "The name of the IAM Role that provides permissions for the EKS Fargate Profile."
  value       = aws_iam_role.fargate.name
}
