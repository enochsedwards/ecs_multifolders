region                                              = "us-west-1"
vpc_cidr                                            = "10.0.0.0/16"
instance_tenancy                                    = "default"
enable_dns_hostnames                                = true
enable_dns_support                                  = true
project_name                                        = "edubuntu"
environment                                         = "dev"
public_subnet_cidrs                                 = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs                                = ["10.0.3.0/24", "10.0.4.0/24"]
map_public_ip_on_launch                             = true
map_private_ip_on_launch                            = false
enable_public_resource_name_dns_a_record_on_launch  = true
enable_private_resource_name_dns_a_record_on_launch = false
container_image                                     = "public.ecr.aws/b4q9g9w5/edubuntu:latest"
record_name                                         = "www"
alternative_name                                    = "*.edubuntu.cloud"
domain_name                                         = "edubuntu.cloud"
db_password                                         = "edubuntu"
security_group = [{
      "alb" = { ingress = [ { port = 80 } ] }
      "ecs" = { ingress = [ { port = 80 } ] }
      "rds" = { ingress = [ { port = 5432 } ] }
}]