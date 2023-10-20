locals {
  account_map = {
    current = data.aws_caller_identity.current.account_id
  }

  # TODO: merge with extra roles from vars
  nodes_role_arns = [aws_iam_role.node.arn]
  nodes_map = [for arn in local.nodes_role_arns : {
    rolearn  = arn
    username = "system:node:{{EC2PrivateDNSName}}"
    groups = [
      "system:bootstrappers",
      "system:nodes",
    ]
  }]

  # TODO: merge with extra roles from vars
  fargate_role_arns = [aws_iam_role.fargate.arn]
  fargate_map = [for arn in local.fargate_role_arns : {
    rolearn  = arn
    username = "system:node:{{SessionName}}"
    groups = [
      "system:bootstrappers",
      "system:nodes",
      "system:node-proxier",
    ]
  }]

  # TODO: merge with extra roles from vars
  masters_role_arns = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/devops"]
  masters_map = [for arn in local.masters_role_arns : {
    rolearn  = arn
    username = "master:{{AccountID}}:{{SessionName}}"
    groups = [
      "system:masters",
    ]
  }]
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapAccounts = yamlencode([
      for account_id in var.auth_map_accounts : lookup(local.account_map, account_id, account_id)
    ])
    mapRoles = yamlencode(flatten([
      local.nodes_map,
      local.fargate_map,
      local.masters_map, [
        for role in var.auth_map_roles : {
          rolearn  = role.arn
          username = role.username
          groups   = role.groups
        }
      ]
    ]))
    mapUsers = yamlencode([
      for user in var.auth_map_users : {
        userarn  = user.arn
        username = user.username
        groups   = user.groups
      }
    ])
  }

  depends_on = [
    aws_eks_cluster.main,
  ]

}
