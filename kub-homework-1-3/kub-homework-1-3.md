# Домашнее задание к занятию «Запуск приложений в K8S»



### Задание 1. Создать Deployment и обеспечить доступ к репликам приложения из другого Pod

1. Создать Deployment приложения, состоящего из двух контейнеров — nginx и multitool. Решить возникшую ошибку.

Файл [Dep1.yaml](./Dep1.yaml)
```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dep-1
  labels:
    app: dep-1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: dep-1
  template:
    metadata:
      labels:
        app: dep-1
    spec:
      containers:
        - name: nginx
          image: nginx
        - name: multitool
          image: wbitt/network-multitool
```
вывод команд и статуса pod
```
user@k8s:~$ kubectl apply -f dep1.yaml 
deployment.apps/dep-1 unchanged
user@k8s:~$ kubectl get po
NAME                     READY   STATUS             RESTARTS      AGE
dep-1-79d9f49dc5-4blxp   1/2     CrashLoopBackOff   5 (29s ago)   3m58s
```
Ошибку исправил добавив inv в [Dep1.yaml](./Dep1.yaml)
```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dep-1
  labels:
    app: dep-1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: dep-1
  template:
    metadata:
      labels:
        app: dep-1
    spec:
      containers:
        - name: nginx
          image: nginx
        - name: multitool
          image: wbitt/network-multitool
          env:
            - name: HTTP_PORT
              value: "1180"
            - name: HTTPS_PORT
              value: "11443"
```
Вывод команд и статус pod после исправлений.
```
user@k8s:~$ kubectl apply -f dep1.yaml 
deployment.apps/dep-1 configured
user@k8s:~$ kubectl get po
NAME                     READY   STATUS        RESTARTS   AGE
dep-1-759d444bd-scqr4    2/2     Running       0          6s
dep-1-79d9f49dc5-4blxp   0/2     Terminating   6          9m35s
user@k8s:~$ kubectl get po
NAME                    READY   STATUS    RESTARTS   AGE
dep-1-759d444bd-scqr4   2/2     Running   0          27s
```

2. После запуска увеличить количество реплик работающего приложения до 2.

Внес изменения в [Dep1.yaml](./Dep1.yaml), где указал
```
spec:
  replicas: 2
```



3. Продемонстрировать количество подов до и после масштабирования.

После чего вывод команд и состояние подов:
```
user@k8s:~$ kubectl apply -f dep1.yaml 
deployment.apps/dep-1 configured
user@k8s:~$ kubectl get po
NAME                    READY   STATUS    RESTARTS   AGE
dep-1-759d444bd-scqr4   2/2     Running   0          4m53s
dep-1-759d444bd-c2494   2/2     Running   0          8s
user@k8s:~$ 
```

4. Создать Service, который обеспечит доступ до реплик приложений из п.1.

Создал файл  [Service.yaml](./Service.yaml)
```
---
apiVersion: v1
kind: Service
metadata:
  name: srv-1
spec:
  selector:
    app: dep-1
  ports:
    - name: nginx-http
      port: 80
      targetPort: 80
    - name: multitool-http
      port: 1180
      targetPort: 1180
    - name: multitool-https
      port: 11443
      targetPort: 11443
```

Вывод команд состояния сервиса:
```
user@k8s:~$ kubectl apply -f service.yaml 
service/srv-1 created
user@k8s:~$ kubectl get services
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                     AGE
kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP                     4d8h
srv-1        ClusterIP   10.152.183.218   <none>        80/TCP,1180/TCP,11443/TCP   5s
user@k8s:~$ 
```

5. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложений из п.1.

Создал файл  [Pod1.yaml](./Pod1.yaml)  :
```
---
apiVersion: v1
kind: Pod
metadata:
  name: pod-1
  labels:
    app: pod-1
spec:
  containers:
    - name: multitool
      image: wbitt/network-multitool
      env:
        - name: HTTP_PORT
          value: "1080"
        - name: HTTPS_PORT
          value: "10443"
```

