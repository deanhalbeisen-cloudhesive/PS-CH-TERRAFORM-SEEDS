# Creating an IAM role for EC2 instances with NIST 800-53 compliance

resource "aws_iam_role" "ec2_iam_role" {
  name = var.iam_role_name

  # Assume role policy for EC2 to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# Attaching necessary policies to the role
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_policy" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "s3_policy" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "sfx_netapp_policy" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = var.sfx_netapp_policy_arn
}

resource "aws_iam_role_policy_attachment" "efs_netapp_policy" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = var.efs_netapp_policy_arn
}
