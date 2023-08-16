variable "region" {}
variable "vpc_cidr" {}
variable "instance_tenancy" {}
variable "enable_dns_hostnames" {}
variable "enable_dns_support" {}
variable "project_name" {}
variable "environment" {}
variable "public_subnet_cidrs" {}
variable "private_subnet_cidrs" {}
variable "map_public_ip_on_launch" {}
variable "map_private_ip_on_launch" {}
variable "enable_public_resource_name_dns_a_record_on_launch" {}
variable "enable_private_resource_name_dns_a_record_on_launch" {}
variable "domain_name" {}
variable "alternative_name" {}
variable "container_image" {}
variable "record_name" {}
variable "db_password" {}
variable "security_group" {
    default = {
      "alb" = { ingress = [ { port = 80 } ] }
      "ecs" = { ingress = [ { port = 80 } ] }
      "rds" = { ingress = [ { port = 5432 } ] }
    }
}