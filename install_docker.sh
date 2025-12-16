#!/bin/bash

if [[ "$(grep ^ID= /etc/os-release | cut -d= -f2)" == *"centos"* ]] || [[ "$(grep ^ID= /etc/os-release | cut -d= -f2)" == *"rhel"* ]]; then
  dnf config-manager --set-disabled '*debug*' '*codeready*' '*source*'
 # Install dnf utils
  dnf -y install dnf-plugins-core
  dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

  # Update the package list and install Docker
  dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  
  systemctl enable --now docker
else
  # Add Docker's official GPG key
  apt-get update
  apt-get install -y ca-certificates curl
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc
  
  # Add the repository to Apt sources
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "${VERSION_CODENAME}") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
  
  # Update the package list and install Docker
  apt-get update
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi
