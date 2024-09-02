https://www.youtube.com/watch?v=jfaiUr5Yt9E&list=PL-CtdCApEFH8XrWyQAyRd6d_CKwxD8Ime&index=4

https://stackoverflow.com/questions/52445691/how-to-enable-virtualization-in-azure-vm

https://github.com/khannedy/belajar-kubernetes.git

instal kubernetes cluster local vm (hanya 1 node)
0. install os ubuntu 22.04 LTS [DONE]
1. install virtualbox (NOT USED FOR minikube old) [DONE]
2. install minikube [DONE]
3. enable docker minikube [DONE]
4. enable docker as user [DONE]
5. install kubectl / kube control [DONE]


pake kalo azure vm hrs paket D V3 , butuh virtualization nested
- ubuntu 22.04 LTS
- kalo virtualbox enabled nested vtx 192.168.18.163
- azure Secure boot standard / disable for virtualbox
- DISABLE SWAP
- minimal D V3 (support Nester Virtualization) 
- https://github.com/kubernetes/minikube
- name 
YOUR-VM-NAME / LOCAL-VM-SV-PROD-KUBERNETES / PRIEDS-VM-SV-PROD-KUBERNETES 


disable swap off
==========================
To disable swap on a Linux system, you'll need to do the following:

1. **Turn off all swap spaces**:
   
   You can use the following command to turn off all swap spaces:

   ```bash
   sudo swapoff -a
   ```

2. **Comment out the swap entry in `/etc/fstab`**:

   To make this change permanent across reboots, you need to comment out or remove the swap entry in the `/etc/fstab` file.

   Open the file with a text editor:

   ```bash
   sudo nano /etc/fstab
   ```

   Look for a line that contains `swap` and either comment it out by adding a `#` at the beginning of the line or remove it entirely.

3. **Verify that swap is disabled**:

   After performing the above steps, you can verify that swap is disabled by running:

   ```bash
   free -h
   ```

   or

   ```bash
   swapon --show
   ```

   These commands should show no swap space being used.

This process disables swap temporarily (step 1) and permanently (step 2).

==========================

================== FOLDER FILE (NOT USED)

https://github.com/kubernetes/minikube/releases/download/v1.33.0/minikube-linux-amd64

================== FOLDER FILE (NOT USED)


================== DEB FILE

https://github.com/kubernetes/minikube/releases/download/v1.33.0/minikube_1.33.0-0_amd64.deb


================== DEB FILE



https://github.com/kubernetes/minikube/releases

mkdir - p /home/ubuntu/DL && \
cd /home/ubuntu/DL
wget https://github.com/kubernetes/minikube/releases/download/v1.33.0/minikube_1.33.0-0_amd64.deb
sudo dpkg -i minikube_1.33.0-0_amd64.deb


wget https://download.virtualbox.org/virtualbox/7.0.20/virtualbox-7.0_7.0.20-163906~Ubuntu~jammy_amd64.deb

dpkg -i virtualbox-7.0_7.0.20-163906~Ubuntu~jammy_amd64.deb
sudo apt-get -f install


sudo nano /etc/needrestart/needrestart.conf
$nrconf{restart} = 'a';


bin ./minikube start 

or 

https://minikube.sigs.k8s.io/docs/drivers/none/


minikube start
minikube start -- force
minikube start --driver=docker
minikube stop






install docker








-----------------
Pesan error "Exiting due to DRV_AS_ROOT: The 'docker' driver should not be used with root privileges" terjadi karena Minikube mendeteksi bahwa Anda menjalankan perintah dengan hak akses root saat menggunakan driver Docker. Minikube mencegah penggunaan driver Docker dengan akses root karena ini bisa menimbulkan masalah keamanan.
-----------------

exit
minikube start --driver=docker
minikube stop



-----------------
Exiting due to PROVIDER_DOCKER_NEWGRP: "docker version --format <no value>-<no value>:<no value>" exit status 1: permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.46/version": dial unix /var/run/docker.sock: connect: permission denied
-----------------

