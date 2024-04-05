output "private_ip" {
    description = "Private IP"
    value = aws_instance.ec2.private_ip
}

output "public_ip" {
    description = "Public IP"
    value = aws_instance.ec2.public_ip
}
