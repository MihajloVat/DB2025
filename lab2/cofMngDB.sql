CREATE TABLE IF NOT EXISTS Location (
loc_id SERIAL PRIMARY KEY,
address TEXT NOT NULL, 
is_open BOOL NOT NULL,
);

CREATE TABLE IF NOT EXISTS Document(
doc_id SERIAL,
loc_id INT NOT NULL REFERENCES Location(loc_id) ON DELETE CASCADE,--NOT NULL?
title TEXT NOT NULL, 
issue_date DATE,
active_from DATE,
expire_date DATE,
is_denied BOOLEAN NOT NULL DEFAULT false,
PRIMARY KEY(doc_id)
);

CREATE TYPE pos_name AS ENUM ('бариста','прибиральник','адміністратор','кухар');

CREATE TABLE IF NOT EXISTS Employee(
emp_id SERIAL PRIMARY KEY,
loc_id INT NOT NULL REFERENCES Location(loc_id) ON DELETE CASCADE,--NOT NULL?
surname VARCHAR(48)  NOT NULL, 
name_ VARCHAR(32)  NOT NULL, 
birthday DATE NOT NULL, 
shift TEXT NOT NULL, 
position_ pos_name,
salary INT NOT NULL CHECK (salary > 0), 
phone_number CHAR(13) NOT NULL CHECK (phone_number ~ '^\+380\d{9}$')
);

CREATE TABLE IF NOT EXISTS EmployeeDoc(
doc_id INT NOT NULL, 
emp_id INT NOT NULL, 

FOREIGN KEY (doc_id)
 REFERENCES Document(doc_id) ON DELETE CASCADE,
 
FOREIGN KEY (emp_id)
 REFERENCES Employee(emp_id) ON DELETE CASCADE,
 
PRIMARY KEY(doc_id ,emp_id) 
);

CREATE TABLE IF NOT EXISTS Menu(
menu_id SERIAL PRIMARY KEY,
title VARCHAR(32) NOT NULL 
); 

CREATE TABLE IF NOT EXISTS Item(
item_id SERIAL PRIMARY KEY,
menu_id INT NOT NULL REFERENCES Menu(menu_id) ON DELETE CASCADE --NOT NULL?
title VARCHAR(32) NOT NULL, 
current_price DECIMAL NOT NULL,
recipe TEXT 
);

CREATE TABLE IF NOT EXISTS SoldOnDay(
sold_id SERIAL,
item_title VARCHAR(32), 
item_id INT REFERENCES Item(item_id) ON DELETE SET NULL --NOT NULL?
date DATE NOT NULL,
price DECIMAL NOT NULL,
amount SMALLINT NOT NULL CHECK (amount >= 0), 
PRIMARY KEY(sold_id,item_title)
);

--НЕ ЗАБУДЬ ФОРЕЙНИ!
--ПОДУМАЙ ПРО ЮНІК, ЧЕКИ І ДЕФОЛТИ
--Перевірити зв'язки

--EXEMPLES OF CONTENT



