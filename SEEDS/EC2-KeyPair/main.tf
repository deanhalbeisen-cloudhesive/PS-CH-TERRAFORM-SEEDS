# Creating EC2 key pair and storing it in Secrets Manager

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = var.key_name
  public_key = var.public_key
}

# Store the EC2 Key Pair in Secrets Manager
resource "aws_secretsmanager_secret" "ec2_key_secret" {
  name        = "${var.project}-${var.environment}-${var.region}-ec2-keypair-${var.unique_id}"
  description = "Key pair for EC2 instance"
}

resource "aws_secretsmanager_secret_version" "ec2_key_secret_version" {
  secret_id     = aws_secretsmanager_secret.ec2_key_secret.id
  secret_string = aws_key_pair.ec2_key_pair.key_pair_id
}
