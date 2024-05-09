-- MySQL은 사용자와 Database를 구분하는 DBMS
SHOW databases;

-- Database 사용 선언해줘야 함
USE sakila; 	-- 우린 이제 sakila Database를 사용하겠다.

-- sakila Database 내에 어떤 Table이 있는가? 확인하기!
SHOW tables;

-- Table 구조 확인 
DESCRIBE actor;

-- 간단한 Query 진행하기
SELECT version(), CURRENT_DATE();
SELECT version(), CURRENT_DATE() FROM dual;

-- 특정 Table의 data 조회하기
SELECT * FROM actor;

-- Database 생성
-- webdb 라는 Database 생성하기
CREATE DATABASE webdb;
-- 시스템 설정에 좌우되는 경우가 많다. 

-- 문자셋(charset), 정렬 방식을 명시적으로 지정하는 것이 좋다.
CREATE DATABASE webdb CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci;
SHOW DATABASES;

-- 사용자 만들기
CREATE USER 'dev'@'localhost' IDENTIFIED BY 'dev';
-- 사용자 비밀번호 변경
-- ALTER USER 'dev'@'localhost' IDENTIFIED BY 'new_password';
-- 사용자 삭제
-- DROP USER 'dev'@'localhost';

-- 권한 부여
-- GRANT 권한 목록 ON 객체 TO '계정'@'접속 호스트';
-- 권한 회수
-- REVOKE 권한 목록 ON 객체 FROM '계정'@'접속 호스트';

-- 'dev'@'localhost'에게 webdb 데이터베이스의 모든 객체에 대한 모든 권한 허용 -> ALL PRIVILEGES(= SELECT, INSERT, UPDATE, DELETE) 하면 괄호 안에 네가지 권한을 부여한것과 같다.
--  webdb.* -> webdb 관련 모든 테이블
GRANT ALL PRIVILEGES ON webdb.* TO 'dev'@'localhost';
-- REVOKE ALL PRIVILEGES ON webdb.* FROM 'dev'@'localhost';


-- 데이터베이스 확인
SHOW DATABASES;
USE webdb;


------------------------------
-- table 만들기alter
------------------------------
-- Author Table 생성
CREATE TABLE author ( author_id int PRIMARY KEY, 
					  author_name VARCHAR(50) NOT NULL,
                      author_desc VARCHAR(500));
                      
SHOW TABLES;
DESC author;


-- 테이블 생성정보를 확인하고 싶다면?
SHOW CREATE TABLE author;

-- book 테이블 생성
CREATE TABLE book ( book_id int PRIMARY KEY,
					title VARCHAR(100) NOT NULL,
					pubs VARCHAR(100),
                    pub_date DATETIME DEFAULT now(),
                    author_id int, CONSTRAINT fk_book FOREIGN KEY(author_id) REFERENCES author(author_id));

SHOW TABLES;
DESC book;


-------------------------
-- INSERT 새로운 레코드 삽입
-- 묵시적 & 명시적
-------------------------
-- 묵시적 방법 : CLOUMN 목록을 제공하지 않는다. -> 테이블 생성시 선언된 COLUMN의 순서대로 레코드 삽입됌!
INSERT INTO author VALUES (1, '박경리', '토지 작가');
-- 명시적 방법 : COLUMN 목록을 제공한다. -> COLUMN 목록의 숫자, 순서, 타입이 값 목록의 숫자, 순서, 타입과 일치해야 한다.
INSERT INTO author (author_id, author_name) VALUES (2, '김영하');
SELECT * FROM author;


--------------------------------
-- TRANSACTION
--------------------------------
-- My SQL 은 기본적으로 자동 COMMIT이 활성화 되어 있다.
-- AUTOCOMMIT 을 비활성화 하고 싶다면? -> AUTOCOMMIT 옵션을 0으로 설정 해줘야 한다.
SET autocommit = 0;
-- SET autocommit = 1; -> 다시 활성화 가능

-- MySQL은 명시적 트랜잭션(TRANSACTION)을 수행한다. 
START transaction;
SELECT * FROM author;

