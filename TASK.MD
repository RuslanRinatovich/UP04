# Текст образца задания:

---

## Модуль №1:

**Разработка, администрирование и защита баз данных**

**Вид аттестации/уровень ДЭ:**

**ПА, ГИА ДЭ БУ, ГИА ДЭ ПУ (инвариантная часть)**

_Текст задания:_

Выберите СУБД и среду для управления инфраструктурой.
Установите ядро выбранной СУБД и среду для управления
инфраструктурой SQL (на виртуальную машину или представленный
компьютер). При установке задайте имя сервера – «`Server_номер вашего
рабочего места`», например `Server_05`. У сервера должен быть включен режим
смешанной **аутентификации**.
Включите или создайте пользователя `sa`, установив пароль «`De_номер
вашего рабочего места`», например `De_05`.
Напишите скрипт, который позволит автоматически:

- создать 10 пользователей `user1`, `user2`, `user3`, ..., `user10`, у которых
пароль формируется случайным образом и содержит 5 символов (буквы,
цифры);
- базы данных `BD1`, `BD2`, `BD3`, ..., `BD10`;
- настроить права доступа пользователей к базам данных. Пользователь
`user1` имеет доступ только к базе данных `BD1`, `user2` имеет доступ только к базе
данных `BD2` и т. д.
- создать базу данных `BD` и таблицу `Users`, для хранения пользователей и их паролей;
- заполнить таблицу Users данными созданных пользователях и паролях.
- 
Хранение паролей в зашифрованном виде очень важно для безопасности доступа к серверу, поэтому создайте скрип,
который зашифрует все пароли в таблице `Users`.

Чтобы предотвратить утрату доступа к аккаунту и потерю данных создайте скрип, который позволит отобразить данные из таблицы `Users` c
расшифрованными паролями.

Напишите скрипт, который позволит провести резервное копирование базы данных `BD`. Необходимо предоставить скрипт и файл бэкапа.

Напишите скрипт, который позволит провести процедуру восстановления базы данных.

Необходимые приложения: нет

---

## Модуль №2:

**Разработка, администрирование и защита баз данных**

**Вид аттестации/уровень ДЭ:**

**ГИА ДЭ БУ, ГИА ДЭ ПУ (инвариантная часть)**

**Текст задания:** 

На основании описания брифинга и документов, представленных заказчиком, необходимо спроектировать ER-диаграмму для
информационной системы. Обязательна **3 нормальная форма** с обеспечением ссылочной целостности. При разработке диаграммы обратите внимание на
согласованную осмысленную схему именования, создайте необходимые
первичные и внешние ключи. ER - диаграмма должна быть представлена в
формате .pdf и содержать таблицы, связи между ними, атрибуты и ключи
(типами данных на данном этапе можно пренебречь). Создайте базу данных,
используя предпочтительную платформу, на сервере баз данных, который вам
предоставлен. Создайте таблицы основных сущностей, атрибуты, отношения.

Заполните созданные таблицы начальными тестовыми данными (не менее трех записей в каждую таблицу).

**Внимание! Данные из ресурсов импортировать не нужно.**

Создайте процедуру, которая вычисляет показатель для расчета эффективности работы гостиницы `ADR (Average Daily Rate)`. Показывает
среднюю стоимость номера за некий промежуток времени. Показатель
получается за счет деления чистой выручки от продаж номерного фонда
(после вычета скидок, косвенных налогов, стоимости завтраков и т.п.) на
общее количество проданных за рассматриваемый период номеров. Другими
словами, данный показатель равен отношению суммы продаж к числу ночей.

Создайте триггер, который при попытке бронирования будет проверять
наличие свободных номеров с выводом статуса `(SIGNAL SQLSTATE '45000')`.

Необходимые приложения: [Текст брифинга.pdf, Документы заказчика.zip.](Resources%20_090207-1-2025.zip)

---

## Модуль №3:

**Соадминистрирование баз данных и серверов**

**Вид аттестации/уровень ДЭ:**

**ГИА ДЭ БУ, ГИА ДЭ ПУ (инвариантная часть)**

_Текст задания:_ 

Напишите запросы к созданной базе данных и предоставьте их скрипты:
- Выведите список клиентов с указанием суммы к оплате, с учетом
проживания и всех используемых дополнительных услуг.
- Обновите у всех номеров со статусом `Назначен к уборке` на статус
`Чистый`.

Необходимые приложения: [Текст брифинга.pdf, Документы заказчика.zip.](Resources%20_090207-1-2025.zip)

---

## Модуль №4:

**Разработка модулей программного обеспечения для компьютерных систем**

**Вид аттестации/уровень ДЭ:**

**ГИА ДЭ ПУ (инвариантная часть)**

_Текст задания:_ 

Создайте модуль программного обеспечения, который
позволит анализировать информацию из созданной базы данных.
Макет окна представлен на рисунке.

![img.png](TASK4/img.png)

**_Рисунок – Макет окна работы с бронированием номеров_**

Подключите к приложению созданную базу данных и реализуйте следующий функционал:
- фильтрацию записей в таблице по указанному периоду. Пользователь указывает начало периода, конец периода
 и по нажатию кнопки «Фильтровать» должна происходить фильтрация данных в таблице, т. е.
отображаться бронирования, попадающие в указанный диапазон. По нажатию
на кнопку «Показать все» отменяется фильтрация записей;

- добавление данных в таблицу бронирование с возможностью указания
всех данных, определенных на этапе проектирования базы данных в модуле 2.
Интерфейс этого окна разработайте самостоятельно;
- удаление данных из таблицы бронирование.

При разработке модуля соблюдайте требования к разработке.
Используйте отладку и обрабатывайте исключительные ситуации,
чтобы избежать фатальных ошибок при работе приложения. Ваше приложение
не должно завершаться аварийно.
Необходимо так же разработать руководство пользователя для данного
модуля. Опишите последовательность действий для выполнения всех функций
модуля с использованием скриншотов.
Необходимые приложения: [Текст брифинга.pdf, Документы заказчика.zip, Требования к разработке.pdf](Resources%20_090207-1-2025.zip)