# Лабораторна робота 5 — Нормалізація бази даних

## Початкова схема
### ER-діаграма

![diagram](./old/DB_ERD.png)

### Список таблиць (оригінальні DDL)
Скопіюй сюди DDL, який був у лабораторній роботі 2 (або коротко переліч DDL для кожної таблиці).

```sql
CREATE TABLE IF NOT EXISTS Location (
loc_id SERIAL PRIMARY KEY,
address TEXT NOT NULL,
city TEXT NOT NULL,
is_open BOOL NOT NULL,
UNIQUE(address,city)
);

CREATE TABLE IF NOT EXISTS Document(
doc_id SERIAL PRIMARY KEY,
loc_id INT NOT NULL REFERENCES Location(loc_id) ON DELETE CASCADE,
title TEXT NOT NULL, 
issue_date DATE NOT NULL CHECK (issue_date <= CURRENT_DATE),
active_from DATE CHECK (active_from >= issue_date),
expire_date DATE CHECK (expire_date > active_from),
is_denied BOOLEAN NOT NULL DEFAULT false
);

CREATE TYPE pos_name AS ENUM ('бариста','прибиральник','адміністратор','кухар');

CREATE TABLE IF NOT EXISTS Employee(
emp_id SERIAL PRIMARY KEY,
loc_id INT NOT NULL REFERENCES Location(loc_id) ON DELETE CASCADE,
surname TEXT  NOT NULL, 
name_ TEXT  NOT NULL, 
birthday DATE NOT NULL CHECK (birthday <= CURRENT_DATE), 
shift TEXT NOT NULL, 
position_ pos_name,
salary INT NOT NULL CHECK (salary > 0), 
phone_number CHAR(13) NOT NULL CHECK (phone_number ~ '^\+380\d{9}$') UNIQUE,
UNIQUE(surname, name_, birthday, loc_id)
);

CREATE TABLE IF NOT EXISTS EmployeeDoc (
    doc_id INT NOT NULL REFERENCES Document(doc_id) ON DELETE CASCADE,
    emp_id INT NOT NULL REFERENCES Employee(emp_id) ON DELETE CASCADE,
    PRIMARY KEY (doc_id, emp_id)
);

CREATE TABLE IF NOT EXISTS Menu(
menu_id SERIAL PRIMARY KEY,
title VARCHAR(48) NOT NULL UNIQUE
); 

CREATE TABLE IF NOT EXISTS LocMenu (
    loc_id INT NOT NULL REFERENCES Location(loc_id) ON DELETE CASCADE,
    menu_id INT NOT NULL REFERENCES Menu(menu_id) ON DELETE CASCADE,
    PRIMARY KEY (loc_id, menu_id)
);

CREATE TABLE IF NOT EXISTS Item(
item_id SERIAL PRIMARY KEY,
menu_id INT NOT NULL REFERENCES Menu(menu_id) ON DELETE CASCADE,
title VARCHAR(48) NOT NULL UNIQUE, 
current_price NUMERIC(7,2) NOT NULL CHECK (current_price > 0),
recipe TEXT
);

CREATE TABLE IF NOT EXISTS SoldOnDay(
sold_id SERIAL PRIMARY KEY,
item_id INT REFERENCES Item(item_id) ON DELETE SET NULL,
item_title VARCHAR(48) NOT NULL, 
loc_address TEXT NOT NULL,
loc_city TEXT NOT NULL,
price NUMERIC(7,2) NOT NULL CHECK (price > 0),
amount SMALLINT NOT NULL CHECK (amount > 0), 
date_ DATE NOT NULL CHECK (date_ <= CURRENT_DATE) default CURRENT_DATE,
UNIQUE(item_title,loc_address,date_)
);

```

# Нормалізація

## 1NF

1. **Таблиця `Employee` порушує вимоги 1NF**, оскільки атрибут *shift* не є атомарним.  
   Для усунення цього порушення створено окрему таблицю `Shift` із такими атрибутами:  
   **emp_id**, **day_**, **start_time**, **end_time**.  
   Це дозволяє зберігати розклад роботи у коректній та нормалізованій формі.

2. Інші таблиці проєкту **відповідають вимогам 1NF**, оскільки всі їхні атрибути містять атомарні значення.

### ТАБЛИЦЯ:
```sql
CREATE TYPE pos_name AS ENUM ('бариста','прибиральник','адміністратор','кухар');

CREATE TABLE IF NOT EXISTS Employee(
emp_id SERIAL PRIMARY KEY,
loc_id INT NOT NULL REFERENCES Location(loc_id) ON DELETE CASCADE,
surname TEXT  NOT NULL, 
name_ TEXT  NOT NULL, 
birthday DATE NOT NULL CHECK (birthday <= CURRENT_DATE), 
shift TEXT NOT NULL, 
position_ pos_name,
salary INT NOT NULL CHECK (salary > 0), 
phone_number CHAR(13) NOT NULL CHECK (phone_number ~ '^\+380\d{9}$') UNIQUE,
UNIQUE(surname, name_, birthday, loc_id)
);
```