-- UPDATE author SET author_desc = '알쓸신잡 출연'; -- -> WHERE절이 없으면 전체 레코드가 변경된다. -> BUT MYSQL에서 막아놨다. 
UPDATE author SET author_desc = '알쓸신잡 출연' WHERE author_id = 2; -- -> 밑에서 ROLLBACK 해서 반영 취소됨
SELECT * FROM author;

-- ROLLBACK; -> 변경사항 반영 취소 

UPDATE author SET author_desc = '알쓸신잡 출연' WHERE author_id = 2;
SELECT * FROM author;

COMMIT; -- -> 변경사항 영구 반영
SELECT * FROM author;


---------------------------------------------------
-- AUTO_INCREMENT : 연속된 순차정보, 주로 PK 속성에 사용
---------------------------------------------------
-- author 테이블의 PK에 AUTO_INCREMENT 속성 부여하기 -> 실패 왜냐면 기존에 있던 기본키를 삭제하지 않았기 때문이지
ALTER TABLE author MODIFY author_id INT AUTO_INCREMENT PRIMARY KEY;

-- 1. 외래키(FOREIGN KEY) 정보 확인하기
SELECT * FROM information_schema.KEY_COLUMN_USAGE;
SELECT constraint_name FROM information_schema.KEY_COLUMN_USAGE WHERE table_name = 'book';
-- 2. 외래키 삭제하기 -> book 테이블의 FK(fk_book)
ALTER TABLE book DROP FOREIGN KEY fk_book;
-- 3. author 의 PK에 AUTO_INCREMENT 속성 설정하기 -> 기존 PK 먼저 삭제
ALTER TABLE author DROP PRIMARY KEY;
ALTER TABLE author MODIFY author_id INT AUTO_INCREMENT PRIMARY KEY;
-- 4. book 테이블의 author_id에 FOREIGN KEY 다시 연결
ALTER TABLE book ADD CONSTRAINT fk_book FOREIGN KEY (author_id) REFERENCES author(author_id);

-- AUTOCOMMIT 다시 켜주기
SET autocommit = 1;

SELECT * FROM author;

-- 새로운 AUTO_INCREMENT 값을 부여하기 위해 PK 최댓값을 구하기
SELECT MAX(author_id) FROM author;

-- 새로 생성되는 AUTO_INCREMENT 시작 값을 변경할 필요 있
ALTER TABLE author AUTO_INCREMENT = 3; -- -> 시작값은 3번 부터 순서대로 -> 이제 굳이 author_id 순서 값 매겨줄 필요 없음
DESC author;

SELECT * FROM author;
INSERT INTO author (author_name) VALUES ('스티븐 킹');
INSERT INTO author (author_name, author_desc) VALUES ('류츠신', '삼체 작가');
SELECT * FROM author;

-- 테이블 생성시 AUTO_INCREMENT 속성을 부여하는 방법 -> 테이블 생성시 PK 설정할때 "INT AUTO_INCREMENT PRIMARY KEY" 기본이라고 생각하고 넣어주기
DROP TABLE book CASCADE;

CREATE TABLE book ( book_id INT AUTO_INCREMENT PRIMARY KEY, 
					title VARCHAR(100) NOT NULL,
                    pubs VARCHAR(100),
                    pub_date DATETIME DEFAULT now(),
                    author_id INT, 
                    CONSTRAINT book_fk FOREIGN KEY (author_id) REFERENCES author(author_id));

INSERT INTO book (title, pub_date, author_id) VALUES ('토지', '1994-03-04', 1);
INSERT INTO book (title, author_id) VALUES ('살인자의 기억법', 2);
INSERT INTO book (title, author_id) VALUES ('쇼생크 탈출', 3);
INSERT INTO book (title, author_id) VALUES ('삼체', 4);
SELECT * FROM book; -- -> 날짜 default 가 현재 시간이기 때문에 따로 설정해주지 않는 경우 그냥 현재시간이 출력된다.


----------------
-- JOIN
----------------
SELECT title 제목, pub_date 출판일, author_name 저자, author_desc '저자 상세' FROM book b JOIN author a ON a.author_id = b.author_id;
