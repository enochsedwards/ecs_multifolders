# Configure the AWS Provider
provider "aws" {
  region = var.region
}

module "networking" {
  source                                              = "../modules/networking"
  region                                              = var.region
  environment                                         = var.environment
  vpc_cidr                                            = var.vpc_cidr
  instance_tenancy                                    = var.instance_tenancy
  enable_dns_hostnames                                = var.enable_dns_hostnames
  enable_dns_support                                  = var.enable_dns_support
  project_name                                        = var.project_name
  public_subnet_cidrs                                 = var.public_subnet_cidrs
  private_subnet_cidrs                                = var.private_subnet_cidrs
  map_public_ip_on_launch                             = var.map_public_ip_on_launch
  map_private_ip_on_launch                            = var.map_private_ip_on_launch
  enable_public_resource_name_dns_a_record_on_launch  = var.enable_public_resource_name_dns_a_record_on_launch
  enable_private_resource_name_dns_a_record_on_launch = var.enable_private_resource_name_dns_a_record_on_launch
}

module "security-groups" {
  source       = "../modules/security-groups"
  vpc_id       = module.networking.vpc_id
  environment  = var.environment
  project_name = var.project_name
}

module "ecs-tasks-execution-role" {
  source       = "../modules/ecs-tasks-execution-role"
  project_name = module.networking.project_name
}

module "acm" {
  source           = "../modules/acm"
  domain_name      = var.domain_name
  alternative_name = var.alternative_name
}

module "alb" {
  source                = "../modules/alb"
  project_name          = module.networking.project_name
  vpc_id                = module.networking.vpc_id
  alb_security_group_id = module.security-groups.alb_security_group_id
  public_subnet_id_1    = module.networking.public_subnet_id_1
  public_subnet_id_2    = module.networking.public_subnet_id_2
  certificate_arn       = module.acm.certificate_arn
}

module "ecs" {
  source                       = "../modules/ecs"
  project_name                 = module.networking.project_name
  ecs_security_group_id        = module.security-groups.ecs_security_group_id
  ecs_tasks_execution_role_arn = module.ecs-tasks-execution-role.ecs_tasks_execution_role_arn
  container_image              = var.container_image
  region                       = module.networking.region
  private_subnet_id_1          = module.networking.private_subnet_id_1
  private_subnet_id_2          = module.networking.private_subnet_id_2
  alb_target_group_arn         = module.alb.alb_target_group_arn
}

module "auto_scaling_group" {
  source           = "../modules/asg"
  ecs_cluster_name = module.ecs.ecs_cluster_name
  ecs_service_name = module.ecs.ecs_service_name
}

module "route_53" {
  source       = "../modules/route-53"
  domain_name  = module.acm.domain_name
  record_name  = var.record_name
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

module "rds" {
  source                = "../modules/rds"
  private_subnet_id_1   = module.networking.private_subnet_id_1
  private_subnet_id_2   = module.networking.private_subnet_id_2
  rds_security_group_id = module.security-groups.rds_security_group_id
  project_name          = var.project_name
  db_password           = var.db_password
  environment           = var.environment
}

output "website_url" {
  value = join("", ["https://", var.record_name, ".", var.domain_name])
}