### ВИПРАВЛЕННЯ:
```sql
ALTER TABLE Employee
DROP COLUMN shift;

CREATE TYPE days AS ENUM ('пн','вт','ср','чт','пт','сб','нд');

CREATE TABLE IF NOT EXISTS Shift (
    shift_id SERIAL PRIMARY KEY,
    emp_id INT NOT NULL REFERENCES Employee(emp_id) ON DELETE CASCADE,
    day_ days NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL CHECK (start_time < end_time),
	UNIQUE(emp_id,day_)
);
```


---

## 2NF

Аналіз показав, що **жодна таблиця не порушує вимоги 2NF**.  
У всіх таблицях первинні ключі є або простими (один атрибут), або всі неключові атрибути повністю залежать від усього складеного первинного ключа.

---

## 3NF

1. **Таблиця `SoldOnDay` формально порушує вимоги 3NF**, оскільки дублює атрибути з таблиць `Item` та `Location` (наприклад: назви, ціни, типи тощо).

2. **Проте це не є помилкою**, оскільки така денормалізація використовується свідомо:  
   вона потрібна для виконання бізнес-вимоги — **зберігати дані про продажі навіть після видалення відповідного товару або локації**.

Таким чином, таблиця `SoldOnDay` є прикладом **denormalization by design**, і її структура змінюватись не буде.

---

## Функціональні залежності (ФЗ)

### Location
- `loc_id → address, city, is_open`
- `(address, city) → is_open, loc_id`

### Document
- `doc_id → loc_id, title, issue_date, active_from, expire_date, is_denied`

### Employee
- `emp_id → loc_id, surname, name_, birthday, position_, salary, phone_number`
- `phone_number → loc_id, surname, name_, birthday, position_, salary, emp_id`

### EmployeeDoc
- `(doc_id, emp_id)` — PK

### Shift
- `shift_id → emp_id, day_, start_time, end_time`
- `(emp_id, day_) → start_time, end_time, shift_id`

### Menu
- `menu_id → title`
- `title → menu_id`

### LocMenu
- `(loc_id, menu_id) → — PK`

### Item
- `item_id → menu_id, title, current_price, recipe`
- `title → menu_id, current_price, recipe, item_id`

### SoldOnDay
- `sold_id → item_id, loc_address, loc_city, price, amount, date_, item_id → item_title`

---

## Перероблений дизайн — DDL у 3NF

