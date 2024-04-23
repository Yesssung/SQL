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

-- 사원정보로부터 사번, 이름, 성 출력하기
SELECT employee_id, first_name, last_name FROM employees;

-- 산술연산 : 기본적인 산술연산을 수행할 수 있다.
-- 특정 테이블의 값이 아닌 Oracle System 으로부터 데이터를 받아오고 싶을 때 : dual(가상 테이블)사용 -> 값만 출력됨
SELECT 3.14159 * 10 * 10 FROM dual;

-- 만약 특정 COLUMN 의 값을 산술 연산에 포함하고 싶다면?
SELECT first_name, salary, salary * 12 FROM employees;

-- 아래는 왜 오류가 발생할까?
SELECT first_name, job_id, job_id * 12 FROM employees;
-- 오류의 원인
DESCRIBE employees;
-- 문자열을 산술연산에 집어넣었기 때문, 수치가 아니면 계산되지 않는다.
