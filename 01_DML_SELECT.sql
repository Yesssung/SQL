-- SQL 문장의 주석
-- SQL 문장은 마지막에 ;(세미콜론) 으로 끝난다.
-- SQL 문장의 키워드들 테이블명, 콜럼들은 대소문자 구분하지 않는다.
-- 실제 데이터의 경우 대소문자를 구분

-- 테이블 구조 확인 (DESCRIBE)
DESCRIBE employees;
DESCRIBE departments;
DESCRIBE locations;

-- 문법 순서 (SELECT -> FROM -> WHERE -> ORDER BY) 
-- 선 필터링 후 정렬 -> WHERE절과 ORDER BY절의 순서가 바뀌면 안됌!
-- SELECT projection_columns FROM table_list WHERE selecrion_condition ORDER BY sorting_column[ASC/DESC]

-------------------------------------------------------------------------------
-- DML(Data Manipulation Language): 조작어
-- SELECT
-- * : 테이블 내에 모든 COLUMN을 PROJECTION , 테이블 설계시에 정의한 순서대로 출력
-------------------------------------------------------------------------------

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
------------------------------------------------------

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




-------------------------------------
-- IN 연산자 : 특정 집합의 요소와 비교
-------------------------------------

-- 직원들 중 10, 20, 40 부서에서 근무하는 직원들의 이름과 부서 아이디 출력하기
-- 두가지 방법 다 가능~
SELECT first_name, department_id FROM employees WHERE department_id = 10 OR department_id = 20 OR department_id = 40;
SELECT first_name, department_id FROM employees WHERE department_id IN(10, 20, 40);





------------------------------------------------------
-- LIKE 연산
-- WILDCARD(%, _)를 이용한 부분 문자열 매핑
-- % : 0개 이상의 정해지지 않은 문자열
-- _ : 1개의 정해지지 않은 문자열
------------------------------------------------------

-- 이름에 am을 포함하고 있는 사원의 이름과, 급여 출력하기
SELECT first_name, salary FROM employees WHERE LOWER(first_name) LIKE'%am%';

-- 이름에 두번째 글자가 a인 사원의 이름과 급여 출력하기
SELECT first_name, salary FROM employees WHERE LOWER(first_name) LIKE'_a%';

-- 이름의 네번째 글자가 a인 사원의 이름과 급여 출력하기
SELECT first_name, salary FROM employees WHERE LOWER(first_name) LIKE'___a%';

-- 이름이 네글자인 사원들 중에서 두번째 글자가 a인 사원의 이름과 급여 출력하기
SELECT first_name, salary FROM employees WHERE first_name LIKE'_a__';

-- 부서 ID가 90인 사원 중, 급여가 20,000이상인 사원은 누구?
SELECT first_name, department_id, salary FROM employees WHERE salary >= 20000 AND department_id = 90;

-- 입사일이 11/01/01 ~ 17/12/31 구간에 있는 사원의 목록
SELECT first_name, hire_date, salary FROM employees WHERE hire_date BETWEEN '11/01/01' AND '17/12/31';
SELECT first_name, hire_date, salary FROM employees WHERE hire_date >= '11/01/01' AND hire_date <= '17/12/31';

-- manager_id가 100, 120, 147인 사원의 명단
-- 1. 비교연산자 + 논리연산자의 조합
-- 2. IN 연산자 이용
-- 두 쿼리를 비교
SELECT employee_id, first_name, manager_id FROM employees WHERE manager_id IN(100, 120, 147);
SELECT first_name, manager_id FROM employees WHERE manager_id = 100 OR manager_id = 120 OR manager_id = 147;




--------------------------------------------------
-- ORDER BY : 주어진 Column 리스트의 순서로 결과를 정렬
-- ASC : 오름차순(작은 값 -> 큰 값) - default
-- DESC : 내림차순(큰 값 -> 작은 값)
-- 여러개의 Column에 적용할 수 있고 , 로 구분한다.
-- 정렬기준(순서)을 어떻게 세우느냐에 따라서 성능과 출력결과에 영향을 미친다. 
--------------------------------------------------

