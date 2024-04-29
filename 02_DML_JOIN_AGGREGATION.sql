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





------------------------------------------------------
-- Group Aggregation
-- 집계 : 여러 행으로부터 데이터를 수집, 하나의 행으로 반환
------------------------------------------------------
-- count : 개수 세기 함수
-- 특정 Column 내에 null 값이 포함되어있는지의 여부는 중요하지 않음
SELECT COUNT(*) FROM employees;     -- employees table 에 레코드가 총 몇개인가

-- commission을 받는 직원의 수를 알고 싶을 경우
-- commission_pct 가 null 인 경우를 제외하고 싶을 경우
SELECT COUNT(commission_pct) FROM employees; -- Column 내에 포함된 null 데이터를 카운터 하지 않음
SELECT COUNT(*) FROM employees WHERE commission_pct IS NOT NULL;

-- SUM : 합계함수
-- 모든 사원의 급여의 합계 구해보쟈
SELECT SUM(salary) FROM employees;

-- AVG : 평균함수
-- 사원들의 평균 급여
SELECT AVG(salary) FROM employees;

-- 사원들이 받는 평균 commission_pct 얼마?
SELECT AVG(commission_pct) FROM employees;
-- AVG 함수는 NULL이 포함될 경우 집계수치에서 제외한다.
-- NULL 값을 집계 결과에 포함시킬지의 여부는 정책으로 결정하고 수행해야 한다.
SELECT AVG(NVL(commission_pct, 0)) FROM employees;

-- MIN & MAX : 최소값, 최대값
-- AVG & MEDIAN : 산술평균, 중앙값
SELECT MIN(salary) 최소급여,
       MAX(salary) 최대급여,
       AVG(salary) 평균급여,
       MEDIAN(salary) 급여중앙값
FROM employees;

-- 자주 발생하는 오류
-- 부서별로 평균 급여를 구하려면
SELECT department_id, AVG(salary) FROM employees; -- 그래서 둘이 같이 쓰면 오류 발생
SELECT department_id FROM employees;    -- 여러개의 레코드로 출력
SELECT AVG(salary) FROM employees;      -- 단일 레코드로 출력

SELECT department_id, salary FROM employees ORDER BY department_id;
SELECT department_id, ROUND(AVG(salary),2) FROM employees GROUP BY department_id ORDER BY department_id;


-- 부서별 평균 급여에 부서명도 포함하여 출력하기
SELECT emp.department_id, dept.department_name, ROUND(AVG(emp.salary), 2) FROM employees emp JOIN departments dept ON emp.department_id = dept.department_id GROUP BY emp.department_id ORDER BY emp.department_id;
-- GROUP BY 절 뒤에는 GROUP BY에 참여한 COLUMN과 집계 함수만 남는다.
SELECT emp.department_id, dept.department_name, ROUND(AVG(emp.salary), 2) FROM employees emp JOIN departments dept ON emp.department_id = dept.department_id GROUP BY emp.department_id, dept.department_name ORDER BY emp.department_id;

-- 평균 급여가 7000이상인 부서만 출력
SELECT department_id, ROUND(AVG(salary),2) FROM employees WHERE AVG(salary) >= 7000 /*아직 집계 함수가 시행되지 않은 상태이기 때문에 집계함수의 비교 불가*/GROUP BY department_id ORDER BY department_id;
-- HAVING 절을 사용해서 출력하기
SELECT department_id, ROUND(AVG(salary),2) FROM employees GROUP BY department_id HAVING AVG(salary) >= 7000 /*GROUP BY aggregation의 조건 필터링*/ORDER BY department_id;





--------------------------------------------
-- ROLLUP & CUBE
-- GROUP BY절과 함께 사용
-- 그룹지어진 결과에 대한 좀 더 상세한 요약 제공
-- 일종의 ITEM TOTAL
--------------------------------------------
-- ROLLUP
SELECT department_id, job_id, SUM(salary) FROM employees GROUP BY ROLLUP(department_id, job_id);

-- CUBE
-- ROLLUP과 출력되는 ITEM TOTAL값과 함께 COLUMN TOTAL값을 함께 추출
SELECT department_id, job_id, SUM(salary) FROM employees GROUP BY CUBE(department_id, job_id) ORDER BY department_id;





----------------------------------
-- SUBQUERY
----------------------------------
-- 모든 직원의 중앙값보다 많은 급여를 받는 사원 출력하기
-- 1) 직원 급여의 중앙값? -> 6,200
-- 2) 1)의 결과보다 많은 급여를 받는 직원 목록
SELECT MEDIAN(salary) FROM employees;
SELECT first_name, salary FROM employees WHERE salary >= 6200;

SELECT first_name, salary FROM employees WHERE salary >= (SELECT MEDIAN(salary) FROM employees) ORDER BY salary DESC;

-- SUSAN 보다 늦게 입사한 사원 정보 출력하기
-- 1) SUSAN의 입사일
-- 2) 1)보다 늦게 입사한 사원 정보 출력 
SELECT hire_date FROM employees WHERE first_name = 'Susan';
SELECT first_name, hire_date FROM employees WHERE hire_date > '12/06/07';

SELECT first_name, hire_date FROM employees WHERE hire_date > (SELECT hire_date FROM employees WHERE first_name = 'Susan');

-- 급여를 모든 직원 급여의 중앙값보다 많이 받으면서 수잔보다 늦게 입사한 직원의 목록
SELECT first_name, hire_date, salary FROM employees WHERE hire_date > (SELECT hire_date FROM employees WHERE first_name = 'Susan') AND salary >= (SELECT MEDIAN(salary) FROM employees) ORDER BY hire_date, salary DESC;