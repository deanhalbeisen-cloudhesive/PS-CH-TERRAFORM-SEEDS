# Variables for IAM role
variable "iam_role_name" {
  description = "Name of the IAM role for EC2 instances"
  type        = string
}

variable "sfx_netapp_policy_arn" {
  description = "ARN of the SFx Netapp policy"
  type        = string
}

variable "efs_netapp_policy_arn" {
  description = "ARN of the EFS Netapp policy"
  type        = string
}
