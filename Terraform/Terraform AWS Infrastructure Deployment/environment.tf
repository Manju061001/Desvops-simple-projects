terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "My-VPC"
  }
}

resource "aws_subnet" "pubsub" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Mypublicsubnet"
  }
}

resource "aws_subnet" "prvsub" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Myprivatesubnet"
  }
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "my-Internet-Gateway"
  }
}

resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }

  tags = {
    Name = "public-routetable"
  }
}

resource "aws_route_table_association" "mypublic-subnet-asso" {
  subnet_id      = aws_subnet.pubsub.id
  route_table_id = aws_route_table.pubrt.id
}

resource "aws_eip" "myeip" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.myeip.id
  subnet_id     = aws_subnet.pubsub.id

  tags = {
    Name = "Nat-gateway"
  }
}

resource "aws_route_table" "prvrt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "private-routetable"
  }
}

resource "aws_route_table_association" "myprivate-subnet-asso" {
  subnet_id      = aws_subnet.prvsub.id
  route_table_id = aws_route_table.prvrt.id
}

resource "aws_security_group" "pubseg" {
  name        = "pubseg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  tags = {
    Name = "Pub-SEG"
  }
}

resource "aws_security_group_rule" "Pub-SEG-Imbound" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.pubseg.id
}

resource "aws_security_group_rule" "Pub-SEG-outbound" {
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.pubseg.id
  protocol          = "-1" # semantically equivalent to all ports
  from_port         = 0     # specify the range of ports
  to_port           = 65535 # specify the range of ports
}

resource "aws_security_group" "priseg" {
  name        = "priseg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  tags = {
    Name = "Pri-SEG"
  }
}

resource "aws_security_group_rule" "Pri-SEG-Imbound" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["10.0.1.0/24"]
  security_group_id = aws_security_group.priseg.id
}

resource "aws_security_group_rule" "Pri-SEG-outbound" {
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.priseg.id
  protocol          = "-1" # semantically equivalent to all ports
  from_port         = 0     # specify the range of ports
  to_port           = 65535 # specify the range of ports
}

resource "aws_instance" "Publicinstance" {
  ami                         = "ami-02d7fd1c2af6eead0"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.pubsub.id
  security_groups             = [aws_security_group.pubseg.id]
  key_name                    = "Terraform"
  associate_public_ip_address = true
}

resource "aws_instance" "privateinstance" {
  ami           = "ami-02d7fd1c2af6eead0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.prvsub.id
  security_groups = [aws_security_group.priseg.id]
  key_name = "Terraform"
}
