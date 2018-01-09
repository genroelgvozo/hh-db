CREATE DATABASE hhschool;

CREATE SCHEMA genro;

CREATE TYPE genro.FIO AS (
    first_name  TEXT,
    second_name TEXT,
    patronymic  TEXT
);

CREATE TABLE genro.users (
    user_id    SERIAL PRIMARY KEY, -- id пользователя
    email      VARCHAR(254) NOT NULL, -- email
    pwd        TEXT         NOT NULL, -- пароль (хеш офкорс)
    time_reg   TIMESTAMP    NOT NULL, -- время регистрации
    time_login TIMESTAMP, -- время последнего захода на сайт
    name       genro.FIO, -- фио для резюме
    birthday   DATE -- дата рождения для вычисления возраста
);

CREATE TABLE genro.vacancies (
    vac_id       SERIAL PRIMARY KEY, -- id вакансии
    company_name TEXT      NOT NULL, -- id компании, оттуда ее название
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

CREATE INDEX vacancies_idx
    ON genro.vacancies USING GIN (to_tsvector(lang, position || ' ' || description));

CREATE INDEX experience_index
    ON genro.vacancies (experience); -- частый поиск с применением операций сравнения, для чего B-деревья и нужны

CREATE TABLE genro.summaries (
    summary_id SERIAL PRIMARY KEY, -- id резюме
    user_id    INT REFERENCES genro.users, -- создатель резюме, оттуда брать ФИО, возраст
    salary_min INT, -- минимальная з/п
    salary_max INT, -- максимальная з/п
    expirience INT, -- опыт работы в мес.
    skills     TEXT ARRAY -- список скилов
);

CREATE TABLE genro.responses (
    response_id SERIAL PRIMARY KEY, -- id отклика
    vacancy_id  INT REFERENCES genro.vacancies, -- id компании
    summary_id  INT REFERENCES genro.summaries -- id резюме
);

CREATE TABLE genro.messages (
    messsage_id SERIAL PRIMARY KEY, -- id message
    response_id INT REFERENCES genro.responses, -- id отклика, в рамках которого это сообщения отправлено
    forward     BOOLEAN   NOT NULL DEFAULT TRUE, -- флаг отправителя (true - работодатель, false - соискатель)
    msg         TEXT      NOT NULL, -- сам текст сообщения
    distime     TIMESTAMP NOT NULL -- время отправки сообщения
);
