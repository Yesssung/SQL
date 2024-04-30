-- 문제 1.
SELECT COUNT(*) FROM employees WHERE manager_id IS NOT NULL;

-- 문제 2.
SELECT salary 임금, MAX(salary) 최고임금, MIN(salary) 최저임금 FROM jobs JOIN employees GROUP BY salary ON salary BETWEEN MAX(salary) AND MIN(salary);

-- 문제 3.
SELECT first_name, hire_date FROM employees WHERE hire_date > 

-- 문제 4.
SELECT emp.department_id ROUND(AVG(j.salary),2) 평균급여, MAX(j.salary) 최대급여, MIN(j.salary) 최소급여
FROM employees emp JOIN jobs j ON emp.job_id = j.job_id GROUP BY department_id ORDER BY department_id DESC;

-- 문제 5.
SELECT AVG(salary), MAX(salary), MIN(salary), job_id FROM employees ORDER BY MIN(salary) DESC, ROUND(AVG(salary), 1) ASC;

-- 문제 6.
SELECT REPLACE(MIN(hire_date),'/','-') FROM employees ;

-- 문제 7.
SELECT department_id, ROUND(AVG(salary),2), MIN(salary) FROM employees WHERE AVG(salary) <= salary <= MAX(salary) ORDER BY salary DESC;

-- 문제 8.
SELECT emp.job_id, j.MAX(salary) 최대급여, j.MIN(salary) 최소급여 FROM employees ORDER BY 최대급여 DESC ; 

-- 문제 9.
SELECT MAX(salary), MIN(salary), AVG(salary) FROM employees GROUP BY employee_id WHERE salary >= (SELECT AVG(salary) FROM jobs WHERE 5000 >= AVG(salary));

-- 문제 10.










-- 1. 
SELECT COUNT(manager_id) "HaveMngCnt" FROM employees WHERE manager_id IS NOT NULL;

-- 2.
SELECT MAX(salary) 최고임금, MIN(salary) 최저임금, MAX(salary) - MIN(salary) "최고임금 - 최저임금" FROM employees;

-- 3. -> ORACLE SQL 에서 한글 부분 ""(따움표)로 묶어주기
SELECT TO_CHAR(MAX(hire_date), 'YYYY"년"MM"월"DD"일"') FROM employees;

-- 4.
SELECT department_id, ROUND(AVG(salary), 2), MAX(salary), MIN(salary) FROM employees GROUP BY department_id ORDER BY department_id DESC;

-- 5. 
SELECT job_id, ROUND(AVG(salary)), MAX(salary), MIN(salary) FROM employees GROUP BY job_id ORDER BY MIN(salary)DESC, AVG(salary);

-- 6.
SELECT TO_CHAR(MIN(hire_date), 'YYYY-MM-DD DAY') 입사일 FROM employees;

-- 7. HAVING 절은 집계 함수가 이뤄진 이후에 조건은 WHERE 절이 아닌 HAVING절을 사용해야 한다.
SELECT department_id, ROUND(AVG(salary)), MIN(salary), ROUND(AVG(salary)) - MIN(salary) FROM employees GROUP BY department_id HAVING ROUND(AVG(salary)) - MIN(salary) < 2000 ORDER BY ROUND(AVG(salary)) - MIN(salary) DESC ;

-- 8.
SELECT job_id, MAX(salary), MIN(salary), MAX(salary) - MIN(salary) diff FROM employees GROUP BY job_id ORDER BY  diff DESC;

-- 9.
SELECT manager_id, ROUND(AVG(salary)) avg, MIN(salary), MAX(salary) FROM employees WHERE hire_date > '15/01/01' GROUP BY manager_id HAVING ROUND(AVG(salary)) >= 5000 ORDER BY avg DESC;

-- 10.
SELECT employee_id, salary,
CASE WHEN hire_date <= '12/12/31' THEN '창립멤버'
     WHEN hire_date >= '13/01/01' AND hire_date <= '13/12/31' THEN '13년입사'
     WHEN hire_date >= '14/01/01' AND hire_date <= '14/12/31' THEN '14년입사'
     ELSE '상장이후입사'
END OPTDATE, hire_date
FROM employees ORDER BY hire_date ASC;


