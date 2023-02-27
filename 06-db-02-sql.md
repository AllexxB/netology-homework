# Домашнее задание к занятию "2. SQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/blob/virt-11/additional/README.md).

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.


### sudo docker run -d  --name postgres-12 -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e PGDATA=/var/lib/postgresql/data/pgdata -v ~/homework/SQL/pgdata:/var/lib/postgresql/data -v ~/homework/SQL/pgbackup:/var/lib/postgresql/data/backup postgres:12
## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

```shell
postgres=# \l
                                    List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |      Access privileges
-----------+----------+----------+------------+------------+------------------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                 +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                 +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/postgres                +
           |          |          |            |            | postgres=CTc/postgres       +
           |          |          |            |            | test_admin_user=CTc/postgres
(4 rows)

postgres=#
```

``` shell
postgres=# \d clients
                                         Table "public.clients"
      Column       |          Type          | Collation | Nullable |               Default
-------------------+------------------------+-----------+----------+-------------------------------------
 id                | integer                |           | not null | nextval('clients_id_seq'::regclass)
 фамилия           | character varying(100) |           |          |
 страна_проживания | character varying(100) |           |          |
 заказ             | integer                |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

postgres=#

```
``` shell
postgres=# \d orders
                                       Table "public.orders"
    Column    |          Type          | Collation | Nullable |              Default
--------------+------------------------+-----------+----------+------------------------------------
 id           | integer                |           | not null | nextval('orders_id_seq'::regclass)
 наименование | character varying(100) |           |          |
 цена         | integer                |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

postgres=#
```

```shell
postgres=# SELECT * from information_schema.table_privileges WHERE grantee = 'test_simple_user' LIMIT 10;
 grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 postgres | test_simple_user | postgres      | public       | clients    | INSERT         | NO           | NO
 postgres | test_simple_user | postgres      | public       | clients    | SELECT         | NO           | YES
 postgres | test_simple_user | postgres      | public       | clients    | UPDATE         | NO           | NO
 postgres | test_simple_user | postgres      | public       | clients    | DELETE         | NO           | NO
 postgres | test_simple_user | postgres      | public       | orders     | INSERT         | NO           | NO
 postgres | test_simple_user | postgres      | public       | orders     | SELECT         | NO           | YES
 postgres | test_simple_user | postgres      | public       | orders     | UPDATE         | NO           | NO
 postgres | test_simple_user | postgres      | public       | orders     | DELETE         | NO           | NO
(8 rows)

postgres=# SELECT * from information_schema.table_privileges WHERE grantee = 'test_admin_user' LIMIT 20;
 grantor  |     grantee     | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
----------+-----------------+---------------+--------------+------------+----------------+--------------+----------------
 postgres | test_admin_user | postgres      | public       | clients    | INSERT         | NO           | NO
 postgres | test_admin_user | postgres      | public       | clients    | SELECT         | NO           | YES
 postgres | test_admin_user | postgres      | public       | clients    | UPDATE         | NO           | NO
 postgres | test_admin_user | postgres      | public       | clients    | DELETE         | NO           | NO
 postgres | test_admin_user | postgres      | public       | clients    | TRUNCATE       | NO           | NO
 postgres | test_admin_user | postgres      | public       | clients    | REFERENCES     | NO           | NO
 postgres | test_admin_user | postgres      | public       | clients    | TRIGGER        | NO           | NO
 postgres | test_admin_user | postgres      | public       | orders     | INSERT         | NO           | NO
 postgres | test_admin_user | postgres      | public       | orders     | SELECT         | NO           | YES
 postgres | test_admin_user | postgres      | public       | orders     | UPDATE         | NO           | NO
 postgres | test_admin_user | postgres      | public       | orders     | DELETE         | NO           | NO
 postgres | test_admin_user | postgres      | public       | orders     | TRUNCATE       | NO           | NO
 postgres | test_admin_user | postgres      | public       | orders     | REFERENCES     | NO           | NO
 postgres | test_admin_user | postgres      | public       | orders     | TRIGGER        | NO           | NO
(14 rows)

postgres=#
```
## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.
```shell
postgres=# insert into orders (наименование, цена) values ('Шоколад', '10'), ('Принтер', '3000'), ('Книга', '500'), ('Монитор', '7000'), ('Гитара', '4000');
INSERT 0 5
```
```shell
postgres=# insert into clients (фамилия, страна_проживания) values ('Иванов Иван Иванович', 'USA'), ('Петров Петр Петрович', 'Canada'), ('Иоганн Себастьян Бах', 'Japan'), ('Ронни Джеймс Дио', 'Russia'), ('Ritchie Blackmore', 'Russia');
INSERT 0 5
```
```shell
postgres=# select * from orders;
 id | наименование | цена 
----+--------------+------
  1 | Шоколад      |   10
  2 | Принтер      | 3000
  3 | Книга        |  500
  4 | Монитор      | 7000
  5 | Гитара       | 4000
(5 rows)

postgres=# select * from clients;
 id |       фамилия        | страна_проживания | заказ 
----+----------------------+-------------------+-------
  1 | Иванов Иван Иванович | USA               |
  2 | Петров Петр Петрович | Canada            |
  3 | Иоганн Себастьян Бах | Japan             |
  4 | Ронни Джеймс Дио     | Russia            |
  5 | Ritchie Blackmore    | Russia            |
(5 rows)
```
```shell
postgres=# select count(id) from orders;
 count 
-------
     5
(1 row)

postgres=# select count(id) from clients;
 count 
-------
     5
(1 row)
```
## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказк - используйте директиву `UPDATE`.
```shell
postgres=# update clients set заказ=3 where фамилия='Иванов Иван Иванович';
UPDATE 1
postgres=# update clients set заказ=4 where фамилия='Петров Петр Петрович';
UPDATE 1
postgres=# update clients set заказ=5 where фамилия='Иоганн Себастьян Бах';
UPDATE 1
postgres=# select фамилия, наименование from clients, orders where заказ=orders.id;
       фамилия        | наименование 
----------------------+--------------
 Иванов Иван Иванович | Книга
 Петров Петр Петрович | Монитор
 Иоганн Себастьян Бах | Гитара
(3 rows)

postgres=#
```
## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
