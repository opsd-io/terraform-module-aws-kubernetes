locals {
  fixed_names = true
}

resource "aws_eks_node_group" "main" {
  for_each = var.node_groups

  node_group_name        = local.fixed_names ? each.key : null
  node_group_name_prefix = local.fixed_names ? null : each.key
  cluster_name           = aws_eks_cluster.main.name
  node_role_arn          = aws_iam_role.node.arn
  subnet_ids             = coalesce(each.value.subnet_ids, var.node_group_subnet_ids)
  tags = merge(var.common_tags, {
    Name = each.key
  })

  scaling_config {
    min_size     = each.value.min_size
    max_size     = each.value.max_size
    desired_size = each.value.desired_size
  }

  update_config {
    max_unavailable            = null
    max_unavailable_percentage = 10
  }

  ami_type       = each.value.ami_type
  capacity_type  = each.value.capacity_type
  disk_size      = each.value.disk_size
  instance_types = [each.value.instance_type]
  labels         = each.value.labels

  #   launch_template {
  #     id      = each.value.launch_template_id
  #     name    = each.value.launch_template_name
  #     version = each.value.launch_template_version
  #   }

  dynamic "remote_access" {
    for_each = var.ec2_ssh_key != null ? [1] : []
    content {
      ec2_ssh_key               = var.ec2_ssh_key
      source_security_group_ids = var.source_security_group_ids
    }
  }

  dynamic "taint" {
    for_each = each.value.taints
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  lifecycle {
    # only if node_group_name_prefix is in use, but (local.fixed_names == false) does not work..
    create_before_destroy = true
    ignore_changes = [
      # scaling_config[0].desired_size, # needed for autoscaling
    ]
  }

  depends_on = [
    aws_eks_cluster.main,
    aws_iam_role.node,
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    kubernetes_config_map.aws_auth,
  ]

}


resource "aws_eks_fargate_profile" "main" {
  for_each = var.fargate_profiles

  fargate_profile_name   = each.key
  cluster_name           = aws_eks_cluster.main.name
  pod_execution_role_arn = aws_iam_role.fargate.arn
  subnet_ids             = coalesce(each.value.subnet_ids, var.fargate_subnet_ids)
  tags = merge(var.common_tags, {
    Name = each.key
  })

  selector {
    namespace = each.value.namespace
    labels    = each.value.labels
  }

  depends_on = [
    aws_eks_cluster.main,
    aws_iam_role.fargate,
    aws_iam_role_policy_attachment.AmazonEKSFargatePodExecutionRolePolicy,
    kubernetes_config_map.aws_auth,
  ]

}
