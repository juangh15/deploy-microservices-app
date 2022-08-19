#!/bin/bash      

# Installs:
# nano, wget, git, net-tools

sudo sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-*
sudo sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*
sudo dnf clean all
sudo dnf swap centos-linux-repos centos-stream-repos -y
# sudo dnf update -y

