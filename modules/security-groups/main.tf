resource "aws_security_group" "edubuntu" {
  for_each = var.security_group
  name = "${each.key}-sg"
  description = "security group for ${each.key}"
  vpc_id = var.vpc_id
  
  tags = {
    "Name" = "${var.environment}-${each.key}-sg-${var.project_name}"
    "Provider" = "Terraform"
  }

  dynamic "ingress" {
    for_each = each.value.ingress[*]
    content {
      from_port   =  ingress.value.port
      to_port     =  ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  } 
}