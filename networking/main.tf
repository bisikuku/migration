# -----networking/main.tf-----
data "aws_availability_zones" "available" {}
resource "random_integer" "random" {
  min = 1
  max = 10
}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

resource "aws_vpc" "tela_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "tela_vpc-${random_integer.random.id}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "tela_public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.tela_vpc.id
  cidr_block              = var.public_cidr[count.index]
  availability_zone       = random_shuffle.az_list.result[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "tela_public_subnet-${count.index + 1}"
  }
}

resource "aws_route_table_association" "tela_public_rt_assoc" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.tela_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.tela_public_rt.id
}

resource "aws_subnet" "tela_private_subnet" {
  count             = var.private_sn_count
  vpc_id            = aws_vpc.tela_vpc.id
  cidr_block        = var.private_cidr[count.index]
  availability_zone = random_shuffle.az_list.result[count.index]
  tags = {
    Name = "tela_private_subnet-${count.index + 1}"
  }
}
resource "aws_internet_gateway" "tela_igw" {
  vpc_id = aws_vpc.tela_vpc.id
  tags = {
    Name = "tela_igw"
  }
}
resource "aws_route_table" "tela_public_rt" {
  vpc_id = aws_vpc.tela_vpc.id
  tags = {
    Name = "tela_public_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.tela_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.tela_igw.id
}

resource "aws_default_route_table" "tela_private_rt" {
  default_route_table_id = aws_vpc.tela_vpc.default_route_table_id
  tags = {
    Name = "tela_private_rt"
  }
}
resource "aws_security_group" "tela_sg" {
  for_each    = var.security_groups
  name        = each.value.name
  vpc_id      = aws_vpc.tela_vpc.id
  description = each.value.description
  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_db_subnet_group" "tela_db_subnet_group" {
  count       = var.db_subnet_group == true ? 1 : 0
  name        = "tela_db_subnet_group"
  description = "tela_db_subnet_group"
  subnet_ids  = aws_subnet.tela_private_subnet.*.id
}
