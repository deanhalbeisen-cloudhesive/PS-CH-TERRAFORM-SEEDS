# Variables for RDS Aurora MySQL Cluster

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

variable "instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "master_username" {
  description = "Master username for the Aurora MySQL cluster"
  type        = string
}

variable "master_password" {
  description = "Master password for the Aurora MySQL cluster"
  type        = string
}

variable "kms_key_id" {
  description = "KMS key ID for storage encryption"
  type        = string
}
