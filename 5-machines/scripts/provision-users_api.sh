#!/bin/bash      

# VARIABLES

export HOME='/root'
export USERNAME='centos'
export USERNAME_DIR='/home/'''$USERNAME''
export MICROSERVICE_GIT_REPOSITORY='https://github.com/bortizf/microservice-app-example.git'
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

# Create user if not exists
if ! id -u $USERNAME &>/dev/null; then
    sudo adduser $USERNAME -p ''
    sudo usermod -aG wheel $USERNAME
fi

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