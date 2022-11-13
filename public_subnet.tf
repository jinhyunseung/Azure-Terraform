# -------------------------------------------- Public subnet ------------------------------------------------
resource "aws_subnet" "public1-a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = "true" # 서버 등을 띄울 때 자동으로 퍼블릭 IP가 할당되도록 한다

  tags = {
    Name = "tf-subnet=public1-a"
  }
}

resource "aws_subnet" "public2-c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = "true" # 서버 등을 띄울 때 자동으로 퍼블릭 IP가 할당되도록 한다

  tags = {
    Name = "tf-subnet=public2-c"
  }
}


# -------------------------------------------Public route table----------------------------------------------
resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "tf-rtb-public"
  }
}

# ------------------------------------------- route table association --------------------------------------------
#aws_route_table_association, subnet_id, route_table_id
resource "aws_route_table_association" "public-a" {
  subnet_id      = aws_subnet.public1-a.id
  route_table_id = aws_route_table.pub.id
}
resource "aws_route_table_association" "public-c" {
  subnet_id      = aws_subnet.public2-c.id
  route_table_id = aws_route_table.pub.id
}
