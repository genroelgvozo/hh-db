SET SEARCH_PATH = genro;

INSERT INTO users (email, pwd, time_reg, time_login, name, birthday)
    SELECT
        concat(left(md5(cast(random() AS TEXT)), 200), '@gmail.com'),
        md5(cast(random() AS TEXT)),
        '2017-01-01 12:00:00' :: TIMESTAMP + random() * '365 days' :: INTERVAL,
        '2017-01-01 12:00:00' :: TIMESTAMP + random() * '365 days' :: INTERVAL,
        (md5(cast(random() AS TEXT)), md5(cast(random() AS TEXT)), 'ИОСИФОВИЧ') :: FIO,
        '1990-01-01 12:00:00' :: TIMESTAMP + random() * '3650 days' :: INTERVAL
    FROM generate_series(1, 5000) AS t(num);

INSERT INTO vacancies (company_name, lang, position, description, salary_min, salary_max, experience, skills, time_create, time_delete)
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

-- на каждого пользователя в среднем 200 резюмю (но разное количество)
INSERT INTO summaries (user_id, salary_min, salary_max, experience, skills)
    SELECT
        u.user_id,
        round(random() * 400000),
        round(random() * 400000),
        round(random() * 6),
        ARRAY ['С', 'С++', 'C+++', '1C', '2C', '2C++']
    FROM users u
        LEFT JOIN generate_series(1, 2000) AS t(num) ON (1 = round(random() * 10));
-- 1001602 rows affected in 16s 239ms

-- ~500k откликов.
INSERT INTO responses (vacancy_id, summary_id)
    SELECT
        v.vacancy_id,
        s.summary_id
    FROM (SELECT vacancy_id
          FROM vacancies
          ORDER BY random()
          LIMIT 5000) AS v
        JOIN (SELECT summary_id
              FROM summaries
              ORDER BY random()
              LIMIT 5000) AS s ON 1 = round(random() * 50);
-- 499399 rows affected in 15s 454ms

-- на каждый отклик в среднем 4 сообщения
INSERT INTO messages (response_id, forward, msg, distime)
    SELECT
        r.response_id,
        cast(cast(random() AS INT) AS BOOLEAN),
        md5(cast(random() AS TEXT)),
        '2017-01-01 12:00:00' :: TIMESTAMP + random() * '365 days' :: INTERVAL
    FROM (SELECT response_id
          FROM responses) AS r LEFT JOIN generate_series(1, 20) AS t(num) ON 1 = round(random() * 5);
-- 2003849 rows affected in 30s 683ms
