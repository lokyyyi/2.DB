-- 행 번호 매겨보자
-- RANK(), DENSE_RANK() 함수
-- RANK() : 동일한 순번이 있을경우 이후의 순번은 이전 동일한 순번의 개수만큼 건너 뛰고 순번을 매기는 함수
SELECT EMP_NAME, 
	   SALARY,
	   RANK() OVER(ORDER BY SALARY DESC) '순위'
FROM EMPLOYEE;
-- 급여 TOP 3만 조회
SELECT EMP_NAME, 
	   SALARY,
	   RANK() OVER(ORDER BY SALARY DESC) '순위'
FROM EMPLOYEE;

SELECT *
FROM (SELECT EMP_NAME, 
	   SALARY,
	   RANK() OVER(ORDER BY SALARY DESC) 순위
	   FROM EMPLOYEE) TA
WHERE 순위 > 4;

SELECT EMP_NAME, 
	   SALARY,
	   RANK() OVER(ORDER BY SALARY DESC) '순위'
FROM EMPLOYEE
LIMIT 3;

-- DENSE_RANK() : 동일한 순번이 있을경우 순번에 영향을 미치지 않는 함수

SELECT EMP_NAME,
	   SALARY,
	   DENSE_RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;
	   
-- ROW_NUMBER() : 그냥 넘버링, 동일 순번은 무시, 1,2,3,4...

SELECT EMP_NAME,
	   SALARY,
	   ROW_NUMBER() OVER(ORDER BY SALARY DESC) 번호
FROM EMPLOYEE;

SET @ROWNO := 0;
SELECT @ROWNO := @ROWNO+1 AS ROWNUM, EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE;

-- ------------------------

-- 부서 별 급여 합계가 전체 부서의 급여 총합의 20%보다 많은 부서의 부서명과, 부서급여 합계를 조회


-- 단일행 서브쿼리
-- 1. 전체 급여 합계의 20% 조회
SELECT SUM(SALARY) * 0.2
FROM EMPLOYEE;

SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) > (
					  SELECT SUM(SALARY) * 0.2
					  FROM EMPLOYEE);

-- [2] 인라인뷰 활용
-- 서브쿼리
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT *
FROM (
	  SELECT DEPT_CODE, SUM(SALARY) SUMSAL
	  FROM EMPLOYEE
	  GROUP BY DEPT_CODE
	  ) TA
WHERE SUMSAL > (SELECT SUM(SALARY)*0.2 FROM EMPLOYEE);

-- 상호 연관 쿼리 : 상관 쿼리
-- 메인쿼리가 사용하는 컬럼값, 계산식 등을 서브쿼리에 적용하여 서브커리 실행 시 메인쿼리의 값도 함께 사용하는 방식

-- 사원의 직급에 따른 급여 평균보다 많이 받는 사원의 정보 조회

SELECT AVG(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;


SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE TA
WHERE SALARY > (
				SELECT AVG(SALARY)
				FROM EMPLOYEE TB 
				WHERE TA.JOB_CODE = TB.JOB_CODE
				);
				
-- 연습 (SELECT)
-- 모든 사원의 사번, 사원명, 관리자 사번, 관리자명을 조회
-- 관리자가 없으면 '없음' 조회, 단 SELECT 문에 서브쿼리를 사용하여 조회

SELECT EMP_ID, EMP_NAME, MANAGER_ID,
	   IFNULL((SELECT EMP_NAME FROM EMPLOYEE TB WHERE TA.MANAGER_ID = TB.EMP_ID),'없음') 관리자명
FROM EMPLOYEE TA
ORDER BY 4;

-- 상관커리 + 단일행 => 스칼라 서브쿼리 : 보통 SELECT 절에 많이 사용, SELECT LIST 라고도 함


-- DDL
-- CREATE : 데이터 베이스의 객체를 생성하는 DDL
-- [사용형식]
-- CREATE 객체형태 객체명 (관련 내용)

-- 예) 테이블 생성
-- CREATE TABLE TB_TEST(
--		컬럼 자료형(길이) 제약조건,
--		...
-- );

