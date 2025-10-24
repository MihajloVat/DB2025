CREATE TABLE IF NOT EXISTS Location (
address TEXT PRIMARY KEY NOT NULL, --think of TEXT
is_open BOOL NOT NULL,
profit DECIMAL NOT NULL, --derived 
staff_count SMALLINT NOT NULL --derived 
);

CREATE TABLE IF NOT EXISTS Document(
title TEXT NOT NULL, --think of TEXT
loc_address TEXT REFERENCES Location(address) ON DELETE CASCADE, --think of TEXT,NOT NULL,CASCADE?
issue_date DATE,
expire_date DATE,
is_active_m BOOLEAN, --think of m|d
PRIMARY KEY(title,loc_address)
);

CREATE TABLE IF NOT EXISTS Employee(
full_name TEXT PRIMARY KEY NOT NULL, --think of TEXT
age SMALLINT NOT NULL, --think if CHECK
shift TEXT NOT NULL, --think of TYPE
position_ TEXT NOT NULL, --think of naming, enum, think of TYPE
salary INT NOT NULL, --think of TYPE
phone_number TEXT NOT NULL --think of TYPE and blueprint
);

CREATE TABLE IF NOT EXISTS EmployeeDoc(
doc_title TEXT NOT NULL, --think of type?
loc_address TEXT NOT NULL, --think of type?
full_name TEXT NOT NULL, --think of type?
FOREIGN KEY (doc_title,loc_address)
 REFERENCES Document(title,loc_address) ON DELETE CASCADE,
FOREIGN KEY (full_name)
 REFERENCES Employee(full_name) ON DELETE CASCADE,
PRIMARY KEY(doc_title,loc_address,full_name) --think of style and ON CASCADE
);

CREATE TABLE IF NOT EXISTS Menu(
title TEXT PRIMARY KEY NOT NULL --think of TEXT
); --does it make any sense?

CREATE TABLE IF NOT EXISTS Item(
title TEXT PRIMARY KEY NOT NULL, --think of TEXT
current_price DECIMAL NOT NULL,
recipe TEXT --think of TYPE
);

CREATE TABLE IF NOT EXISTS SoldOnDay(
date DATE NOT NULL,
item_title TEXT NOT NULL, --think of type?
price DECIMAL NOT NULL,
amount SMALLINT NOT NULL, --think of TYPE
PRIMARY KEY(date,item_title)
);

--НЕ ЗАБУДЬ ФОРЕЙНИ!

--EXEMPLES OF CONTENT

--location
INSERT INTO Location 
VALUES
('Вул. Іво Бобула 14',true, 10000,3),
('Пр. Кевіна Холланда 5\б',true, 30000,3),
('Пл. Культури 10',false, 300,2)
ON CONFLICT (address) DO NOTHING;

--document
INSERT INTO Document 
VALUES
('Договір про оренду', 'Вул. Іво Бобула 14', '2025-10-24', '2026-11-01', true),
('Договір про оренду', 'Пр. Кевіна Холланда 5\б', '2025-10-24', '2026-11-01', true),
('Дозвіл на торгівлю', 'Пр. Кевіна Холланда 5\б', '2025-10-24', NULL, true),
('Договір на працевлаштування', 'Пр. Кевіна Холланда 5\б', '2025-10-24', NULL, true),
('Документ про зміну посади','Пр. Кевіна Холланда 5\б', '2025-11-24', NULL, true)
ON CONFLICT (title,loc_address) DO NOTHING;

--employee
INSERT INTO Employee
VALUES
('Ватолкін Михайло',18,'10:00 - 20:00','бариста',17000,'+380966555734'),
('Михайлов Антон',23,'18:00 - 20:00','прибиральник',14000,'+380956757733'),
('Антоненко Андрій',25,'10:00 - 20:00','адміністратор',20000,'+380931111711')
ON CONFLICT (full_name) DO NOTHING;

--employeeDoc
INSERT INTO EmployeeDoc 
VALUES
('Договір на працевлаштування','Пр. Кевіна Холланда 5\б', 'Ватолкін Михайло'),
('Договір на працевлаштування','Пр. Кевіна Холланда 5\б', 'Михайлов Антон'),
('Договір на працевлаштування','Пр. Кевіна Холланда 5\б', 'Антоненко Андрій'),
('Документ про зміну посади','Пр. Кевіна Холланда 5\б', 'Антоненко Андрій')
ON CONFLICT (doc_title,loc_address,full_name) DO NOTHING;

--menu
INSERT INTO Menu
VALUES
('Холодні напої'),
('Кава'),
('Солодощі')
ON CONFLICT (title) DO NOTHING;

--item
INSERT INTO Item 
VALUES
('Капучино',50,'*рецепт капучино*'),
('Піна-колада',70,'*рецепт піни-колади*'),
('Тістечко шоколадне', 50, NULL)
ON CONFLICT (title) DO NOTHING;

INSERT INTO SoldOnDay
VALUES
('2025-10-24','Капучино', 50, 104),
('2025-10-24','Піна-колада', 70, 43),
('2025-10-24','Тістечко шоколадне',50, 20)
ON CONFLICT (date,item_title) DO NOTHING 


