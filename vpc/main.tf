locals {
  public_blocks  = [cidrsubnet(var.vpc_cidr_block, 0, 8), cidrsubnet(var.vpc_cidr_block, 1, 8)]
  private_blocks = [cidrsubnet(var.vpc_cidr_block, 2, 8), cidrsubnet(var.vpc_cidr_block, 3, 8)]
  data_blocks    = [cidrsubnet(var.vpc_cidr_block, 4, 8), cidrsubnet(var.vpc_cidr_block, 5, 8)]
}


data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "primary_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
}

resource "aws_subnet" "public" {
  count             = var.availability_zone_count
  cidr_block        = local.public_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.primary_vpc.id

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "private" {
  count             = var.availability_zone_count
  cidr_block        = local.private_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[1]
  vpc_id            = aws_vpc.primary_vpc.id

  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_subnet" "data" {
  count             = var.availability_zone_count
  cidr_block        = local.data_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[1]
  vpc_id            = aws_vpc.primary_vpc.id

  tags = {
    Name = "Data Subnet"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.primary_vpc.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.primary_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "main" {
  count          = var.availability_zone_count
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "alb_sg" {
  description = "The security group used to grant access to the ALB"

  vpc_id = aws_vpc.primary_vpc.id

  # ingress {
  #   protocol    = "tcp"
  #   from_port   = 80
  #   to_port     = 80
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

resource "aws_security_group" "instance_sg" {
  description = "The security group allowing SSH administrative access to the instances"
  vpc_id      = aws_vpc.primary_vpc.id

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22

    cidr_blocks = [
      var.admin_cidr_ingress,
    ]
  }

  ingress {
    protocol  = "tcp"
    from_port = 32768
    to_port   = 61000

    security_groups = [
      aws_security_group.alb_sg.id,
    ]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = local.data_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