-- 제약조건 : 테이블에 데이터를 저장하고자 할 때 지켜야 하는 규칙
-- NOT NULL : NULL 값 허용 X (필수입력)
-- UNIQUE : 중복값을 허용하지 않는다
-- CHECK : 지정한 입력 사항 외에는 저장하지 못한다.
-- PRIMARY KEY(NOT NULL + UNIQUE) : 테이블 내에서 해당 ROW를 인식할 수 있는 고유의 값.
--									테이블 내에서 단 1개만 존재 할 수 있다.(주 식별자)
-- FOREIGN KEY : 다른 테이블에서 저장된 값을 연결지어서 참조로 가져오는 데이터에 지정하는 제약조건(외래키)

-- 테이블 생성
-- 데이터 저장을 위한 틀(객체)
-- 데이터들을 2차원의 표 형태로 담을 수 있는 객체

DROP TABLE MEMBER;

CREATE TABLE MEMBER(
	MEMBER_NO INT,
	MEMBER_ID VARCHAR(20),
	MEMBER_PWD VARCHAR(20),
	MEMBER_NAME VARCHAR(15) COMMENT '회원이름'
);

SELECT * FROM MEMBER;
SHOW TABLES;

-- 컬럼 주석 확인
SHOW FULL COLUMNS FROM MEMBER;

-- 컬럼에 주석 달기
ALTER TABLE MEMBER MODIFY MEMBER_NO INT COMMENT '회원번호';
ALTER TABLE MEMBER MODIFY MEMBER_ID VARCHAR(30) COMMENT '회원 아이디';

SHOW FULL COLUMNS FROM MEMBER;

SELECT TABLE_NAME, COLUMN_NAME, COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='MEMBER';

-- 컬럼타입
-- 숫자/문자/날짜
-- 숫자 : INT, INTEGER, FLOAT, DOUBLE, NUMBER
-- 문자 : CHAR, VARCHAR, TEXT, BLOB
-- 날짜 : DATE, TIME, DATETIME, TIMESTAMP



-- 제약조건
-- 테이블에 각 컬럼마다 값을 기록하는것에 제약사항을 설정할 때 사용하는 조건

SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA='multi';

-- NOT NULL
-- NULL 값 허용하지 않는ㄷ
-- 해당 제약조건을 추가한 컬럼에 반드시 값을 기록해야 하는경우
-- 데이터 삽입/수정/삭제 시에 NULL값을 허용하지 않도록 컬럼 작성시 함께 작성.

DROP TABLE USER_NOCONS;

CREATE TABLE USER_NOCONS(
	USER_NO INT,
	USER_ID VARCHAR(20),
	USER_PWD VARCHAR(20),
	USER_NAME VARCHAR(15)
);

SELECT * FROM USER_NOCONS;

-- 테이블에 값 추가하기
-- DML : INSERT

INSERT INTO USER_NOCONS VALUES(1,'USER01','PASS01','홍길동');

SELECT * FROM USER_NOCONS;

INSERT INTO USER_NOCONS VALUES(2,NULL, NULL, NULL);

CREATE TABLE USER_NOT_NULL(
	USER_NO INT NOT NULL,
	USER_ID VARCHAR(20) NOT NULL,
	USER_PWD VARCHAR(20) NOT NULL,
	USER_NAME VARCHAR(15) NOT NULL
);

DESC USER_NOT_NULL;
DESC USER_NOCONS;

INSERT INTO USER_NOT_NULL VALUES(1,'USER01','PASS01','홍길동');
SELECT * FROM USER_NOT_NULL;

INSERT INTO USER_NOT_NULL VALUES(2,NULL,NULL,NULL);

INSERT INTO USER_NOCONS VALUES(1,'USER01','PASS01','홍길동');
SELECT * FROM USER_NOCONS;

CREATE TABLE USER_UNIQUE(
	USER_NO INT,
	USER_ID VARCHAR(20) UNIQUE, -- 컬럼레벨 제약조건
	USER_PWD VARCHAR(20),
	USER_NAME VARCHAR(15),
	UNIQUE(USER_NO) -- 테이블레벨 제약조건
);

