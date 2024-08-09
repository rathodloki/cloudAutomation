terraform {  
  required_providers {  
    aws = {  
      source  = "hashicorp/aws"  
      version = "~> 4.0"  
    }  
  }  
}  

provider "aws" {  
  region = var.region
}  

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block         = "10.0.1.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block         = "10.0.2.0/24"
  availability_zone = "${var.region}b"

  tags = {
    Name = "PrivateSubnet" 
  }
}

resource "aws_security_group" "web_server" {
  name = "web_server_sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "my-key-pair"
  public_key = <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDiS57b4zW9nYa5Fm1DSRIA+naRzL8ign+SdNBSNljhqsVzeGZVodI2LDqZJ7BcVN8vJVsp/QbiDp3LDuB8l3nvyzsZ6D5PWCDwdPuhlpZ4QDA1TV5QNw53KAD3riq98X6QtBftM1xVVJy/ja0m1FSoRr6kaPqd0F+bXH6tUPJhlDqE1KeW/77F9YWoHhAUQbf3WZH9P7t1xL6bKeopWKgXdHZYfCEWQd7e6Ob48G0ygZF0YPdsLc9ExgOn63vqi33+EtMd9/sxZQxjR03wXwjyZYpwfh5n4YcwydvspKKIIsH1juypZPQuLY5A5zF/zItuG1t84fnSL/4R2qd9Y35DOwMpe+cRWWHUptu4SMhtL3fK5IsY2UxrVVf7wuERWdf/MySm4NEpC0oXvxbFDRBj0CHSs+SVauuv64s2CimDRnGDTVF3BYdiZ9DLsd9E2dfEgU9yzB4ZmZRzNL96Jes852QWuC+sxfLcSw1gwF1+4DYyVkeCZ3JDJXtZ90+E3qE= lokendar@Lokendars-MacBook-Air.local 
EOF
}


resource "aws_instance" "web_server" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_server.id]
  key_name      = aws_key_pair.deployer.key_name
  associate_public_ip_address = true
  tags = {
    Name = var.web_server_name
  }
}