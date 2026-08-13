output "ec2_instance_id" {
  value = aws_instance.app_server.id
}

output "ec2_public_ip" {
  value = aws_instance.app_server.public_ip
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}
