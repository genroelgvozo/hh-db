CREATE DATABASE hhschool;

CREATE SCHEMA genro;

SET SEARCH_PATH = genro;

CREATE TYPE FIO AS (
    first_name  TEXT,
    second_name TEXT,
    patronymic  TEXT
);

CREATE TABLE users (
    user_id    SERIAL PRIMARY KEY, -- id пользователя
    email      VARCHAR(254) NOT NULL, -- email
    pwd        TEXT         NOT NULL, -- пароль (хеш офкорс)
    time_reg   TIMESTAMP    NOT NULL, -- время регистрации
    time_login TIMESTAMP, -- время последнего захода на сайт
    name       FIO, -- фио для резюме
    birthday   DATE -- дата рождения для вычисления возраста
);

CREATE UNIQUE INDEX email_index
    ON users (email);

CREATE TABLE vacancies (
    vacancy_id   SERIAL PRIMARY KEY, -- id вакансии
    company_name TEXT      NOT NULL, -- название компании
    lang         REGCONFIG NOT NULL, -- язык вакансии, для конфигурации полнотекстового поиска
    position     TEXT      NOT NULL, -- название должности
    description  TEXT, -- описание вакансии
    salary_min   INT, -- минимальная з/п
    salary_max   INT, -- максимальная з/п
    experience   INT, -- требуемый опыт работы в мес.
    skills       TEXT ARRAY, -- список требуемых скилов
    time_create  TIMESTAMP NOT NULL, -- время создания вакансии
    time_delete  TIMESTAMP -- время окончания публиикации вакансии
);

CREATE INDEX vacancies_index
    ON vacancies USING GIN (to_tsvector(lang, position || ' ' || description));

CREATE INDEX experience_index
    ON vacancies (experience); -- частый поиск с применением операций сравнения, для чего B-деревья и нужны

CREATE INDEX salary_index
    ON vacancies (salary_min, salary_max); -- чаще все таки ищут по минимальной зарплате, но можно и по обоим границам


CREATE TABLE summaries (
    summary_id SERIAL PRIMARY KEY, -- id резюме
    user_id    INT REFERENCES users, -- создатель резюме, оттуда брать ФИО, возраст
    salary_min INT, -- минимальная з/п
    salary_max INT, -- максимальная з/п
    experience INT, -- опыт работы в мес.
    skills     TEXT ARRAY -- список скилов
);

CREATE INDEX user_experience_index
    ON summaries (experience); -- частый поиск с применением операций сравнения, для чего B-деревья и нужны

CREATE TABLE responses (
    response_id SERIAL PRIMARY KEY, -- id отклика
    vacancy_id  INT REFERENCES vacancies, -- id компании
    summary_id  INT REFERENCES summaries -- id резюме
);

CREATE TABLE messages (
    messsage_id SERIAL PRIMARY KEY, -- id message
    response_id INT REFERENCES responses, -- id отклика, в рамках которого это сообщения отправлено
    forward     BOOLEAN   NOT NULL DEFAULT TRUE, -- флаг отправителя (true - работодатель, false - соискатель)
    msg         TEXT      NOT NULL, -- сам текст сообщения
    distime     TIMESTAMP NOT NULL -- время отправки сообщения
);