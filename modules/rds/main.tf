# create database subnet group
# terraform aws db subnet group
resource "aws_db_subnet_group" "database_subnet_group" {
  name         = "rds database subnets"
  subnet_ids   = [var.private_subnet_id_1, var.private_subnet_id_2]
  description  = "subnets for database instance"

  tags   = {
    Name = "${var.environment}-db-${var.project_name}"
  }
}


resource "aws_db_parameter_group" "database_parameter_group" {
  name   = "${var.project_name}"
  family = "postgres15"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}


resource "aws_db_instance" "database_instance" {
  identifier                  = "${var.project_name}-rds"
  instance_class              = "db.t3.micro"
  allocated_storage           = 5
  apply_immediately           = true
  engine                      = "postgres"
  engine_version              = "15.3"
  username                    = "edubuntu"
  password                    = var.db_password
  allow_major_version_upgrade = true
  db_subnet_group_name        = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids      = [var.rds_security_group_id]
  parameter_group_name        = aws_db_parameter_group.database_parameter_group.name
  publicly_accessible         = false
  skip_final_snapshot         = true
  backup_retention_period     = 1
  multi_az                    = false
  availability_zone           = data.aws_availability_zones.available.names[0]
}


resource "aws_db_instance" "database_instance_replica" {
  identifier             = "edubuntu-replica"
  replicate_source_db    = aws_db_instance.database_instance.identifier
  instance_class         = "db.t3.micro"
  apply_immediately      = true
  publicly_accessible    = true
  skip_final_snapshot    = true
  vpc_security_group_ids = [var.rds_security_group_id]
  parameter_group_name   = aws_db_parameter_group.database_parameter_group.name
  multi_az               = false
  availability_zone      = data.aws_availability_zones.available.names[1]
}

data "aws_availability_zones" "available" {
  state = "available"
}

