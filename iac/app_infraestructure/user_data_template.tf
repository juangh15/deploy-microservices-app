data "template_file" "client" {
  template = file(var.ec2_template_user_data)
}
data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = false
  #first part of local config file
  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
    #!/bin/bash
    echo 'AUTH_API_ADDRESS="${var.user_data_backend_ip}"' >> /opt/server_ip
    echo 'TODOS_API_ADDRESS="${var.user_data_backend_ip}"' >> /opt/server_ip
    echo 'BACKEND_IP="${var.user_data_backend_ip}"' >> /opt/server_ip  
    EOF
  }
  #second part
  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.client.rendered
  }
}