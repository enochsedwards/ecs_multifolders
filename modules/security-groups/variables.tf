variable "environment" {}
variable "project_name" {}
variable "vpc_id" {}
variable "security_group" {
    default = {
      "alb" = { ingress = [ { port = 80 } ] }
      "ecs" = { ingress = [ { port = 80 } ] }
      "rds" = { ingress = [ { port = 5432 } ] }
    }
}