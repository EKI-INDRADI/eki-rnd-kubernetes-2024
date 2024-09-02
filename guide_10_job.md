
Job = printah/pekerjaan yang hanya jalan 1x lalu berhenti jika selesai dilakukan (tidak seperti daemon sets yg selalu on)

contoh : 
migrasi data,
backup / restore database
proses batch csv / xlsx


```bash
kubectl create -f job_name.yaml
kubectl get job
kubectl delete job job_name
```






[job.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/job.yaml)

```yml
apiVersion: batch/v1
kind: Job
metadata:
  name: job-name
  labels:
    label-key1: label-value1
  annotations:
    annotation-key1: annotation-value1
spec:
  completions: 5
  parallelism: 2
  selector:
    matchLabels:
      abel-key1: label-value1
  template:
    metadata:
      name: pod-name
      labels:
        label-key1: label-value1
    spec:
      restartPolicy: Never
      containers:
        - name: container-name
          image: image-name
          ports:
            - containerPort: 80
```

[job-nodejs.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/examples/job-nodejs.yaml)

```yml
apiVersion: batch/v1
kind: Job
metadata:
  name: nodejs-job
spec:
  completions: 4
  parallelism: 2
  template:
    spec:
      restartPolicy: Never
      containers:
        - name: nodejs-job
          image: khannedy/nodejs-job
```

```bash
mkdir -p /home/ubuntu/KUBERNETES_FILE/job && 
cd /home/ubuntu/KUBERNETES_FILE/job && 
nano job_nodejs.yaml
```

```yml
apiVersion: apps/v1
apiVersion: batch/v1
kind: Job
metadata:
  name: job-nodejs
spec:
  completions: 4
  parallelism: 2
  template:
    spec:
      restartPolicy: Never
      containers:
        - name: nodejs-job
          image: khannedy/nodejs-job
```


```bash
cd /home/ubuntu/KUBERNETES_FILE/job &&
kubectl create -f job_nodejs.yaml --namespace default
kubectl get job

# NAME         STATUS    COMPLETIONS   DURATION   AGE
# job-nodejs   Running   1/4           15s        15s

kubectl get pod
# NAME                       READY   STATUS             RESTARTS       AGE
# job-nodejs-77npk           0/1     Completed          0              41s
# job-nodejs-jlzxg           0/1     Completed          0              28s
# job-nodejs-sssfs           0/1     Completed          0              25s
# job-nodejs-xtk6c           0/1     Completed          0              41s
# nginx-with-probe           1/1     Running            1 (19h ago)    21h
# nginx-with-probe-error     0/1     CrashLoopBackOff   92 (68s ago)   21h
# rs-nginx-match-exp-5vv6n   1/1     Running            0              72m
# rs-nginx-match-exp-7vvvb   1/1     Running            0              72m
# rs-nginx-match-exp-mjm2j   1/1     Running            0              72m


kubectl get all
# NAME                           READY   STATUS             RESTARTS        AGE
# pod/job-nodejs-77npk           0/1     Completed          0               97s
# pod/job-nodejs-jlzxg           0/1     Completed          0               84s
# pod/job-nodejs-sssfs           0/1     Completed          0               81s
# pod/job-nodejs-xtk6c           0/1     Completed          0               97s
# pod/nginx-with-probe           1/1     Running            1 (19h ago)     21h
# pod/nginx-with-probe-error     0/1     CrashLoopBackOff   92 (2m4s ago)   21h
# pod/rs-nginx-match-exp-5vv6n   1/1     Running            0               73m
# pod/rs-nginx-match-exp-7vvvb   1/1     Running            0               73m
# pod/rs-nginx-match-exp-mjm2j   1/1     Running            0               73m

# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   26h

# NAME                                 DESIRED   CURRENT   READY   AGE
# replicaset.apps/rs-nginx-match-exp   3         3         3       73m

# NAME                   STATUS     COMPLETIONS   DURATION   AGE
# job.batch/job-nodejs   Complete   4/4           22s        97s

kubectl describe job  job-nodejs
# .....
# Events:
#   Type    Reason            Age    From            Message
#   ----    ------            ----   ----            -------
#   Normal  SuccessfulCreate  3m     job-controller  Created pod: job-nodejs-77npk
#   Normal  SuccessfulCreate  2m59s  job-controller  Created pod: job-nodejs-xtk6c
#   Normal  SuccessfulCreate  2m47s  job-controller  Created pod: job-nodejs-jlzxg
#   Normal  SuccessfulCreate  2m44s  job-controller  Created pod: job-nodejs-sssfs
#   Normal  Completed         2m38s  job-controller  Job completed

kubectl delete job   job-nodejs
# job.batch "job-nkodejs" deleted


```

ex :
  completions: 5 = berpa banyak job yg harus di jalankan, sampai di anggap jobnya ini complite
  parallelism: 2 = berpa banyak pod yang berjalan pada 1 waktu

  maka akan 1 waktu akan ada 2 pod yg nyala, selesai ,lalu nyala lagi 2 pod , selesai , lalu nyala lagi 1 pod

  restartPolicy: Never =  tidak boleh sampe restart jadi wajib Never

  imagenya menggunakan KUBERNETES\images_docker\nodejs-job
