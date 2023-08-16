# create an auto scaling group for the ecs service
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 8
  min_capacity       = 4
  resource_id        = "service/${var.ecs_cluster_name}/${var.ecs_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}