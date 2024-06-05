module "network" {
  source = "github.com/opsd-io/terraform-module-aws-network"

  vpc_name   = "k8s-test-vpc"
  cidr_block = "10.100.0.0/16"

  public_subnet_groups = {
    "public1" = {
      availability_zones = {
        "a" = { cidr_block = "10.100.1.0/24", nat_gateway = true }
        "b" = { cidr_block = "10.100.2.0/24" }
        "c" = { cidr_block = "10.100.3.0/24" }
      }
    }
  }
  private_subnet_groups = {
    "nodes1" = {
      nat_group_name = "public1"
      availability_zones = {
        "a" = { cidr_block = "10.100.101.0/24" }
        "b" = { cidr_block = "10.100.102.0/24" }
        "c" = { cidr_block = "10.100.103.0/24" }
      }
    }
    "fargate1" = {
      nat_group_name = "public1"
      availability_zones = {
        "a" = { cidr_block = "10.100.201.0/24" }
        "b" = { cidr_block = "10.100.202.0/24" }
        "c" = { cidr_block = "10.100.203.0/24" }
      }
    }
  }
}

module "kubernetes" {
  source = "github.com/opsd-io/terraform-module-aws-kubernetes"
  name   = "basic-k8s-example"

  subnet_ids = [
    for subnet in module.network.public_subnet_groups["public1"] : subnet.id
  ]

  node_group_subnet_ids = [
    for subnet in module.network.private_subnet_groups["nodes1"] : subnet.id
  ]
  node_groups = {
    main = {
      max_size     = 9
      desired_size = 1
      disk_size    = 8
    }
  }

  fargate_subnet_ids = [
    for subnet in module.network.private_subnet_groups["fargate1"] : subnet.id
  ]
  fargate_profiles = {
    "default-namespace" = { # default is bad, better put it "far"
      namespace = "default"
    }
    "amazonaws-components" = { # this should put CoreDNS on fargate
      namespace = "*"
      labels    = { "eks.amazonaws.com/component" = "*" }
    }
  }
}

module "autoscaler" {
  source         = "github.com/opsd-io/terraform-module-eks-autoscaler"
  cluster_region = module.kubernetes.region
  cluster_name   = module.kubernetes.name
  openid_arn     = module.kubernetes.openid_arn
  openid_sub     = module.kubernetes.openid_sub
}
