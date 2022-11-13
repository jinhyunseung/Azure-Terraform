# ----------------------------------------- VPC ------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default" #dedicated 와 두가지가 있으며 default는 공용, dedicated는 전용 테넌시 사용을 말한다(매우빠른 통신이 필요할 때 사용한다)
  enable_dns_hostnames = true      #default = true
  enable_dns_support   = true      #default = false

  tags = {
    Name = "tf-vpc"
  }
}
# ----------------------------------------- IGW ------------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "tf-igw"
  }
}
# ------------------------------------------- NAT GW --------------------------------------------
resource "aws_nat_gateway" "natgw-a" {
  allocation_id = aws_eip.natgw-a.id
  subnet_id     = aws_subnet.public1-a.id

  tags = {
    Name = "gw NAT"
  }
}

resource "aws_eip" "natgw-a" {
  vpc = true
}

resource "aws_nat_gateway" "natgw-c" {
  allocation_id = aws_eip.natgw-c.id
  subnet_id     = aws_subnet.public2-c.id

  tags = {
    Name = "gw NAT"
  }
}

resource "aws_eip" "natgw-c" {
  vpc = true
}
# ------------------------------------------- Autoscaling Group --------------------------------------------
resource "aws_autoscaling_group" "web" {
  name                 = "asg-${aws_launch_configuration.web.name}"
  launch_configuration = aws_launch_configuration.web.name
  #vpc_zone_identifier  = data.aws_subnets.default.ids
  vpc_zone_identifier = [aws_subnet.private1-a.id, aws_subnet.private2-c.id]
  target_group_arns   = [aws_lb_target_group.asg.arn]
  health_check_type   = "ELB"


  min_size = 2
  #description_capacity = 4 #사용 가용영역 수
  max_size = 10

  tag {
    key                 = "Name"
    value               = "asg-web"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "web" {
  name_prefix = "web_auto-"
  image_id    = aws_ami_from_instance.web-img.id
  key_name    = "btc031"

  instance_type   = var.instance_type
  security_groups = [aws_security_group.web.id]

  user_data = templatefile("userdata.tftpl", {
    server_port = var.server_port
  })

  lifecycle {
    create_before_destroy = true
  }
}
# -------------------------------------------- security_group ---------------------------------------------
resource "aws_security_group" "web" {
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from VPC"
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
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
    Name = "var.instance_security_group_name"
  }
}
#aws_ami_from_instance
resource "aws_ami_from_instance" "web-img" {
  name               = "terraform-webimg"
  source_instance_id = aws_instance.public-web.id
}