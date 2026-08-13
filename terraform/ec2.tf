resource "aws_instance" "app_server" {
  ami           = "ami-0dc6aa44dbcdd872e"
  instance_type = "t3.micro"
  key_name      = "cloud-keypair"
  subnet_id     = "subnet-0c89588eb031b6900"

  vpc_security_group_ids = [
    "sg-00f6660d8793cea15"
  ]

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name        = "cloud-native-devops-app-server"
    Project     = "cloud-native-devops"
    Environment = "development"
    ManagedBy   = "Terraform"
  }
}
