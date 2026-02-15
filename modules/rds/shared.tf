resource "aws_db_subnet_group" "this" {
  name       = "rds-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "this" {
  name   = "rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_parameter_group" "this" {
  name   = "rds-parameter-group"
  family = var.engine == "postgres" ? "postgres14" : "mysql8.0"

parameter {
  name         = "max_connections"
  value        = "100"
  apply_method = "pending-reboot"
}
}
