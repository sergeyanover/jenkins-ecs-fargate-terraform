
resource "aws_lb" "albdev" {
  name               = "albdev"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_dev.id]
  subnets            = [aws_subnet.ecs_subnet_2.id, aws_subnet.ecs_subnet_3.id]

  enable_deletion_protection = false

  tags = {
    Environment = "dev"
  }
}



resource "aws_lb_listener" "albdev" {
  load_balancer_arn = aws_lb.albdev.arn
  port              = "8080"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.albdev.arn
  }
}


resource "aws_lb_target_group" "albdev" {
  name        = "dev-lb-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.ecs_vpc.id


  health_check {
    healthy_threshold   = "2"
    interval            = "90"
    protocol            = "HTTP"
    port                = "8080"
    matcher             = "200"
    timeout             = "60"
    path                = "/login"
    unhealthy_threshold = "7"
  }


  
}