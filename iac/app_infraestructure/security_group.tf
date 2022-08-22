resource "aws_security_group" "load_balancer_sg" {
  name        = var.load_balancer_sg_name
  description = var.load_balancer_sg_description
}

resource "aws_security_group" "launch_template_sg" {
  name        = var.launch_template_sg_name
  description = var.launch_template_sg_description
}