output "load_balancer_sg_id" {
  description = "ID of the security group for the load balancer"
  value       = aws_security_group.load_balancer_sg.id
}

output "launch_template_sg_id" {
  description = "ID of the security group for the launch template"
  value       = aws_security_group.launch_template_sg.id
}

output "load_balancer_dns_name" {
  description = "DNS name for accesing"
  value       = aws_lb.load_balancer.dns_name
}

 