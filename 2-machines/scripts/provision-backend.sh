#!/bin/bash   

# GENERAL VARIABLES

export HOME='/root'
export USERNAME='centos'
export USERNAME_DIR='/home/'''$USERNAME''
export MICROSERVICE_GIT_REPOSITORY='https://github.com/bortizf/microservice-app-example.git'

sudo yum install wget nano git net-tools -y

# CREATE USER IF NOT EXISTS -----------------------------------------------------
if ! id -u $USERNAME &>/dev/null; then
    sudo adduser $USERNAME -p ''
    sudo usermod -aG wheel $USERNAME
fi

# USERS-API ---------------------------------------------------------------------

export EXPECTED_JAVA_HOME='/usr/lib/jvm/java-1.8.0-openjdk'
export USERS_API_DIR=''$USERNAME_DIR'''/microservice-app-example/users-api'
export SYSTEMD_USERS_API_CONFIG='''
[Unit]
Description=Users API
After=network.target

[Service]
User='$USERNAME'
Environment="JWT_SECRET=PRFT"
Environment="SERVER_PORT=8083"
ExecStart='$EXPECTED_JAVA_HOME'/bin/java -jar '$USERS_API_DIR'/target/users-api-0.0.1-SNAPSHOT.jar
Restart=always
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
'''

# Dependency Java OpenJDK8 -> required for Users API
sudo yum install java-1.8.0-openjdk-devel -y

# Adds Java to PATH if not exists
if [[ ! "$PATH" == *"$EXPECTED_JAVA_HOME"* ]]; then
    rm -rf /etc/profile.d/java_env.sh
    touch /etc/profile.d/java_env.sh
    echo '''export JAVA_HOME='$EXPECTED_JAVA_HOME'
    export PATH='$JAVA_HOME'/bin:'$PATH'''' | sudo tee -a /etc/profile.d/java_env.sh
    source /etc/profile.d/java_env.sh
fi


# Clone repo if not exists
if [ ! -d "$USERS_API_DIR" ]; then 
    cd $USERNAME_DIR
    git clone $MICROSERVICE_GIT_REPOSITORY
fi

# Installs the API
cd $USERS_API_DIR
./mvnw clean install


# Turn users_api into a System Service:
sudo systemctl stop users_api.service
rm -rf /etc/systemd/system/users_api.service
touch /etc/systemd/system/users_api.service
echo "$SYSTEMD_USERS_API_CONFIG" | sudo tee -a /etc/systemd/system/users_api.service
sudo systemctl daemon-reload 
sudo systemctl enable users_api.service
sudo systemctl start users_api.service
sudo systemctl status users_api.service



# AUTH-API ---------------------------------------------------------------------

export USERS_API_ADDRESS='http://localhost:8083'
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



#TODOs-API ---------------------------------------------------------------------

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




# LOG_MESSAGE-AND-REDIS ---------------------------------------------------------------------

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
