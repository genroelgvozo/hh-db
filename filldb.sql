INSERT INTO genro.users (email, pwd, time_reg, time_login, name, birthday)
    SELECT
        concat(left(md5(cast(random() AS TEXT)), 200), '@gmail.com'),
        md5(cast(random() AS TEXT)),
        '2017-01-01 12:00:00' :: TIMESTAMP + random() * '365 days' :: INTERVAL,
        '2017-01-01 12:00:00' :: TIMESTAMP + random() * '365 days' :: INTERVAL,
        (md5(cast(random() AS TEXT)), md5(cast(random() AS TEXT)), 'ИОСИФОВИЧ') :: genro.FIO,
        '1990-01-01 12:00:00' :: TIMESTAMP + random() * '3650 days' :: INTERVAL
    FROM generate_series(1, 5000) AS t(num);

INSERT INTO genro.vacancies (company_name, lang, position, description, salary_min, salary_max, experience, skills, time_create, time_delete)
    SELECT
        md5(cast(random() AS TEXT)),
        'english',
        ('{Developer,DevelOpers,Lead Developer,Project Manager,Designer,Pro Designer}' :: TEXT []) [
        ceil(random() * 6)],
        md5(CAST(random() AS TEXT)),
        round(random() * 40000),
        -- платят мало :(
        round(random() * 400000),
        round(random() * 240),
        ARRAY ['тыжпрограммист', 'уметь перезагружать вайфай', 'чинить утюги, принтеры и процессоры'],
        '2017-01-01 12:00:00' :: TIMESTAMP + random() * '365 days' :: INTERVAL,
        '2017-01-01 12:00:00' :: TIMESTAMP + random() * '365 days' :: INTERVAL
    FROM generate_series(1, 1000000) AS t(num);

INSERT INTO genro.summaries (user_id, salary_min, salary_max, expirience, skills)
    SELECT
        round(random() * 4999 + 1),
        round(random() * 400000),
        -- а юзеры хотят много
        round(random() * 400000),
        round(random() * 6),
        -- а опыта нет
        ARRAY ['С', 'С++', 'C+++', '1C', '2C', '2C++'] -- а эту шутку ваши коллеги придумали
    FROM generate_series(1, 1000000) AS t(num);

-- 500к откликов, на каждыый в среднем 4 сообщения, итого 2кк сообщений

INSERT INTO genro.responses (vacancy_id, summary_id)
    SELECT
        round(random() * 999999 + 1),
        round(random() * 999999 + 1)
    FROM generate_series(1, 500000) AS t(num);

INSERT INTO genro.messages (response_id, forward, msg, distime)
    SELECT
        round(random() * 499999 + 1),
        cast(cast(random() AS INT) AS BOOLEAN),
        md5(cast(random() AS TEXT)),
        '2017-01-01 12:00:00' :: TIMESTAMP + random() * '365 days' :: INTERVAL
    FROM generate_series(1, 2000000) AS t(num);
