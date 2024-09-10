# Variables for KMS key creation
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