Вывод команд и проверка доступа из под пода к приложению:
```
user@k8s:~$ kubectl apply -f pod1.yaml 
pod/pod-1 created
user@k8s:~$ kubectl get po
NAME                    READY   STATUS    RESTARTS   AGE
dep-1-759d444bd-scqr4   2/2     Running   0          16m
dep-1-759d444bd-c2494   2/2     Running   0          11m
pod-1                   1/1     Running   0          8s
user@k8s:~$ kubectl get po -o wide 
NAME                    READY   STATUS    RESTARTS   AGE   IP           NODE   NOMINATED NODE   READINESS GATES
dep-1-759d444bd-scqr4   2/2     Running   0          17m   10.1.77.19   k8s    <none>           <none>
dep-1-759d444bd-c2494   2/2     Running   0          13m   10.1.77.20   k8s    <none>           <none>
pod-1                   1/1     Running   0          88s   10.1.77.21   k8s    <none>           <none>
user@k8s:~$ kubectl exec pod-1 -- curl --silent -i 10.1.77.19:80
HTTP/1.1 200 OK
Server: nginx/1.25.2
Date: Sat, 16 Sep 2023 15:11:03 GMT
Content-Type: text/html
Content-Length: 615
Last-Modified: Tue, 15 Aug 2023 17:03:04 GMT
Connection: keep-alive
ETag: "64dbafc8-267"
Accept-Ranges: bytes

<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
user@k8s:~$ kubectl exec pod-1 -- curl --silent -i 10.1.77.20:80
HTTP/1.1 200 OK
Server: nginx/1.25.2
Date: Sat, 16 Sep 2023 15:11:19 GMT
Content-Type: text/html
Content-Length: 615
Last-Modified: Tue, 15 Aug 2023 17:03:04 GMT
Connection: keep-alive
ETag: "64dbafc8-267"
Accept-Ranges: bytes

<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
user@k8s:~$
```

------

### Задание 2. Создать Deployment и обеспечить старт основного контейнера при выполнении условий

1. Создать Deployment приложения nginx и обеспечить старт контейнера только после того, как будет запущен сервис этого приложения.

Создал файл [Dep2.yaml](./Dep2.yaml)

```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dep-2
  labels:
    app: dep-2
spec:
  replicas: 1
  selector:
    matchLabels:
      app: dep-2
  template:
    metadata:
      labels:
        app: dep-2
    spec:
      containers:
        - name: nginx
          image: nginx
      initContainers:
        - name: busybox
          image: busybox
          command: ['sh', '-c', 'until nslookup service-2.default.svc.cluster.local; do echo Waiting for service-2!; sleep 5; done;']

```

2. Убедиться, что nginx не стартует. В качестве Init-контейнера взять busybox.

Вывод команд и статус пода:
```
user@k8s:~$ kubectl apply -f Dep2.yaml 
deployment.apps/dep-2 created
user@k8s:~$ kubectl get po
NAME                     READY   STATUS     RESTARTS   AGE
dep-2-58c57849f9-8dhvf   0/1     Init:0/1   0          18s
user@k8s:~$
```

3. Создать и запустить Service. Убедиться, что Init запустился.

Создал файл [Service2.yaml](./Service2.yaml)
```
user@k8s:~$ kubectl apply -f Service2.yaml 
service/srv-2 created
user@k8s:~$ kubectl get service
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.152.183.1    <none>        443/TCP   4d9h
srv-2        ClusterIP   10.152.183.29   <none>        80/TCP    2m21s
```

4. Продемонстрировать состояние пода до и после запуска сервиса.
```
user@k8s:~$ kubectl get po
NAME                     READY   STATUS     RESTARTS   AGE
dep-2-58c57849f9-8dhvf   0/1     Init:0/1   0          16m
```

```
user@k8s:~$ kubectl get po
NAME                     READY   STATUS     RESTARTS   AGE
dep-2-58c57849f9-8dhvf   1/1     Running    0          25m
```
------

