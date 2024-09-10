# Creating an RDS Aurora MySQL single-node cluster with NIST 800-53 compliance

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier       = "${var.project}-${var.environment}-${var.region}-rds-cluster-${var.unique_id}"
  engine                   = "aurora-mysql"
  engine_version           = "5.7.mysql_aurora.2.07.1"
  master_username          = var.master_username
  master_password          = var.master_password
  backup_retention_period  = 35
  preferred_backup_window  = "07:00-09:00"
  storage_encrypted        = true
  kms_key_id               = var.kms_key_id
  auto_minor_version_upgrade = true

  tags = {
    Name = "${var.project}-${var.environment}-${var.region}-rds-cluster-${var.unique_id}"
  }
}

# Creating an RDS cluster instance for Aurora
resource "aws_rds_cluster_instance" "aurora_cluster_instance" {
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.aurora_cluster.engine
  engine_version     = aws_rds_cluster.aurora_cluster.engine_version
  publicly_accessible = false

  tags = {
    Name = "${var.project}-${var.environment}-${var.region}-rds-instance-${var.unique_id}"
  }
}

# Parameter group for the Aurora MySQL cluster
resource "aws_db_parameter_group" "aurora_mysql_params" {
  name        = "${var.project}-${var.environment}-${var.region}-db-params-${var.unique_id}"
  family      = "aurora-mysql5.7"

  parameter {
    name  = "innodb_flush_log_at_trx_commit"
    value = "2"
  }

  tags = {
    Name = "${var.project}-${var.environment}-${var.region}-db-params-${var.unique_id}"
  }
}
