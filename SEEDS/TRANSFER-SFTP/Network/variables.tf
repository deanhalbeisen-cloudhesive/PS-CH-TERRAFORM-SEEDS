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

variable "vpc_id" {
  description = "ID of the VPC for the SFTP server in the network account"
  type        = string
}

variable "allowed_hosts" {
  description = "List of CIDR blocks that are allowed to connect to the SFTP server"
  type        = list(string)
}

variable "logging_role" {
  description = "IAM role for CloudWatch logging"
  type        = string
}

variable "sftp_users" {
  description = "Map of SFTP users and their associated metadata"
  type        = map(any)
}

variable "prod_s3_bucket_arn" {
  description = "ARN of the S3 bucket in the production account"
  type        = string
}

variable "prod_s3_bucket_name" {
  description = "Name of the S3 bucket in the production account"
  type        = string
}

variable "account_id" {
  description = "AWS Account ID of the network account"
  type        = string
}
