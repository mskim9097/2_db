-- 00sys계정 01SELECT 02함수 03GROUPBYHAVING 05DML 06TCL 07서브쿼리 08,09 DDL 
-- 뷰 시퀀스 인덱스 DCL 안나옴 1월 20일 배운거까지

-- ** DBMS란? 데이터베이스에서 데이터 추출, 조작, 정의, 제어 등을 할 수 있게 해주는 데이터베이스 전용 관리 프로그램

-- ** RESULT SET OR 결과 SET 이란? SELECT구문에 의해 조회된 행들의 집합

-- 데이터타입 **NUMBER(숫자(정수, 실수))**, DATE(날짜) <== 자료형크기 제시X
--			CHARACTER(문자) 1.CHAR 2.VARCHAR2
-- CHAR : 고정길이 최대2000BYTE 남으면그대로 VARCHAR2 : 가변길이 최대4000BYTE 남으면삭제
-- **CHAR(100) 100BYTE의 고정길이 문자열 (영어 100자)**

-- ** TABLE이란? 데이터를 행과 열의 표형태로 표현한거

--** SQL(Structured Query Language) : 구조적 질의 언어 **
--DQL(Data Query Language) (질의어)	: 데이터 검색		SELECT(데이터 조회) <= DML로도 분류
--DML(Data Manipulation Language)	: 데이터 조작		INSERT(데이터 삽입), UPDATE(데이터 수정), DELETE(데이터 삭제)
----------------CRUD------------------------------------------------------------------------------------------------------------------------
--DDL(Data Definition Language)	: 데이터 정의(테이블관련)	CREATE(데이터베이스 객체를 생성), DROP, ALTER
--DCL(Data Control Language)		: 데이터 제어 (권한주고뺏고)	GRANT, REVOKE
--TCL(Transaction Control Language)	: 트랜잭션 제어		COMMIT(트랜잭션에 임시저장된 데이터를 DB에 반영)
														--ROLLBACK(트랜잭션에 임시저장된 데이터를 삭제하고 직전 COMMIT으로 돌아감)

SELECT TO_CHAR(TO_DATE('210505', 'YYMMDD'), 'YYYY"년" MM"월" DD"일"') FROM DUAL; -- 문자열데이터 날짜로 바꾸는 셀렉트구문작성

--날짜변환 여러개
SELECT TO_DATE('510505', 'RRMMDD') FROM DUAL; -- 1951-05-05
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS DAY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일" (DY)') FROM DUAL; 

-- SUBSTR : 컬럼이나 문자열에서 지정한 위치부터 지정된 길이만큼 문자열을 잘라서 반환
SELECT SUBSTR(EMAIL, 1, INSTR(EMAIL, '@') -1 ) FROM EMPLOYEE; -- EMAIL의 1번째 부터 INSTR - 1(@전)까지의 문자 출력

-- UPPER	: 조회한 컬럼이 영문자일 경우 대문자로 바꿔주는 함수
SELECT UPPER(EMAIL) FROM EMPLOYEE;

-- INITCAP  : 조회한 컬럼이 영문자일 경우 앞글자를 대문자로 변환해 주는 함수
SELECT INITCAP(EMAIL) FROM EMPLOYEE;

-- TRIM 함수 : 조회한 컬럼 양 끝에 띄어쓰기나 빈칸이 있을 경우, 이를 제거해주는 역할을 한다.
SELECT TRIM('     HELLO     ') FROM DUAL; -- 주어진 컬럼이나 문자열의 앞, 뒤, 양쪽에 있는 지정된 문자를 제거
SELECT TRIM(BOTH '#' FROM '####안녕####') FROM DUAL; -- LEADING은 앞, TRAILING은 뒤 BOTH는 둘다 제거

-- DECODE / CASE END 구문
-- 직원의 급여를 인상하고자 한다.
-- 직급 코드가 J7인 직원은 20%, J6인 직원은 15%, J5인 직원은 10%, 그 외 직급은 5% 인상
-- 이름, 직급코드, 원래 급여, 인상률, 인상된 급여
SELECT EMP_NAME "이름", JOB_CODE "직급코드", SALARY "원래급여", DECODE(JOB_CODE, 'J7', '20%', 'J6', '15%', 'J5', '10%', '5%') "인상률",
DECODE(JOB_CODE, 'J7', SALARY * '1.2', 'J6', SALARY * '1.15', 'J5', SALARY * '1.1', SALARY * '1.05') "인상된 급여"
FROM EMPLOYEE;

--ROLL UP 함수: 그룹별로 중간 집계 처리를 하는 함수
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY 1;

-- CONCAT 함수 : 여러 문자열을 하나로 합쳐주는 역할
SELECT EMP_ID || ', ' || EMP_NAME || ', ' || EMP_NO FROM EMPLOYEE;
-- 위 SELECT 구문을 CONCAT 을 이용하여 변경 가능
SELECT CONCAT(CONCAT(CONCAT(CONCAT(EMP_ID, ', '), EMP_NAME), ', '), EMP_NO) FROM EMPLOYEE;


