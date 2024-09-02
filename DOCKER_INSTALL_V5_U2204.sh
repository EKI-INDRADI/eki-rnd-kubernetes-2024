#!/bin/bash -ex

# DESCRIPTION : AUTO INSTALL DOCKER
# MAINTENER : EKI INDRADI
# OS : UBUNTU 22.04 LTS
# TESTED : 2023-08-07
# GITHUB : https://github.com/EKI-INDRADI
# SERVICE : AWS EC2, AWS LIGHTSAIL, VPS SERVER
#
#
# mkdir -p /home/ubuntu && cd /home/ubuntu && rm -rf DOCKER_INSTALL_V5_U2204.sh && nano DOCKER_INSTALL_V5_U2204.sh
# chmod u+x DOCKER_INSTALL_V5_U2204.sh && ./DOCKER_INSTALL_V5_U2204.sh

# ref : docker-ce & cli
# https://ubuntu.pkgs.org/20.04/docker-ce-amd64/
# https://ubuntu.pkgs.org/22.04/docker-ce-amd64/

# NOTE JIKA ISSUE --fix-missing

# apt-cache madison docker-ce 

# apt-cache madison docker-compose-plugin


function dockerPrepareStage {
# apt-cache madison docker-ce 
DOCKER_VERSION="5:25.0.4-1~ubuntu.22.04~jammy"
# apt-cache madison docker-compose-plugin
DOCKER_COMPOSE_VERSION="2.24.7-1~ubuntu.22.04~jammy"

sudo -i << EOF
rm -rf /etc/apt/keyrings/docker.gpg && \
rm -rf /etc/apt/sources.list.d/docker.list && \
apt-get update
EOF


{ # try
sudo -i << EOF
apt-get remove docker docker-engine docker.io containerd runc docker-compose-plugin
EOF
} || { # catch
echo "=== SKIP ERROR MISSING docker docker-engine docker.io containerd runc ==="
}

}

function dockerConfigureStage {


sudo -i << EOF
sleep 1 && \
apt-get update && \
apt-get install \
    ca-certificates -y \
    curl -y \
    gnupg -y \
    lsb-release -y && \
mkdir -p /etc/apt/keyrings && \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null  && \
apt-get update && \
apt-cache madison docker-ce 
EOF

}

function dockerInstallStage {

sudo -i << EOF
sleep 1 && \
apt-get install docker-ce=${DOCKER_VERSION} -y  && \
apt-get install docker-ce-cli=${DOCKER_VERSION} -y  && \
apt-get install containerd.io -y  && \
apt-get install docker-compose-plugin -y  && \
docker --version
EOF

}


function dockerSetup {

dockerPrepareStage && dockerConfigureStage && dockerInstallStage


}


function dockerComposeSetup {
    
sudo -i << EOF
sleep 1 && \
apt-get update && \
apt-get install docker-compose-plugin -y && \
apt-cache madison docker-compose-plugin
EOF


sudo -i << EOF
sleep 1 && \
apt-get install docker-compose-plugin=${DOCKER_COMPOSE_VERSION} && \
docker compose version
EOF

}


dockerSetup && dockerComposeSetup



