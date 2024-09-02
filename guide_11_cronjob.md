cronjob = aplikasi penjadwalan, aplikasi berjalan berdasarkan waktu yg kita inginkan

cara kerjanya mirip job
job = berjalan sekali
cronjob = berjalan berulang sesuai dengan jadwal

ex : auto backup tiap malam


[crontab.guru](https://crontab.guru/)

*/5 * * * *




```bash
kubectl create -f conjob_name.yaml
kubectl get cronjobs
kubectl delete cronjobs cronjob_name
```



[cronjob.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/templates/cronjob.yaml)

```yml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: cron-job-name
  labels:
    label-key: label-value
  annotations:
    annotation-key1: annotation-value1
spec:
  schedule: "* * * * *"
  jobTemplate:
    spec:
      selector:
        matchLabels:
          label-key1: label-value1
      template:
        metadata:
          name: pod-name
          labels:
            app: pod-la
        spec:
          restartPolicy: Never
          containers:
            - name: container-name
              image: image-name
              ports:
                - containerPort: 80
```

[cronjob-nodejs.yaml](https://github.com/khannedy/belajar-kubernetes/blob/master/examples/cronjob-nodejs.yaml)

```yml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: nodejs-cronjob
  labels:
    name: nodejs-cronjob
spec:
  schedule: "* * * * *"
  jobTemplate:
    spec:
      template:
        metadata:
          name: nodejs-cronjob
          labels:
            name: nodejs-cronjob
        spec:
          restartPolicy: Never
          containers:
            - name: nodejs-cronjob
              image: khannedy/nodejs-job
```

```bash
mkdir -p /home/ubuntu/KUBERNETES_FILE/cronjob && 
cd /home/ubuntu/KUBERNETES_FILE/cronjob && 
nano cronjob_nodejs.yaml
```

```yml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: nodejs-cronjob
  labels:
    name: nodejs-cronjob
spec:
  schedule: "* * * * *"
  jobTemplate:
    spec:
      template:
        metadata:
          name: nodejs-cronjob
          labels:
            name: nodejs-cronjob
        spec:
          restartPolicy: Never
          containers:
            - name: nodejs-cronjob
              image: khannedy/nodejs-job
```

[khannedy/nodejs-job](KUBERNETES\images_docker\nodejs-job)

```bash
cd /home/ubuntu/KUBERNETES_FILE/cronjob &&
kubectl create -f cronjob_nodejs.yaml --namespace default
kubectl get cronjob
# NAME             SCHEDULE    TIMEZONE   SUSPEND   ACTIVE   LAST SCHEDULE   AGE
# nodejs-cronjob   * * * * *   <none>     False     1        2s              8s

kubectl get all

# NAME                                READY   STATUS             RESTARTS          AGE
# pod/nginx-with-probe                1/1     Running            1 (20h ago)       23h
# pod/nginx-with-probe-error          0/1     CrashLoopBackOff   124 (3m52s ago)   23h
# pod/nodejs-cronjob-28737029-wg8xq   0/1     Completed          0                 2m55s
# pod/nodejs-cronjob-28737030-lq9x8   0/1     Completed          0                 115s
# pod/nodejs-cronjob-28737031-l7kcg   0/1     Completed          0                 55s
# pod/rs-nginx-match-exp-5vv6n        1/1     Running            0                 165m
# pod/rs-nginx-match-exp-7vvvb        1/1     Running            0                 165m
# pod/rs-nginx-match-exp-mjm2j        1/1     Running            0                 165m

# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   28h

# NAME                                 DESIRED   CURRENT   READY   AGE
# replicaset.apps/rs-nginx-match-exp   3         3         3       165m

# NAME                           SCHEDULE    TIMEZONE   SUSPEND   ACTIVE   LAST SCHEDULE   AGE
# cronjob.batch/nodejs-cronjob   * * * * *   <none>     False     0        55s             69m

# NAME                                STATUS     COMPLETIONS   DURATION   AGE
# job.batch/nodejs-cronjob-28737029   Complete   1/1           9s         2m55s
# job.batch/nodejs-cronjob-28737030   Complete   1/1           6s         115s
# job.batch/nodejs-cronjob-28737031   Complete   1/1           6s         55s


kubectl logs  nodejs-cronjob-28737031-l7kcg
# Job executed at Wed Aug 21 2024 06:31:03 GMT+0000 (Coordinated Universal Time)


#NOTE  : pada kubectl get all  , NAME   pod/  , dll hanya history jika sudah completed dan berjumlah banyak artinya sudah selesai berkali2


kubectl describe cronjobs nodejs-cronjob

#...
#...
# Events:
#   Type    Reason            Age                   From                Message
#   ----    ------            ----                  ----                -------
#   Normal  SuccessfulCreate  23m (x42 over 64m)    cronjob-controller  (combined from similar events): Created job nodejs-cronjob-28737013
#   Normal  SuccessfulDelete  2m59s (x59 over 60m)  cronjob-controller  (combined from similar events): Deleted job nodejs-cronjob-28737030

kubectl delete cronjobs nodejs-cronjob
# cronjob.batch "nodejs-cronjob" deleted


```
