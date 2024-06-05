<a href="https://www.opsd.io" target="_blank"><img alt="OPSd" src=".github/img/OPSD_logo.svg" width="180px"></a>

Meet **OPSd**. The unique and effortless way of managing cloud infrastructure.

# terraform-module-aws-kubernetes

## Introduction

What does the module provide?

## Usage

```hcl
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
}
```

**IMPORTANT**: Make sure not to pin to master because there may be breaking changes between releases.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_eks_cluster.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_fargate_profile.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_fargate_profile) | resource |
| [aws_eks_node_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_openid_connect_provider.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.fargate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ec2_container_registry_readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_cluster_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_fargate_pod_execution_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_worker_node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [kubernetes_config_map.aws_auth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.assume_role_fargate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.assume_role_node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [tls_certificate.oidc_issuer](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auth_map_accounts"></a> [auth\_map\_accounts](#input\_auth\_map\_accounts) | Maps IAM ARN from these accounts to username. | `list(string)` | <pre>[<br>  "current"<br>]</pre> | no |
| <a name="input_auth_map_roles"></a> [auth\_map\_roles](#input\_auth\_map\_roles) | Maps an IAM role to a username and set of groups. | <pre>list(object({<br>    arn      = string<br>    username = optional(string)<br>    groups   = optional(list(string))<br>  }))</pre> | `[]` | no |
| <a name="input_auth_map_users"></a> [auth\_map\_users](#input\_auth\_map\_users) | Maps an IAM user to a static username and set of groups. | <pre>list(object({<br>    arn      = string<br>    username = optional(string)<br>    groups   = optional(list(string))<br>  }))</pre> | `[]` | no |
| <a name="input_cluster_log_retention_in_days"></a> [cluster\_log\_retention\_in\_days](#input\_cluster\_log\_retention\_in\_days) | Specifies the number of days you want to retain log events. | `number` | `7` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | A map of tags to assign to every resource in this module. | `map(string)` | `{}` | no |
| <a name="input_ec2_ssh_key"></a> [ec2\_ssh\_key](#input\_ec2\_ssh\_key) | The EC2 Key Pair name that provides access to the worker nodes. | `string` | `null` | no |
| <a name="input_enabled_cluster_log_types"></a> [enabled\_cluster\_log\_types](#input\_enabled\_cluster\_log\_types) | List of the desired control plane logging to enable. | `list(string)` | <pre>[<br>  "api",<br>  "authenticator",<br>  "controllerManager",<br>  "scheduler"<br>]</pre> | no |
| <a name="input_encryption_key_arn"></a> [encryption\_key\_arn](#input\_encryption\_key\_arn) | ARN of the KMS customer master key for secrets encryption. | `string` | `null` | no |
| <a name="input_endpoint_private_access"></a> [endpoint\_private\_access](#input\_endpoint\_private\_access) | Whether the Amazon EKS private API server endpoint is enabled. | `bool` | `false` | no |
| <a name="input_endpoint_public_access"></a> [endpoint\_public\_access](#input\_endpoint\_public\_access) | Whether the Amazon EKS public API server endpoint is enabled. | `bool` | `true` | no |
| <a name="input_fargate_profiles"></a> [fargate\_profiles](#input\_fargate\_profiles) | Map of EKS Fargate Profile definitions. | <pre>map(object({<br>    subnet_ids = optional(set(string))<br>    namespace  = string<br>    labels     = optional(map(string))<br>  }))</pre> | `{}` | no |
| <a name="input_fargate_role_arns"></a> [fargate\_role\_arns](#input\_fargate\_role\_arns) | Additional IAM role ARNs of Fargate Profiles managed externally. | `list(string)` | `[]` | no |
| <a name="input_fargate_subnet_ids"></a> [fargate\_subnet\_ids](#input\_fargate\_subnet\_ids) | Identifiers of private EC2 Subnets to associate with the EKS Fargate Profiles. | `set(string)` | `[]` | no |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | Desired Kubernetes master version. | `string` | `null` | no |
| <a name="input_masters_role_arns"></a> [masters\_role\_arns](#input\_masters\_role\_arns) | List of IAM role to set as system:masters. Shortcut for auth\_map\_roles. | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the cluster. | `string` | n/a | yes |
| <a name="input_node_group_subnet_ids"></a> [node\_group\_subnet\_ids](#input\_node\_group\_subnet\_ids) | Identifiers of EC2 Subnets to associate with the EKS Node Groups. | `set(string)` | `[]` | no |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | Map of EKS Node Group definitions. | <pre>map(object({<br>    subnet_ids    = optional(set(string))<br>    ami_type      = optional(string, "AL2_x86_64")<br>    capacity_type = optional(string, "ON_DEMAND")<br>    instance_type = optional(string, "t3.medium")<br>    disk_size     = optional(number, 20)<br>    min_size      = optional(number, 0)<br>    max_size      = optional(number, 1)<br>    desired_size  = optional(number, 0)<br>    labels        = optional(map(string))<br>    taints = optional(list(object({<br>      key    = string<br>      value  = string<br>      effect = string # Valid values: NO_SCHEDULE, NO_EXECUTE, PREFER_NO_SCHEDULE.<br>    })), [])<br>  }))</pre> | `{}` | no |
| <a name="input_nodes_role_arns"></a> [nodes\_role\_arns](#input\_nodes\_role\_arns) | Additional IAM role ARNs of Node Groups managed externally. | `list(string)` | `[]` | no |
| <a name="input_public_access_cidrs"></a> [public\_access\_cidrs](#input\_public\_access\_cidrs) | List of CIDR blocks that can access the Amazon EKS public API server endpoint when enabled. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs to allow communication between your worker nodes and the Kubernetes control plane. | `set(string)` | `[]` | no |
| <a name="input_source_security_group_ids"></a> [source\_security\_group\_ids](#input\_source\_security\_group\_ids) | Set of EC2 Security Group IDs to allow SSH access (port 22) from on the worker nodes. | `set(string)` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs. Must be in at least two different availability zones. | `set(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the cluster. |
| <a name="output_cluster_ca"></a> [cluster\_ca](#output\_cluster\_ca) | Decoded CA certificate of the cluster. |
| <a name="output_cluster_role_arn"></a> [cluster\_role\_arn](#output\_cluster\_role\_arn) | The ARN of the IAM role that provides permissions for the Kubernetes control plane. |
| <a name="output_cluster_role_name"></a> [cluster\_role\_name](#output\_cluster\_role\_name) | The name of the IAM role that provides permissions for the Kubernetes control plane. |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Endpoint for your Kubernetes API server. |
| <a name="output_fargate_role_arn"></a> [fargate\_role\_arn](#output\_fargate\_role\_arn) | The ARN of the IAM Role that provides permissions for the EKS Fargate Profile. |
| <a name="output_fargate_role_name"></a> [fargate\_role\_name](#output\_fargate\_role\_name) | The name of the IAM Role that provides permissions for the EKS Fargate Profile. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the cluster. |
| <a name="output_name"></a> [name](#output\_name) | The name of the cluster. |
| <a name="output_node_role_arn"></a> [node\_role\_arn](#output\_node\_role\_arn) | The ARN of the IAM Role that provides permissions for the EKS Node Group. |
| <a name="output_node_role_name"></a> [node\_role\_name](#output\_node\_role\_name) | The name of the IAM Role that provides permissions for the EKS Node Group. |
| <a name="output_oidc_issuer"></a> [oidc\_issuer](#output\_oidc\_issuer) | Issuer URL for the OpenID Connect identity provider. |
| <a name="output_openid_arn"></a> [openid\_arn](#output\_openid\_arn) | The ARN assigned by AWS for IAM OpenID Connect of the cluster. |
| <a name="output_openid_sub"></a> [openid\_sub](#output\_openid\_sub) | The URL of the identity provider. Corresponds to the iss claim. |
| <a name="output_region"></a> [region](#output\_region) | The region of of the cluster. |
| <a name="output_version"></a> [version](#output\_version) | The Kubernetes master version. |
<!-- END_TF_DOCS -->

## Examples of usage

Do you want to see how the module works? See all the [usage examples](examples).

## Related modules

The list of related modules (if present).

## Contributing

If you are interested in contributing to the project, see see our [guide](https://github.com/opsd-io/contribution).

## Support

If you have a problem with the module or want to propose a new feature, you can report it via the project's (Github) issue tracker.

If you want to discuss something in person, you can join our community on [Slack](https://join.slack.com/t/opsd-community/signup).

## License

[Apache License 2.0](LICENSE)
