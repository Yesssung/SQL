-----------------------------------
-- DCL & DDL
-----------------------------------
-- 사용자 생성
-- CREATE USER 권한이 있어야 한다.
-- system 계정으로 수행
-- connect system/manager 

-- himedia라는 이름의 계정을 만들고 비밀번호 himedia로 설정해보기
CREATE USER himedia IDENTIFIED BY himedia;


-- 권한 부여, 회수
-- 부여: GRANT 시스템 권한 목록 TO 사용자|역할|PUBLIC [WITH ADMIN OPTION] -> 시스템권한부여
-- 회수: REVOKE 회수 할 권한 FROM 사용자|역할|PUBLIC

-- GRANT 객체 개별권한 |ALL ON 객체명 TO 사용자|역할|PUBLIC [WITH ADMIN OPTION]
-- REVOKE 회수할 권한 ON 객체명 FROM 사용자|역할|PUBLIC


-- 1.
-- Oracle ver.18 부터 Container Database 개념 도입
-- 사용자 계정 생성: 사용자 계정 C## 붙이고 만들기
CREATE USER C##HIMEDIA IDENTIFIED BY himedia;
-- 비밀번호 변경: ALTER USER
ALTER USER C##HIMEDIA IDENTIFIED BY new_password;
-- 사용자 계정 삭제: DROP USER -> CASCADE : 폭포수 OR 연결된 것 의미
DROP USER C##HIMEDIA CASCADE;

-- 2.
-- CD 기능 무력화 -> 비추천
-- 사용자 계정 생성
ALTER SESSION SET "_ORACLE_SCRIPT" = true;
CREATE USER himedia IDENTIFIED BY himedia;

-- 여기까지 해도 아직 접속 불가상태
-- 데이터베이스 접속, 테이블 생성 데이터베이스 객체 작업을 수행 -> CONNECT, RESOURCE ROLE
GRANT CONNECT, RESOURCE TO himedia;     -- -> CONNECT 역할과 RESOURCE 역할을 HIMEDIA에 부여한다.
-- 이제 cmd에서 sqlplus himedia/himedia 로 접속 가능
-- CREATE TABLE test(a NUMBER);         -- a 속성의 test 테이블을 만들거얌
-- DESCRIBE test;                       -- 테이블 test의 구조보기

-- HIMEDIA 계정으로 수행
-- 데이터 추가하기
DESCRIBE test;
INSERT INTO test VALUES (2024);         -- test라는 테이블에 2024라는 정보 입력해라
-- USERS 테이블 스페이스에 대한 접근 권한이 없기 때문에 실행 불가상태
-- ORACLE 18 이상에서 발생하는 문제
-- SYSTEM 계정으로 수행해야 함
ALTER USER himedia DEFAULT TABLESPACE USERS QUOTA unlimited on USERS;   -- TABLE SPACE 권한 부여 완
-- HIMEDIA로 복귀
INSERT INTO test VALUES (2024);
SELECT * FROM test;

SELECT * FROM USER_USERS;           -- 현재 로그인 한 사용자 정보(나)
SELECT * FROM ALL_USERS;            -- 모든 사용자 정보
-- DBA 전용(SYSDBA로 로그인 해야 확인 가능)
-- CMD에서 sqlplus sys/oracle as sysdba
SELECT * FROM DBA_USERS;

-- 시나리오: HR 스키마의 employees table 조회 권한을 himedia에게 부여하고자 한다면
-- HR 스키마의 owner -> HR
-- HR 계정으로 접속 진행
GRANT select ON employees TO himedia; -- employees 테이블에 있는 select권한을 himedia에 부여하겠다. 

-- HIMEDIA로 돌아오기
SELECT * FROM hr.employees;           -- himedia 는 HR의 employees를 select할 수 있는 권한만 부여받음.
SELECT * FROM hr.departments;         -- departments 에 대한 권한을 부여받지 않았기 때문에 select할 수 없음.

-- 현재 사용자에게 부여된 역할(ROLE)의 확인
SELECT * FROM USER_ROLE_PRIVS;

-- CONNECT & RESOURCE 역할은 어떤 권한으로 구성되어 있나?
-- sysdba로 진행하기
-- cmd에서
-- sqlplus sys/oracle as sysdba
-- desc role_sys_privs;
-- CONNECT ROLE에는 어떤 권한이 포함되어 있나?
-- SELECT privilege FROM role_sys_privs WHERE role='CONNECT';
-- RESOURCE ROLE에는 어떤 권한이 포함되어 있나?
-- SELECT privilege FROM role_sys_privs WHERE role='RESOURCE';






----------------------------
-- DDL
----------------------------
-- 스키마 내의 모든 테이블을 확인
SELECT * FROM tabs;                 -- tabs : 테이블 정보 DICTIONARY

-- 1.
-- 기본 테이블 생성 -> CREATE TABLE
CREATE TABLE book(
    book_id NUMBER(5),
    title VARCHAR(50),
    author VARCHAR(10),
    pub_date DATE DEFAULT SYSDATE
);
-- 테이블 정보 확인
DESC book;




-- 2.
-- SUBQUERY 를 이용한 테이블 생성 -> SUBQUERY
SELECT * FROM hr.employees;

-- HR.EMPLOYEES 테이블에서 job_id가 IT 관련된 직원의 목록으로 새 테이블을 생성
SELECT * FROM hr.employees WHERE job_id LIKE 'IT_%';

CREATE TABLE emp_it AS(
    SELECT * FROM hr.employees WHERE job_id LIKE 'IT_%'
);
-- SUBQUERY 로 생성한 테이블은 NOT NULL 제약 조건만 물려받음

SELECT * FROM tabs;

DESC EMP_IT;




-- 3. 
-- 테이블 삭제하는 방법
-- DROP
DROP TABLE emp_it;

SELECT * FROM tabs;

DESC book;




