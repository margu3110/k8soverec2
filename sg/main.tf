locals {
    service_ports = [8080,22]
}


### Create the Security Group
resource "aws_security_group" "service-sg" {
  name        = "service security group"
  description = "Allow access to port 8080 and 22"
  vpc_id      = var.vpc_id

   dynamic "ingress" {
    for_each = local.service_ports
    content {
    from_port   = ingress.value
    to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "service-sg"
    appName = var.appName
  }
}
