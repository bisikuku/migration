#-----networking/output.tf-----

output "vpc_id" {
  value = aws_vpc.tela_vpc.id
}

output "db_subnet_group" {
  value = aws_db_subnet_group.tela_db_subnet_group.*.name
}

output "db_security_group" {
  value = [aws_security_group.tela_sg["rds"].id]
}

output "public_sg" {
  value = [aws_security_group.tela_sg["public"].id]
}

output "public_subnet" {
  value = [aws_subnet.tela_public_subnet.*.id]
}

output "private_subnet" {
  value = [aws_subnet.tela_private_subnet.*.id]
}
