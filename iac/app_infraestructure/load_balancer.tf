resource "aws_lb" "load_balancer" {
  name                       = var.load_balancer_name
  internal                   = var.is_load_balancer_internal
  load_balancer_type         = var.load_balancer_type
  security_groups            = ["${aws_security_group.load_balancer_sg.id}"]
  subnets                    = var.load_balancer_subnet_ids
  enable_deletion_protection = var.is_load_balancer_deletion_protected
  tags                       = var.general_tags
}

resource "aws_lb_listener" "load_balancer_listener" {
  for_each          = aws_lb_target_group.tg
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = each.value.port
  protocol          = each.value.protocol

  default_action {
    target_group_arn = each.value.arn
    type             = "forward"
  }
}