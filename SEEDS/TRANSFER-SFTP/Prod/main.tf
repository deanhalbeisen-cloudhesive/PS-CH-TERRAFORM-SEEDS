# S3 Bucket in the production account for storing SFTP data
resource "aws_s3_bucket" "prod_s3_bucket" {
  bucket = "${var.project}-${var.environment}-${var.region}-sftp-prod-${var.unique_identifier}"

  # Enable versioning and MFA delete
  versioning {
    enabled    = true
    mfa_delete = true
  }

  # Bucket lifecycle policy
  lifecycle_rule {
    id      = "S3LifecycleRule"
    enabled = true

    # Transition to STANDARD_IA after 35 days
    transition {
      days          = 35
      storage_class = "STANDARD_IA"
    }

    # Transition to GLACIER after 265 days
    transition {
      days          = 36
      storage_class = "GLACIER"
    }

    # Transition to GLACIER_DEEP_ARCHIVE after 2 years
    transition {
      days          = 365
      storage_class = "DEEP_ARCHIVE"
    }
  }

  # Prevent public access to the bucket
  acl = "private"

  # Enable logging
  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
  }

  tags = local.common_tags
}

# Logging bucket in the production account
resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.project}-${var.environment}-${var.region}-sftp-logs-${var.unique_identifier}"

  versioning {
    enabled = true
  }

  acl = "log-delivery-write"

  tags = local.common_tags
}

# Allow the network account's role to access the S3 bucket in the production account
resource "aws_s3_bucket_policy" "sftp_bucket_policy" {
  bucket = aws_s3_bucket.prod_s3_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = var.network_account_role_arn
        },
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = "arn:aws:s3:::${aws_s3_bucket.prod_s3_bucket.bucket}/*"
      }
    ]
  })

  tags = local.common_tags
}
