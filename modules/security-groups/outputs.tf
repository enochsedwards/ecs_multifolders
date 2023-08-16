output "alb_security_group_id" {
  value = aws_security_group.edubuntu["alb"].id
}

output "ecs_security_group_id" {
  value = aws_security_group.edubuntu["ecs"].id
}

output "rds_security_group_id" {
  value = aws_security_group.edubuntu["rds"].id
}