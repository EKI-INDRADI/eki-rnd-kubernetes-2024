volume = tidak permanen , akan terhapus seiuiring di hapusnya pod

# https://kubernetes.io/docs/concepts/storage/volumes/

jenis2 valume  :
1. emptyDir = dir zonk (tidak cocok digunakan di prod , karena ketika run zonk , dan ketika pod hilang zonk, ketikas restart zonk)
2. hostPath = dir node(host) ke pod
3. gitRepo = dir clone git repo
4. nfs = hsaring network file system
5. dll : https://kubernetes.io/docs/concepts/storage/volumes/



Template :
[pod-with-volume.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/pod-with-volume.yaml)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-name
  labels:
    label-key1: label-value1
    label-key2: label-value2
    label-key3: label-value3
spec:
  volumes:
    - name: volume-name
      emptyDir: {}
      # gitRepo:
      #   repository:
      # nfs:
      #   path:
      #   server:
  containers:
    - name: container-name
      image: image-name
      ports:
        - containerPort: 80
      volumeMounts:
        - mountPath: /app/volume
          name: volume-name
```

volume akan di mounting ke directory container
dan JIKA menggunakan emptyDir: {} <<<< KETIKA RESTART DATA AKAN HILANG , saran pake hostPath

Contoh :
[volume.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/examples/volume.yaml)
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nodejs-writer
  labels:
    name: nodejs-writer
spec:
  volumes:
    - name: html
      emptyDir: {}
  containers:
    - name: nodejs-writer
      image: khannedy/nodejs-writer
      volumeMounts:
        - mountPath: /app/html
          name: html
```
COBA

```bash
kubectl delete all --all
kubectl delete ingress ingress-nginx-with-ingress
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission ##(SOLVED VALIDATE)


mkdir -p /home/ubuntu/KUBERNETES_FILE/pod && 
cd /home/ubuntu/KUBERNETES_FILE/pod && 
nano pod_volume.yaml
```


```bash
apiVersion: v1
kind: Pod
metadata:
  name: nodejs-writer
  labels:
    name: nodejs-writer
spec:
  volumes:
    - name: html
      emptyDir: {}
  containers:
    - name: nodejs-writer
      image: khannedy/nodejs-writer
      volumeMounts:
        - mountPath: /app/html
          name: html
```

```bash
cd /home/ubuntu/KUBERNETES_FILE/pod &&
kubectl create -f pod_volume.yaml  --namespace default


kubectl get all

kubectl exec -it nodejs-writer -- /bin/sh

/# ls /app/html
# index.html
/# cat /app/html/index.html
# <html><body>Fri Aug 23 2024 07:10:16 GMT+0000 (Coordinated Universal Time)</body></html>/app/html 



```