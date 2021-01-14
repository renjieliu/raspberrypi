# ********************************************************************************************************************

sudo nano /boot/cmdline.txt # add below line to the end of the file
 cgroup_enable=memory cgroup_memory=1

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo nano /etc/apt/sources.list.d/k8s.list

deb http://apt.kubernetes.io/ kubernetes-xenial main

sudo apt update

sudo apt-get install conntrack kubectl kubeadm kubelet gnupg2 pass 

curl -sSL https://get.docker.com | sh ;

sudo usermod -aG docker pi ;
 
mkdir -p cd /home/pi/Share/k8s

cd /home/pi/Share/k8s

wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-arm

mv minikube-linux-arm minikube

chmod +x minikube

sudo reboot now

# ********************************************************************************************************************

sudo dphys-swapfile swapoff

cd /home/pi/Share/k8s

sudo /home/pi/Share/k8s/minikube start --vm-driver=none

kubectl get node

kubectl get services

kubectl create deployment ubuntu --image=ubuntu

kubectl get deployment

kubectl get replicaset

kubectl get services

kubectl edit deployment ubuntu

kubectl get pod

kubectl logs podName

kubectl exec -it podName -- echo 'Hello World'

kubectl delete deployment name

kubectl apply -f XXX.yaml

kubectl delete -f yyy.json


# ********************************************************************************************************************
