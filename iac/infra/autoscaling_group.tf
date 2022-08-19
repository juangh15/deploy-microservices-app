#######################################################
# FRONTEND AUTOSCALING GROUP
#######################################################

resource "aws_autoscaling_group" "JuanSE_AG_Frontend" {
  #availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1

  vpc_zone_identifier = ["subnet-0ed083b4f1714e9a7"]

  launch_template {
    id      = aws_launch_template.JuanSE_LT_Frontend.id
    version = "$Latest"
  }

  target_group_arns = ["${aws_lb_target_group.JuanSE_TG_Frontend_8080.arn}"]
}

#######################################################
#   BACKEND AUTOSCALING GROUP
#######################################################

resource "aws_autoscaling_group" "JuanSE_AG_Backend" {
  #availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1

  vpc_zone_identifier = ["subnet-0ed083b4f1714e9a7"]

  launch_template {
    id      = aws_launch_template.JuanSE_LT_Backend.id
    version = "$Latest"
  }

  target_group_arns = [
    "${aws_lb_target_group.JuanSE_TG_Backend_8000.arn}",
    "${aws_lb_target_group.JuanSE_TG_Backend_8082.arn}",
    "${aws_lb_target_group.JuanSE_TG_Backend_8083.arn}",
    "${aws_lb_target_group.JuanSE_TG_Backend_6379.arn}",
  ]
}