#!/bin/bash
HOME=/home/ubuntu
USER=ubuntu
GROUP=ubuntu

sudo apt update -y && sudo apt upgrade -y
sudo swapoff -a; sed -i '/swap/d' /etc/fstab

sudo cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
sudo cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Install dependencies
sudo apt-get install -y apt-transport-https ca-certificates curl

# Fetch the public key from Google to validate the Kubernetes packages once it will be installed.
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add the Kubernetes package in the sources.list.d directory
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update the packages as we have added some keys and packages.
sudo apt update

# Install kubelet, kubeadm, kubectl and kubernets-cni
sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni

# Install docker
sudo apt install -y docker.io
# sudo usermod -aG docker $USER && newgrp docker
sudo usermod -aG docker ubuntu && newgrp docker

# Configuring containerd to ensure compatibility with Kubernetes
sudo mkdir /etc/containerd
sudo sh -c "containerd config default > /etc/containerd/config.toml"
sudo sed -i 's/ SystemdCgroup = false/ SystemdCgroup = true/' /etc/containerd/config.toml

# Restart containerd, kubelet, and enable kubelet so when we reboot our machine the nodes will restart it as well and connect properly.
sudo systemctl restart containerd.service
sudo systemctl restart kubelet.service
sudo systemctl enable kubelet.service




%{ 
    if node_type == "master" 
}{

#!/bin/bash

echo "node_type:master"  >  $HOME/node_type.log


# Initialize the Kubernetes cluster and it will pull some images such as kube-apiserver, kube-controller, and many other important components.
sudo kubeadm config images pull

# initialize the Kubernetes cluster
sudo kubeadm init > $HOME/kubeadm.log

# kubectl configuration
sudo mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $USER:$GROUP $HOME/.kube/config

# To install the network plugin on the Master node
sudo -u $USER kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

}
%{ 
    endif 
}
%{ 
    if node_type == "worker" 
}
{
echo "node_type:worker"  >  $HOME/node_type.log
}
%{ 
    endif 
}
