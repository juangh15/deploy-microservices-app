
module "deploy_frontend" {
  source       = "../app_infraestructure"
  vpc_id       = "vpc-e6246881"
  general_tags = { project = "ramp-up-devops", responsible = "juan.sarriase" }
  target_groups = {
    "FRONTEND-8080" = { port = "8080", protocol = "HTTP" }
  }

  load_balancer_sg_name        = "frontend-load-balancer-sg"
  load_balancer_sg_description = "Allow http over port 8080"

  launch_template_sg_name        = "frontend-launch-template-sg"
  launch_template_sg_description = "Allow http over ports 8080 and ssh over 22"

  ec2_template_name_prefix   = "frontend-launch-template"
  ec2_template_image_id      = "ami-06640050dc3f556bb"
  ec2_template_instance_type = "t2.micro"
  ec2_template_device_name   = "/dev/sda1"
  ec2_template_volume_size   = 10
  ec2_template_volume_type   = "gp2"
  ec2_template_key_pair_name = "JuanSE-RampUP"
  ec2_template_user_data     = "../deploy/provision-frontend.sh"
  user_data_backend_ip       = module.deploy_backend.load_balancer_dns_name

  load_balancer_name                  = "frontend-load-balancer"
  is_load_balancer_internal           = false
  load_balancer_type                  = "application"
  load_balancer_security_group_ids    = ["none"]
  load_balancer_subnet_ids            = ["subnet-0ed083b4f1714e9a7", "subnet-030ee31454511f6ec"]
  is_load_balancer_deletion_protected = false

  ec2_autoscaling_min_size          = 1
  ec2_autoscaling_max_size          = 2
  ec2_autoscaling_desired_size      = 1
  ec2_autoscaling_vpc_identifier    = ["subnet-0ed083b4f1714e9a7"]
  ec2_autoscaling_target_group_arns = ["NONE"]

}

module "deploy_backend" {
  source       = "../app_infraestructure"
  vpc_id       = "vpc-e6246881"
  general_tags = { project = "ramp-up-devops", responsible = "juan.sarriase" }
  target_groups = {
    "BACKEND-8000" = { port = "8000", protocol = "HTTP" },
    "BACKEND-8082" = { port = "8082", protocol = "HTTP" },
    "BACKEND-8083" = { port = "8083", protocol = "HTTP" },
    "BACKEND-6379" = { port = "6379", protocol = "HTTP" }
  }

  load_balancer_sg_name        = "backend-load-balancer-sg"
  load_balancer_sg_description = "Allow http over ports 8000,8082,8083 and 6379"

  launch_template_sg_name        = "backend-launch-template-sg"
  launch_template_sg_description = "Allow http over ports 8000,8082,8083 and 6379 and ssh over 22"

  ec2_template_name_prefix   = "backend-launch-template"
  ec2_template_image_id      = "ami-06640050dc3f556bb"
  ec2_template_instance_type = "t2.micro"
  ec2_template_device_name   = "/dev/sda1"
  ec2_template_volume_size   = 10
  ec2_template_volume_type   = "gp2"
  ec2_template_key_pair_name = "JuanSE-RampUP"
  ec2_template_user_data     = "../deploy/provision-backend.sh"

  load_balancer_name                  = "backend-load-balancer"
  is_load_balancer_internal           = true
  load_balancer_type                  = "application"
  load_balancer_security_group_ids    = ["none"]
  load_balancer_subnet_ids            = ["subnet-0ed083b4f1714e9a7", "subnet-030ee31454511f6ec"]
  is_load_balancer_deletion_protected = false

  ec2_autoscaling_min_size          = 1
  ec2_autoscaling_max_size          = 2
  ec2_autoscaling_desired_size      = 1
  ec2_autoscaling_vpc_identifier    = ["subnet-0ed083b4f1714e9a7"]
  ec2_autoscaling_target_group_arns = ["NONE"]

}