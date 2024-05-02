
-- 문제 1.
SELECT first_name||' '||last_name 이름, salary 월급, phone_number 전화번호, hire_date 입사일 FROM employees ORDER BY hire_date ASC;
-- 모답: 굿 (ORDER BY : 원래 default가 ASC 이기 때문에 생략 가능하다.)

-- 문제 2.
SELECT job_title, max_salary FROM jobs ORDER BY max_salary DESC;

-- 문제 3.
SELECT first_name, manager_id, commission_pct, salary FROM employees WHERE commission_pct IS NULL AND salary > 3000;
-- 모답: 조건3개 매니저id가 null이 아니고, 커미션 비율 null이고, 월급이 3000이상 -> WHERE절에 manager_id IS NOT NULL 추가해주기
SELECT first_name, manager_id, commission_pct, salary FROM employees WHERE manager_id IS NOT NULL AND commission_pct IS NULL AND salary > 3000;

-- 문제 4.
SELECT job_title, max_salary FROM jobs WHERE max_salary >= 10000 ORDER BY max_salary DESC;

-- 문제 5.
SELECT first_name, salary, NVL(commission_pct, 0) FROM employees WHERE salary >= 10000 AND salary < 14000 ORDER BY salary DESC;

-- 문제 6. 
SELECT first_name, salary, TO_CHAR(hire_date, 'YYYY-MM'), department_id FROM employees WHERE department_id IN(10, 90, 100);

-- 문제 7. 
SELECT first_name, salary FROM employees WHERE first_name LIKE '%S%' OR first_name LIKE '%s%' ;
-- 모답: 이름을 먼저 대문자로 바꿔서 대문자S가 있는지 확인 -> 왜냐면 대문자로 다 바꿔놓으면 조건 한번만 해도 괜찮기 때문 -> LOWER버전으로 해도 됩니다.
SELECT first_name, salary FROM employees WHERE UPPER(first_name) LIKE '%S%';

-- 문제 8. 
SELECT department_name FROM departments ORDER BY LENGTH(department_name) DESC;   

-- 문제 9. 
SELECT country_name, UPPER(country_name) FROM countries ORDER BY country_name ASC;

-- 문제 10. 
SELECT first_name, salary, REPLACE(phone_number, '.', '-' ),hire_date FROM employees WHERE hire_date <= '13/12/31';
-- 모답: 문제와 똑.같.이 출력하고 싶다면?
SELECT first_name, salary, REPLACE(SUBSTR(phone_number, 3), '.', '-' ),hire_date FROM employees WHERE hire_date <= '13/12/31';