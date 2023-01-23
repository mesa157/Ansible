provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "example" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "example" {
  name        = "example"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.example.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.example.id]
  subnet_id            = aws_subnet.example.id

  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y nginx httpd",
      "sudo service nginx start",
      "sudo service httpd start",
      "sudo echo 'Hello World' > /var/www/html/index.html",
    ]
  }
}

