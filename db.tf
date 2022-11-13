# -------------------------------------------- DB Security Group ------------------------------------------------
resource "aws_security_group" "db" {
  name        = "allow_mysql"
  description = "Allow MySQL inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow MySQL"
  }
}
# -------------------------------------------- Subnet Group ------------------------------------------------
resource "aws_db_subnet_group" "tf-db" {
  subnet_ids = [aws_subnet.private1-a.id, aws_subnet.private2-c.id] # db가 생성될 서브넷

  tags = {
    Name = "Terraform DB subnet group"
  }
}
# -------------------------------------------- DB Instance ------------------------------------------------
resource "aws_db_instance" "tftestdb" {
  identifier        = "tf-db-0629"
  allocated_storage = 10
  db_name           = "tf"
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t3.micro"
  username          = "master"
  password          = "Wlsgustmd123"
  #parameter_group_name = "default.mysql5.7"
  skip_final_snapshot = true
  multi_az            = true


  db_subnet_group_name   = aws_db_subnet_group.tf-db.name
  vpc_security_group_ids = [aws_security_group.db.id]
}
# ----------------------------- DB Endpoint Output ------------------------------------------------
output "db_endpoint" {
  value = aws_db_instance.tftestdb.endpoint
}