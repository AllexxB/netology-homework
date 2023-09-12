

### Задание 1. Создать Pod с именем hello-world

1. Создать манифест (yaml-конфигурацию) Pod.
2. Использовать image - gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
3. Подключиться локально к Pod с помощью `kubectl port-forward` и вывести значение (curl или в браузере).

Манифест файл - [pod1.yaml](./pod1.yaml)

![image](https://github.com/AllexxB/netology-homework/blob/7faf746a63ddf85b001b31284711482192e93644/pic/kuber2-1.png)

![image](https://github.com/AllexxB/netology-homework/blob/7faf746a63ddf85b001b31284711482192e93644/pic/kuber2-2.png)

![image](https://github.com/AllexxB/netology-homework/blob/7faf746a63ddf85b001b31284711482192e93644/pic/kuber2-3.png)
------

### Задание 2. Создать Service и подключить его к Pod

1. Создать Pod с именем netology-web.
2. Использовать image — gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
3. Создать Service с именем netology-svc и подключить к netology-web.
4. Подключиться локально к Service с помощью `kubectl port-forward` и вывести значение (curl или в браузере).


Манифест файл - [service.yaml](./service.yaml)

![image](https://github.com/AllexxB/netology-homework/blob/7faf746a63ddf85b001b31284711482192e93644/pic/kuber2-4.png)

![image](https://github.com/AllexxB/netology-homework/blob/7faf746a63ddf85b001b31284711482192e93644/pic/kuber2-5.png)

![image](https://github.com/AllexxB/netology-homework/blob/7faf746a63ddf85b001b31284711482192e93644/pic/kuber2-6.png)
------

