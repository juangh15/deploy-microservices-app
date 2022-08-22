resource "aws_launch_template" "ec2_template" {
  name_prefix            = var.ec2_template_name_prefix
  image_id               = var.ec2_template_image_id
  instance_type          = var.ec2_template_instance_type
  key_name               = var.ec2_template_key_pair_name
  vpc_security_group_ids = [aws_security_group.launch_template_sg.id]
  user_data              = base64encode(data.template_cloudinit_config.config.rendered)

  block_device_mappings {
    device_name = var.ec2_template_device_name

    ebs {
      volume_size = var.ec2_template_volume_size
      volume_type = var.ec2_template_volume_type
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags          = var.general_tags
  }

  tag_specifications {
    resource_type = "volume"
    tags          = var.general_tags
  }

}