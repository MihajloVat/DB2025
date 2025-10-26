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

INSERT INTO Document (loc_id, title, issue_date, active_from, expire_date) VALUES
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
shift TEXT NOT NULL, 
position_ pos_name,
salary INT NOT NULL CHECK (salary > 0), 
phone_number CHAR(13) NOT NULL CHECK (phone_number ~ '^\+380\d{9}$') UNIQUE,
UNIQUE(surname, name_, birthday, loc_id)
);

INSERT INTO Employee (loc_id, surname, name_, birthday, shift,position_, salary, phone_number) VALUES
(1,'Ватолкін', 'Михайло', '2006-11-06','10:00 - 20:00, пн-ср','бариста',17000,'+380966555734'),
(2,'Михайлов', 'Антон', '2005-11-06','18:00 - 20:00, ср-пт','прибиральник',14000,'+380956757733'),
(3,'Антоненко', 'Андрій', '2006-11-04','10:00 - 20:00, пт-вт','адміністратор',20000,'+380931111711');

CREATE TABLE IF NOT EXISTS EmployeeDoc (
    doc_id INT NOT NULL REFERENCES Document(doc_id) ON DELETE CASCADE,
    emp_id INT NOT NULL REFERENCES Employee(emp_id) ON DELETE CASCADE,
    PRIMARY KEY (doc_id, emp_id)
);

INSERT INTO EmployeeDoc (emp_id, doc_id) VALUES
(1, 2),
(2, 2),
(3, 2),
(3, 3);

CREATE TABLE IF NOT EXISTS Menu(
menu_id SERIAL PRIMARY KEY,
title VARCHAR(48) NOT NULL UNIQUE
); 

INSERT INTO Menu (title) VALUES
('Сніданки'),
('Холодні напої'),
('Десерти'),
('Кава');

CREATE TABLE IF NOT EXISTS LocMenu (
    loc_id INT NOT NULL REFERENCES Location(loc_id) ON DELETE CASCADE,
    menu_id INT NOT NULL REFERENCES Menu(menu_id) ON DELETE CASCADE,
    PRIMARY KEY (loc_id, menu_id)
);

INSERT INTO LocMenu (loc_id, menu_id) VALUES
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
UNIQUE(item_title,loc_address,date_)
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




