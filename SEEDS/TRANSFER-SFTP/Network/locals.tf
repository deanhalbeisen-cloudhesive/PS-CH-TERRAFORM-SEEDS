locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    Region      = var.region
    Compliance  = "NIST-800-53"
  }
}
