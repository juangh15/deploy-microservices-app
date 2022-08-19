#######################################################
# FRONTEND LB TARGET GROUPS
#######################################################

resource "aws_lb_target_group" "JuanSE_TG_Frontend_8080" {
  name     = "JuanSE-TG-Frontend-8080"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "vpc-e6246881"
}

#######################################################
# BACKEND LB TARGET GROUPS
#######################################################

resource "aws_lb_target_group" "JuanSE_TG_Backend_8000" {
  name     = "JuanSE-TG-BACKEND-8000"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = "vpc-e6246881"
}

resource "aws_lb_target_group" "JuanSE_TG_Backend_8082" {
  name     = "JuanSE-TG-BACKEND-8082"
  port     = 8082
  protocol = "HTTP"
  vpc_id   = "vpc-e6246881"
}

resource "aws_lb_target_group" "JuanSE_TG_Backend_8083" {
  name     = "JuanSE-TG-BACKEND-8083"
  port     = 8083
  protocol = "HTTP"
  vpc_id   = "vpc-e6246881"
}

resource "aws_lb_target_group" "JuanSE_TG_Backend_6379" {
  name     = "JuanSE-TG-BACKEND-6379"
  port     = 6379
  protocol = "HTTP"
  vpc_id   = "vpc-e6246881"
}