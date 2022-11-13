# ------------------------------------------- Private subnet ---------------------------------------------
resource "aws_subnet" "private1-a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "tf-subnet=private1-a"
  }
}

resource "aws_subnet" "private2-c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "tf-subnet=private2-c"
  }
}
# ----------------------------------------------Private route table------------------------------------------
resource "aws_route_table" "priv-a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw-a.id

  }
  tags = {
    Name = "tf-rtb-private-a"
  }
}

resource "aws_route_table" "priv-c" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw-c.id
  }
  tags = {
    Name = "tf-rtb-private-c"
  }
}

# ------------------------------------------- route table association --------------------------------------------
resource "aws_route_table_association" "priv-a" {
  subnet_id      = aws_subnet.private1-a.id
  route_table_id = aws_route_table.priv-a.id
}
resource "aws_route_table_association" "priv-c" {
  subnet_id      = aws_subnet.private2-c.id
  route_table_id = aws_route_table.priv-c.id
}
