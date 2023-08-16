output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_id_1" {
  value = aws_subnet.public[0].id
}

output "public_subnet_id_2" {
  value = aws_subnet.public[1].id
}

output "private_subnet_id_1" {
  value = aws_subnet.private[0].id
}

output "private_subnet_id_2" {
  value = aws_subnet.private[1].id
}

output "project_name" {
  value = var.project_name
}

output "internet_gateway" {
  value = aws_internet_gateway.igw.id
}

output "nat_gateway" {
  value = aws_nat_gateway.ngw.id
}

output "region" {
  value = var.region
}