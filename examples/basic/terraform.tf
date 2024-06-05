terraform {
  required_version = ">= 1.5.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

data "aws_eks_cluster_auth" "this" {
  name = module.kubernetes.name
}

provider "kubernetes" {
  host                   = module.kubernetes.endpoint
  cluster_ca_certificate = module.kubernetes.cluster_ca
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = module.kubernetes.endpoint
    cluster_ca_certificate = module.kubernetes.cluster_ca
    token                  = data.aws_eks_cluster_auth.this.token
  }
}