SELECT first_name, salary FROM employees ORDER BY salary DESC;
SELECT first_name, salary FROM employees WHERE salary >= 9000 ORDER BY salary DESC;

-- 부서 번호를 오름차순으로 정렬하고 부서번호, 급여, 이름을 출력하기
SELECT department_id, salary, first_name FROM employees ORDER BY department_id ASC;
-- 어차피 ASC는 default 값이기 때문에 생략 가능
SELECT department_id, salary, first_name FROM employees ORDER BY department_id;

-- 급여가 10,000 이상인 직원의 이름을 급여 내림차순으로 출력하기
SELECT first_name, salary FROM employees WHERE salary >= 10000 ORDER BY salary DESC; 

-- 부서번호, 급여, 이름 순으로 출력하되 부서번호 오름차순, 급여 내림차순으로 출력하기
SELECT department_id, salary, first_name FROM employees ORDER BY department_id ASC, salary DESC;




------------------------------------------------------
-- 단일행 함수
-- 단일 레코드를 기준으로 특정 Column의 값에 적용하는 함수
------------------------------------------------------

-- 문자열 단일행 함수
SELECT first_name, last_name FROM employees;

-- CONCAT : 문자열 연결 -> full name 출력하기
SELECT first_name, last_name, CONCAT(first_name, CONCAT(' ', last_name))  FROM employees;
    
-- INITCAP :  각 단어의 첫번째 글자를 대문자로
SELECT first_name, last_name, INITCAP(first_name ||' '|| last_name) FROM employees;

-- UPPER, LOWER : 모두 대문자로, 모두 소문자로
SELECT first_name, last_name, LOWER(first_name), UPPER(first_name) FROM employees;

-- LPAD, RPAD : 왼쪽 빈공간 숫자만큼 저 문자로 채움, 오른쪽 빈공간 동일
SELECT first_name, last_name, LPAD(first_name, 20, '*'), RPAD(first_name, 20, '*') FROM employees;

-- LTRIM, RTRIM : 왼쪽 빈 공간 삭제, 오른쪽 빈 공간 삭제
SELECT '     ORACLE     ', '*****DATABASE*****', LTRIM('     ORACLE     '), RTRIM('     ORACLE     ') FROM dual;

-- TRIM : 압뒤 잡음 문자 삭제
SELECT '     ORACLE     ', '*****DATABASE*****', LTRIM('     ORACLE     '), RTRIM('     ORACLE     '), TRIM('*' FROM '*****DATABASE*****') FROM dual;

-- SUBSTR : 어떤 문자열에서 부분적으로 출력 -> 8번째글자부터 뒤에 네글자 출력 / 뒤에서부터 출력하고 싶으면 - 부호 붙이면 되지유
SELECT '     ORACLE     ', '*****DATABASE*****', LTRIM('     ORACLE     '), RTRIM('     ORACLE     '), TRIM('*' FROM '*****DATABASE*****'), SUBSTR('Oracle Database', 8, 4) FROM dual;
SELECT '     ORACLE     ', '*****DATABASE*****', LTRIM('     ORACLE     '), RTRIM('     ORACLE     '), TRIM('*' FROM '*****DATABASE*****'), SUBSTR('Oracle Database', -8, 4) FROM dual;

-- LENGTH : 문자열의 길이 출력하기
SELECT '     ORACLE     ', '*****DATABASE*****', LTRIM('     ORACLE     '), RTRIM('     ORACLE     '), TRIM('*' FROM '*****DATABASE*****'), SUBSTR('Oracle Database', 8, 4), LENGTH('Oracle Database') FROM dual;


-- 숫자형 단일행 함수
SELECT 3.14159 FROM dual;

-- ABS : 절대값 함수
SELECT 3.14159, ABS(-3.14) FROM dual;

-- CEIL, FLOOR : 올림, 내림
SELECT 3.14159, CEIL(3.14), FLOOR(3.14) FROM dual;

