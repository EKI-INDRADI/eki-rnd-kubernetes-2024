# minikube have public IP
# how to expose service kubernetes port  to ip public automatic


kubectl port-forward --address 0.0.0.0 pod_name 8888:8080

kubectl port-forward --address 0.0.0.0 -n k8s-s3-be-snbx-product service/service-be-backend <pod_port_access>:port_pod
kubectl port-forward --address 0.0.0.0 -n k8s-s3-be-snbx-product service/service-be-a-report <pod_port_access>:port_pod
kubectl port-forward -n k8s-s3-be-snbx-product service/service-be-a-export-import
kubectl port-forward -n k8s-s3-be-snbx-product service/service-be-oa-forstok
kubectl port-forward -n k8s-s3-be-snbx-product service/service-be-oa-notification
kubectl port-forward -n k8s-s3-be-snbx-product service/service-be-oa-xendit
kubectl port-forward -n k8s-s3-be-snbx-product service/service-be-oa-accurate
kubectl port-forward -n k8s-s3-be-snbx-product service/service-be-oa-qris
kubectl port-forward -n k8s-s3-be-snbx-product service/service-be-oa-verihubs
kubectl port-forward -n k8s-s3-be-snbx-product service/service-be-oa-meta
kubectl port-forward -n k8s-s3-be-snbx-product service/service-be-oa-tada
kubectl port-forward -n k8s-s3-be-snbx-product service/service-be-oa-oracle-netsuite
kubectl port-forward -n k8s-s3-be-snbx-product service/service-be-oa-mekari-jurnal

kubectl proxy --address=0.0.0.0 --accept-hosts='.*'

https://kubernetes.io/docs/tutorials/kubernetes-basics/expose/expose-intro/

kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080


https://stackoverflow.com/questions/55591468/unable-to-access-a-nodeport-service-on-minikube

minikube start --ports=30000:30000,32000:32000



### Summary
- **`minikube tunnel`**: Easiest way to expose services with a simulated public IP.
- **`NodePort` with `minikube ip`**: Access your service directly using Minikube’s IP and NodePort.
- **`Ingress`**: More complex setup but closer to production environments.



----


To expose a Kubernetes service with a public IP automatically in a Minikube environment, you can use Minikube’s built-in functionalities, like `minikube tunnel`, or use a `LoadBalancer` service type. Here’s how to do it:

### 1. **Use `minikube tunnel`**

Minikube doesn’t provide a public IP by default since it’s designed for local development, but you can simulate a public IP using `minikube tunnel`. This command allows services of type `LoadBalancer` to be exposed with an external IP.

#### Steps:
1. **Create a `LoadBalancer` service**:
   
   Update your service configuration to use the `LoadBalancer` type:

   ```yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: service-be
   spec:
     type: LoadBalancer
     selector:
       app-selector: deploy-be
     ports:
       - port: 80
         targetPort: 3000
         protocol: TCP
   ```

2. **Run `minikube tunnel`**:

   Execute the following command:

   ```sh
   minikube tunnel
   ```

   This command creates a network tunnel and assigns an external IP to the `LoadBalancer` service. You might need to run this command with elevated privileges (`sudo`).

3. **Access the service**:

   Once the `minikube tunnel` command is running, Kubernetes will assign an external IP to your service, which you can use to access it from outside your local environment.

### 2. **Use `NodePort` with `minikube ip`**

If you don't want to use `LoadBalancer`, you can use a `NodePort` service type and combine it with Minikube’s IP:

1. **Expose your service as `NodePort`**:
   
   You already have a `NodePort` service defined in your YAML file. Ensure the `nodePort` is within the 30000-32767 range.

2. **Get Minikube’s IP**:

   Run the following command to get the IP address of the Minikube node:

   ```sh
   minikube ip
   ```

   This IP, combined with the `NodePort`, can be used to access the service.

3. **Access the service**:

   You can access your service using `http://<minikube-ip>:<nodePort>`.

### 3. **Use `Ingress`**

For a more production-like setup, you can use an Ingress controller:

1. **Enable Ingress addon**:

   Enable the Ingress addon in Minikube:

   ```sh
   minikube addons enable ingress
   ```

2. **Create an Ingress resource**:

   Define an Ingress resource to route traffic to your service:

   ```yaml
   apiVersion: networking.k8s.io/v1
   kind: Ingress
   metadata:
     name: example-ingress
   spec:
     rules:
       - host: my-app.minikube.local
         http:
           paths:
             - path: /
               pathType: Prefix
               backend:
                 service:
                   name: service-be
                   port:
                     number: 80
   ```

3. **Access the service**:

   Add an entry to your `/etc/hosts` file mapping `my-app.minikube.local` to the Minikube IP:

   ```sh
   echo "$(minikube ip) my-app.minikube.local" | sudo tee -a /etc/hosts
   ```

   Then, access your service using `http://my-app.minikube.local`.

### Summary
- **`minikube tunnel`**: Easiest way to expose services with a simulated public IP.
- **`NodePort` with `minikube ip`**: Access your service directly using Minikube’s IP and NodePort.
- **`Ingress`**: More complex setup but closer to production environments.