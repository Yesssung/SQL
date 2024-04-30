-- 문제 1.
SELECT COUNT(*) FROM employees WHERE manager_id IS NOT NULL;

-- 문제 2.
SELECT salary 임금, MAX(salary) 최고임금, MIN(salary) 최저임금 FROM jobs GROUP BY JOIN employees ON salary BETWEEN max_salary AND min_salary;

-- 문제 3.

-- 문제 4.
SELECT ROUND(AVG(salary),2) 평균급여, MAX(salary) 최대급여, MIN(salary) 최소급여, emp.department_id
FROM employees emp JOIN jobs j ON emp.job_id = j.job_id GROUP BY department_id ORDER BY department_id DESC;

-- 문제 5.

-- 문제 6.

-- 문제 7.

-- 문제 8.

-- 문제 9.

-- 문제 10.