-- GROUP BY / HAVING 
--[작성법]
SELECT DEPT_CODE, ROUND(AVG(SALARY))  
FROM EMPLOYEE
--WHERE SALARY >= 3000000 -> 한 사람의 급여가 300만 이상이라는 조건
GROUP BY DEPT_CODE
-- GROUP BY 그룹을 묶을 컬럼명 -- 같은 값들이 여러개 기록된 컬럼을 가지고 같은 값들을 하나의 그룹으로 묶음
-- SELECT문에 GROUP BY절을 사용할 경우 SELECT절에 명시한 조회하려는 컬럼 중 그룹함수가 적용되지 않은 컬럼을 모두 GROUP BY절에 작성해야함.
HAVING AVG(SALARY) >= 3000000 --> DEPT_CODE 그룹 중 급여 평균이 300만 이상인 그룹만 남음
-- HAVING 그룹함수식 비교연산자 비교값 -- 그룹내 조건절이 붙을 경우
ORDER BY DEPT_CODE;

-----JOIN---------------------------------------------------------------------------
-- 하나 이상의 테이블에서 데이터를 조회하기 위해 사용. 결과는 하나의 Result Set으로 나옴.
-- JOIN시 연결할 컬럼명이 같으면 USING 다르면 ON
-- ** INNER JOIN이란 ? 연결되는 컬럼의 값이 일치하는 행들만 조인됨.
-- ** OUTER JOIN이란 ? 두 테이블의 지정하는 컬럼값이 일치하지 않는 행도 조인에 포함을 시킴
-- (LEFT, RIGHT, FULL)
-- CROSS JOIN = 조인되는 테이블의 각 행들이 모두 매핑된 데이터가 검색(곱집합)
-- NON EQUAL JOIN ON = 지정한 컬럼값이 일치하는 경우가 아닌, 값의 범위에 포함되는 행들을 연결하는 방식
-- SELF JOIN ON = 같은 테이블을 조인
-- NATURAL JOIN = 동일한 타입과 컬럼명을 가진 테이블을 간단히 조인(없으면 교차조인됨)
-- 다중조인 = N개의 테이블을 조회할 때 사용 (순서 중요!!)
------------------------------------------------------------------------------------

-- RANK() OVER : 동일한 순위 이후의 등수를 동일한 인원수 만큼 건너뛰고 순위 계산
SELECT RANK() OVER (ORDER BY SALARY DESC) "순위",
	EMP_NAME, SALARY
FROM EMPLOYEE;

-- DENSE_RANK() OVER : 동일한 순위 이후의 등수를 이후의 순위로 계산
SELECT DENSE_RANK() OVER (ORDER BY SALARY DESC) "순위",
	EMP_NAME, SALARY
FROM EMPLOYEE;

/* CREATE TABLE MEMBER_KH(
MNO NUMBER PRIMARY KEY 회원번호
MNAME VARCHAR2(300) NOTNULL 회원명
ADDRESS VARCHAR2(1000) 주소
)
INSERT (1,~~~~)
INSERT (1,~~~~) */
-- 생성안되는 이유는? PRIMARY키는 중복허용안하고 필수로 있어야하는 고유식별자이기때문에


-- [Set Operator]
-- UNION : 선행 SELECT 결과와 다음 SELECT 결과의 합집합
-- UNION과 UNION ALL의 차이 : UNION 대신 UNION ALL은 중복결과를 포함한 결과를 나타낸다. UNION은 중복을 제거하는 작업을 해야하기 때문에 UNION ALL이 속도가 빠르다.
-- INTERSECT : 선행 SELECT 결과에서 다음 SELECT 결과와 겹치는 부분만을 추출한 것(교집합)
-- MINUS : 선행 SELECT 결과에서 다음 SELECT 결과와 겹치는 부분을 제외한 나머지 부분 추출(차집합)


-----------------------------------------------------------------------------------------

SELECT EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
LEFT JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
WHERE BONUS IS NOT NULL;

SELECT E1.EMP_NAME, DEPT_CODE, E2.EMP_NAME
FROM EMPLOYEE E1
JOIN EMPLOYEE E2 USING (DEPT_CODE)
WHERE E1.EMP_NAME <> E2.EMP_NAME
ORDER BY 1;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
LEFT JOIN JOB USING (JOB_CODE)
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
								FROM EMPLOYEE
								WHERE EMP_NAME = '노옹철')
							AND EMP_NAME <> '노옹철';

SELECT EMP_NAME, JOB_CODE, SALARY,
				(SELECT AVG(SALARY) FROM EMPLOYEE SUB
				WHERE SUB.JOB_CODE = MAIN.JOB_CODE)
FROM EMPLOYEE MAIN;



SELECT TO_CHAR(TO_DATE(SUBSTR(EMP_NO, 1, INSTR(EMP_NO, '-') - 1), 'RRMMDD'), 
		'YYYY"년" MM"월" DD"일"') FROM EMPLOYEE;