variable "vpc_id" {}
variable "security_group" {}
variable "subnet_id" {}

resource "aws_lb" "alb_8byte" {
  name = "alb-8byte"
  internal = false
  load_balancer_type = "application"
  security_groups = [var.security_group]
  subnets = var.subnet_id
}

resource "aws_lb_target_group" "alb_tg" {
  name = "alb-tg"
  port = 8080
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "ip"
  health_check {
    path = "/"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
    matcher = "200"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb_8byte.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

output "target_group" {
  value = aws_lb_target_group.alb_tg.id
}