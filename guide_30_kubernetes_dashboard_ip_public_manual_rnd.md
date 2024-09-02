


#### SYSTEM D MINIKUBE (DONT USE ISSUE)
<!-- 
```bash
which minikube
# /usr/bin/minikube


# NOTE : replace all /usr/local/bin/minikube ->  /usr/bin/minikube

```


To create a systemd service for starting Minikube with the Docker driver, follow these steps:

### 1. **Create the systemd Service File**

First, create a new systemd service file:

```bash
sudo nano /etc/systemd/system/minikube.service
```

### 2. **Add the Following Configuration**

Add the following content to the service file:

```ini
[Unit]
Description=Minikube Kubernetes Cluster
After=network.target docker.service
Requires=docker.service

[Service]
User=ubuntu
Environment=MINIKUBE_IN_STYLE=false
ExecStart=/usr/bin/minikube start --driver=docker
ExecStop=/usr/bin/minikube stop
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

### Explanation:

- **`User=ubuntu`**: Replace `ubuntu` with the user who has permissions to run Minikube.
- **`Environment=MINIKUBE_IN_STYLE=false`**: This disables Minikube's colored output, which can help avoid issues with logs in systemd.
- **`ExecStart=/usr/bin/minikube start --driver=docker`**: This command starts Minikube using the Docker driver.
- **`ExecStop=/usr/bin/minikube stop`**: This command stops Minikube when the service is stopped.
- **`Restart=on-failure`**: The service will restart if it fails.
- **`RestartSec=10`**: Waits 10 seconds before attempting to restart the service.

### 3. **Reload systemd and Start the Service**

After saving the service file, reload systemd to apply the changes:

```bash
sudo systemctl daemon-reload
```

Then, enable and start the Minikube service:

```bash
sudo systemctl enable minikube.service
sudo systemctl start minikube.service
```

### 4. **Check the Service Status**

You can check if Minikube is running by viewing the status of the service:

```bash
sudo systemctl status minikube.service
```

This setup will ensure that Minikube starts automatically using the Docker driver whenever your system boots up or the service is restarted.

Let me know if you encounter any issues!
 -->



```bash
sudo systemctl disable minikube.service
sudo rm /etc/systemd/system/minikube.service


minikube start --driver=docker
minikube status
minikube addons enable metrics-server
```


#### SYSTEM D MINIKUBE-DASHBOARD



https://unix.stackexchange.com/questions/621369/how-can-i-make-the-minikube-dashboard-answer-on-all-ips-0-0-0-0

```bash
$ minikube dashboard --url &
[1] 356972
And then use kubectl proxy to listen to all addresses,

kubectl proxy --address=0.0.0.0 --accept-hosts='.*'


# EX :
# <your-host-external-ip>:8001/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/


# https://stackoverflow.com/questions/60784407/how-to-configure-external-ip-address-of-minikube-dashboard (SOLVED)


# SOLVED :

http://<YOUR_IP_PUBLIC>:8001/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/
```


SYSTEM D


To create a systemd service for both the Minikube dashboard and the `kubectl proxy` command, you can create two separate service files.


```bash
which minikube
# /usr/bin/minikube
which kubectl
# /usr/local/bin/kubectl

```

### 1. **Minikube Dashboard systemd Service**

Create a systemd service to start the Minikube dashboard:

```bash
sudo nano /etc/systemd/system/minikube-dashboard.service
```

Add the following content:

<!-- ExecStart=/usr/local/bin/minikube dashboard --url HAS ISSUE -->

```ini
[Unit]
Description=Minikube Dashboard
After=network.target

[Service]
User=ubuntu
ExecStart=/usr/bin/minikube dashboard --url
Restart=always
Environment=DISPLAY=:0
Environment=XAUTHORITY=/home/ubuntu/.Xauthority

[Install]
WantedBy=multi-user.target
```

- **Replace `ubuntu`** with your actual username.
- **ExecStart** uses the `--url` option to start the dashboard without opening it in a browser.

### 2. **kubectl Proxy systemd Service**

Create a systemd service to start the `kubectl proxy`:

```bash
sudo nano /etc/systemd/system/kubectl-proxy.service
```

Add the following content:

```ini
[Unit]
Description=Kubernetes API Proxy
After=network.target

[Service]
User=ubuntu
ExecStart=/usr/local/bin/kubectl proxy --address=0.0.0.0 --accept-hosts='.*'
Restart=always

[Install]
WantedBy=multi-user.target
```

- **Replace `ubuntu`** with your actual username.
- The `ExecStart` command starts the `kubectl proxy` service.

### 3. **Reload systemd and Enable Services**

After creating the service files, reload systemd to recognize the new services:

```bash
sudo systemctl daemon-reload
```

Enable and start both services:

```bash
sudo systemctl enable minikube-dashboard.service
sudo systemctl start minikube-dashboard.service
sudo systemctl status minikube-dashboard.service
sudo systemctl stop minikube-dashboard.service


sudo systemctl enable kubectl-proxy.service
sudo systemctl start kubectl-proxy.service
sudo systemctl status kubectl-proxy.service
sudo systemctl stop kubectl-proxy.service
```

### 4. **Check the Status**

To check if the services are running, you can use:

```bash

# sudo systemctl stop minikube.service
sudo systemctl stop minikube-dashboard.service
sudo systemctl stop kubectl-proxy.service


# sudo systemctl status minikube.service
sudo systemctl status minikube-dashboard.service
sudo systemctl status kubectl-proxy.service

sudo systemctl start kubectl-proxy.service
sudo systemctl start minikube-dashboard.service


```

This will allow the Minikube dashboard to run in the background as a service and make the Kubernetes API accessible via `kubectl proxy` on all network interfaces.

Let me know if you need further assistance!




<!-- RUN : -->
http://<YOUR_IP_PUBLIC>:8001/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/
