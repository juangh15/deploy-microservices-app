#!/bin/bash

# VARIABLES

export HOME='/root'
export USERNAME='centos'
export USERNAME_DIR='/home/'''$USERNAME''
export MICROSERVICE_GIT_REPOSITORY='https://github.com/bortizf/microservice-app-example.git'
export REDIS_INSTALLER='https://github.com/redis/redis/archive/7.0.4.tar.gz'
export LOG_MESSAGE_DIR=''$USERNAME_DIR'''/microservice-app-example/log-message-processor'
export REDIS_BASE_DIR='/var/redis'
export REDIS_BINARY_DIR='/usr/local/bin'
export REDIS_CONFIG_DIR='/etc/redis'
export REDIS_LOG_FILE='/var/log/redis.log'
export PYTHON3_EXEC='/usr/bin/python3'

export SYSTEMD_SERVICE_REDIS_CONFIG='''
[Unit]
Description=Redis In-Memory Data Store
After=network.target

[Service]
User='$USERNAME'
ExecStart='$REDIS_BINARY_DIR'/redis-server '$REDIS_CONFIG_DIR'/redis.conf
ExecStop='$REDIS_BINARY_DIR'/redis-cli shutdown
Restart=always

[Install]
WantedBy=multi-user.target
'''

export SYSTEMD_SERVICE_LOG_MESSAGE_CONFIG='''
[Unit]
Description=LOG MESSAGE PROCESSOR
After=redis.service

[Service]
User='$USERNAME'
Environment="REDIS_HOST=127.0.0.1"
Environment="REDIS_PORT=6379"
Environment="REDIS_CHANNEL=log_channel"
ExecStart='$PYTHON3_EXEC' '$LOG_MESSAGE_DIR'/main.py
Restart=always
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
'''

# CREATE USER IF NOT EXISTS -----------------------------------------------------
if ! id -u $USERNAME &>/dev/null; then
    sudo adduser $USERNAME -p ''
    sudo usermod -aG wheel $USERNAME
fi

# Python 3.6.0, PIP default and Redis 7.0 -> required for Log Message Processor

sudo yum install python36-devel gcc make -y
cd $USERNAME_DIR

# Get redis if not exists
if [ ! -d "$USERNAME_DIR/redis-7.0.4" ]; then 
    wget $REDIS_INSTALLER
    sudo tar -zxf 7.0.4.tar.gz
fi

# Installs Redis
cd $USERNAME_DIR/redis-7.0.4
sudo make
sudo make install
sudo mkdir -p $REDIS_CONFIG_DIR
sudo mkdir -p $REDIS_BASE_DIR
sudo cp -f redis.conf $REDIS_CONFIG_DIR

# Make Redis Config if not exists
if ! grep -q '''bind 0.0.0.0''' $REDIS_CONFIG_DIR/redis.conf && echo $? ; then
    echo '''
bind 0.0.0.0
logfile "'$REDIS_LOG_FILE'"
dir '$REDIS_BASE_DIR'/''' | sudo tee -a $REDIS_CONFIG_DIR/redis.conf
fi

cd $USERNAME_DIR

# Clone repo if not exists
if [ ! -d "$LOG_MESSAGE_DIR" ]; then 
    git clone $MICROSERVICE_GIT_REPOSITORY
fi

# Installs Log Message Requirements
cd $LOG_MESSAGE_DIR
sudo pip3 install -r requirements.txt


# Turn Redis into a System Service:
sudo systemctl stop redis.service
sudo touch /etc/systemd/system/redis.service
rm -rf /etc/systemd/system/redis.service
echo "$SYSTEMD_SERVICE_REDIS_CONFIG" | sudo tee -a /etc/systemd/system/redis.service
sudo systemctl daemon-reload 
sudo systemctl enable redis.service
sudo systemctl start redis.service
sudo systemctl status redis.service


# Turn Log Message Processor into a System Service:
sudo systemctl stop log_message.service
sudo touch /etc/systemd/system/log_message.service
rm -rf /etc/systemd/system/log_message.service
echo "$SYSTEMD_SERVICE_LOG_MESSAGE_CONFIG" | sudo tee -a /etc/systemd/system/log_message.service
sudo systemctl daemon-reload 
sudo systemctl enable log_message.service
sudo systemctl start log_message.service
sudo systemctl status log_message.service
