variable "server_port" {
  description = "The port the server will ise for HTTP requests"
  type        = number
  default     = 80
}

variable "instance_security_group_name" {
  description = "The name of the security group for EC2 Instance"
  type        = string
  default     = "allow_http_ssh_instance"
}

variable "instance_type" {
  description = "The name of the instance_type"
  type        = string
  default     = "t3.micro"
}

variable "image_id" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."
  default     = ""
}
variable "alb_security_group_name" {
  description = "The name of the security group for the ALB"
  type        = string
  default     = "allow_http_alb"
}
