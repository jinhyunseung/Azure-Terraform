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
