-- 문제 1.
SELECT COUNT(salary) FROM employees WHERE salary < (SELECT AVG(salary) FROM employees);
-- 答
SELECT COUNT(*) FROM employees WHERE salary < (SELECT AVG(salary) FROM employees);



-- 문제 2.
SELECT employee_id, first_name, salary, AVG(salary), MAX(salary)
FROM employees WHERE salary >= (SELECT salary FROM employees
WHERE salary >= AVG(salary)) AND salary < (SELECT MAX(salary)FROM employees) ORDER BY salary ;
-- 答
SELECT emp.employee_id, emp.first_name, emp.salary, t.avgSalary, t.maxSalary FROM employees emp
JOIN(SELECT ROUND(AVG(salary)) avgSalary, MAX(salary) maxSalary FROM employees) t
ON emp.salary BETWEEN t.avgSalary AND t.maxSalary ORDER BY salary; 



-- 문제 3.
SELECT location_id, street_address, postal_code, city, state_province, country_id FROM locations 
WHERE (SELECT emp.first_name, emp.last_name, dept.departments_name FROM employees emp 
JOIN departments dept ON emp.department_id = dept.department_id);
-- 答 SUBQUERY ver.
SELECT location_id, street_address, postal_code, city, state_province, country_id FROM locations 
WHERE location_id = (SELECT location_id FROM departments WHERE department_id =
                      (SELECT department_id FROM employees WHERE first_name = 'Steven' AND last_name = 'King') );
-- 答 JOIN ver.
SELECT location_id, street_address, postal_code, city, state_province, country_id FROM locations
        NATURAL JOIN departments JOIN employees ON employees.department_id = departments.department_id
        WHERE first_name = 'Steven' AND last_name = 'King';
        
        

-- 문제 4.
SELECT employee_id, first_name, salary FROM employees WHERE salary < ANY(SELECT salary FROM employees 
WHERE first_name = 'ST_MAN') ORDER BY salary DESC;   -- -> first_name에서 찾을게 아니라 job_id에서 찾았어야지!
-- 答
SELECT employee_id, first_name, salary FROM employees WHERE salary < ANY(SELECT salary FROM employees
WHERE job_id = 'ST_MAN') ORDER BY salary DESC;



-- 문제 5.
SELECT emp.department_id, emp.employee_id, emp.first_name, emp.salary
FROM employees emp, (SELECT department_id, MAX(salary) salary FROM employees GROUP BY department_id) sal
WHERE emp.department_id = sal.department_id
AND emp.salary = sal.salary
ORDER BY emp.department_id DESC;
-- 答
-- 조건절 비교
SELECT employee_id, first_name, salary, department_id FROM employees;
--  부서별 최고급여 쿼리
SELECT department_id MAX(salary) FROM employees GROUP BY department_id;
-- 최종
SELECT emp.employee_id, emp.first_name, emp.salary, emp.department_id FROM employees emp
WHERE (emp.department_id, emp.salary)
IN(SELECT department_id, MAX(salary) FROM employees GROUP BY department_id) ORDER BY salary DESC ;
-- 테이블 조인 ver
SELECT emp.employee_id, emp.first_name, emp.salary, emp.department_id FROM employees emp
JOIN (SELECT department_id, MAX(salary) salary FROM employees GROUP BY department_id) t ON emp.department_id = t.department_id
WHERE emp.salary = t.salary ORDER BY emp.salary DESC;



-- 문제 6.
SELECT COUNT(salary) FROM jobs GROUP BY department_id;
-- 答
SELECT j.job_title, t.sumSalary, j.job_id, t.job_id FROM jobs j
JOIN (SELECT job_id, SUM(salary) sumSalary FROM employees GROUP BY job_id) t ON j.job_id = t.job_id ORDER BY sumSalary DESC;



-- 문제 7.
SELECT employee_id, first_name, salary, department_id FROM employees OUTER 
WHERE salary > (SELECT AVG(salary) FROM employees WHERE department_id = OUTER.department_id);
-- 答 -> 위에 내가 푼 문제랑 결과가 같음!
SELECT emp.employee_id, emp.first_name, emp.salary FROM employees emp
JOIN(SELECT department_id, AVG(salary) salary FROM employees GROUP BY department_id) t
ON emp.department_id = t.department_id WHERE emp.salary > t.salary;



-- 문제 8.
SELECT rownum, employee_id, first_name, salary, hire_date 
FROM (SELECT * FROM employees WHERE hire_date LIKE '00%' ORDER BY salary DESC) WHERE rownum <= 5; 
-- 答 ver 1
SELECT employee_id, first_name, salary, hire_date
FROM (SELECT rownum rn, employee_id, first_name, salary, hire_date FROM(SELECT employee_id, first_name, salary, hire_date FROM employees ORDER BY hire_date))
WHERE rn >= 11 AND rn <= 15;
-- 答 ver 2
SELECT rownum, employee_id, first_name, salary, hire_date
FROM (SELECT employee_id, first_name, salary, hire_date, ROW_NUMBER()OVER (ORDER BY hire_date) AS rnum FROM employees)
WHERE rnum >= 11 AND rnum <= 15; 


