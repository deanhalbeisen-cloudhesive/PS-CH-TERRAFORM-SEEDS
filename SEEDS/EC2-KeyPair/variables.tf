# Variables for EC2 key pair
variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
}

variable "public_key" {
  description = "Public key material for the EC2 key pair"
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
