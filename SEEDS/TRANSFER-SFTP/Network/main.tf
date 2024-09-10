# SFTP Transfer Server in the network account
resource "aws_transfer_server" "sftp_server" {
  endpoint_type          = "VPC"
  identity_provider_type = "SERVICE_MANAGED"
  logging_role           = var.logging_role

  tags = local.common_tags
}

# Create a dynamic set of users with SSH keys retrieved from Secrets Manager
resource "aws_transfer_user" "sftp_users" {
  for_each = var.sftp_users

  server_id     = aws_transfer_server.sftp_server.id
  user_name     = each.key
  role          = aws_iam_role.sftp_user_role.arn
  home_directory = "/${var.prod_s3_bucket_name}"

  # Fetch SSH public key from Secrets Manager
  ssh_public_key_body = data.aws_secretsmanager_secret_version.ssh_key[each.key].secret_string

  tags = local.common_tags
}

# Retrieve SSH public keys from Secrets Manager for each user
data "aws_secretsmanager_secret_version" "ssh_key" {
  for_each      = var.sftp_users
  secret_id     = "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:${each.key}-ssh-key"
}

# IAM role for the SFTP user in the network account to access the S3 bucket in the prod account
resource "aws_iam_role" "sftp_user_role" {
  name               = "${var.project}-${var.environment}-${var.region}-sftp-role-${var.unique_identifier}"
  assume_role_policy = data.aws_iam_policy_document.sftp_assume_role_policy.json

  tags = local.common_tags
}

data "aws_iam_policy_document" "sftp_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }
  }
}

# IAM Policy for cross-account access to the S3 bucket in the prod account
resource "aws_iam_policy" "sftp_user_policy" {
  name        = "${var.project}-${var.environment}-${var.region}-sftp-policy-${var.unique_identifier}"
  description = "SFTP user policy to access the S3 bucket in the production account"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
        Effect   = "Allow",
        Resource = "arn:aws:s3:::${var.prod_s3_bucket_arn}/*"
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "sftp_user_policy_attachment" {
  role       = aws_iam_role.sftp_user_role.name
  policy_arn = aws_iam_policy.sftp_user_policy.arn
}

# Security group for SFTP server in the network account
resource "aws_security_group" "sftp_security_group" {
  name        = "${var.project}-${var.environment}-${var.region}-sftp-sg-${var.unique_identifier}"
  description = "Security group for SFTP access in network account"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_hosts
    description = "Allow SSH access from trusted IPs"
  }

  tags = local.common_tags
}
