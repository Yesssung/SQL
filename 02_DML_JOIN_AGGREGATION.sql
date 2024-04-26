------------------------------------------------
-- JOIN
------------------------------------------------

-- EMPLOYEES와 DEPARTMENTS
DESC employees;
DESC departments;

-- 카티전 프로덕트(CARTESION PRODUCT) : 두 테이블 행들의 가능한 모든 쌍이 추출됨
SELECT * FROM employees;                -- 107
SELECT * FROM departments;              -- 27
SELECT * FROM employees, departments;   -- 2889??? -> 107*27

-- INNER-JOIN
SELECT * FROM employees, departments WHERE employees.department_id = departments.department_id;





------------------------------------------------
-- ALIAS를 이용한 원하는 필드의 PROJECTION
-- SIMPLE_JOIN, EQUI_JOIN
------------------------------------------------
-- 정의가 애매하다고 오류남
SELECT first_name, department_id, department_id, department_name FROM employees, departments WHERE employees.department_id = departments.department_id;
-- 각 테이블명 표기해주면 되지만 너무 길어짐
SELECT first_name, employees.department_id, departments.department_id, departments.department_name FROM employees, departments WHERE employees.department_id = departments.department_id;
-- 테이블에 별칭만들어서 길이 줄여주기
SELECT first_name, emp.department_id, dept.department_id, department_name FROM employees emp, departments dept WHERE emp.department_id = dept.department_id; -- 106명 department_id가 NULL 인 직원은 JOIN에서 배제

SELECT * FROM employees WHERE department_id IS NULL; -- 178명

SELECT emp.first_name, dept.department_name FROM employees emp JOIN departments dept USING(department_id);




------------------------------------------------
-- THEATA JOIN
-- JOIN 조건이 = 아닌 조건들
------------------------------------------------

-- 급여가 직군 평균 급여보다 낮은 직원들 목록
SELECT emp.employee_id, emp.first_name, emp.salary, emp.job_id, j.job_id, j.job_title FROM employees emp JOIN jobs j ON emp.job_id = j.job_id WHERE emp.salary <= (j.min_salary + j.max_salary) / 2 ;




-------------------------------------------------------------------------------------------------
-- OUTER JOIN
-- 조건이 만족하는 짝이 없는 튜플도 NULL을 포함해서 결과 출력에 참여시키는 방법
-- 모든 결과를 표현한 테이블이 어느 쪽에 위치하는가에 따라 LEFT, RIGHT, FULL OUTER JOIN으로 구분한다
-- Oracle SQL의 경우 NULL이 출력되는 쪽에 (+) 붙여주기!
-------------------------------------------------------------------------------------------------

-- Oracle SQL(LEFT ver.)
SELECT emp.first_name, emp.department_id, dept.department_id, dept.department_name FROM employees emp, departments dept WHERE emp.department_id = dept.department_id;       -- 106행
SELECT * FROM employees WHERE department_id IS NULL;                                                                                                                        -- kIMBERELY -> 부서에 소속되지 않은사람(DEPARTMENT_ID 없음)그렇기 때문에 위에서는 출력되지 않음
SELECT emp.first_name, emp.department_id, dept.department_id, dept.department_name FROM employees emp, departments dept WHERE emp.department_id = dept.department_id(+);    -- NULL이 포함된 쪽에 (+) 넣기 -> 107명

-- ANSI SQL : 명시적으로 JOIN 표시
SELECT first_name, emp.department_id, dept.department_id, department_name FROM employees emp LEFT OUTER JOIN departments dept ON emp.department_id = dept.department_id; 

-- Oracle SQL(RIGHT ver.)
SELECT emp.first_name, emp.department_id, dept.department_id, dept.department_name FROM employees emp, departments dept WHERE emp.department_id = dept.department_id;        -- DEPARTMENTS 테이블 전부를 출력에 참여시킬거
SELECT emp.first_name, emp.department_id, dept.department_id, dept.department_name FROM employees emp, departments dept WHERE emp.department_id(+) = dept.department_id;     -- 122행 출력

-- ANSI SQL : 명시적으로 JOIN 표시
SELECT first_name, emp.department_id, dept.department_id, department_name FROM employees emp RIGHT OUTER JOIN departments dept ON emp.department_id = dept.department_id; 

-- FULL OUTER : JOIN에 참여한 모든 테이블의 모든 레코드를 출력에 참여, 짝이 없는 레코드들은 NULL을 포함해서 출력에 참여(ONLY ANSI SQL)
SELECT first_name, emp.department_id, dept.department_id, department_name FROM employees emp FULL OUTER JOIN departments dept ON emp.department_id = dept.department_id;     -- KIMBERELY도 나오고 DEPARTMENT_ID도 다 나옴!





---------------------------------------------------------------------------------------
-- NATURAL JOIN
-- JOIN할 테이블에 같은 이름의 COLUMN이 있을 경우 해당 COLUMN을 기준으로 JOIN한다요
-- 실제 JOIN 할 조건과 일치하는지 확인이 필요 -> 같은 값이 두개 이상일 경우 불확실할 가능성 있음
---------------------------------------------------------------------------------------
SELECT * FROM employees emp NATURAL JOIN departments dept;                                                                           -- 32행 (지금 department_id와 manager_id 두개가 같다. 어떤것을 기준했는지 모름! -> natural은 불확실할 수 있음)
SELECT * FROM employees emp JOIN departments dept ON emp.department_id = dept.department_id;                                         -- 50행
SELECT * FROM employees emp JOIN departments dept ON emp.manager_id = dept.manager_id AND emp.department_id = dept.department_id;    -- 32행





--------------------------------------------------------------------
-- SELF JOIN
-- 자기 자신과 JOIN
-- 자신을 두 번 호출 하기 때문에 별칭을 반드시 부여해야 할 필요가 있는 JOIN
--------------------------------------------------------------------
SELECT * FROM employees;        -- 107행 -> 직원은 총 107명
SELECT emp.employee_id, emp.first_name, emp.manager_id, man.first_name FROM employees emp JOIN employees man ON emp.manager_id = man.employee_id; 
SELECT emp.employee_id, emp.first_name, emp.manager_id, man.first_name FROM employees emp, employees man WHERE emp.manager_id = man.employee_id; -- 106행 -> 매니저 없는 1명 제외

-- MANAGER 없는 STEVEN 포함해서 출력해보세오 =============================== 미완
SELECT emp.employee_id, emp.first_name, emp.manager_id, man.first_name FROM employees emp RIGHT OUTER JOIN employees man ON emp.manager_id = man.employee_id;