INSERT INTO USER_UNIQUE VALUES(1,'USER01', 'PASS01', '홍길동');
SELECT * FROM USER_UNIQUE;
INSERT INTO USER_UNIQUE VALUES(1,'USER02', 'PASS02', '김길동');
INSERT INTO USER_UNIQUE VALUES(2,'USER01', 'PASS01', '홍길동');

-- UNIQUE 제약조건 여러개 컬럼에 적용하기
-- 두개 이상의 컬럼을 제약조건으로 묶을경우
-- 반드시 테이블레벨에서 제약조건을 선언해야 한다

CREATE TABLE USER_UNIQUE2(
	USER_NO INT,
	USER_ID VARCHAR(20),
	USER_PWD VARCHAR(20),
	USER_NAME VARCHAR(15),
	UNIQUE(USER_NO, USER_ID)
);

DESC USER_UNIQUE2;
SELECT * FROM USER_UNIQUE2;

INSERT INTO USER_UNIQUE2 VALUES (1,'USER01', 'PASS01', '홍길동');
INSERT INTO USER_UNIQUE2 VALUES (1,'USER02', 'PASS02', '김길동');
INSERT INTO USER_UNIQUE2 VALUES (2,'USER01', 'PASS03', '박길동');
INSERT INTO USER_UNIQUE2 VALUES (2,'USER02', 'PASS04', '최길동');

-- CHECK 제약조건
-- 값을 지정할때 컬럼에 지정한 값 이외에는 값이 기록되지 않도록 범위를 제한하는 조건
-- EX) CHECK(GENDER IN('M', 'F'))
-- EX) CHECK(USER_ID IS NOT NULL)

CREATE TABLE USER_CHECK(
	USER_NO INT,
	USER_ID VARCHAR(20),
	USER_PWD VARCHAR(20),
	USER_NAME VARCHAR(15),
	-- GENDER VARCHAR(3) CHECK(GENER IN('남', '여')) -- 컬럼레벨
	GENDER VARCHAR(3),
	CONSTRAINT CK_GENDER CHECK(GENDER IN('남', '여')) -- 테이블레벨
	);
	
SELECT * FROM USER_CHECK;
INSERT INTO USER_CHECK VALUES(1, 'USER01', 'PASS01', '홍길동', '남');
INSERT INTO USER_CHECK VALUES(2, 'USER02', 'PASS02', '김길동', '남자');
INSERT INTO USER_CHECK VALUES(2, 'USER02', 'PASS02', '김길동', 'M');

SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'USER_CHECK';

CREATE TABLE TEST_CHECK(
	TEST_DATA INT,
	CONSTRAINT CK_TEST_DATA CHECK(TEST_DATA > 0 AND TEST_DATA < 100)
);

INSERT INTO TEST_CHECK VALUES(10);
INSERT INTO TEST_CHECK VALUES(-10);

-- PRIMARY KEY 제약조건
-- '기본키 제약조건'
-- 테이블 내의 한 행에서 그 행을 식별하기 위한 고유값을 가지는 컬럼
-- NOT NULL, UNIQUE 함께 걸어줌
-- 테이블 전체에 대한 각 데이터(ROW)의 식별자 역할을 수행하는 제약조건
-- 기본키로 선언된 컬럼은 반드시 값이 들어가고, 중복이 있으면 안된다
-- 기본키 제약조건 테이블에서 한개 존재, 한 컬럼에서 적용가능한것 뿐만아니라 여러컬럼을 묶어서도 적용가능.

CREATE TABLE USER_PK_TABLE(
	USER_NO INT PRIMARY KEY,
	USER_ID VARCHAR(20) UNIQUE NOT NULL,
	USER_PWD VARCHAR(20) NOT NULL,
	USER_NAME VARCHAR(15) NOT NULL
);

DESC USER_PK_TABLE;

INSERT INTO USER_PK_TABLE VALUES(1, 'USER01', 'PASS01', '홍길동');
INSERT INTO USER_PK_TABLE VALUES(2, 'USER02', 'PASS02', '김길동');
INSERT INTO USER_PK_TABLE VALUES(1, 'USER03', 'PASS03', '박길동');
INSERT INTO USER_PK_TABLE VALUES(NULL, 'USER03', 'PASS03', '박길동');

