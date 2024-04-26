-- 문제 1.
SELECT e.employee_id, e.first_name, e.last_name, d.department_name FROM employees e JOIN departments d USING(department_id) ORDER BY department_name ASC, employee_id DESC; 

-- 문제 2. ======= 보류
--SELECT e.employee_id, e.first_name, e.salary, d.department_name, j.job_title FROM employees e JOIN departments d, jobs j USING(department_id, job_id)

-- 문제 3. 
SELECT l.location_id, l.city, d.department_name, d.department_id FROM departments d JOIN location l USING(location_id) ORDER BY location_id ASC;
