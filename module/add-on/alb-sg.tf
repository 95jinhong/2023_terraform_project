
resource "aws_security_group" "alb_sg" {
  name        = "${var.eks-name}-alb"
  description = "Allow nginx HTTP"
  vpc_id      = var.vpc_id

  ingress {
    description = "nginx port"
    self        = true
    from_port   = 80
    to_port     = 8080
    protocol    = "http"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks-alb-nginx-http"
  }
}
