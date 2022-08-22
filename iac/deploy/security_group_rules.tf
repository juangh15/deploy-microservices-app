module "frontend_security_rules" {
  source = "../Security_Rules"

  security_ingress_ports = {

    FRONTEND_LOAD_BALANCER_8080 = {
      security_group_id        = module.deploy_frontend.load_balancer_sg_id,
      port                     = 8080,
      protocol                 = "TCP",
      source_security_group_id = null,
      cidr_blocks              = ["0.0.0.0/0"]
    },
    FRONTEND_LAUNCH_TEMPLATE_8080 = {
      security_group_id        = module.deploy_frontend.launch_template_sg_id,
      port                     = 8080,
      protocol                 = "TCP",
      source_security_group_id = module.deploy_frontend.load_balancer_sg_id,
      cidr_blocks              = null
    },
    FRONTEND_LAUNCH_TEMPLATE_22 = {
      security_group_id        = module.deploy_frontend.launch_template_sg_id,
      port                     = 22,
      protocol                 = "TCP",
      source_security_group_id = null,
      cidr_blocks              = ["190.70.20.93/32"]
    }
  }


  security_egress_ports = {

    FRONTEND_LAUNCH_TEMPLATE = {
      port                     = 0,
      protocol                 = "-1",
      security_group_id        = module.deploy_frontend.launch_template_sg_id,
      source_security_group_id = null,
      cidr_blocks              = ["0.0.0.0/0"]
    },

    FRONTEND_LOAD_BALANCER = {
      port                     = 0,
      protocol                 = "-1",
      security_group_id        = module.deploy_frontend.load_balancer_sg_id,
      source_security_group_id = null,
      cidr_blocks              = ["0.0.0.0/0"]
    }
  }
}

module "backend_security_rules" {
  source = "../Security_Rules"
  security_ingress_ports = {

    # ALL BACKEND LOAD BALANCER RULES:
    BACKEND_LOAD_BALANCER_8000 = {
      security_group_id        = module.deploy_backend.load_balancer_sg_id,
      port                     = 8000,
      protocol                 = "TCP",
      source_security_group_id = module.deploy_frontend.launch_template_sg_id,
      cidr_blocks              = null
    },
    BACKEND_LOAD_BALANCER_8082 = {
      security_group_id        = module.deploy_backend.load_balancer_sg_id,
      port                     = 8082,
      protocol                 = "TCP",
      source_security_group_id = module.deploy_frontend.launch_template_sg_id,
      cidr_blocks              = null
    },
    BACKEND_LOAD_BALANCER_8083 = {
      security_group_id        = module.deploy_backend.load_balancer_sg_id,
      port                     = 8083,
      protocol                 = "TCP",
      source_security_group_id = module.deploy_frontend.launch_template_sg_id,
      cidr_blocks              = null
    },
    BACKEND_LOAD_BALANCER_6379 = {
      security_group_id        = module.deploy_backend.load_balancer_sg_id,
      port                     = 6379,
      protocol                 = "TCP",
      source_security_group_id = module.deploy_frontend.launch_template_sg_id,
      cidr_blocks              = null
    },


    # ALL BACKEND LAUNCH TEMPLATE RULES:
    BACKEND_LAUNCH_TEMPLATE_8000 = {
      security_group_id        = module.deploy_backend.launch_template_sg_id,
      port                     = 8000,
      protocol                 = "TCP",
      source_security_group_id = module.deploy_backend.load_balancer_sg_id,
      cidr_blocks              = null
    },
    BACKEND_LAUNCH_TEMPLATE_8082 = {
      security_group_id        = module.deploy_backend.launch_template_sg_id,
      port                     = 8082,
      protocol                 = "TCP",
      source_security_group_id = module.deploy_backend.load_balancer_sg_id,
      cidr_blocks              = null
    },
    BACKEND_LAUNCH_TEMPLATE_8083 = {
      security_group_id        = module.deploy_backend.launch_template_sg_id,
      port                     = 8083,
      protocol                 = "TCP",
      source_security_group_id = module.deploy_backend.load_balancer_sg_id,
      cidr_blocks              = null
    },
    BACKEND_LAUNCH_TEMPLATE_6379 = {
      security_group_id        = module.deploy_backend.launch_template_sg_id,
      port                     = 6379,
      protocol                 = "TCP",
      source_security_group_id = module.deploy_backend.load_balancer_sg_id,
      cidr_blocks              = null
    },
    BACKEND_LAUNCH_TEMPLATE_22 = {
      security_group_id        = module.deploy_backend.launch_template_sg_id,
      port                     = 22,
      protocol                 = "TCP",
      source_security_group_id = null,
      cidr_blocks              = ["190.70.20.93/32"]
    }
  }


  security_egress_ports = {

    BACKEND_LAUNCH_TEMPLATE = {
      port                     = 0,
      protocol                 = "-1",
      security_group_id        = module.deploy_backend.launch_template_sg_id,
      source_security_group_id = null,
      cidr_blocks              = ["0.0.0.0/0"]
    },

    BACKEND_LOAD_BALANCER = {
      port                     = 0,
      protocol                 = "-1",
      security_group_id        = module.deploy_backend.load_balancer_sg_id,
      source_security_group_id = null,
      cidr_blocks              = ["0.0.0.0/0"]
    }
  }
}