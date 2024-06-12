resource "aws_alb_target_group" "main" {
  name     = var.alb_target_group_name
  port     = var.alb_target_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = var.enabled
    healthy_threshold   = var.healthy_threshold
    interval            = var.interval
    path                = var.path
    port                = var.port
    protocol            = var.protocol
    timeout             = var.timeout
    unhealthy_threshold = var.unhealthy_threshold
  }
}

resource "aws_alb" "main" {
  name            = var.alb_name
  subnets         = var.subnet_ids
  security_groups = var.security_groups
}

resource "aws_alb_listener" "front_end_tls" {
  load_balancer_arn = aws_alb.main.id
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2015-05"
  certificate_arn = var.certificate_arn

  default_action {
    target_group_arn = aws_alb_target_group.main.id
    type             = "forward"
  }
}