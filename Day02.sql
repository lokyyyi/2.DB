-- SELECT : 조회용 SQL

-- 데이터베이스에서 실행하고자 하는 명령 종류
-- CRUD : 데이터 기본 사항 처리 로직
-- CREATE : 데이터 추가/ INSERT 
-- READ	  : 데이터 조회/ SELECT
-- UPDATE : 데이터 수정/ UPDATE
-- DELETE : 데이터 삭제/ DELETE


-- 연산자 --
-- 비교 연산자

SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE != 'D9';

-- EMPLOYEE 테이블에서 급여가 350 <= 550 직원의 사번, 사원명, 부서코드, 직급코드(JOB_CODE_, 급여정보를 조회

SELECT EMP_ID '사번', EMP_NAME '사원명', DEPT_CODE '부서코드', JOB_CODE '직급코드', SALARY '급여'
FROM EMPLOYEE
WHERE SALARY >= 3500000 && SALARY <= 5500000;

SELECT EMP_ID '사번', EMP_NAME '사원명', DEPT_CODE '부서코드', JOB_CODE '직급코드', SALARY '급여'
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 5500000;

-- 급여가 350 !<= 550
SELECT EMP_ID '사번', EMP_NAME '사원명', DEPT_CODE '부서코드', JOB_CODE '직급코드', SALARY '급여'
FROM EMPLOYEE
WHERE SALARY NOT BETWEEN 3500000 AND 5500000;

-- LIKE 조회 연산자
-- '_' 임의의 한문자, '%' 몇자리든

SELECT *
FROM EMPLOYEE
WHERE EMP_NAME LIKE '_중_';

-- 여자 조회
SELECT *
FROM EMPLOYEE
WHERE EMP_NO LIKE '%-2%';

-- 이메일 아이디가 5글자 초과하는사원의 사원 명, 사번, 이메일정보 조회
SELECT EMP_NAME '사원명', EMP_ID '사번', EMAIL '이메일'
FROM EMPLOYEE
WHERE EMAIL LIKE '______%@%';

-- 4번쨰가 '_' 인 사원
SELECT *
FROM EMPLOYEE
WHERE EMAIL LIKE '___!_%@%' ESCAPE '!';

-- IN() 연산자
-- IN(값1, 값2, 값3, ...)
-- 안에 있는 값 중 하나라도 일치 하는 경우
-- 해당하는 값 조회

-- 부서코드가 D1, D6 부서 직원정보 조회

SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE IN('D1', 'D6');

-- D1,D6 !

SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE NOT IN('D1', 'D6');


----------------------------

-- LENGTH / CHAR_LENGTH
SELECT LENGTH('Hello'), CHAR_LENGTH('Hello')

SELECT LENGTH('주현록'), CHAR_LENGTH('주현록')


-- INSTR() : 주어진 값에서 원하는 문자가 몇번째인지 찾아 반환하는 함수
SELECT INSTR('ABCDE', 'A');

SELECT EMAIL, INSTR(EMAIL, '@')	
FROM EMPLOYEE;

-- SUBSTR() : 주어진 문자열에서 특정 부분만 꺼내오는 함수

SELECT 'Hello World', SUBSTR('Hello world',1,5), SUBSTR('Hello world',7);

-- EMPLOYEE TABLE 에서 사원들의 이름, 이메일 조회하되
-- 이메일은 아이디 부분만 조회

SELECT EMP_NAME '이름', SUBSTR(EMAIL,1 ,INSTR(EMAIL,. '@')-1)
FROM EMPLOYEE;


-- LPAD/RPAD
-- 빈칸을 지정한 문자로 채우는 함수

SELECT LPAD(EMAIL, 20,"#"),
RPAD(EMAIL,20,'-')
FROM EMPLOYEE;

--- LTRIM/RTRIM
--- 현재 부여된 컬럼이나, 값으로 붜터 공백만 찾아 지워주는 함수

SELECT LTRIM('       Hello');

--- TRIM

SELECT TRIM('     Hello   ');

SELECT TRIM('0' FROM '000Hello00000')

-- LOWER/UPPER

SELECT LOWER('AbCd'), UPPER('AbCd');

-- CONCAT() : 문자열 합치기
SELECT CONCAT('마이에스큐엘',' 재밌어요:)');

SELECT CONCAT(RPAD(SUBSTR(EMP_NAME,1,1),3,'*'),'님')
FROM EMPLOYEE;

-- REPLACE() : 주어진 문자열에서 특정문자를 변경할 떄
SELECT REPLACE('HELLO WORLD', 'HELLO', 'BYE');

-- 실습 3
-- EMPLOYEE 테이블에서
-- 사원의 주민번호를 확인하여
-- 생년, 생월, 생일을 각각 조회하시오.
-- [출력예시]
-- 이름  | 생년  | 생월  | 생일
-- 홍길동| 00년  | 00월  | 00일
SELECT EMP_NAME '이름', CONCAT(SUBSTR(EMP_NO,1,2), '년'), CONCAT(SUBSTR(EMP_NO,3,2), '월'), CONCAT(SUBSTR(EMP_NO,5,2), '일')   
FROM EMPLOYEE;

SELECT *
FROM EMPLOYEE;


-- 실습 4
-- EMPOYEE 테이블에서
-- 사원의 사번, 사원명, 이메일, 주민번호를 조회.
-- 이 때, 이메일은 '@'전 까지, 
-- 주민번호는 7번째 자리 이후 '*'(000000-1******) 처리하여 조회
SELECT EMP_ID '사번', EMP_NAME '사원명', 
SUBSTR(EMAIL,1 ,INSTR(EMAIL, '@')-1) '이메일', 
RPAD(SUBSTR(EMP_NO,1,8), 14, '*') '주민번호'
FROM EMPLOYEE;

-- 실습 5
-- EMPLOYEE 테이블에서 현재 근무하는 
-- 여성 사원의 사번, 사원명, 직급코드를 조회.
-- **ENT_YN : 현재 근무 여부 파악하는 컬럼(퇴사여부)
-- **WHERE에 함수 사용 가능

SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = 2 AND ENT_YN LIKE 'N';

-- AVG() 해당 컬럼들의 평균을 계산
SELECT AVG(SALARY)
FROM EMPLOYEE;

-- MAX(), MIN() : 해당 컬럼들의 값 중 최대,최솟
SELECT MAX(SALARY), MIN(SALARY)
FROM EMPLOYEE;

-- '해외영업1부'근무사원의 평균급여, MAX, MIN , 급여합계
SELECT AVG(SALARY), MAX(SALARY), MIN(SALARY), SUM(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

SELECT COUNT(DEPT_CODE),
		COUNT(DISTINCT(DEPT_CODE))
FROM EMPLOYEE;

SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE;

SELECT *
FROM EMPLOYEE;

-- 날짜처리함수
-- SYSDATE(), NOW() : 현재 컴퓨터의 날짜를 변환하는 함수
SELECT SYSDATE();
SELECT NOW();

-- DATEDIFF : 단순 일차이
-- TIMESTAMPDIFF : 연 분기 월 주 일 시 분 초 를 지정하여 차이

SELECT HIRE_DATE '입사일', DATEDIFF(NOW(), HIRE_DATE) '입사 후 일 수'
FROM EMPLOYEE;

SELECT HIRE_DATE '입사일',
		TIMESTAMPDIFF(YEAR, HIRE_DATE, NOW()) '입사 후 연 수'
FROM EMPLOYEE;

/*
 * YEAR
 * QUARTER
 * MONTH
 * WEEK
 * DAY
 * HOUR
 * MINUTE
 * SECOND
 */

-- EXTRACT(YEAR|MONTH|DAY FROM 날짜데이터)
-- :지정한 날짜데이터로 부터 원하는 날짜값을 추출하는 함수

SELECT EXTRACT(YEAR FROM HIRE_DATE),
		EXTRACT(MONTH FROM HIRE_DATE),
		EXTRACT(DAY FROM HIRE_DATE)
FROM EMPLOYEE;

-- DATE_FORMAT()
-- 날짜정보변경

SELECT HIRE_DATE, DATE_FORMAT(HIRE_DATE, '%Y%m%d%h%i%s'),
					DATE_FORMAT(HIRE_DATE, '%Y/%m/%d/%h:%i:%s'),
					DATE_FORMAT(NOW(), '%Y/%m/%d/%H:%i:%s')
FROM EMPLOYEE;

-- STR_TO_DATE()
SELECT STR_TO_DATE('20231010', '%Y%m%d'),
		STR_TO_DATE('231010', '%y%m%d'),
		STR_TO_DATE('23-10-10', '%Y-%m-%d');

SELECT EMP_NAME, EMP_NO,
		IF(SUBSTR(EMP_NO,8,1)='2', '여', '남') '성별'
FROM EMPLOYEE
ORDER BY '성별';

-- 모든직원의 사번, 사원명, 부서코드, 직급코드, 근무여부, 관리자여부를 조회
-- 이때 근무여부 : ENT_YN이 'Y'면 퇴사자
--	관리자여부 : MANAGER_ID가 있으면 사원,	없으면 관리자
SELECT *
FROM EMPLOYEE;

SELECT EMP_ID '사번', EMP_NAME '사원명', DEPT_CODE '부서코드', JOB_CODE '직급코드', IF(ENT_YN = 'Y', '퇴사자', '근무자') '근무여부', 
IF(MANAGER_ID IS NOT NULL ,'사원', '관리자') '관리자 여부'
FROM EMPLOYEE;
		

-- CASE
-- WHEN(조건식1) THEN 결과1
-- WHEN(조건식2) THEN 결과2
-- END

SELECT EMP_ID '사번', EMP_NAME '사원명', DEPT_CODE '부서코드', JOB_CODE '직급코드', 
CASE 
	WHEN ENT_YN = 'Y' THEN '퇴사자'
	WHEN ENT_YN = 'N' THEN '근무자'
	END '근무여부' ,
CASE
	WHEN MANAGER_ID IS NULL THEN '관리자'
	WHEN MANAGER_ID IS NOT NULL THEN '사원'
END '관리자여부'
FROM EMPLOYEE;

-- MOD() : 몫
SELECT MOD(10,3), MOD(10,2), MOD(10,7);

-- ROUND() : 반올림

SELECT ROUND(123.456,0),
		ROUND(123.456,1),
		ROUND(123.456,2),
		ROUND(123.456,-2);
	
-- CEIL() : 소수점 첫째자리에서 올림
-- FLOOR() : 소수점 이하 자리의 숫자를 버리는 함수

SELECT CEIL(123.456), FLOOR(123.456);

-- TRUNCATE(): 지정한 위치까지 숫자를 버리는 함수


SELECT TRUNCATE(123.456,0), TRUNCATE(123.456,1), TRUNCATE(123.456,-2);

-- CEILING() : 소숫점 반올림

SELECT CEILING (4.0), CEILING (4.1), CEILING(3.9);

-- 입사한 달의 숫자가 홀수 달인
-- 직원의 사번, 사원명, 입사일 정보를 조회 (HIRE_DATE에 SUBSTR활용)	
SELECT *
FROM EMPLOYEE;

SELECT EMP_ID '사번', HIRE_DATE '입사일'
FROM EMPLOYEE
WHERE NOT MOD(SUBSTR(HIRE_DATE, 6, 2), 2) = 0;

-- 함수 연습문제 --

-- 1. 직원명과 주민번호를 조회함
--  단, 주민번호 9번째 자리부터 끝까지는 '*'문자로 채움
--  예 : 홍길동 771120-1******
SELECT EMP_NAME '직원명', RPAD(SUBSTR(EMP_NO,1,8) ,14,'*') '주민번호'
FROM EMPLOYEE;

-- 2. 부서코드가 D5, D9인 직원들 중에서 2004년도에 입사한 직원의 
--   수 조회함.
--   사번 사원명 부서코드 입사일
SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR(HIRE_DATE,1,4) LIKE '2004';

-- 3. 직원명, 입사일, 입사한 달의 근무일수 조회
--   단, 주말도 포함함 ( LAST_DAY() : 주어진 날짜의 해당월의 마지막 날 반환 )

SELECT EMP_NAME '직원명', HIRE_DATE '입사일', TIMESTAMPDIFF(DAY, HIRE_DATE, LAST_DAY(HIRE_DATE)) '근무일수'
FROM EMPLOYEE;

-- 4. 직원명, 부서코드, 생년월일, 나이 조회
--   단, 생년월일은 주민번호에서 추출해서 ㅇㅇ년 ㅇㅇ월 ㅇㅇ일로 출력되게 함.
--   나이는 주민번호에서 추출해서 날짜데이터로 변환한 다음, 계산함

SELECT EMP_NAME '직원명', DEPT_CODE '부서코드', 
CONCAT(CONCAT(SUBSTR(EMP_NO,1,2),'년'), CONCAT(SUBSTR(EMP_NO,3,2),'월'),CONCAT(SUBSTR(EMP_NO,5,2),'일')) '생년월일',
EXTRACT(YEAR, NOW()
FROM EMPLOYEE;

SELECT EXTRACT(YEAR, FROM STR_TO_DATE(SUBSTR(EMP_NO,1,6), '%y%m%d'))
FROM EMPLOYEE;

SELECT STR_TO_DATE(SUBSTR(EMP_NO,1,6), '%y%m%d')
FROM EMPLOYEE;

SELECT EMP_NAME, DEPT_CODE, 
      CONCAT(SUBSTR(EMP_NO, 1, 2),  '년 ', SUBSTR(EMP_NO, 3, 2), '월 ', 
      		 SUBSTR(EMP_NO, 5, 2) , '일 ') 생년월일,
      EXTRACT(YEAR FROM NOW()) - 
     EXTRACT(YEAR FROM (STR_TO_DATE(CONCAT('19',SUBSTR(EMP_NO, 1, 6)), '%Y%m%d'))) +1  나이
FROM EMPLOYEE
WHERE EMP_ID NOT IN (200, 201, 214)
ORDER BY 1;



-- 5.  부서코드가 D5이면 총무부, D6이면 기획부, D9이면 영업부로 처리하시오.
--   단, 부서코드가 D5, D6, D9 인 직원의 정보만 조회함
--  => case 사용

SELECT *, CASE WHEN DEPT_CODE = 'D5' THEN '총무부'
				WHEN DEPT_CODE = 'D6' THEN '기획부'
				WHEN DEPT_CODE = 'D7' THEN '총무부'
				END '부서코드'
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' OR DEPT_CODE = 'D6' OR DEPT_CODE = 'D7';



