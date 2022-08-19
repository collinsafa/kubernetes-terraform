#!/bin/bash
sudo apt-get update -y

sudo apt-get install -y \
 apt-transport-https \
 ca-certificates \
 curl \
 gnupg-agent \
 software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
 "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

sudo apt-get update -y

sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a
sudo apt-get update -y 
sudo service docker start

sudo apt-get update -y 
sudo service docker start
sudo swapoff –a


sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable kubeadm
sudo apt-get update -y
sudo systemctl daemon-reload
sudo systemctl enable docker
sudo systemctl restart docker
sudo rm -rf /etc/docker/key.json
sudo systemctl enable kubelet
sudo systemctl restart kubelet
sudo hostnamectl set-hostname node01
sudo apt-get update -y
