# Creating an EC2 instance with NIST 800-53 compliance

resource "aws_instance" "ec2_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_ids]

  # Attach the IAM role to the EC2 instance
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  
  # Encrypted EBS volume
  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_volume_size
    encrypted   = true
    kms_key_id  = var.kms_key_id
  }

  tags = {
    Name = "${var.project}-${var.environment}-${var.region}-ec2-instance-${var.unique_id}"
  }
}

# IAM Instance Profile for attaching IAM Role to EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = var.iam_instance_profile_name
  role = var.iam_role_name
}