-- 여러컬럼에 기본키 제약조건 적용
CREATE TABLE USER_PK_TABLE2(
	USER_NO INT,
	USER_ID VARCHAR(20) UNIQUE,
	USER_PWD VARCHAR(20) NOT NULL,
	USER_NAME VARCHAR(15) NOT NULL,
	CONSTRAINT PK_USER_NO2 PRIMARY KEY(USER_NO, USER_ID)
);

-- DROP은 객체 삭제하는 명령어
DROP TABLE MEMBER;

SELECT * FROM TEST_CHECK;
)

-- 실습1
-- MEMBER 테이블을 생성하여 사용자 번호를 바등ㄹ 수 있는 테이블 객체를 만들자
-- 회원번호 INT PRIMARY
-- 아이디 VARCHAR, UNIQUE, CHECK
-- 비번 VARCHAR, CHECK
-- 이름 VARCHAR
-- 성별 VARCHAR (M,F)만
-- 연락처 VARCHAR
-- 생년월일 VARCHAR
-- 회원정보 5개 이상입력 


DROP TABLE MEMBER;

CREATE TABLE MEMBER(
	USER_NO INT PRIMARY KEY,
	USER_ID VARCHAR(20) UNIQUE NOT NULL,
	USER_PWD VARCHAR(20) NOT NULL,
	USER_NAME VARCHAR(15),
	USER_GENDER VARCHAR(15) CHECK(USER_GENDER IN('M','F')),
	USER_PHONE VARCHAR(20),
	USER_AGE VARCHAR(20)
);

DESC MEMBER;

INSERT INTO MEMBER VALUES(1, 'USER01', 'PASS01', '주현록', 'M', '01021047995', '960108');
INSERT INTO MEMBER VALUES(2, 'USER02', 'PASS02', '1현록', 'F', '01021047991', '960101');
INSERT INTO MEMBER VALUES(3, 'USER03', 'PASS03', '2현록', 'F', '01021047992', '960102');
INSERT INTO MEMBER VALUES(4, 'USER04', 'PASS04', '3현록', 'F', '01021047993', '960103');
INSERT INTO MEMBER VALUES(5, 'USER05', 'PASS05', '4현록', 'M', '01021047994', '960104');
INSERT INTO MEMBER VALUES(6, 'USER06', 'PASS06', '6현록', 'D', '01021047995', '960108');

SELECT * FROM MEMBER;

-- FOREIGN KEY 제약조건
-- 외래키, 외부키, 참조키 라고 한다
-- 다른 테이블의 컬럼값을 참조하여, 참조하는 테이블의 값만 허용한다
-- 해당 제약조건을 통해 다른 테이블과의 관계 (RELATIONSHIP)가 형성

-- 참조하고자 하는 컬럼은 반드시 PRIMARY KEY 이거나, UNIQUE 제약조건이 걸려있어야 한다.
CREATE TABLE USER_GRADE(
	GRADE_CODE INT PRIMARY KEY,
	GRADE_NAME VARCHAR(20) NOT NULL
);

INSERT INTO USER_GRADE VALUES(1, '일반회원');
INSERT INTO USER_GRADE VALUES(2, 'VIP');
INSERT INTO USER_GRADE VALUES(3, 'VVIP');
INSERT INTO USER_GRADE VALUES(4, 'VVVIP');

SELECT * FROM USER_GRADE;

CREATE TABLE USER_FOREIGN_KEY(
	USER_NO INT PRIMARY KEY,
	USER_ID VARCHAR(20),
	USER_PWD VARCHAR(20),
	USER_NAME VARCHAR(15),
	-- GRADE_CODE INT REFERENCES USER_GRADE(GRADE_CODE) -- 컬럼레벨
	GRADE_CODE INT,
	CONSTRAINT FK_GRADE_CODE FOREIGN KEY(GRADE_CODE) REFERENCES USER_GRADE(GRADE_CODE)
);

DESC USER_FOREIGN_KEY;
SELECT * FROM USER_FOREIGN_KEY;