```sql
CREATE TABLE IF NOT EXISTS Location (
loc_id SERIAL PRIMARY KEY,
address TEXT NOT NULL,
city TEXT NOT NULL,
is_open BOOL NOT NULL,
UNIQUE(address,city)
);

INSERT INTO Location (address, city, is_open) VALUES
('Вул. Іво Бобула 14', 'Харків', true),
('Пр. Кевіна Холланда 5\б', 'Львів', true),
('Пл. Культури 10', 'Вінниця', false);

CREATE TABLE IF NOT EXISTS Document(
doc_id SERIAL PRIMARY KEY,
loc_id INT NOT NULL REFERENCES Location(loc_id) ON DELETE CASCADE,
title TEXT NOT NULL, 
issue_date DATE NOT NULL CHECK (issue_date <= CURRENT_DATE),
active_from DATE CHECK (active_from >= issue_date),
expire_date DATE CHECK (expire_date > active_from),
is_denied BOOLEAN NOT NULL DEFAULT false
);

INSERT INTO Document (loc_id, title, issue_date, active_from, expire_date) 
VALUES
(1,'Договір про оренду','2025-10-24' , '2025-11-24', '2026-11-01'),
(2,'Договір про оренду', '2025-10-24', '2025-11-24', '2026-11-01'),
(2,'Дозвіл на торгівлю', '2025-10-24', '2025-11-24', NULL),
(2,'Договір на працевлаштування', '2025-10-24', '2025-11-24', NULL),
(2,'Документ про зміну посади','2025-10-24', NULL, NULL);

CREATE TYPE pos_name AS ENUM ('бариста','прибиральник','адміністратор','кухар');

CREATE TABLE IF NOT EXISTS Employee(
emp_id SERIAL PRIMARY KEY,
loc_id INT NOT NULL REFERENCES Location(loc_id) ON DELETE CASCADE,
surname TEXT  NOT NULL, 
name_ TEXT  NOT NULL, 
birthday DATE NOT NULL CHECK (birthday <= CURRENT_DATE), 
position_ pos_name,
salary INT NOT NULL CHECK (salary > 0), 
phone_number CHAR(13) NOT NULL CHECK (phone_number ~ '^\+380\d{9}$') UNIQUE
);

INSERT INTO Employee (loc_id, surname, name_, birthday,position_, salary, phone_number)
VALUES
(1,'Ватолкін', 'Михайло', '2006-11-06','бариста',17000,'+380966555734'),
(2,'Михайлов', 'Антон', '2005-11-06','прибиральник',14000,'+380956757733'),
(3,'Антоненко', 'Андрій', '2006-11-04','адміністратор',20000,'+380931111711');

CREATE TYPE days AS ENUM ('пн','вт','ср','чт','пт','сб','нд');

CREATE TABLE IF NOT EXISTS Shift (
    shift_id SERIAL PRIMARY KEY,
    emp_id INT NOT NULL REFERENCES Employee(emp_id) ON DELETE CASCADE,
    day_ days NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL CHECK (start_time < end_time),
	UNIQUE(emp_id,day_)
);

INSERT INTO Shift (emp_id, day_, start_time, end_time) VALUES
(1, 'вт', '10:00', '18:00'),
(2, 'ср', '18:00', '22:00'),
(2, 'чт', '18:00', '22:00'),
(3, 'пт', '09:00', '17:00'),
(3, 'сб', '09:00', '17:00'),
(3, 'нд', '12:00', '20:00');


CREATE TABLE IF NOT EXISTS EmployeeDoc (
    doc_id INT NOT NULL REFERENCES Document(doc_id) ON DELETE CASCADE,
    emp_id INT NOT NULL REFERENCES Employee(emp_id) ON DELETE CASCADE,
    PRIMARY KEY (doc_id, emp_id)
);

INSERT INTO EmployeeDoc (emp_id, doc_id) 
VALUES
(1, 2),
(2, 2),
(3, 2),
(3, 3);

CREATE TABLE IF NOT EXISTS Menu(
menu_id SERIAL PRIMARY KEY,
title VARCHAR(48) NOT NULL UNIQUE
); 

INSERT INTO Menu (title) 
VALUES
('Сніданки'),
('Холодні напої'),
('Десерти'),
('Кава');

CREATE TABLE IF NOT EXISTS LocMenu (
    loc_id INT NOT NULL REFERENCES Location(loc_id) ON DELETE CASCADE,
    menu_id INT NOT NULL REFERENCES Menu(menu_id) ON DELETE CASCADE,
    PRIMARY KEY (loc_id, menu_id)
);

INSERT INTO LocMenu (loc_id, menu_id) 
VALUES
(1, 1),
(1, 2),
(1, 4),
(2, 2),
(2, 3),
(3, 1),
(3, 3);

CREATE TABLE IF NOT EXISTS Item(
item_id SERIAL PRIMARY KEY,
menu_id INT NOT NULL REFERENCES Menu(menu_id) ON DELETE CASCADE,
title VARCHAR(48) NOT NULL UNIQUE, 
current_price NUMERIC(7,2) NOT NULL CHECK (current_price > 0),
recipe TEXT
);

INSERT INTO Item (menu_id, title, current_price, recipe)
VALUES
(4, 'Еспресо', 45.00, '*рецепт*'),
(4, 'Американо', 50.00, '*рецепт*'),
(4, 'Капучино', 65.00, '*рецепт*'),
(4, 'Лате', 70.00, '*рецепт*'),
(2, 'Блю курасао', 65.00, '*рецепт*'),
(2, 'Піна-колада', 85.00, '*рецепт*');
INSERT INTO Item (menu_id, title, current_price)
VALUES
(3, 'Чізкейк', 95.00),
(3, 'Тірамісу', 105.00);

CREATE TABLE IF NOT EXISTS SoldOnDay(
sold_id SERIAL PRIMARY KEY,
item_id INT REFERENCES Item(item_id) ON DELETE SET NULL,
item_title VARCHAR(48) NOT NULL, 
loc_address TEXT NOT NULL,
loc_city TEXT NOT NULL,
price NUMERIC(7,2) NOT NULL CHECK (price > 0),
amount SMALLINT NOT NULL CHECK (amount > 0), 
date_ DATE NOT NULL CHECK (date_ <= CURRENT_DATE) default CURRENT_DATE,
);

INSERT INTO SoldOnDay (item_id, item_title, loc_address,loc_city, price, amount, date_) 
VALUES
(1, 'Еспресо', 'Вул. Іво Бобула 14', 'Харків', 45.00, 37, '2025-10-22'),
(2, 'Американо', 'Вул. Іво Бобула 14', 'Харків', 50.00, 28, '2025-10-22'),
(3, 'Капучино', 'Пр. Кевіна Холланда 5\б', 'Львів', 65.00, 41, '2025-10-22'),
(4, 'Лате', 'Вул. Іво Бобула 14', 'Харків', 70.00, 33, '2025-10-22'),
(5, 'Блю курасао', 'Пр. Кевіна Холланда 5\б', 'Львів', 165.00, 12, '2025-10-22'),
(6, 'Піна-колада', 'Пр. Кевіна Холланда 5\б', 'Львів', 185.00, 8, '2025-10-22'),
(7, 'Чізкейк', 'Пл. Культури 10', 'Вінниця', 95.00, 10, '2025-10-22'),
(8, 'Тірамісу', 'Пл. Культури 10', 'Вінниця', 105.00, 6, '2025-10-22');
```
