# Variables for EC2 instance creation
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to launch the EC2 instance"
  type        = string
}

variable "security_group_ids" {
  description = "List of Security Group IDs for the EC2 instance"
  type        = list(string)
}

variable "root_volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
}

variable "kms_key_id" {
  description = "KMS key ID for EBS volume encryption"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "Name of the IAM instance profile"
  type        = string
}

variable "iam_role_name" {
  description = "IAM role name attached to EC2"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "unique_id" {
  description = "Unique identifier for the resource"
  type        = string
}