-- ROUND : 뒤에 숫자만큼 자리까지 반올림 -> 2라면 두번째 자리까지 출력되야 함
SELECT round(3.14159, 2) FROM dual;
SELECT round(3.14159, 0) FROM dual;
SELECT round(3.14159, -1) FROM dual;

-- TRUNC : 버림 함수 -> 뒤에 숫자만큼 출력되고 나머지는 다 버려용
SELECT 3.14159, TRUNC(3.14159, 3) FROM dual;

-- SIGN : 부호 함수(-1: 음수, 0: 0, 1: 양수)
SELECT 3.14159, SIGN(-3.14159) FROM dual;

-- MOD : 나머지 함수 -> 예시는 7을 3으로 나누면? 1나오즁..
SELECT 3.14159, MOD(7, 3) FROM dual;

-- POWER : 제곱함수 -> 예시는 2의 4제곱
SELECT 3.14159, POWER(2, 4) FROM dual;





-----------------------------------------
-- DATE FORMAT
-- RR/MM/DD : 년 월 일
-----------------------------------------

-- 현재 세션 정보 확인
SELECT * FROM nls_session_parameters;

-- 현재 날짜 포맷이 어떻게 되는가?
-- 딕셔너리를 확인하세유
SELECT value FROM nls_session_parameters
WHERE parameter='NLS_DATE_FORMAT';

-- 현재 날짜 : SYSDATE -> 일반적으로는 가상테이블 사용해서 날짜 출력
SELECT sysdate FROM dual;
SELECT sysdate FROM employees;


-- 날짜 관련 단일행 함수
SELECT sysdate, 
    ADD_MONTHS(sysdate, 2),                     -- 현재 MONTH로 부터 2개월이 지난 후 날짜
    LAST_DAY(sysdate),                          -- 현재 달의 마지막 날
    MONTHS_BETWEEN('12/09/24', sysdate),        -- 두 날짜 사이의 개월수
    NEXT_DAY(sysdate, '금'),                    -- sysdate 이후에 첫 요일의 날짜 (설정이 korean이기 때문에 한글 쳐야함!)
    ROUND(sysdate, 'MONTH'),                    -- 오늘은 4/25일 반올림해서 5월이 되버림
    TRUNC(sysdate, 'MONTH')                     -- 오늘은 4/25일 일수는 버린다. -> 4월1일 됨! 
FROM dual;

SELECT first_name, hire_date, ROUND (MONTHS_BETWEEN(sysdate, hire_date)) as 근속월수 FROM employees;





------------------------------------
-- 변환함수
------------------------------------
-- TO_NUMBER(s, fmt) : 문자열 -> 숫자
-- TO_DATE(s, fmt) : 문자열 ->  날짜
-- TO_CHAR(o, fmt) : 숫자, 날짜 -> 문자열

-- YYYY-MM-DD
SELECT first_name, 
    TO_CHAR(hire_date, 'YYYY-MM-DD' )
FROM employees;

-- 현재시간을 년-월-일 시:분:초 로 표시
SELECT sysdate, 
    TO_CHAR(sysdate, 'YYYY-MM-DD HH:MI:SS' )
FROM dual;

-- 단위마다 , 구분해주기
SELECT TO_CHAR(3000000, 'L999,999,999.99')
FROM dual;

-- 모든 직원의 이름과 연봉 정보를 표시해서 출력하기
SELECT first_name, salary, commission_pct,
    TO_CHAR((salary + salary * NVL(commission_pct, 0)) * 12, '$999,999,999.99' )연봉
FROM employees;

-- TO_NUMBER : 문자 ->  숫자(나누기 12는 숫자형으로 바뀌었는지 확인하기 위해)
SELECT '$57,600', TO_NUMBER('$57,600', '$999,999.00') / 12 월급 FROM dual;

-- TO_NUMBER : 문자 ->  날짜
SELECT '2012-09-24 13:48:00', TO_DATE('2012-09-24 13:48:00', 'YYYY-MM-DD HH24:MI:SS') FROM dual;





------------------------------------------------------
-- 산술연산 : 기본적인 산술연산을 수행할 수 있다.
------------------------------------------------------

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
