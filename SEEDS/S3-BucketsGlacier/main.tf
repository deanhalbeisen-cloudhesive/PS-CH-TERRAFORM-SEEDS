# Creating an S3 bucket with versioning, lifecycle policy, and Glacier, compliant with NIST 800-53

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.project}-${var.environment}-${var.region}-s3-bucket-${var.unique_id}"

  # Enable versioning for the bucket
  versioning {
    enabled = true
  }

  tags = {
    Name = "${var.project}-${var.environment}-${var.region}-s3-bucket-${var.unique_id}"
  }
}

# Configure lifecycle policy for transition to Glacier
resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle" {
  bucket = aws_s3_bucket.s3_bucket.bucket

  rule {
    id     = "lifecycle_rule_glacier"
    status = "Enabled"

    # Transition to STANDARD_IA after 35 days
    transition {
      days          = 35
      storage_class = "STANDARD_IA"
    }

    # Transition to Glacier after 265 days
    transition {
      days          = 265
      storage_class = "GLACIER"
    }

    # Expire after 2 years
    expiration {
      days = 730
    }
  }
}
