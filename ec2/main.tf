locals {
  userdata = templatefile("${path.module}/files//user_data.tpl",
    {
      node_type          = var.node_type
    }
  )
}


resource "aws_instance" "ec2" {
    ami                     = var.ami
    instance_type           = var.instance_type
    key_name                = var.key_name
    vpc_security_group_ids  = [var.vpc_sg]
    user_data               = local.userdata

    iam_instance_profile    = var.instance_profile

    tags = {
        Name = var.ec2_name
    }
}