data "template_file" "client" {
  template = "${file("../infra/provision-frontend.sh")}"
}
data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = false
  #first part of local config file
  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
    #!/bin/bash
    echo 'BACKEND_IP="${aws_lb.JuanSE_LB_Backend.dns_name}"' > /opt/server_ip 
    EOF
  }
  #second part
  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.client.rendered
  }
}