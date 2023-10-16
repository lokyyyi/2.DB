-- 1. EMPLOYEE TABLE에서 가장 큰 급여는 얼마인지 조회하시오
SELECT MAX(SALARY)
FROM EMPLOYEE;

-- 2. EMPLOYEE TABLE에서 가장 큰 급여를 받는사람을 조회하시오
SELECT *
FROM EMPLOYEE
ORDER BY SALARY DESC
LIMIT 1;

-- 3. EMPLOYEE TABLE 에서 보너스 받는 사람의 사원을 조회하시오
SELECT COUNT(*)
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;

-- 4. EMPLOYEE TABLE에서 급여가 높은 순으로 정렬해서 조회하시오.
SELECT *
FROM EMPLOYEE
ORDER BY SALARY DESC;

-- 5. EMPLOYEE TABLE에서 직원명과 주민번호를 조회하시오, 단, 주민번호 9번째 자리부터 끝까지는 '*'문자로 채움
SELECT EMP_NAME '직원명', RPAD(SUBSTR(EMP_NO,1,8) ,14,'*') '주민번호'
FROM EMPLOYEE;

-- 6. EMPLOYEE TABLE에서 직원명, 입사일, 입사한 달의 근무일수 조회, 
-- 단, 주말도 포함함 ( LAST_DAY() : 주어진 날짜의 해당월의 마지막 날 반환 )
SELECT EMP_NAME '직원명', HIRE_DATE '입사일', TIMESTAMPDIFF(DAY, HIRE_DATE, LAST_DAY(HIRE_DATE)) '근무일수'
FROM EMPLOYEE;

-- 7. EMPLOYEE TABLE에서 근속년수 20년 이상인 사원의 사번, 이름, 부서코드, 입사일 조회하시오
SELECT EMP_ID '사번', EMP_NAME '이름', DEPT_CODE '부서코드', HIRE_DATE '입사일'
FROM EMPLOYEE

WHERE DATE_ADD(HIRE_DATE, INTERVAL 20 YEAR) <= NOW();
-- 8. EMPLOYEE TABLE에서 부서 D2의 평균 급여를 조회하시오.
SELECT DEPT_CODE, TRUNCATE(AVG(SALARY), -3)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING DEPT_CODE = 'D2'
ORDER BY DEPT_CODE;

-- 9. EMPLOYEE TABLE에서 남성직원의 수를 조회.
SELECT COUNT(*) '직원수'
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) = '1';

-- 10. EMPLOYEE TABLE에서 보너스를 포함한 연봉을 조회하여 낮은순으로 정렬하여 이름과 연봉을 조회하시오.
SELECT EMP_NAME 이름, CASE WHEN BONUS IS NULL THEN SALARY * 12
						 WHEN BONUS IS NOT NULL THEN (SALARY + (SALARY * BONUS))
						 END 연봉
FROM EMPLOYEE
ORDER BY 2;

-- 11. EMPLOYEE TABEL에서 이름에 '태'를 포함한 사람의 사번과 이름을 조회하여 사번이 낮은순으로 정렬하시오.
SELECT EMP_ID, EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%태%'
ORDER BY EMP_ID;

-- 12. 부서 별 그붋의 급여 합계 중 600만원을 초과하는 부서의 부서코드, 급여합계 조회
SELECT DEPT_CODE '부서코드', SUM(SALARY) '급여합계'
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) > 6000000;

-- 13. 부서코드가 D5이면 총무부, D6이면 기획부, D9이면 영업부로 처리하시오. ,부서코드가 D5, D6, D9 인 직원의 정보만 조회함
SELECT *, CASE WHEN DEPT_CODE = 'D5' THEN '총무부'
				WHEN DEPT_CODE = 'D6' THEN '기획부'
				WHEN DEPT_CODE = 'D7' THEN '총무부'
				END '부서코드'
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' OR DEPT_CODE = 'D6' OR DEPT_CODE = 'D7';

-- 14. EMPLOYEE 테이블의 직원 급여 정보와, SAL_GRADE의 급여 등급을 합쳐서
-- 사번, 사원명, 급여, 등급 기준 최소급여, 최대급여를 조회
SELECT EMP_ID '사번', EMP_NAME '사원명', SALARY '급여', TB.MIN_SAL '등급기준 최소급여', TB.MAX_SAL '등급기준 최대급여'
FROM EMPLOYEE TA
JOIN SAL_GRADE TB ON TA.SAL_LEVEL = TB.SAL_LEVEL;

-- 15. EMPLOYEE TABLE에서 생일이 8월이며 남사원이거나, 생일이 10월이며 여사원인 사람들을 조회하여 나이가 적은순으로 
--    나이, 생년월일, 성별, 이름을 정렬 하시오, 단 나이가 같다면 이름순으로 내림차순 정렬하시오.
SELECT EXTRACT(YEAR FROM NOW()) - 
	   EXTRACT(YEAR FROM (STR_TO_DATE(CONCAT('19',SUBSTR(EMP_NO, 1, 6)), '%Y%m%d')))+1 나이,
	   CONCAT('19',SUBSTR(EMP_NO, 1, 6)) 생년월일,
	   CASE WHEN SUBSTR(EMP_NO,8,1) = '1' THEN '남'
	    	WHEN SUBSTR(EMP_NO,8,1) = '2' THEN '여'
			END 성별,
	   EMP_NAME 이름
FROM EMPLOYEE
WHERE (SUBSTR(EMP_NO,8,1) = '1' AND (SUBSTR(EMP_NO,3,2) = '08')) 
	  OR (SUBSTR(EMP_NO,8,1) = '2' AND (SUBSTR(EMP_NO,3,2) = '10'))
ORDER BY 1, 4 DESC;


CREATE TABLE MYTEST(
	MNO INT,
	MNAME VARCHAR(20),
	NICNAME VARCHAR(20)
);