sudo usermod -aG docker $USER
newgrp docker
docker version
minikube start --driver=docker
minikube stop

============================ directory

ls -la ~/.minikube/


ls ~/.minikube/

pwd


============================ directory



====================DONE
ubuntu@local-vm-sv-prod-kubernetes:~$ minikube start --driver=docker
😄  minikube v1.33.0 on Ubuntu 22.04
🎉  minikube 1.33.1 is available! Download it: https://github.com/kubernetes/minikube/releases/tag/v1.33.1
💡  To disable this notice, run: 'minikube config set WantUpdateNotification false'

✨  Using the docker driver based on user configuration
📌  Using Docker driver with root privileges
👍  Starting "minikube" primary control-plane node in "minikube" cluster
🚜  Pulling base image v0.0.43 ...
💾  Downloading Kubernetes v1.30.0 preload ...
    > preloaded-images-k8s-v18-v1...:  342.90 MiB / 342.90 MiB  100.00% 5.50 Mi
    > gcr.io/k8s-minikube/kicbase...:  480.29 MiB / 480.29 MiB  100.00% 5.05 Mi
🔥  Creating docker container (CPUs=2, Memory=2200MB) ...
🐳  Preparing Kubernetes v1.30.0 on Docker 26.0.1 ...
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🔗  Configuring bridge CNI (Container Networking Interface) ...
🔎  Verifying Kubernetes components...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Enabled addons: storage-provisioner, default-storageclass
💡  kubectl not found. If you need it, try: 'minikube kubectl -- get pods -A'
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
====================DONE

https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-binary-with-curl-on-linux

install kubectl

---------------------
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

kubectl version --client

kubectl version --client --output=yaml

--------------------- 




minikube start --driver=docker
minikube stop

ubuntu@local-vm-sv-prod-kubernetes:~$ minikube start --driver=docker
😄  minikube v1.33.0 on Ubuntu 22.04
✨  Using the docker driver based on existing profile
👍  Starting "minikube" primary control-plane node in "minikube" cluster
🚜  Pulling base image v0.0.43 ...
🔄  Restarting existing docker container for "minikube" ...
🐳  Preparing Kubernetes v1.30.0 on Docker 26.0.1 ...
🔎  Verifying Kubernetes components...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Enabled addons: default-storageclass, storage-provisioner
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default











## UPDATE MINIKUBE
```bash
minikube update-check

#CurrentVersion: v1.33.0
#LatestVersion: v1.33.1

#https://www.youtube.com/watch?v=v7f5zN2tXYk&list=PL-CtdCApEFH8XrWyQAyRd6d_CKwxD8Ime&index=19
#https://youtu.be/v7f5zN2tXYk?list=PL-CtdCApEFH8XrWyQAyRd6d_CKwxD8Ime

# https://github.com/kubernetes/minikube/releases

minikube stop
#minikube stop
minikube delete
#minikube delete

#minikube start --driver=azure
#minikube start --driver=aws
minikube start --driver=docker
#  minikube addons enable metrics-server


# minikube start --driver=virtualbox
# minikube start --driver=hyperv
# minikube start --vm-driver=virtualbox
# minikube start --vm-driver=virtualbox --cpus=2 --memory=6g --disk-size=20g

```


minikube start --driver=docker
minikube addons list
minikube addons enable ingress
minikube addons enable dashboard
minikube addons enable metrics-server


kubectl delete all --all && \
kubectl delete all --all --namespace k8s-s3-fe-snbx-product && \
kubectl delete secret secret-env-fe --namespace k8s-s3-fe-snbx-product && \
kubectl delete configmap configmap-env-fe --namespace k8s-s3-fe-snbx-product && \
kubectl delete secret secret-env-be && \
kubectl delete configmap configmap-env-be


kubectl delete all --all --namespace k8s-s3-fe-snbx-product