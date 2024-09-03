#create the vpc
resource "aws_vpc" "vpc hellal" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "MY_VPC"                
  }
}



#create public subnet
resource "aws_subnet" "public_sub_hellal" {
  vpc_id     = aws_vpc.my_VPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public"
  }
}


#create private subnet
resource "aws_subnet" "private_sub_hellal" {
  vpc_id     = aws_vpc.my_VPC.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private"
  }
}


# Create an internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_VPC.id

  tags = {
    Name = "IGW1"
  }
}


# Create a public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "Public_Route_Table"
  }
}


resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_VPC.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  

  tags = {
    Name = "Private_Route_Table"
  }
}


# Associate the route table with the public subnet
resource "aws_route_table_association" "public_rt_association" {
  subnet_id      = aws_subnet.public_sub.id
  route_table_id = aws_route_table.public_route_table.id
}


# Associate the route table with the public subnet
resource "aws_route_table_association" "private1_rt_association" {
  subnet_id      = aws_subnet.private_sub.id
  route_table_id = aws_route_table.private_route_table.id
}
