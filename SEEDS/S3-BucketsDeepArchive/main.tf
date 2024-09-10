# Creating an S3 bucket with versioning, lifecycle policy, and Glacier Deep Archive, compliant with NIST 800-53

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

# Configure lifecycle policy for transition to Glacier Deep Archive
resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle" {
  bucket = aws_s3_bucket.s3_bucket.bucket

  rule {
    id     = "lifecycle_rule_glacier_deep_archive"
    status = "Enabled"

    # Transition to STANDARD_IA after 35 days
    transition {
      days          = 35
      storage_class = "STANDARD_IA"
    }

    # Transition to Glacier Deep Archive after 265 days
    transition {
      days          = 265
      storage_class = "DEEP_ARCHIVE"
    }

    # Expire after 2 years
    expiration {
      days = 730
    }
  }
}
