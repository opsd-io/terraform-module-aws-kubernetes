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

variable "auth_map_accounts" {
  description = "Maps IAM ARN from these accounts to username."
  type        = list(string)
  default     = ["current"]
}

variable "auth_map_roles" {
  description = "Maps an IAM role to a username and set of groups."
  type = list(object({
    role_arn = string
    username = optional(string)
    groups   = list(string)
  }))
  default = []
}

variable "auth_map_users" {
  description = "Maps an IAM user to a static username and set of groups."
  type = list(object({
    user_arn = string
    username = optional(string)
    groups   = list(string)
  }))
  default = []
}
