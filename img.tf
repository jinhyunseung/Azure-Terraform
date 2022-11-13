# ------------------------------------------- Public Instance --------------------------------------------
resource "aws_instance" "public-web" {
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.web.id]
  user_data_replace_on_change = true
  subnet_id                   = aws_subnet.public1-a.id

  user_data = templatefile("userdata.tftpl", {
    server_port = var.server_port
  })

  ami      = var.image_id == "" ? data.aws_ami.amzlinux.id : var.image_id
  key_name = "btc031"

  tags = {
    Name = "tf-public-web"
  }
}