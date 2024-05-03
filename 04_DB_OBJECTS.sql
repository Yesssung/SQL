-----------------------------------------------------
-- DB OBJECTS
-- VIEW(SIMPLE, COMPLEX), INDEX, SEQUENCE, SYNONYM
-----------------------------------------------------
-- SYSTEM 으로 진행
-- VIEW 생성을 위한 SYSTEM 권한
GRANT create view TO himedia;

GRANT select ON HR.employees TO himedia;
GRANT select ON HR.departments TO himedia;

-- himedia로 돌아가기

-- SIMPLE VIEW : 단일 테이블 혹은 단일 뷰를 베이스로 한 함수, 연산식을 포함하지 않은 VIEW
-- SIMPLE VIEW 는 특별한 제한상황이 없다면 INSERT, UPDATE, DELETE를 할 수 있다.

-- EMP123 TABLE
DESC emp123;

-- EMP123 TABLE을 기반함 -> DEPARTMENT_ID = 10 -> 10번 부서 소속 사원만 조회하는 VIEW
CREATE OR REPLACE VIEW emp10
    AS SELECT employee_id, first_name, last_name, salary FROM emp123
    WHERE department_id = 10;
    
SELECT * FROM tabs;
-- 일반 테이블처럼 활용할 수 있다
DESC emp10;
SELECT * FROM emp10;
SELECT first_name||' '||last_name, salary FROM emp10;

-- SIMPLE VIEW 는 INSERT, UPDATE, DELETE 가능
UPDATE emp10 SET salary = salary * 2;
SELECT * FROM emp10;
ROLLBACK;

-- 가급적이면 VIEW는 조회용도로만 활용하게끔 READ ONLY 해야함
-- WITH READ ONLY : 읽기 전용 VIEW -> 내용 수정 불가
CREATE OR REPLACE VIEW emp10 
    AS SELECT employee_id, first_name, last_name, salary FROM emp123
    WHERE department_id = 10
    WITH READ ONLY;
    
UPDATE emp10 SET salary = salary * 2;  -- WITH READ ONLY 했기 때문에 더이상 수정 불가

-- COMPLEX VIEW : 한개 혹은 여러개의 테이블 혹은 VIEW에 JOIN, 함수, 연산식 등을 활용한 VIEW
-- 특별한 경우가 아니면 INSERT, UPDATE, DELETE 불가
CREATE OR REPLACE VIEW emp_detail (employee_id, employee_name, manager_name, department_name)
    AS SELECT emp.employee_id,
              emp.first_name||' '||emp.last_name,
              man.first_name||' '||man.last_name,
              dept.department_name
    FROM HR.employees emp   -- 권한만 받은거지 스키마 자체를 넘겨받은것이 아니기 때문에 앞에 HR 붙여줘야 한다.
              JOIN HR.employees man ON emp.employee_id = man.employee_id
              JOIN HR.departments dept ON emp.department_id = dept.department_id;
              
DESC emp_detail;
SELECT * FROM emp_detail;

-- VIEW 를 위한 DICTIONARY : VIEWS
SELECT * FROM USER_VIEWS;
SELECT * FROM USER_OBJECTS; -- VIEW를 포함 모든 DB객체들의 정보

-- DROP : VIEW  삭제
-- VIEW를 삭제해도 기반 테이블 데이터를 삭제되지 않는다.
DROP VIEW emp_detail;
SELECT * FROM USER_VIEWS ;




-----------------------------------
-- INDEX
-----------------------------------
-- HR.EMPLOYEES 테이블 복사 S_EMP 테이블 만들기!

CREATE TABLE s_emp AS SELECT * FROM HR.employees;

DESC s_emp;
SELECT * FROM s_emp;

-- s_emp 테이블의 employee_id에 UNIQUE INDEX 만들기!
CREATE UNIQUE INDEX s_emp_id_pk ON s_emp (employee_id); 

-- 사용자가 가지고 있는 INDEX 확인
SELECT * FROM USER_INDEXES;
-- 어느 INDEX 가 어느 COLUMN에 걸려있는지 확인하기
SELECT * FROM USER_IND_COLUMNS;

-- 어느 INDEX 어느 COLUMN에 걸려있는지 JOIN해서 알아보기
SELECT t.INDEX_NAME, t.TABLE_NAME, c.COLUMN_NAME, c.COLUMN_POSITION FROM USER_INDEXES t 
JOIN USER_IND_COLUMNS c ON t.INDEX_NAME = c.INDEX_NAME 
WHERE t.TABLE_NAME = 'S_EMP';




---------------------
-- SEQUENCE
---------------------

SELECT * FROM author;

-- 새로운 레코드를 추가 겹치치 않는 유일한 PK가 필요
-- 아래 같이 해도 되긴 함 개발 테스트, 서비스시행 시에도 사용자가 별로 없다면..
-- 문제 없음 but 사용자가 많아질수록 오류 발생 가능성
INSERT INTO author (author_id, author_name) VALUES ((SELECT MAX(author_id) +1 FROM author),'이문열'); 

SELECT * FROM author;
ROLLBACK;

-- 순차 객체 SEQUENCE
CREATE SEQUENCE seq_author_id START WITH 4 INCREMENT BY 1 MAXVALUE 1000000;

-- PK는 SEQUENCE 객체로부터 생성
INSERT INTO author(author_id, author_name, author_desc) VALUES(seq_author_id.NEXTVAL, '스티븐 킹', '쇼생크 탈출');

SELECT * FROM author;

SELECT seq_author_id.CURRVAL FROM dual;

-- 새 시퀀스 생성
CREATE SEQUENCE my_seq START WITH 1 INCREMENT BY 1 MAXVALUE 10;
SELECT my_seq.NEXTVAL FROM dual;        -- 다음 시퀀스 추출 가상 컬럼
SELECT my_seq.CURRVAL FROM dual;        -- 시퀀스의 현재 상태

-- 시퀀스 수정
ALTER SEQUENCE my_seq INCREMENT BY 2 MAXVALUE 1000000;

SELECT my_seq.CURRVAL FROM dual;
SELECT my_seq.NEXTVAL FROM dual;

-- 시퀀스를 위한 딕셔너리
SELECT * FROM USER_SEQUENCES;

SELECT * FROM USER_OBJECTS WHERE OBJECT_TYPE = 'SEQUENCE';

-- 시퀀스 삭제
DROP SEQUENCE my_seq;

SELECT * FROM USER_SEQUENCES;

-- BOOK 테이블의 PK의 현재 값 확인
SELECT max(book_id) FROM book;

CREATE SEQUENCE seq_book_id START WITH 3 INCREMENT BY 1 MAXVALUE 1000000 NOCACHE;







                       
    
    
    



































