# Домашнее задание к занятию «Организация сети»

### Подготовка к выполнению задания

1. Домашнее задание состоит из обязательной части, которую нужно выполнить на провайдере Yandex Cloud, и дополнительной части в AWS (выполняется по желанию). 
2. Все домашние задания в блоке 15 связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
3. Все задания нужно выполнить с помощью Terraform. Результатом выполненного домашнего задания будет код в репозитории. 
4. Перед началом работы настройте доступ к облачным ресурсам из Terraform, используя материалы прошлых лекций и домашнее задание по теме «Облачные провайдеры и синтаксис Terraform». Заранее выберите регион (в случае AWS) и зону.

---
### Задание 1. Yandex Cloud 

**Что нужно сделать**

1. Создать пустую VPC. Выбрать зону.
2. Публичная подсеть.

 - Создать в VPC subnet с названием public, сетью 192.168.10.0/24.
 - Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1.
 - Создать в этой публичной подсети виртуалку с публичным IP, подключиться к ней и убедиться, что есть доступ к интернету.
3. Приватная подсеть.
 - Создать в VPC subnet с названием private, сетью 192.168.20.0/24.
 - Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс.
 - Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее, и убедиться, что есть доступ к интернету.

Resource Terraform для Yandex Cloud:

- [VPC subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet).
- [Route table](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_route_table).
- [Compute Instance](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance).

---

### Правила приёма работы

Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.


### Решение
Файлы terraform [тут](src/).

Проверяем код и запускаем создание ресурсов
```
alex@KRD-SO-20:~/netology-homework/Task 15-1/src$ terraform validate
Success! The configuration is valid.

alex@KRD-SO-20:~/netology-homework/Task 15-1/src$ terraform apply --auto-approve

------ВЫРЕЗАЛ ЧАСТЬ ВЫВОДА------------

Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_nat = "51.250.13.251"
external_ip_address_public = "158.160.125.143"
internal_ip_address_private = "192.168.20.23"
alex@KRD-SO-20:~/netology-homework/Task 15-1/src$
```

![task-15-1.PNG](https://github.com/AllexxB/netology-homework/blob/075213abe4119d77f35c4aa784803f1d88170813/pic/task-15-1.png)


Проверка созданных подсетей и инстансов
```
alex@KRD-SO-20:~/netology-homework/Task 15-1/src$ yc vpc network --name network-netology list-subnets
+----------------------+---------+----------------------+----------------------+----------------------+---------------+-------------------+
|          ID          |  NAME   |      FOLDER ID       |      NETWORK ID      |    ROUTE TABLE ID    |     ZONE      |       RANGE       |
+----------------------+---------+----------------------+----------------------+----------------------+---------------+-------------------+
| e9b1qvvp15nbu2c13soj | public  | b1g2g1prvm8gau6r00ap | enp2t2isc4i5lo0kthsd |                      | ru-central1-a | [192.168.10.0/24] |
| e9bkq15jbj33hseajvs7 | private | b1g2g1prvm8gau6r00ap | enp2t2isc4i5lo0kthsd | enp7l9760053de49fu0m | ru-central1-a | [192.168.20.0/24] |
+----------------------+---------+----------------------+----------------------+----------------------+---------------+-------------------+

alex@KRD-SO-20:~/netology-homework/Task 15-1/src$ yc compute instance list
+----------------------+------------------+---------------+---------+-----------------+----------------+
|          ID          |       NAME       |    ZONE ID    | STATUS  |   EXTERNAL IP   |  INTERNAL IP   |
+----------------------+------------------+---------------+---------+-----------------+----------------+
| fhm0a98ctkfe9lsq151u | private-instance | ru-central1-a | RUNNING |                 | 192.168.20.23  |
| fhma6lpmsg9saji68bbk | nat-instance     | ru-central1-a | RUNNING | 51.250.13.251   | 192.168.10.254 |
| fhmt8hjhj0s51q6qv5tr | public-instance  | ru-central1-a | RUNNING | 158.160.125.143 | 192.168.10.21  |
+----------------------+------------------+---------------+---------+-----------------+----------------+

alex@KRD-SO-20:~/netology-homework/Task 15-1/src$
```
Через public-instance попадаем на private-instance и проверяем выход в инет
```
user@private-instance:~$ ping -c 3 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=104 time=57.3 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=104 time=58.0 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=104 time=56.8 ms

--- 8.8.8.8 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 56.788/57.364/58.028/0.509 ms
```