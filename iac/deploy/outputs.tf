output "frontend_load_balancer_dns_name" {
  description = "DNS name for accesing"
  value       = module.deploy_frontend.load_balancer_dns_name
}

output "backend_load_balancer_dns_name" {
  description = "DNS name for accesing"
  value       = module.deploy_backend.load_balancer_dns_name
}