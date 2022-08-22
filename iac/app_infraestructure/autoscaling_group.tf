resource "aws_autoscaling_group" "ec2_autoscaling" {
  desired_capacity    = var.ec2_autoscaling_desired_size
  max_size            = var.ec2_autoscaling_max_size
  min_size            = var.ec2_autoscaling_min_size
  vpc_zone_identifier = var.ec2_autoscaling_vpc_identifier
  target_group_arns   = [for k, v in var.target_groups : aws_lb_target_group.tg["${k}"].arn]

  launch_template {
    id      = aws_launch_template.ec2_template.id
    version = "$Latest"
  }

}