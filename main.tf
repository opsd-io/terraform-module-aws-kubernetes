terraform {
  required_version = ">= 1.5.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

data "aws_caller_identity" "current" {
  # no arguments
}

data "aws_region" "current" {
  # no arguments
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

  dynamic "encryption_config" {
    for_each = var.encryption_key_arn != null ? [1] : []
    content {
      provider {
        key_arn = var.encryption_key_arn
      }
      resources = ["secrets"]

    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_fargate_pod_execution_role_policy,
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
