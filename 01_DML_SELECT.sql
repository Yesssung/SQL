-- SQL 문장의 주석
-- SQL 문장은 마지막에 ;(세미콜론) 으로 끝난다.
-- SQL 문장의 키워드들 테이블명, 콜럼들은 대소문자 구분하지 않는다.
-- 실제 데이터의 경우 대소문자를 구분

-- 테이블 구조 확인 (DESCRIBE)
DESCRIBE employees;
DESCRIBE departments;
DESCRIBE locations;





-- DML(Data Manipulation Language): 조작어
-- SELECT
-- * : 테이블 내에 모든 COLUMN을 PROJECTION , 테이블 설계시에 정의한 순서대로 출력
SELECT * FROM employees;

-- 특정 COLUMN만 PROJECTION 할 경우 열 목록을 명시해주기
-- EX) employees table의 first_name, phone_number, hire_date, salary 만 출력하고 싶다면
SELECT first_name, phone_number, hire_date, salary FROM employees;

-- 사원의 이름, 성, 급여, 전화번호, 입사일 정보 출력하기
SELECT first_name, last_name, salary, phone_number, hire_date FROM employees;
-- NULL은 0이나 공백과 다르게 빈 값
-- NULL은 산술연산 결과 혹은 통계결과를 왜곡시킬수 있기 때문에 철저하게 관리필요

-- Alias : 별칭. Projection 단계에서 출력용으로 표시되는 임시 Column 제목
-- Column 뒤에 별칭, Column 뒤에 as, 표시명에 특수문자나 공백이 있다면 ""으로 묶어주기(대소문자 합친그대로 출력하고 싶을때도 묶어주기)
--                                                                              -> 아래 empNo 그냥 쓰면 EMPNO대문자로 출력되고, ""로 묶어주면 내가 쓴 그대로 출력된다.

-- 직원 아이디, 이름, 급여 별칭 부여해서 출력하기 empNo, f-name, 월급
SELECT employee_id "empNo", first_name "f-name" , salary 월급 FROM employees; 

-- first_name,  last_name으로 구분되어 있는 직원 이름을 하나로 합쳐서 출력하기
-- Commission 이 포함된 급여, 연봉을 별칭으로 표기해서 출력하기
-- 문자열 합치기는 ||을 사용한다.
SELECT first_name ||' '|| last_name "FULL NAME", salary + salary * NVL(commission_pct, 0) "급여(Commission포함)", salary * 12 연봉 FROM employees;
SELECT '이름: '||first_name||' '||last_name 이름, '입사일: '||hire_date 입사일, '전화번호: '||phone_number 전화번호, '급여: '||salary 급여, '연봉: '||salary * 12 연봉 FROM employees;

-- 사원정보로부터 사번, 이름, 성 출력하기
SELECT employee_id, first_name, last_name FROM employees;





------------------------------------------------------
-- WHERE
-- 특정 조건을 기준으로 레코드를 선택( SELECTION)
-- 비교연산 : =, <>, >, >=, <, <=

-- 사원들 중 급여가 15,000 이상인 직원의 이름과 급여
SELECT first_name, salary FROM employees WHERE salary >= 15000;

-- 입사일이 07/01/01 이상인 직원들의 이름과 입사일 출력하기
SELECT first_name, hire_date FROM employees WHERE hire_date > '17/01/01';

-- 급여가 14,000 이하이거나, 17,000 이상인 직원의 이름과 급여 출력하기
-- 둘 중 하나만 맞으면 출력 : OR 
SELECT first_name, salary FROM employees WHERE salary <= 4000 OR salary >= 17000; 

-- 급여가 14,000 이상이고, 17,000 미만인 사원의 이름과 급여 : AND
SELECT first_name, salary FROM employees WHERE salary >= 14000 AND salary < 17000;

-- 급여가 14,000 이상이고, 17,000 이하인 사원의 이름과 급여 : BETWEEN(범위비교)
SELECT first_name, salary FROM employees WHERE salary BETWEEN 14000 AND 17000;

-- NULL 체크할때 =,<> 사용하지 않고 -> IS NULL, IS NOT NULL 사용해서 비교해주기
-- Commission을 받지 않는 상황일때 -> Commission 데이터가 NULL 일 때
SELECT first_name, commission_pct FROM employees WHERE commission_pct IS NULL;
-- Commission을 받는 상황일때 -> Commission 데이터가 NULL 이 아닐 때
SELECT first_name, commission_pct FROM employees WHERE commission_pct IS NOT NULL;

-- IN 연산자 : 특정 집합의 요소와 비교
-- 직원들 중 10, 20, 40 부서에서 근무하는 직원들의 이름과 부서 아이디 출력하기
-- 두가지 방법 다 가능~
SELECT first_name, department_id FROM employees WHERE department_id = 10 OR department_id = 20 OR department_id = 40;
SELECT first_name, department_id FROM employees WHERE department_id IN(10, 20, 40);





------------------------------------------------------
-- LIKE 연산
-- WILDCARD(%, _)를 이용한 부분 문자열 매핑
-- % : 0개 이상의 정해지지 않은 문자열
-- _ : 1개의 정해지지 않은 문자열

-- 이름에 am을 포함하고 있는 사원의 이름과, 급여 출력하기
SELECT first_name, salary FROM employees WHERE LOWER(first_name) LIKE'%am%';

-- 이름에 두번째 글자가 a인 사원의 이름과 급여 출력하기
SELECT first_name, salary FROM employees WHERE LOWER(first_name) LIKE'_a%';

-- 이름의 네번째 글자가 a인 사원의 이름과 급여 출력하기
SELECT first_name, salary FROM employees WHERE LOWER(first_name) LIKE'___a%';

--이름이 네글자인 사원들 중에서 두번째 글자가 a인 사원의 이름과 급여 출력하기





------------------------------------------------------
-- 산술연산 : 기본적인 산술연산을 수행할 수 있다.
-- 특정 테이블의 값이 아닌 Oracle System 으로부터 데이터를 받아오고 싶을 때 : dual(가상 테이블)사용 -> 값만 출력됨
SELECT 3.14159 * 10 * 10 FROM dual;

-- NULL
-- 이름, 급여, 커미션비율 출력하기
SELECT first_name, salary, commission_pct FROM employees;

-- 이름, 급여, 커미션을 포함한 급여 출력하기
SELECT first_name, salary, commission_pct, salary + salary * commission_pct FROM employees; 
-- NULL이 포함된 연산식의 결과는 NULL -> NULL 을 처리하기 위한 NVL이 필요
-- NVL(표현식1, 표현식2) : 표현식1이 NULL일 경우 표현식2가 출력됨
-- NVL
SELECT first_name, salary, commission_pct, salary + salary * NVL(commission_pct, 0) FROM employees;





-- 만약 특정 COLUMN 의 값을 산술 연산에 포함하고 싶다면?
SELECT first_name, salary, salary * 12 FROM employees;

-- 아래는 왜 오류가 발생할까?
SELECT first_name, job_id, job_id * 12 FROM employees;
-- 오류의 원인
DESCRIBE employees;
-- 문자열을 산술연산에 집어넣었기 때문, 수치가 아니면 계산되지 않는다.
