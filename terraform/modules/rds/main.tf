variable "vpc_id" {}
variable "subnet_group" {}
variable "security_groups" {}

resource "aws_db_instance" "rds_8byte" {
  identifier = "postgre-8byte"
  engine = "postgres"
  instance_class = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  db_name = "rds_8byte"
  username = var.db_username
  password = var.db_password
  port = 5432
  publicly_accessible = false
  vpc_security_group_ids = [var.security_groups]
  db_subnet_group_name = var.subnet_group
  skip_final_snapshot = true
}