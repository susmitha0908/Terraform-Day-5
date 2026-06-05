#creation of vpc
resource "aws_vpc" "Shiny" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Shiny"
  }
}

#creation of subnets
resource "aws_subnet" "Shiny_subnet" {
  vpc_id            = aws_vpc.Shiny.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "Shiny_Subnet"
  }
}

#creation of internet gateway
resource "aws_internet_gateway" "Shiny_igw" {
  vpc_id = aws_vpc.Shiny.id
  tags = {
    Name = "Shiny_IGW"
  }
}

#creation of route table
resource "aws_route_table" "Shiny_rt" {
  vpc_id = aws_vpc.Shiny.id
  tags = {
    Name = "Shiny_RT"
  }
}

#association of route table with subnet
resource "aws_route_table_association" "Shiny_rta" {
  subnet_id      = aws_subnet.Shiny_subnet.id
  route_table_id = aws_route_table.Shiny_rt.id
}

#creation of route to internet gateway
resource "aws_route" "Shiny_route" {
  route_table_id         = aws_route_table.Shiny_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.Shiny_igw.id
}

#create a security group
resource "aws_security_group" "Shiny_sg" {
  name        = "Shiny_SG"
  description = "Security group for Shiny VPC"
  vpc_id      = aws_vpc.Shiny.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Shiny_SG"
  }
}

#creation of EC2 instance
resource "aws_instance" "Shiny_instance" {
  ami                    = "ami-029a761f237195c2c"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.Shiny_subnet.id
  vpc_security_group_ids = [aws_security_group.Shiny_sg.id]

  tags = {
    Name           = "Shiny_Instance"
    associated_vpc = aws_vpc.Shiny.id
  }
}

resource "aws_s3_bucket" "shiny_bucket" {
  bucket = "susmitha-devops9-bucket-2026"

  tags = {
    Name        = "Shiny_Bucket"
    Environment = "Dev"
  }
}