variable "vpc_id" {
  type        = string
  description = "VPC ID in which all resources will be created"
}


variable "ssh_allowed_block" {
  type        = string
  description = "Specific IP directions which will be allowed to access the instances"
  default     = "0.0.0.0/0"
}


variable "general_tags" {
  description = "Tags for most of the resources will be created"
  type        = map(string)
}


variable "target_groups" {
  description = "Create target groups with: Key = Target groups names | Values = ports and protocols"

  type = map(object({
    port     = number
    protocol = string
  }))
}


variable "load_balancer_sg_name" {
  type        = string
  description = "Name of the Security Group for the Load Balancer"
}

variable "load_balancer_sg_description" {
  type        = string
  description = "Description of the Security Group for the Load Balancer"
}



variable "launch_template_sg_name" {
  type        = string
  description = "Name of the Security Group for the Launch Template"
}

variable "launch_template_sg_description" {
  type        = string
  description = "Description of the Security Group for the Launch Template"
}



variable "ec2_template_name_prefix" {
  type        = string
  description = "Name Prefix for the instances to launch"
}


variable "ec2_template_image_id" {
  type        = string
  description = "AMI ID for the instances to launch"
}

variable "ec2_template_instance_type" {
  type        = string
  description = "Type of the instances to launch"
  default     = "t2.micro"
}

variable "ec2_template_device_name" {
  type        = string
  description = "Device name of the volume for the instances to launch"
  default     = "/dev/sda1"
}

variable "ec2_template_volume_size" {
  type        = number
  description = "Storage of the volume for the instances to launch"
  default     = 10
}

variable "ec2_template_volume_type" {
  type        = string
  description = "Type of the volume for the instances to launch"
  default     = "gp2"
}

variable "ec2_template_key_pair_name" {
  type        = string
  description = "Name of the key for connections on the instances to launch"
}

variable "ec2_template_user_data" {
  type        = string
  description = "Location of the file for provision the instances to launch"
}

variable "user_data_backend_ip" {
  type        = string
  description = "IP or net direction of the backend APIs"
  default     = "localhost"
}



variable "load_balancer_name" {
  type        = string
  description = "Name for the Load Balancer"
}

variable "is_load_balancer_internal" {
  type        = bool
  description = "true: Load Balancer private | false: Load Balancer accesible from internet"
  default     = false
}

variable "load_balancer_type" {
  type        = string
  description = "Type of Load Balancer"
  default     = "application"
}

variable "load_balancer_security_group_ids" {
  type        = set(string)
  description = "Security group which can access the Load Balancer"
}

variable "load_balancer_subnet_ids" {
  type        = set(string)
  description = "Subnets IDs in which the Load Balancer will be created"
}

variable "is_load_balancer_deletion_protected" {
  type        = bool
  description = "true: Load Balancer only can be deleted with confirmation | false: Load Balancer can be deleted without asking"
  default     = false
}


variable "ec2_autoscaling_min_size" {
  type        = number
  description = "Minimum amount of instances running"
  default     = 1
}

variable "ec2_autoscaling_max_size" {
  type        = number
  description = "Maximum amount of instances running"
  default     = 2
}

variable "ec2_autoscaling_desired_size" {
  type        = number
  description = "Desired amount of instances running"
  default     = 1
}

variable "ec2_autoscaling_vpc_identifier" {
  type        = set(string)
  description = "IDs of the subnets in which the autoscaling will be located"
}

variable "ec2_autoscaling_target_group_arns" {
  type        = set(string)
  description = "ARNs of the target groups for the instances in the autoscaling group"
}

variable "ec2_autoscaling_health_check_grace_period" {
  type        = number
  description = "Time to wait before sending health requests to launched instances"
  default     = 240
}

variable "ec2_autoscaling_health_check_type" {
  type        = string
  description = "Type of the health checks to instances"
  default     = "ELB"
}

variable "ec2_autoscaling_wait_for_capacity_timeout" {
  type        = string
  description = "Time to wait before destroying the previous instances"
  default     = "1s"
}

variable "ec2_autoscaling_wait_for_elb_capacity" {
  type        = number
  description = "Number of launched instances running before destroying the previous instances"
  default     = 1
} 