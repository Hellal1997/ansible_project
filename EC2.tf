resource "aws_key_pair" "my_key" {
  key_name   = "hellalkey"
  public_key = file("~/.ssh/id_rsa.pub")
}


resource "aws_security_group" "my_sg" {
  vpc_id = aws_vpc.my_VPC.id  
  name        = "my-security-group"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-security-group"
  }
}


# Launch an EC2 Instance in the Public 1 Subnet
resource "aws_instance" "public1_instance" {
  ami   = "ami_catlog can choose it "
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_sub.id
  key_name      = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  # Ensure a public IP is associated with this instance
  associate_public_ip_address = true

  tags = {
    Name = "public_ec2"
  }

  depends_on = [aws_subnet.public_sub]
}




# Launch an EC2 Instance in the Private 1 Subnet
resource "aws_instance" "private1_instance" {
  ami   = "ami_catlog can choose it"
 instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_sub.id
  key_name      = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  # Ensure a public IP is associated with this instance
  associate_public_ip_address = true

  tags = {
    Name = "private1_ec2"
  }
    depends_on = [aws_subnet.private_sub]

}
