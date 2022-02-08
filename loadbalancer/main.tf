resource "aws_lb" "tela_lb" {
  name               = var.lb_name
  internal           = var.lb_facing
  load_balancer_type = var.lb_type
  security_groups    = var.lb_public_sg
  subnets            = var.lb_public_subnet

  enable_deletion_protection = false

  #   access_logs {
  #     bucket  = aws_s3_bucket.lb_logs.bucket
  #     prefix  = "test-lb"
  #     enabled = true
  #   }

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "tela_lb_target_group" {
  name     = "tela-tg"
  port     = var.lb_port
  protocol = var.lb_protocol
  vpc_id   = var.lb_vpc
}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.tela_lb.arn
  port              = var.lb_port
  protocol          = var.lb_protocol
  #ssl_policy        = var.lb_ssl_policy
  #certificate_arn   = var.lb_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = var.lb_tg_arn
  }
}

resource "aws_lb_listener" "front_end_ssl" {
  load_balancer_arn = aws_lb.tela_lb.arn
  port              = var.lb_port_ssl
  protocol          = var.lb_protocol_ssl
  ssl_policy        = var.lb_ssl_policy
  certificate_arn   = var.lb_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = var.lb_tg_arn
  }
}


