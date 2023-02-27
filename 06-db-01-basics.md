

## Задача 1

Архитектор ПО решил проконсультироваться у вас, какой тип БД 
лучше выбрать для хранения определенных данных.

Он вам предоставил следующие типы сущностей, которые нужно будет хранить в БД:

- Электронные чеки в json виде
 
 *нужно использовать документоориентированнуб БД MongoDB*
- Склады и автомобильные дороги для логистической компании
 
 *в виду известности данны можно использовать реляционные БД как пример mySQL*
- Генеалогические деревья
 
 *графовая БД - OrientDB, Neo4j.*
- Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации
 
 *нужно использовать БД типа ключ-значение. Пример Redis* 
- Отношения клиент-покупка для интернет-магазина

 *MongoDB*

Выберите подходящие типы СУБД для каждой сущности и объясните свой выбор.

## Задача 2

Вы создали распределенное высоконагруженное приложение и хотите классифицировать его согласно 
CAP-теореме. Какой классификации по CAP-теореме соответствует ваша система, если 
(каждый пункт - это отдельная реализация вашей системы и для каждого пункта надо привести классификацию):

- Данные записываются на все узлы с задержкой до часа (асинхронная запись)

 *AC (PA\EC)*
- При сетевых сбоях, система может разделиться на 2 раздельных кластера

 *AP (PA\EL)*
- Система может не прислать корректный ответ или сбросить соединение

 *CP (PC\EC)*
 
А согласно PACELC-теореме, как бы вы классифицировали данные реализации?

## Задача 3

Могут ли в одной системе сочетаться принципы BASE и ACID? Почему?

 *Не могут. BASE - это противопоставление ACID. ACID гарантирует консистентность данных после транзакции, BASE допускает возврат неверных данных.*
## Задача 4

Вам дали задачу написать системное решение, основой которого бы послужили:

- фиксация некоторых значений с временем жизни
- реакция на истечение таймаута

Вы слышали о key-value хранилище, которое имеет механизм Pub/Sub. 
Что это за система? 

*Основным предсатвителем данной системы является redis.*
 
Какие минусы выбора данной системы?

 *Redis хранит данные в памяти и копирует на жесткий диск. Может получится так, что при отказе Redis какие-то данные могут не успеть оказаться на носителе и они не восстановятся при восстановлении самого Redis, так мы можем потерять данные.*
 ### Время жизни сообщений возможно тоже может являться минусом данной системы, т.к. в pub/sub нет прямой связи между издателем и подписчиком и это может привести при не штатной ситуации к потери сообщения для подписчика. 


