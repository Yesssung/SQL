-- 문제 1.
SELECT first_name, manager_id, commission_pct, salary FROM employees WHERE manager_id IS NOT NULL AND commission_pct IS NULL AND salary > 3000;

-- 문제 2.
SELECT employee_id, first_name, salary, TO_CHAR(hire_date,'YYYY-MM-DD DAY'), REPLACE(SUBSTR(phone_number, 3), '.','-'), department_id
FROM employees WHERE(department_id, salary) IN(SELECT department_id, MAX(salary) FROM employees GROUP BY department_id)
ORDER BY salary DESC;

-- 문제 3.
-- SELECT manager_id, first_name, salary

-- 문제 4. (SELF JOIN)
SELECT emp.employee_id, emp.first_name, emp.department_id, man.first_name FROM employees emp JOIN employees man ON emp.manager_id = man.employee_id;

-- 문제 5.
SELECT rownum, employee_id, first_name, department_id, salary, hire_date
FROM (SELECT employee_id, first_name, department_id, salary, hire_date, ROW_NUMBER()OVER (ORDER BY hire_date) AS rnum FROM employees)
WHERE rnum >= 11 AND rnum <= 20; 

-- 문제 6. 
SELECT emp.first_name||' '||emp.last_name 이름, emp.salary 연봉, dept.department_name 부서이름, MAX(hire_date) HIRE_DATE FROM employees emp JOIN departments dept ON emp.department_id = dept.department_id GROUP BY department_name;

-- 문제 7.
SELECT emp.employee_id, emp.first_name, emp.last_name, AVG(emp.salary), j.job_title
FROM employees emp JOIN jobs j ON emp.job_id = j.job_id 
GROUP BY emp.department_id HAVING MAX(salary);