SELECT position, salary_max
FROM genro.vacancies
WHERE to_tsvector(lang, position || ' ' || description) @@ to_tsquery('develop')
ORDER BY time_create DESC
LIMIT 10;

-- 10 rows retrieved starting from 1 in 419ms (execution: 416ms, fetching: 3ms)

-- #	position		salary_max
-- ===============================
-- 1	DevelOpers		240069
-- 2	Lead Developer	364920
-- 3	DevelOpers		301032
-- 4	Lead Developer	101711
-- 5	Lead Developer	160220
-- 6	Developer		214521
-- 7	DevelOpers		364437
-- 8	DevelOpers		52825
-- 9	Developer		247748
-- 10	DevelOpers		140120



SELECT position, salary_min
FROM genro.vacancies
WHERE to_tsvector(lang, position || ' ' || description) @@ to_tsquery('design')
ORDER BY salary_min DESC
LIMIT 10;


-- 10 rows retrieved starting from 1 in 436ms (execution: 425ms, fetching: 11ms)

-- #	position		salary_min
-- ===============================
-- 1	Pro Designer	40000
-- 2	Pro Designer	40000
-- 3	Designer		39999
-- 4	Pro Designer	39999
-- 5	Pro Designer	39999
-- 6	Designer		39999
-- 7	Pro Designer	39999
-- 8	Designer		39999
-- 9	Pro Designer	39999
-- 10	Designer		39999



SELECT
    position,
    salary_min,
    salary_max,
    experience
FROM genro.vacancies
WHERE experience <= 6 AND to_tsvector(lang, POSITION || ' ' || description) @@ to_tsquery('develop')
ORDER BY time_create DESC
LIMIT 10;

-- 10 rows retrieved starting from 1 in 144ms (execution: 134ms, fetching: 10ms)

-- #	position		salary_min	salary_max	experience
-- =======================================================
-- 1	DevelOpers		26438		124388		1
-- 2	Developer		22579		155781		5
-- 3	Lead Developer	34264		375953		3
-- 4	DevelOpers		19740		42096		2
-- 5	Developer		12346		188281		1
-- 6	Developer		37050		215424		5
-- 7	Lead Developer	12090		129512		6
-- 8	Developer		15785		296395		2
-- 9	DevelOpers		29748		251417		1
-- 10	DevelOpers		2536		285481		3
