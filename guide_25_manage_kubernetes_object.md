Manage Kubernetes Object

cth : pod , service ,configmap,secret, dll

semua menggunakan kubectl create -f namefile.yaml



update object
melihat object
menghapus object


# imperative management

perintah                                    Keterangan
kubectl create -f name_file.yaml           = Membuat kubernetes object
kubectl replace -f name_file.yaml          = Mengupdate kubernetes object  #<--- tidak semua konfigurasi bs di replace
kubectl get -f name_file.yaml -o yaml/json = Melihat kubernetes object
kubectl delete -f name_file.yaml           = Menghapus kubernetes object


## SEBELUMNYA

```bash
mkdir -p /home/ubuntu/KUBERNETES_FILE/pod && 
cd /home/ubuntu/KUBERNETES_FILE/pod && 
nano pod_nginx.yaml
```

```yml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
    - name: nginx-320
      image: nginx:stable-alpine3.20
      ports:
        - containerPort: 80
```

submit pod
```bash

kubectl create -f pod_nginx.yaml
# pod/nginx created

kubectl get pod  nginx
# NAME    READY   STATUS    RESTARTS   AGE
# nginx   1/1     Running   0          24s


```

## COMMAND BARU

mirip konsep docker compose
```bash
kubectl get -f /home/ubuntu/KUBERNETES_FILE/pod/pod_nginx.yaml
# NAME    READY   STATUS    RESTARTS   AGE
# nginx   1/1     Running   0          119s

kubectl get -f /home/ubuntu/KUBERNETES_FILE/pod/pod_nginx.yaml -o yaml
# kind: Pod
# metadata:
#   creationTimestamp: "2024-08-26T04:29:21Z"
#   name: nginx
#   namespace: default
#   resourceVersion: "120707"
#   uid: c0e020be-f059-4250-a6d9-a32ed1ca2577
# spec:
#   containers:
#   - image: nginx:stable-alpine3.20
#     imagePullPolicy: IfNotPresent
#     name: nginx-320
#     ports:
#     - containerPort: 80
#       protocol: TCP
#     resources: {}
#     terminationMessagePath: /dev/termination-log
#     terminationMessagePolicy: File
#     volumeMounts:
#     - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
#       name: kube-api-access-28prt
#       readOnly: true
#   dnsPolicy: ClusterFirst
#   enableServiceLinks: true
#   nodeName: minikube
#   preemptionPolicy: PreemptLowerPriority
#   priority: 0
#   restartPolicy: Always
#   schedulerName: default-scheduler
#   securityContext: {}
#....
#....

kubectl get -f /home/ubuntu/KUBERNETES_FILE/pod/pod_nginx.yaml -o json 

# {
#     "apiVersion": "v1",
#     "kind": "Pod",
#     "metadata": {
#         "creationTimestamp": "2024-08-26T04:29:21Z",
#         "name": "nginx",
#         "namespace": "default",
#         "resourceVersion": "120707",
#         "uid": "c0e020be-f059-4250-a6d9-a32ed1ca2577"
#     },
#     "spec": {
#         "containers": [
#             {
#                 "image": "nginx:stable-alpine3.20",
#                 "imagePullPolicy": "IfNotPresent",
#                 "name": "nginx-320",
#                 "ports": [
#                     {
#                         "containerPort": 80,
#                         "protocol": "TCP"
#                     }
#                 ],
#                 "resources": {},
#                 "terminationMessagePath": "/dev/termination-log",
#                 "terminationMessagePolicy": "File",
#                 "volumeMounts": [
#                     {
#                         "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
#                         "name": "kube-api-access-28prt",
#                         "readOnly": true
#                     }
#                 ]
#             }
#         ],
# ... 
# ...

kubectl get -f /home/ubuntu/KUBERNETES_FILE/pod/pod_nginx.yaml -o json | code - #<---membuka di visual studio code


kubectl replace -f /home/ubuntu/KUBERNETES_FILE/pod/pod_nginx.yaml # (NOT RECOMENDED, selain containers[*].image`,`spec.initContainers[*].image`,`spec.activeDeadlineSeconds`,`spec.tolerations` gak bs di update)

