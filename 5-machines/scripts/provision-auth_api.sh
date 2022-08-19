#!/bin/bash      

# VARIABLES

export HOME='/root'
export USERNAME='centos'
export USERNAME_DIR='/home/'''$USERNAME''
export MICROSERVICE_GIT_REPOSITORY='https://github.com/bortizf/microservice-app-example.git'
export USERS_API_ADDRESS='http://10.0.0.10:8083'
export GOLANG_INSTALLER='https://go.dev/dl/go1.18.2.linux-amd64.tar.gz'
export EXPECTED_GOLANG_HOME='/usr/local/go'
export AUTH_API_DIR=''$USERNAME_DIR'''/microservice-app-example/auth-api'
export AUTH_BINARY_DIR='/usr/local/bin'
export SYSTEMD_AUTH_API_CONFIG='''
[Unit]
Description=Auth API
After=network.target

[Service]
User='$USERNAME'
Environment="JWT_SECRET=PRFT"
Environment="AUTH_API_PORT=8000"
Environment="USERS_API_ADDRESS='$USERS_API_ADDRESS'"
ExecStart='$AUTH_BINARY_DIR'/auth-api
Restart=always
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
'''

# Go 1.18.2 -> required for Auth API

# Installs GOLANG if not exists
if ! go version | grep -q "1.18.2" && echo $? ; then
    wget $GOLANG_INSTALLER
    sudo tar -xvf go1.18.2.linux-amd64.tar.gz -C /usr/local
fi

# Adds GOLANG to PATH if not exists
if [[ ! "$PATH" == *"$EXPECTED_GOLANG_HOME"* ]]; then
    rm -rf /etc/profile.d/golang_env.sh
    touch /etc/profile.d/golang_env.sh
    echo 'export PATH=$PATH:'$EXPECTED_GOLANG_HOME'/bin' | sudo tee -a /etc/profile.d/golang_env.sh
    source /etc/profile.d/golang_env.sh
fi

# Clone repo if not exists
if [ ! -d "$AUTH_API_DIR" ]; then 
    cd $USERNAME_DIR
    git clone $MICROSERVICE_GIT_REPOSITORY
fi

# Installs the API
cd $AUTH_API_DIR

export GO111MODULE=on
go mod init github.com/bortizf/microservice-app-example/tree/master/auth-api
go mod tidy
go build

cp -r -f $AUTH_API_DIR/auth-api $AUTH_BINARY_DIR

# Turn Auth API  into a System Service:
sudo systemctl stop auth_api.service
sudo touch /etc/systemd/system/auth_api.service
rm -rf /etc/systemd/system/auth_api.service
echo "$SYSTEMD_AUTH_API_CONFIG" | sudo tee -a /etc/systemd/system/auth_api.service
sudo systemctl daemon-reload 
sudo systemctl enable auth_api.service
sudo systemctl start auth_api.service
sudo systemctl status auth_api.service

