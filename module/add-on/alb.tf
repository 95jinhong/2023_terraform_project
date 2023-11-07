resource "aws_lb" "test" {
  name               = var.alb-name
  internal           = false # true : external
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [for public_subnets in aws_subnet.public : public_subnets.id]
  # depends_on = {}
  enable_deletion_protection = true
  enable_cross_zone_load_balancing = true

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.id
  #   prefix  = "test-lb"
  #   enabled = false
  # }

  tags = {
    Environment = "test"
  }
}
