#!/bin/bash

# GET THE BACKEND IP
echo "Inject Variable"
source /opt/server_ip 

sudo yum install wget nano git net-tools -y
# VARIABLES

export HOME='/root'
export USERNAME='centos'
export USERNAME_DIR='/home/'''$USERNAME''
export FRONTEND_DIR=''$USERNAME_DIR'''/microservice-app-example/frontend'
export FRONTEND_PORT='8080'
export AUTH_API_ADDRESS='http://'''$BACKEND_IP''':8000'
export TODOS_API_ADDRESS='http://'''$BACKEND_IP''':8082'
export MICROSERVICE_GIT_REPOSITORY='https://github.com/bortizf/microservice-app-example.git'
export NVM_INSTALLER='https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh'
export BASE_DIR='/usr/bin'
export NODE_HOME='/usr/bin/node/v8.17.0'
export SYSTEMD_SERVICE_CONFIG='''
[Unit]
Description=Frontend Service
After=network.target

[Service]
User='$USERNAME'
WorkingDirectory='$FRONTEND_DIR'
Environment="PORT='$FRONTEND_PORT'"
Environment="AUTH_API_ADDRESS='$AUTH_API_ADDRESS'"
Environment="TODOS_API_ADDRESS='$TODOS_API_ADDRESS'"
ExecStart='$NODE_HOME'/bin/node ./build/dev-server.js
Restart=on-failure
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
'''

# Create user if not exists
if ! id -u $USERNAME &>/dev/null; then
    sudo adduser $USERNAME -p ''
    sudo usermod -aG wheel $USERNAME
fi

# NPM 6.13.4 and Node 8.17.0 -> required for Frontend

# Installs NVM if not exists
if ! nvm -v | grep -q "0.39.0" && echo $? ; then
    curl -o- $NVM_INSTALLER | bash
    source ~/.bashrc
fi

# Installs Node and NPM if not exists
if ! node -v | grep -q "8.17.0" && echo $? ; then
    nvm install v8.17.0
fi

# node -v
# npm -v

cd $USERNAME_DIR

# Clone repo if not exists
if [ ! -d "$FRONTEND_DIR" ]; then 
    git clone $MICROSERVICE_GIT_REPOSITORY
fi

cd $FRONTEND_DIR

npm install module node-sass@4.7.2 --unsafe-perm
npm install
npm run build

# Adds Node to an executable env
cp -r -f $HOME/.nvm/versions/node $BASE_DIR

# Turn Frontend into a system service
sudo systemctl stop frontend.service
rm -rf /etc/systemd/system/frontend.service
touch /etc/systemd/system/frontend.service
echo "$SYSTEMD_SERVICE_CONFIG" | sudo tee -a /etc/systemd/system/frontend.service
sudo systemctl daemon-reload 
sudo systemctl start frontend.service
sudo systemctl enable frontend.service
sudo systemctl status frontend.service