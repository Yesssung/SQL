-- 문제 1.
SELECT COUNT(salary) FROM employees WHERE salary < (SELECT AVG(salary) FROM employees);

-- 문제 2.
SELECT employee_id, first_name, salary, AVG(salary), MAX(salary)
FROM employees WHERE salary >= (SELECT salary FROM employees
WHERE salary >= AVG(salary)) AND salary < (SELECT MAX(salary)FROM employees) ORDER BY salary ;

-- 문제 3.
SELECT location_id, street_address, postal_code, city, state_province, country_id FROM locations 
WHERE (SELECT emp.first_name, emp.last_name, dept.departments_name FROM employees emp 
JOIN departments dept ON emp.department_id = dept.department_id);

-- 문제 4.
SELECT employee_id, first_name, salary FROM employees WHERE salary < ANY(SELECT salary FROM employees 
WHERE first_name = 'ST_MAN'   , )ORDER BY salary DESC;

-- 문제 5.
SELECT emp.department_id, emp.employee_id, emp.first_name, emp.salary
FROM employees emp, (SELECT department_id, MAX(salary) salary FROM employees GROUP BY department_id) sal
WHERE emp.department_id = sal.department_id
AND emp.salary = sal.salary
ORDER BY emp.department_id DESC;

-- 문제 6.
SELECT COUNT(salary) FROM jobs GROUP BY department_id;

-- 문제 7.
SELECT first_name, salary, department_id FROM employees OUTER 
WHERE salary > (SELECT AVG(salary) FROM employees WHERE department_id = OUTER.department_id);

-- 문제 8.
SELECT rownum, employee_id, first_name, salary, hire_date 
FROM (SELECT * FROM employees WHERE hire_date LIKE '00%' ORDER BY salary DESC) WHERE rownum <= 5; 