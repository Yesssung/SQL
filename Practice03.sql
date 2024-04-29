-- 윗줄 ORACLE, 아랫줄 ANSI

-- 문제 1.
SELECT e.employee_id, e.first_name, e.last_name, d.department_name FROM employees e JOIN departments d USING(department_id) ORDER BY department_name ASC, employee_id DESC; 

-- 문제 2. 
SELECT emp.employee_id 사번, emp.first_name 이름, emp.salary 월급, dept.department_name 부서명, j.job_title 현재업무 FROM employees emp, departments dept, jobs j WHERE emp.department_id = dept.department_id AND emp.job_id = j.job_id ORDER BY emp.employee_id;
SELECT emp.employee_id 사번, emp.first_name 이름, emp.salary 월급, dept.department_name 부서명, j.job_title 현재업무 FROM employees emp JOIN departments dept ON emp.department_id = dept.department_id JOIN jobs j ON emp.job_id = j.job_id ORDER BY emp.employee_id;
-- 문제 2-1
SELECT emp.employee_id 사번, emp.first_name 이름, emp.salary 월급, dept.department_name 부서명, j.job_title 현재업무 FROM employees emp, departments dept, jobs j WHERE emp.department_id = dept.department_id(+) AND emp.job_id = j.job_id ORDER BY emp.employee_id;
SELECT emp.employee_id 사번, emp.first_name 이름, emp.salary 월급, dept.department_name 부서명, j.job_title 현재업무 FROM employees emp LEFT OUTER JOIN departments dept ON emp.department_id = dept.department_id JOIN jobs j ON emp.job_id = j.job_id ORDER BY emp.employee_id;

-- 문제 3. 
SELECT l.location_id 도시아이디, l.city 도시명, d.department_name 부서명, d.department_id 부서아이디 FROM locations l, departments d WHERE l.location_id = d.location_id ORDER BY l.location_id ASC;
SELECT l.location_id, l.city, d.department_name, d.department_id FROM departments d JOIN locations l ON d.location_id = l.location_id ORDER BY location_id ASC;
-- 문제 3-1.
SELECT l.location_id, l.city, d.department_name, d.department_id FROM locations l, departments d WHERE l.location_id = d.location_id(+) ORDER BY location_id ASC;
SELECT l.location_id, l.city, d.department_name, d.department_id FROM departments d RIGHT OUTER JOIN locations l ON l.location_id = d.location_id ORDER BY location_id ASC;

-- 문제 4. 
SELECT re.region_name, c.country_name FROM countries c, regions re WHERE c.region_id = re.region_id ORDER BY region_name , country_name DESC;
SELECT re.region_name, c.country_name FROM countries c JOIN regions re ON c.region_id = re.region_id ORDER BY region_name , country_name DESC;

-- 문제 5.  JOIN을 따로 명시적으로 해줘야 WHERE 가 SELECTION 조건으로 적용될때 헷갈리지 않음
SELECT emp.employee_id 사번, emp.first_name 이름, emp.hire_date 채용일, man.first_name 매니저이름, man.hire_date 매니저입사일 FROM employees emp JOIN employees man ON emp.manager_id = man.employee_id WHERE emp.hire_date < man.hire_date;

-- 문제 6. 
SELECT con.counrty_name 나라명,
       con.country_id 나라아이디,
       loc.city 도시명,
       loc.location_id 도시아이디,
       dept.department_name 부서명,
       dept.department_id 부서아이디
FROM countries con 
    JOIN locations loc
        ON con.country_id = loc.country_id
    JOIN departments dept 
        ON loc.location_id = dept.location_id
ORDER BY con.country_name ASC;

-- 문제 7.
SELECT emp.employee_id 사번,
       emp.first_name||' '|| emp.last_name 이름,
       jh.job_id 업무아이디,
       jh.start_date 시작일,
       jh.end_date 종료일
FROM employees emp
    JOIN job_history jh
        ON emp.employee_id = jh.employee_id
WHERE jh.job_id = 'AC_ACCOUNT';

-- 문제 8.
SELECT dept.department_id 부서번호, dept.department_name 부서명,
       man.first_name 매니저이름,
       loc.city 위치한도시,
       con.country_name 나라,
       reg.region_name 지역
FROM departments dept
    JOIN employees man ON dept.manager_id = man.employee_id
    JOIN locations loc ON dept.location_id = loc.location_id
    JOIN countries con ON loc.country_id = con.country_id
    JOIN regions reg ON con.region_id = reg.region_id
ORDER BY department_id ASC;

-- 문제 9.
SELECT emp.employee_id 사번, emp.first_name 이름, dept.department_name 부서명, man.first_name 매니저이름
FROM employees emp
    LEFT OUTER JOIN departments dept
        ON emp.department_id = dept.department_id
    JOIN employees man
        ON emp.manager_id = man.employee_id;
