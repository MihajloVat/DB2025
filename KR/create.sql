CREATE TABLE IF NOT EXISTS Projects(
    proj_id SERIAL PRIMARY KEY,
    title VARCHAR (32) NOT NULL,
    descr TEXT,
    s_date DATE DEFAULT CURRENT_DATE, --гадаю, точна дата початку не обов'язкова
    dline TIMESTAMP --а от дедлайну обов'язкова--
);

CREATE TYPE statuses AS ENUM ('active','done','canceled');

CREATE TABLE IF NOT EXISTS Tasks(
    task_id SERIAL PRIMARY KEY,
    proj_id INT NOT NULL REFERENCES Projects(proj_id) ON DELETE CASCADE,
    title VARCHAR (32) NOT NULL,
    descr TEXT,
    prio SMALLINT CHECK (prio >= 0),
    dline TIMESTAMP, --
    stat statuses
);

CREATE TABLE IF NOT EXISTS Users(
    user_id SERIAL PRIMARY KEY,
    team_role VARCHAR(32) NOT NULL,
    fullname TEXT NOT NULL,
    email TEXT CHECK (email LIKE '%@%.%')
);

CREATE TABLE IF NOT EXISTS Assignment(
    user_id INT NOT NULL REFERENCES Users(user_id) ON DELETE CASCADE,
    task_id INT NOT NULL REFERENCES Tasks(task_id) ON DELETE CASCADE,
    PRIMARY KEY(user_id,task_id)
);

CREATE TABLE IF NOT EXISTS Comments(
    comm_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES Users(user_id) ON DELETE CASCADE,
    task_id INT NOT NULL REFERENCES Tasks(task_id) ON DELETE CASCADE,
    comm TEXT NOT NULL,
    tstamp TIMESTAMP DEFAULT NOW() --
);