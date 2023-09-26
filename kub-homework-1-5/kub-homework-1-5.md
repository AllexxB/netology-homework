# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 2»

### Цель задания

В тестовой среде Kubernetes необходимо обеспечить доступ к двум приложениям снаружи кластера по разным путям.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://microk8s.io/docs/getting-started) по установке MicroK8S.
2. [Описание](https://kubernetes.io/docs/concepts/services-networking/service/) Service.
3. [Описание](https://kubernetes.io/docs/concepts/services-networking/ingress/) Ingress.
4. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment приложений backend и frontend

1. Создать Deployment приложения _frontend_ из образа nginx с количеством реплик 3 шт.

Файл [frontend.yaml](./frontend.yaml)
```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  labels:
    app: frontend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
        - name: nginx
          image: nginx

```
2. Создать Deployment приложения _backend_ из образа multitool. 
Файл [backend.yaml](./backend.yaml)
```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  labels:
    app: backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
        - name: multitool
          image: wbitt/network-multitool
          

```
3. Добавить Service, которые обеспечат доступ к обоим приложениям внутри кластера.
Файл [service-front.yaml](./service-front.yaml)
```
---
apiVersion: v1
kind: Service
metadata:
  name: service-front
spec:
  selector:
    app: frontend
  ports:
    - name: nginx-http
      port: 80
      targetPort: 80
``` 
Файл [service-back.yaml](./service-back.yaml)
```
---
apiVersion: v1
kind: Service
metadata:
  name: service-back
spec:
  selector:
    app: backend
  ports:
    - name: multitool-http
      port: 80
      targetPort: 80
    

```
4. Продемонстрировать, что приложения видят друг друга с помощью Service.
```
user@k8s:~$ kubectl get po
NAME                        READY   STATUS    RESTARTS   AGE
backend-6c666c55f-jfdb6     1/1     Running   0          28s
frontend-54d8796d8c-4lrlf   1/1     Running   0          23s
frontend-54d8796d8c-j2fj4   1/1     Running   0          23s
frontend-54d8796d8c-sgqdx   1/1     Running   0          23s
user@k8s:~$ kubectl get service
NAME            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
kubernetes      ClusterIP   10.152.183.1     <none>        443/TCP   14d
service-front   ClusterIP   10.152.183.18    <none>        80/TCP    27s
service-back    ClusterIP   10.152.183.216   <none>        80/TCP    22s
user@k8s:~$ 
user@k8s:~$ 
user@k8s:~$ kubectl exec backend-6c666c55f-jfdb6 -- curl --silent -i service-front -I
HTTP/1.1 200 OK
Server: nginx/1.25.2
Date: Tue, 26 Sep 2023 08:09:11 GMT
Content-Type: text/html
Content-Length: 615
Last-Modified: Tue, 15 Aug 2023 17:03:04 GMT
Connection: keep-alive
ETag: "64dbafc8-267"
Accept-Ranges: bytes

user@k8s:~$ kubectl exec frontend-54d8796d8c-4lrlf -- curl --silent -i service-back -I
HTTP/1.1 200 OK
Server: nginx/1.24.0
Date: Tue, 26 Sep 2023 08:10:04 GMT
Content-Type: text/html
Content-Length: 138
Last-Modified: Tue, 26 Sep 2023 08:04:49 GMT
Connection: keep-alive
ETag: "651290a1-8a"
Accept-Ranges: bytes

user@k8s:~$ 
```
5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

------

### Задание 2. Создать Ingress и обеспечить доступ к приложениям снаружи кластера

1. Включить Ingress-controller в MicroK8S.
2. Создать Ingress, обеспечивающий доступ снаружи по IP-адресу кластера MicroK8S так, чтобы при запросе только по адресу открывался _frontend_ а при добавлении /api - _backend_.

Файл [ingress.yaml](./ingress.yaml)
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-test
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: service-front
            port:
              number: 80
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: service-back
            port:
              number: 80

```
3. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.

```
user@k8s:~$ kubectl get ingress
NAME           CLASS    HOSTS         ADDRESS     PORTS   AGE
ingress-test   public   example.com   127.0.0.1   80      70m
user@k8s:~$ curl 127.0.0.1  -H "HOST: example.com"
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
user@k8s:~$ curl 127.0.0.1  -H "HOST: example.com/api"
<html>
<head><title>400 Bad Request</title></head>
<body>
<center><h1>400 Bad Request</h1></center>
<hr><center>nginx</center>
</body>
</html>
user@k8s:~$
```
4. Предоставить манифесты и скриншоты или вывод команды п.2.

------

### Правила приема работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------
