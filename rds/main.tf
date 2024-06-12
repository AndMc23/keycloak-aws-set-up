locals {
  project = "keycloakdb"
}

## Generating a password so to avoid passing one in the variables. 
resource "random_password" "db_password" {
  length           = 16
  special          = false
  override_special = "!#$%&*()[]{}<>"
}


## DB SG to allow access from the SG of the instance 
resource "aws_security_group" "keycloakdb_sg" {

  name        = "${local.project}_sg"
  description = "Security group for connecting to the KeyCloak database instance"

  vpc_id = var.vpc_id

  # Only PostgreSQL traffic inbound
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.instance_security_group]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name   = "${local.project}_sg"
    prject = local.project
  }
}

resource "aws_db_subnet_group" "main" {

  name       = "${local.project}_db_sng"
  subnet_ids = var.data_subnet_ids

}
resource "aws_db_instance" "keycloakdb" {

  allocated_storage       = var.rds_storage_gigabytes
  backup_retention_period = var.rds_backup_retention_days

  db_subnet_group_name = aws_db_subnet_group.main.name

  engine         = var.rds_engine
  engine_version = var.rds_engine_version
  multi_az       = var.rds_multi_az
  instance_class = var.instance_type

  identifier = "${local.project}-${var.rds_engine}-db-id"
  db_name    = "${local.project}-${var.rds_engine}-db"

  username = "${var.rds_engine}-${var.rds_username}"
  password = random_password.db_password.result

  publicly_accessible = false
  storage_encrypted   = true

  vpc_security_group_ids = [aws_security_group.keycloakdb_sg.id]

  skip_final_snapshot = true
}
