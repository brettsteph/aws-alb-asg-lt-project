resource "aws_lb" "alb" {
  name               = "ALB-${local.env_suffix}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-security-group.id]
  subnets            = [local.public_subnet_id_1, local.public_subnet_id_2]

  enable_deletion_protection = false

  enable_cross_zone_load_balancing = true

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.bucket
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  tags = {
    Name = "ALB-${local.env_suffix}"
  }
}

# Instance Target Group
resource "aws_lb_target_group" "alb-tg" {
  name     = "HTTP-TG-${local.env_suffix}"
  port     = 80
  protocol = "HTTP"

  vpc_id = local.vpc_id

  # deregistration_delay = 300

  health_check {
    enabled             = true
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 4
    interval            = 30
    matcher             = "200-299" # has to be HTTP 200 or fails
    path                = "/"
  }
}

resource "aws_lb_listener" "alb-http-80-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}


output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}
