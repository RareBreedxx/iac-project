resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnet-group-2"
  subnet_ids = [aws_subnet.private.id, aws_subnet.private2.id]

  tags = {
    Name = "main-db-subnet-group-2"
  }
}

resource "aws_db_instance" "main" {
  identifier             = "main-rds-instance-2"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true

  tags = {
    Name = "main-rds-instance"
  }
}
