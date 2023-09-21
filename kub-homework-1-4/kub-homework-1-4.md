# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 1»

### Цель задания

В тестовой среде Kubernetes необходимо обеспечить доступ к приложению, установленному в предыдущем ДЗ и состоящему из двух контейнеров, по разным портам в разные контейнеры как внутри кластера, так и снаружи.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/services-networking/service/) Описание Service.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment и обеспечить доступ к контейнерам приложения по разным портам из другого Pod внутри кластера

1. Создать Deployment приложения, состоящего из двух контейнеров (nginx и multitool), с количеством реплик 3 шт.

Файл [Dep-1.yaml](./Dep-1.yaml)
```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dep-1
  labels:
    app: dep-1
spec:
  replicas: 3
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
              value: "8080"
            - name: HTTPS_PORT
              value: "11443"
```
Вывод команд:
```
user@k8s:~$ kubectl apply -f Dep-1.yaml 
deployment.apps/dep-1 created
user@k8s:~$ kubectl get po
NAME                     READY   STATUS    RESTARTS   AGE
dep-1-77b4757cf8-7w9t9   2/2     Running   0          20s
dep-1-77b4757cf8-ll7gf   2/2     Running   0          20s
dep-1-77b4757cf8-5nwg2   2/2     Running   0          20s
user@k8s:~$  
```


2. Создать Service, который обеспечит доступ внутри кластера до контейнеров приложения из п.1 по порту 9001 — nginx 80, по 9002 — multitool 8080.
Файл [Service-1.yaml](./Service-1.yaml)
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
      port: 9001
      targetPort: 80
    - name: multitool-http
      port: 9002
      targetPort: 8080
```
Вывод команд:
```
user@k8s:~$ kubectl apply -f Service-1.yaml 
service/srv-1 created
user@k8s:~$ kubectl get service
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP             9d
srv-1        ClusterIP   10.152.183.232   <none>        9001/TCP,9002/TCP   7s
user@k8s:~$  
```

3. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложения из п.1 по разным портам в разные контейнеры.
Файл [Pod-1.yaml](./Pod-1.yaml)
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
Вывод команд создания пода:
```
user@k8s:~$ kubectl apply -f Pod-1.yaml 
pod/pod-1 created
user@k8s:~$ kubectl get po -o wide
NAME                     READY   STATUS    RESTARTS   AGE     IP           NODE   NOMINATED NODE   READINESS GATES
dep-1-77b4757cf8-7w9t9   2/2     Running   0          2m16s   10.1.77.38   k8s    <none>           <none>
dep-1-77b4757cf8-ll7gf   2/2     Running   0          2m16s   10.1.77.39   k8s    <none>           <none>
dep-1-77b4757cf8-5nwg2   2/2     Running   0          2m16s   10.1.77.40   k8s    <none>           <none>
pod-1                    1/1     Running   0          5s      10.1.77.41   k8s    <none>           <none>
user@k8s:~$  
```
Демонстрация доступа из под пода в приложение по разным портам в разные контейнеры ( показано на примере одного пода)
```
user@k8s:~$ kubectl exec pod-1 -- curl --silent -i 10.1.77.38:80 -I
HTTP/1.1 200 OK
Server: nginx/1.25.2
Date: Thu, 21 Sep 2023 12:37:11 GMT
Content-Type: text/html
Content-Length: 615
Last-Modified: Tue, 15 Aug 2023 17:03:04 GMT
Connection: keep-alive
ETag: "64dbafc8-267"
Accept-Ranges: bytes

user@k8s:~$ kubectl exec pod-1 -- curl --silent -i 10.1.77.38:8080 -I
HTTP/1.1 200 OK
Server: nginx/1.24.0
Date: Thu, 21 Sep 2023 12:37:15 GMT
Content-Type: text/html
Content-Length: 141
Last-Modified: Thu, 21 Sep 2023 12:33:38 GMT
Connection: keep-alive
ETag: "650c3822-8d"
Accept-Ranges: bytes

user@k8s:~$ 
```

4. Продемонстрировать доступ с помощью `curl` по доменному имени сервиса.
```
user@k8s:~$ kubectl get service
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP             9d
srv-1        ClusterIP   10.152.183.232   <none>        9001/TCP,9002/TCP   6m30s
user@k8s:~$ kubectl exec pod-1 -- curl --silent -i srv-1:9001 -I
HTTP/1.1 200 OK
Server: nginx/1.25.2
Date: Thu, 21 Sep 2023 12:42:22 GMT
Content-Type: text/html
Content-Length: 615
Last-Modified: Tue, 15 Aug 2023 17:03:04 GMT
Connection: keep-alive
ETag: "64dbafc8-267"
Accept-Ranges: bytes

user@k8s:~$ kubectl exec pod-1 -- curl --silent -i srv-1:9002 -I
HTTP/1.1 200 OK
Server: nginx/1.24.0
Date: Thu, 21 Sep 2023 12:42:24 GMT
Content-Type: text/html
Content-Length: 141
Last-Modified: Thu, 21 Sep 2023 12:33:40 GMT
Connection: keep-alive
ETag: "650c3824-8d"
Accept-Ranges: bytes

user@k8s:~$ 
```

5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

------

### Задание 2. Создать Service и обеспечить доступ к приложениям снаружи кластера

1. Создать отдельный Service приложения из Задания 1 с возможностью доступа снаружи кластера к nginx, используя тип NodePort.
Файл [Service-2.yaml](./Service-2.yaml)
```
---
apiVersion: v1
kind: Service
metadata:
  name: srv-2
spec:
  type: NodePort
  selector:
    app: dep-1
  ports:
    - name: nginx-http
      port: 9001
      targetPort: 80
```
2. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.
```
ser@k8s:~$ kubectl apply -f Service-2.yaml 
service/srv-2 created
user@k8s:~$ kubectl get service
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP          9d
srv-2        NodePort    10.152.183.237   <none>        9001:32459/TCP   9s
user@k8s:~$
```
```
user@k8s:~$ curl --silent -i localhost:32459 -I
HTTP/1.1 200 OK
Server: nginx/1.25.2
Date: Thu, 21 Sep 2023 12:53:57 GMT
Content-Type: text/html
Content-Length: 615
Last-Modified: Tue, 15 Aug 2023 17:03:04 GMT
Connection: keep-alive
ETag: "64dbafc8-267"
Accept-Ranges: bytes

user@k8s:~$
```
3. Предоставить манифест и Service в решении, а также скриншоты или вывод команды п.2.
