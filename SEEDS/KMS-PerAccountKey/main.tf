# Creating a KMS key with NIST 800-53 compliance

resource "aws_kms_key" "kms_key" {
  description             = "KMS Key for encryption"
  enable_key_rotation     = true

  tags = {
    Name = "${var.project}-${var.environment}-${var.region}-kms-key-${var.unique_id}"
  }
}
