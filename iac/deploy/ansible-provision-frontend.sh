#!/bin/bash
# Get Instance metadata
# EC2_INSTANCE_ID="`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id || die \"wget instance-id has failed: $?\"`"
# EC2_AVAIL_ZONE="`wget -q -O - http://169.254.169.254/latest/meta-data/placement/availability-zone || die \"wget availability-zone has failed: $?\"`"
# EC2_REGION="`echo \"$EC2_AVAIL_ZONE\" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"
# 
# # Tag the instance: not provisioned
# aws ec2 create-tags --region $EC2_REGION --resources $EC2_INSTANCE_ID --tags Key=Provisioned,Value=false

# Install tools and ansible
# dnf update -y
dnf install wget nano git net-tools python3 -y
pip3 install pip --upgrade
pip3 install boto
pip3 install --upgrade ansible

# Declare Backend IP if not exists
if [ ! -f "/opt/server_ip" ]; then 
    echo '#!/bin/bash' >> /opt/server_ip
    echo 'AUTH_API_ADDRESS="10.0.0.10"' >> /opt/server_ip
    echo 'TODOS_API_ADDRESS="10.0.0.10"' >> /opt/server_ip
    echo 'BACKEND_IP="10.0.0.10"' >> /opt/server_ip 
fi

# Clone repository
git clone https://github.com/juangh15/deploy-microservices-app.git
cd ./deploy-microservices-app/ansible/frontend_config
# chmod 400 keys/*
# 
# Run ansible playbook 
ansible-playbook ./main.yml 
# 
# # Tag the instance: provisioned
# aws ec2 create-tags --region $EC2_REGION --resources $InstanceID --tags Key=Provisioned,Value=true