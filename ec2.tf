variable "private_key_path" {
  description = "Path to the private key file"
  type        = string
}
resource "random_id" "this" {
  byte_length = 8
}

resource "aws_security_group" "strapi_sg" {
  name = "StrapiInstance-${random_id.this.hex}"
  description = "Security group for Strapi EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

resource "aws_instance" "strapi" {
  ami           = "ami-04b70fa74e45c3917"  # Correct AMI ID for ap-south-1
  instance_type = "t2.medium"              # Changed to t2.medium
  key_name      = "devops"                  # Your key pair name
  vpc_security_group_ids = [aws_security_group.strapi_sg.id]

  tags = {
    Name = "StrapiServer"
  }

  
     provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y docker.io",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo usermod -aG docker ubuntu",
      "sudo chmod 666 /var/run/docker.sock",
      #"docker pull priya247/${var.docker_image}",  # Replace with your Docker image
      "docker run -d -p 80:80 -p 1337:1337 priya247/mystrapidocker:latest"  # Replace with your Docker image
    ]


    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }
}

