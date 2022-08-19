#######################################################
# FRONTEND LOAD BALANCER AND LISTENERS
#######################################################

resource "aws_lb" "JuanSE_LB_Frontend" {
  name               = "JuanSE-LB-Frontend"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.JuanSE_SG_LB_Frontend.id]
  subnets            = ["subnet-0ed083b4f1714e9a7", "subnet-030ee31454511f6ec"]

  enable_deletion_protection = false

  tags = { project = "ramp-up-devops", responsible = "juan.sarriase" }
}


resource "aws_lb_listener" "Frontend_8080_Listener" {
  load_balancer_arn = aws_lb.JuanSE_LB_Frontend.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.JuanSE_TG_Frontend_8080.arn
    type             = "forward"
  }
}

#######################################################
# BACKEND LOAD BALANCER AND LISTENERS
#######################################################

resource "aws_lb" "JuanSE_LB_Backend" {
  name               = "JuanSE-LB-Backend"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.JuanSE_SG_LB_Backend.id]
  subnets            = ["subnet-0ed083b4f1714e9a7", "subnet-030ee31454511f6ec"]

  enable_deletion_protection = false

  tags = { project = "ramp-up-devops", responsible = "juan.sarriase" }
}


resource "aws_lb_listener" "Backend_8000_Listener" {
  load_balancer_arn = aws_lb.JuanSE_LB_Backend.arn
  port              = "8000"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.JuanSE_TG_Backend_8000.arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "Backend_8082_Listener" {
  load_balancer_arn = aws_lb.JuanSE_LB_Backend.arn
  port              = "8082"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.JuanSE_TG_Backend_8082.arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "Backend_8083_Listener" {
  load_balancer_arn = aws_lb.JuanSE_LB_Backend.arn
  port              = "8083"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.JuanSE_TG_Backend_8083.arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "Backend_6379_Listener" {
  load_balancer_arn = aws_lb.JuanSE_LB_Backend.arn
  port              = "6379"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.JuanSE_TG_Backend_6379.arn
    type             = "forward"
  }
}


