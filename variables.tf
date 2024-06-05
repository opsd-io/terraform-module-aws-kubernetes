variable "common_tags" {
  description = "A map of tags to assign to every resource in this module."
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "The name of the cluster."
  type        = string
}

variable "k8s_version" {
  description = "Desired Kubernetes master version."
  type        = string
  default     = null
}

# EKS vpc_config

variable "subnet_ids" {
  description = "List of subnet IDs. Must be in at least two different availability zones."
  type        = set(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to allow communication between your worker nodes and the Kubernetes control plane."
  type        = set(string)
  default     = []
}

variable "endpoint_private_access" {
  description = "Whether the Amazon EKS private API server endpoint is enabled."
  type        = bool
  default     = false
}

variable "endpoint_public_access" {
  description = "Whether the Amazon EKS public API server endpoint is enabled."
  type        = bool
  default     = true
}

variable "public_access_cidrs" {
  description = "List of CIDR blocks that can access the Amazon EKS public API server endpoint when enabled."
  type        = list(string)
  default = [
    "0.0.0.0/0",
  ]
}

variable "encryption_key_arn" {
  description = "ARN of the KMS customer master key for secrets encryption."
  type        = string
  default     = null
}

# EKS control plane logs

variable "enabled_cluster_log_types" {
  description = "List of the desired control plane logging to enable."
  type        = list(string)
  default = [
    "api",
    # "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]
}

variable "cluster_log_retention_in_days" {
  description = "Specifies the number of days you want to retain log events."
  type        = number
  default     = 7
}

# Worker nodes

variable "ec2_ssh_key" {
  description = "The EC2 Key Pair name that provides access to the worker nodes."
  type        = string
  default     = null
}

variable "source_security_group_ids" {
  description = "Set of EC2 Security Group IDs to allow SSH access (port 22) from on the worker nodes."
  type        = set(string)
  default     = null
}


variable "node_group_subnet_ids" {
  description = "Identifiers of EC2 Subnets to associate with the EKS Node Groups."
  type        = set(string)
  default     = []
}

variable "node_groups" {
  description = "Map of EKS Node Group definitions."
  type = map(object({
    subnet_ids    = optional(set(string))
    ami_type      = optional(string, "AL2_x86_64")
    capacity_type = optional(string, "ON_DEMAND")
    instance_type = optional(string, "t3.medium")
    disk_size     = optional(number, 20)
    min_size      = optional(number, 0)
    max_size      = optional(number, 1)
    desired_size  = optional(number, 0)
    labels        = optional(map(string))
    taints = optional(list(object({
      key    = string
      value  = string
      effect = string # Valid values: NO_SCHEDULE, NO_EXECUTE, PREFER_NO_SCHEDULE.
    })), [])
  }))
  default = {}
}

# Fargate pods

variable "fargate_subnet_ids" {
  description = "Identifiers of private EC2 Subnets to associate with the EKS Fargate Profiles."
  type        = set(string)
  default     = []
}

variable "fargate_profiles" {
  description = "Map of EKS Fargate Profile definitions."
  type = map(object({
    subnet_ids = optional(set(string))
    namespace  = string
    labels     = optional(map(string))
  }))
  default = {}
}

# kube-system/aws-auth configmap

variable "auth_map_accounts" {
  description = "Maps IAM ARN from these accounts to username."
  type        = list(string)
  default     = ["current"]
}

variable "auth_map_roles" {
  description = "Maps an IAM role to a username and set of groups."
  type = list(object({
    arn      = string
    username = optional(string)
    groups   = optional(list(string))
  }))
  default = []
}

variable "auth_map_users" {
  description = "Maps an IAM user to a static username and set of groups."
  type = list(object({
    arn      = string
    username = optional(string)
    groups   = optional(list(string))
  }))
  default = []
}

variable "nodes_role_arns" {
  description = "Additional IAM role ARNs of Node Groups managed externally."
  type        = list(string)
  default     = []
}

variable "fargate_role_arns" {
  description = "Additional IAM role ARNs of Fargate Profiles managed externally."
  type        = list(string)
  default     = []
}

variable "masters_role_arns" {
  description = "List of IAM role to set as system:masters. Shortcut for auth_map_roles."
  type        = list(string)
  default = [
    # "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/devops",
  ]
}
