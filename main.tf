terraform {
  required_version = ">= 1.3.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_eks_cluster" "main" {
  name     = var.name
  version  = var.k8s_version
  role_arn = aws_iam_role.cluster.arn
  tags = merge(var.common_tags, {
    Name = var.name
  })

  enabled_cluster_log_types = var.enabled_cluster_log_types

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
    security_group_ids      = var.security_group_ids
  }

  kubernetes_network_config {
    ip_family         = "ipv4"
    service_ipv4_cidr = "172.20.0.0/16"
  }

  #   encryption_config {
  #     provider {
  #       key_arn = "aaa"
  #     }
  #     resources = ["secrets"]
  #   }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKSFargatePodExecutionRolePolicy,
    aws_cloudwatch_log_group.cluster,
  ]
}

resource "aws_cloudwatch_log_group" "cluster" {
  name              = "/aws/eks/${var.name}/cluster"
  retention_in_days = var.cluster_log_retention_in_days
}

data "tls_certificate" "oidc_issuer" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks_cluster" {
  url = data.tls_certificate.oidc_issuer.url
  thumbprint_list = [
    data.tls_certificate.oidc_issuer.certificates[0].sha1_fingerprint
  ]
  client_id_list = ["sts.amazonaws.com"]
}
