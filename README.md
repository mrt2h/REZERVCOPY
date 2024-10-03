# Домашнее задание к занятию «Базы данных» - `Хасаншин Марат`

### Задание 1
Опишите не менее семи таблиц, из которых состоит база данных:
- какие данные хранятся в этих таблицах;
- какой тип данных у столбцов в этих таблицах, если данные хранятся в PostgreSQL.

Приведите решение к следующему виду:
Сотрудники (
- идентификатор, первичный ключ, serial,
- фамилия varchar(50),
- ...
- идентификатор структурного подразделения, внешний ключ, integer).
---

### Ответ 1
#### Какие данные хранятся в этих таблицах :

* фио  - фамилия имя и отчество сотрудника 
* ОКЛАД  - заработная плата сотрудника
* должность  - Занимаемая должность сотрудника
* Тип подразделения - отдел в котором работает сотрудник
* Дата - дата найма сотрудника
* Адрес - местонахождение филиала
* Проэкт - наименование проэкта для конкретного сотрудника.
---

 #### Какой тип данных у столбцов в этих таблицах, если данные хранятся в PostgreSQL.

* фио  -  строковый (varchar)
* ОКЛАД  - числовой (decimal/numeric)
* должность  - строковый (varchar)
* Тип подразделения - строковый (varchar)
* Дата - дата и время (tinyint)
* Адрес - местонахождение филиала (varchar)
* Проэкт - строковый (varchar)
---

 #### Приведите решение к следующему виду:

employees (
- id_employee, int, not null, auto_increment, primary_key
- last_name, varchar(50), not null
- first_name, varchar(50), not null
- surname, varchar(50)
- rank, foreign_key
- salary, foreign_key
- subdivision, foreign_key
- office, foreign_key
- project, foreign_key
- hired_since, date, not null
)
---

subdivisions (
- id_subdivision, int, not null, auto_increment, primary_key
- subdivision, varchar(100), not null
- type_of_subdivision, foreign_key
- office, foreign_key
)
---

type_of_subdivision (
- id_of_type, int, not null, auto_increment, primary_key
- type
)
---

offices (
- id_office, int, not null, auto_increment, primary_key
- office, varchar(200), not null
)
---

projects (
- id_project, int, not null, auto_increment, primary_key
- project, varchar(100), not null
)
---

ranks (
- id_rank, int, not null, auto_increment, primary_key
- rank, varchar(100), not null
)
---

salary (
- id_salary, int, not null, auto_increment, primary_key
- salary, real, not null
)
---
