#!/bin/bash      

# VARIABLES

export HOME='/root'
export USERNAME='centos'
export USERNAME_DIR='/home/'''$USERNAME''
export MICROSERVICE_GIT_REPOSITORY='https://github.com/bortizf/microservice-app-example.git'
export TODOS_API_DIR=''$USERNAME_DIR'''/microservice-app-example/todos-api'
export NVM_INSTALLER='https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh'
export BASE_DIR='/usr/bin'
export NODE_HOME=''$BASE_DIR'''/node/v8.17.0'
export SYSTEMD_TODOS_API_CONFIG='''
[Unit]
Description=ToDos API
After=network.target

[Service]
User='$USERNAME'
WorkingDirectory='$TODOS_API_DIR'
Environment="JWT_SECRET=PRFT"
Environment="TODO_API_PORT=8082"
ExecStart='$NODE_HOME'/bin/node '$TODOS_API_DIR'/server.js
Restart=always
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
if [ ! -d "$TODOS_API_DIR" ]; then 
    git clone $MICROSERVICE_GIT_REPOSITORY
fi

cd $TODOS_API_DIR
npm install

# Adds Node to an executable env
cp -r -f $HOME/.nvm/versions/node $BASE_DIR

# Turn TODOS API into a System Service:
sudo systemctl stop todos_api.service
touch /etc/systemd/system/todos_api.service
rm -rf /etc/systemd/system/todos_api.service
echo "$SYSTEMD_TODOS_API_CONFIG" | sudo tee -a /etc/systemd/system/todos_api.service
sudo systemctl daemon-reload 
sudo systemctl start todos_api.service
sudo systemctl status todos_api.service
sudo systemctl enable todos_api.service