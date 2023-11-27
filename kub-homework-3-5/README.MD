# Домашнее задание к занятию Troubleshooting

### Цель задания

Устранить неисправности при деплое приложения.

### Чеклист готовности к домашнему заданию

1. Кластер K8s.

### Задание. При деплое приложение web-consumer не может подключиться к auth-db. Необходимо это исправить

1. Установить приложение по команде:
```shell
kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
```
2. Выявить проблему и описать.
3. Исправить проблему, описать, что сделано.
4. Продемонстрировать, что проблема решена.


### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.


```
user@master:~$ kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "web" not found
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "data" not found
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "data" not found
user@master:~$ kubectl get pods
No resources found in default namespace.
user@master:~$ kubectl create namespace web
namespace/web created
user@master:~$ kubectl create namespace data
namespace/data created
user@master:~$ kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
deployment.apps/web-consumer created
deployment.apps/auth-db created
service/auth-db created
user@master:~$
```

### Проблема
```
user@master:~$ kubectl get po -n data
NAME                       READY   STATUS    RESTARTS   AGE
auth-db-7b5cdbdc77-xkm2q   1/1     Running   0          2m22s
user@master:~$ kubectl get po -n web
NAME                            READY   STATUS    RESTARTS   AGE
web-consumer-5f87765478-8mf9b   1/1     Running   0          2m24s
web-consumer-5f87765478-dg2l5   1/1     Running   0          2m24s
user@master:~$ kubectl logs -n data auth-db-7b5cdbdc77-xkm2q
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
user@master:~$ kubectl logs -n web web-consumer-5f87765478-8mf9b
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
```
### Т.к. поды в разных ns, то связности по именам у них нет, для этого в деплойменте необходимо указать полное имя сервиса, тогда проблема будет решена.

```
 spec:
      containers:
      - command:
        - sh
        - -c
        - while true; do curl auth-db.data.svc.cluster.local; sleep 5; done
```

```
user@master:~$ kubectl edit -n web deployments.apps web-consumer
deployment.apps/web-consumer edited
user@master:~$
user@master:~$ kubectl get po -n web
NAME                            READY   STATUS        RESTARTS   AGE
web-consumer-5f87765478-8mf9b   1/1     Terminating   0          23m
web-consumer-5f87765478-dg2l5   1/1     Terminating   0          23m
web-consumer-6fb89747cf-b59s2   1/1     Running       0          14s
web-consumer-6fb89747cf-d7hj9   1/1     Running       0          16s
user@master:~$ kubectl logs -n web web-consumer-6fb89747cf-b59s2
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0  91616      0 --:--:-- --:--:-- --:--:--  597k
<!DOCTYPE html>
<html>
<head>
```