# The Pod "nginx" is invalid: spec: Forbidden: pod updates may not change fields other than `spec.containers[*].image`,`spec.initContainers[*].image`,`spec.activeDeadlineSeconds`,`spec.tolerations` (only additions to existing tolerations),`spec.terminationGracePeriodSeconds` (allow it to be set to 1 if it was previously negative)
#   core.PodSpec{
# -       Volumes: []core.Volume{
# -               {
# -                       Name:         "kube-api-access-28prt",
# -                       VolumeSource: core.VolumeSource{Projected: &core.ProjectedVolumeSource{...}},
# -               },
# -       },
# +       Volumes:        nil,
#         InitContainers: nil,
#         Containers: []core.Container{
#                 {
#                         ... // 9 identical fields
#                         ResizePolicy:  nil,
#                         RestartPolicy: nil,
# -                       VolumeMounts: []core.VolumeMount{
# -                               {
# -                                       Name:      "kube-api-access-28prt",
# -                                       ReadOnly:  true,
# -                                       MountPath: "/var/run/secrets/kubernetes.io/serviceaccount",
# -                               },
# -                       },
# +                       VolumeMounts:  nil,
#                         VolumeDevices: nil,
#                         LivenessProbe: nil,
#                         ... // 10 identical fields
#                 },
#         },
#         EphemeralContainers: nil,
#         RestartPolicy:       "Always",
#         ... // 2 identical fields
#         DNSPolicy:                    "ClusterFirst",
#         NodeSelector:                 nil,
# -       ServiceAccountName:           "default",
# +       ServiceAccountName:           "",
#         AutomountServiceAccountToken: nil,
# -       NodeName:                     "minikube",
# +       NodeName:                     "",
#         SecurityContext:              &{},
#         ImagePullSecrets:             nil,
#         ... // 19 identical fields
#   }

kubectl delete -f /home/ubuntu/KUBERNETES_FILE/pod/pod_nginx.yaml 
# pod "nginx" deleted



```


# DECLARATIVE MANAGEMENT


printah                             keterangan

kubectl apply - f nama_file.yaml =  membuat atau mengupdate kubernetes object


apply = insert or update


perbedaan

create & replace vs apply


apply = file konfigurasi akan di simpan dalam annotation object, ini bermanfaat saat menggunakan objet Deployment, adanya da payload json annotation , "kubectl.kubernetes.io/last-applied-configuration": <<< VALUENYA PAYLOAD DARI yaml configurasinya , maka akan dengan gampang melakukan rollback


create/replace = tidak ada payload json annotation

declrarative management (apply) lbih sering digunakan di banding imperative management





contoh :

```bash
kubectl apply -f /home/ubuntu/KUBERNETES_FILE/pod/pod_nginx.yaml
# pod/nginx created
kubectl get -f /home/ubuntu/KUBERNETES_FILE/pod/pod_nginx.yaml -o json

# kubectl get -f /home/ubuntu/KUBERNETES_FILE/pod/pod_nginx.yaml -o json | code -


# NOTE : ketika membuat podnya menggunakan apply , akan ada annotation , isinya
# "kubectl.kubernetes.io/last-applied-configuration": <<< VALUENYA PAYLOAD DARI yaml configurasinya


# {
#     "apiVersion": "v1",
#     "kind": "Pod",
#     "metadata": {
#         "annotations": {
#             "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"v1\",\"kind\":\"Pod\",\"metadata\":{\"annotations\":{},\"name\":\"nginx\",\"namespace\":\"default\"},\"spec\":{\"containers\":[{\"image\":\"nginx:stable-alpine3.20\",\"name\":\"nginx-320\",\"ports\":[{\"containerPort\":80}]}]}}\n"
#         },
#         "creationTimestamp": "2024-08-26T05:00:39Z",
#         "name": "nginx",
#         "namespace": "default",
#         "resourceVersion": "122476",
#         "uid": "47fd88af-5949-4e52-94fd-9216b88a9206"
#     },
# ...
# ...
kubectl delete -f /home/ubuntu/KUBERNETES_FILE/pod/pod_nginx.yaml
# pod "nginx" deleted
kubectl create -f /home/ubuntu/KUBERNETES_FILE/pod/pod_nginx.yaml
# pod/nginx created


kubectl get -f /home/ubuntu/KUBERNETES_FILE/pod/pod_nginx.yaml -o json
# kubectl get -f /home/ubuntu/KUBERNETES_FILE/pod/pod_nginx.yaml -o json | code -

# tidak ada annotation

# {
#     "apiVersion": "v1",
#     "kind": "Pod",
#     "metadata": {
#         "creationTimestamp": "2024-08-26T05:04:47Z",
#         "name": "nginx",
#         "namespace": "default",
#         "resourceVersion": "122721",
#         "uid": "1a870ec0-e05f-43e4-86df-150ed847ee06"
#     },
# ....
# ....


```