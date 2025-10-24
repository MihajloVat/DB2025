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
 REFERENCES Document(title,loc_address) ON DELETE CASCADE
FOREIGN KEY (full_name)
 REFERENCES Employee(full_name) ON DELETE CASCADE
PRIMARY KEY(doc_title,loc_address,full_name) --think of style and ON CASCADE
);--does it makes any sense?

CREATE TABLE IF NOT EXISTS Menu(
title TEXT PRIMARY KEY NOT NULL --think of TEXT
);

CREATE TABLE IF NOT EXISTS Item(
title TEXT PRIMARY KEY NOT NULL, --think of TEXT
current_price DECIMAL NOT NULL,
recipe TEXT --think of TYPE
);

CREATE TABLE IF NOT EXISTS SoldOnDay(
date DATE NOT NULL,
item_title TEXT REFERENCES Item(title) ON DELETE CASCADE, --think of type,ON DELETE,NOT NULL?
price DECIMAL NOT NULL,
amount SMALLINT NOT NULL, --think of TYPE
PRIMARY KEY(date,item_title)
);