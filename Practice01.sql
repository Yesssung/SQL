
-- 문제 1.
SELECT first_name||' '||last_name 이름, salary 월급, phone_number 전화번호, hire_date 입사일 FROM employees ORDER BY hire_date ASC;

-- 문제 2.
SELECT job_title, max_salary FROM jobs ORDER BY max_salary DESC;

-- 문제 3.
SELECT first_name, manager_id, commission_pct, salary FROM employees WHERE commission_pct IS NULL AND salary > 3000;

-- 문제 4.
SELECT job_title, max_salary FROM jobs WHERE max_salary > =10000 ORDER BY max_salary DESC;

-- 문제 5.
SELECT first_name, salary, NVL(commission_pct, 0) FROM employees WHERE salary >= 1000 AND salary < 14000 ORDER BY salary DESC;

-- 문제 6. 
SELECT first_name, salary, TO_CHAR(hire_date, 'YYYY-MM'), department_id FROM employees WHERE department_id IN(10, 90, 100);

-- 문제 7. 
SELECT first_name, salary FROM employees WHERE first_name LIKE '%S%' OR first_name LIKE '%s%' ;

-- 문제 8. 
SELECT department_name FROM departments ORDER BY LENGTH(department_name) DESC;   

-- 문제 9. ***
SELECT country_name, UPPER(country_name) FROM countries ORDER BY country_name ASC;

--문제 10. 
SELECT first_name, salary, REPLACE(phone_number, '.', '-' ),hire_date FROM employees WHERE hire_date < '13/12/31';