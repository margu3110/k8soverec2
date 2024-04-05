output "service_sg_id" {
    description = "Id for the service sg"
    value = aws_security_group.service-sg.id
}
