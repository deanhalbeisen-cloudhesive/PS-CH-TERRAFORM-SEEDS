variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "unique_identifier" {
  description = "Unique identifier for the resource"
  type        = string
}

variable "network_account_role_arn" {
  description = "ARN of the IAM role in the network account that will access the S3 bucket"
  type        = string
}
