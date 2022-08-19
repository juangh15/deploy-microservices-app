#######################################################
# FRONTEND LAUNCH TEMPLATE
#######################################################

resource "aws_launch_template" "JuanSE_LT_Frontend" {
  name_prefix   = "JuanSE-LT-Frontend"
  image_id      = "ami-06640050dc3f556bb"
  instance_type = "t2.micro"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 10
      volume_type = "gp2"
    }
  }

  key_name               = "JuanSE-RampUP"
  vpc_security_group_ids = [aws_security_group.JuanSE_SG_LT_Frontend.id]

  tag_specifications {
    resource_type = "instance"
    tags          = { project = "ramp-up-devops", responsible = "juan.sarriase" }
  }
  
  tag_specifications {
     resource_type = "volume"
     tags          = { project = "ramp-up-devops", responsible = "juan.sarriase" }
  }

  
  user_data = "${base64encode(data.template_cloudinit_config.config.rendered)}"

}

#######################################################
# BACKEND LAUNCH TEMPLATE
#######################################################

resource "aws_launch_template" "JuanSE_LT_Backend" {
  name_prefix   = "JuanSE-LT-Backend"
  image_id      = "ami-06640050dc3f556bb"
  instance_type = "t2.micro"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 10
      volume_type = "gp2"
    }
  }

  key_name               = "JuanSE-RampUP"
  vpc_security_group_ids = [aws_security_group.JuanSE_SG_LT_Backend.id]

  tag_specifications {
    resource_type = "instance"
    tags          = { project = "ramp-up-devops", responsible = "juan.sarriase" }
  }

  tag_specifications {
     resource_type = "volume"
     tags          = { project = "ramp-up-devops", responsible = "juan.sarriase" }
  }

  user_data = filebase64("../infra/provision-backend.sh")

}