INSERT INTO USER_FOREIGN_KEY VALUES(1, 'USER01', 'PASS01', '1길동', 2);
INSERT INTO USER_FOREIGN_KEY VALUES(2, 'USER02', 'PASS02', '2길동', 4);
INSERT INTO USER_FOREIGN_KEY VALUES(3, 'USER03', 'PASS03', '3길동', 1);
INSERT INTO USER_FOREIGN_KEY VALUES(4, 'USER04', 'PASS04', '4길동', 3);
INSERT INTO USER_FOREIGN_KEY VALUES(5, 'USER05', 'PASS05', '5길동', 1);

SELECT * FROM USER_FOREIGN_KEY JOIN USER_GRADE USING(GRADE_CODE);


-- 
DELETE FROM USER_GRADE
WHERE GRADE_CODE = 3;

-- 참조되는 테이블의 컬럼은 기본적으로 삭제가 불가능 하다

-- 삭제옵션
-- 참조되는 테이블의 컬럼 값이 삭제/수정 될 때 참조하는 값을 어떻게 처리할 것인지 설정하는 옵션

DROP TABLE USER_FOREIGN_KEY;

DROP TABLE USER_GRADE;

CREATE TABLE USER_FOREIGN_KEY(
	USER_NO INT PRIMARY KEY,
	USER_ID VARCHAR(20),
	USER_PWD VARCHAR(20),
	USER_NAME VARCHAR(15),
	GRADE_CODE INT,
	CONSTRAINT FK_GRADE_CODE FOREIGN KEY(GRADE_CODE) 
	REFERENCES USER_GRADE(GRADE_CODE) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO USER_FOREIGN_KEY VALUES(1, 'USER01', 'PASS01', '1길동', 2);
INSERT INTO USER_FOREIGN_KEY VALUES(2, 'USER02', 'PASS02', '2길동', 4);
INSERT INTO USER_FOREIGN_KEY VALUES(3, 'USER03', 'PASS03', '3길동', 1);
INSERT INTO USER_FOREIGN_KEY VALUES(4, 'USER04', 'PASS04', '4길동', 3);
INSERT INTO USER_FOREIGN_KEY VALUES(5, 'USER05', 'PASS05', '5길동', 1);

SELECT * FROM USER_FOREIGN_KEY;

UPDATE USER_GRADE SET GRADE_CODE = 10 WHERE GRADE_CODE = 1;
SELECT * FROM USER_GRADE;
SELECT * FROM USER_FOREIGN_KEY;

DELETE FROM USER_GRADE WHERE GRADE_CODE=10;

-- SUBQUERY 를 활용한 테이블 만들기
-- 컬럼명, 데이터타입, 값, NOT NULL은 복사 가능
-- 다른 제약조건(PRIMARY, UNIQUE ... )은 복사되지 않는다

CREATE TABLE EMPLOYEE_COPY AS SELECT * FROM EMPLOYEE;

SELECT * FROM EMPLOYEE_COPY;

DESC EMPLOYEE;
DESC EMPLOYEE_COPY;


-- 테이블의 형식만 복사
-- 테이블의 값을 제외한 형식 복사

CREATE TABLE EMPLOYEE_COPY2
AS SELECT * FROM EMPLOYEE WHERE 1=2;

SELECT * FROM EMPLOYEE_COPY2;

-- 특정 컬럼만 복사
CREATE TABLE EMPLOYEE_COPY4
AS SELECT EMP_ID, EMP_NAME, SALARY '급여' FROM EMPLOYEE WHERE 1=2;

SELECT * FROM EMPLOYEE_COPY4;

-- 테이블 생성시 기본값 설정

CREATE TABLE DEFAULT_TABLE(
	COL1 VARCHAR(30) DEFAULT '없음',
	COL2 DATE DEFAULT (CURRENT_DATE),
	COL3 DATETIME DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM DEFAULT_TABLE;

INSERT INTO DEFAULT_TABLE VALUES(DEFAULT, DEFAULT, DEFAULT);

DESC DEFAULT_TABLE;

CREATE TABLE DEFAULT_TABLE1(
	COL1 VARCHAR(30) DEFAULT '없음' PRIMARY KEY,
	COL2 DATE DEFAULT (CURRENT_DATE) UNIQUE,
	COL3 DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

DESC DEFAULT_TABLE1;


