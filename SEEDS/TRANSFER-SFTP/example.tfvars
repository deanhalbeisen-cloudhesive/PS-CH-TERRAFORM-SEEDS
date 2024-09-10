project           = "myproject"
environment       = "prod"
region            = "us-east-1"
unique_identifier = "001"
vpc_id            = "vpc-12345678"
allowed_hosts     = ["203.0.113.0/24", "198.51.100.0/24"]
sftp_bucket_name  = "sftp-prod-bucket"
logging_role      = "arn:aws:iam::123456789012:role/logging-role"
account_id        = "123456789012"

sftp_users = {
  "user1" = {
    home_directory = "/sftp-bucket"
    # Secret created and stores the SSH key in Secrets Manager as user1-ssh-key
  },
  "user2" = {
    home_directory = "/sftp-bucket"
    # Secret created and stores the SSH key in Secrets Manager as user2-ssh-key
  },
  # Repeat for all 135 users...
}
