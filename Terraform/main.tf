provider "aws" {
  #region is using variables.tf file
  region = var.region
  access_key = "AKIAZZ5BDHZTV4GW2TXC"
  secret_key = "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" 
}


data "aws_region" "current" {}

# Using block "resource aws_vpc" to define our VPC
resource "aws_vpc" "main" {
  cidr_block       = var.cidr
  instance_tenancy = "default"
  
  tags = {
    Name = "${var.environment}-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  cidr_block              = var.publicCIDR
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone
}


# To provide internet in/out access for our VPC 
# we should use "resource "aws_internet_gateway"" (AWS Internet Gateway service)
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-main"
  }

  depends_on = [aws_vpc.main]
}

# "resource "aws_route_table"" is  needed to define the Public Routes 
# as an our "custom :-)" settings for AWS Internet Gateway service
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.environment}-public"
  }

  depends_on = [aws_internet_gateway.main]
}

# Route Table Association - Public Routes
# resource "aws_route_table_association" is needed to determine subnets
# which  will be connected to the Internet Gateway and Public Routes
resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public.id

  depends_on = [aws_subnet.public, aws_route_table.public]
}


resource "aws_instance" "ubuntu_tf" {

  ami                    = var.instance_AMI
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.public.id]
  key_name = "tfkey"

  user_data = <<-EOF
  #!/bin/bash
  yum -y update
  yum -y install httpd
  echo "<h2>WebServer</h2><br>Build by Terraform!"  >  /var/www/html/index.html
  sudo service httpd start
  chkconfig httpd on
  EOF


  #tags are using variables.tf file
  tags = {
    Name = "${var.instance_tag}"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.ubuntu_tf.public_ip} > ../Ansible/hosts.txt"
  }  
}

resource "aws_security_group" "public" {
  name = "Security Group for EC2 instances public subnets"
  #  aws_vpc = aws_vpc.main.id
  vpc_id = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.allowed_ports
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
    Name = "${var.environment}-public-SG"
  }
  depends_on = [aws_vpc.main]
}

#Create public key to aws
resource "aws_key_pair" "tfkey" {
    key_name   = "tfkey"
    public_key = tls_private_key.rsa.public_key_openssh
}

# RSA key of size 4096 bits
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "tfkey" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tfkey"
}
