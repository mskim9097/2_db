-- 00sys계정 01SELECT 02함수 03GROUPBYHAVING 05DML 06TCL 08DDL(CREATE)

--데이터베이스 정의 특징!!
--개념보다는 구문작성이 시험에 많이나옴
--쿼리문 꼼꼼하게 봐야함 야비한거있을수도있음(등호가 반대로되어있거나)

--SQL표싹다
--제약조건 개념이랑 표 싹다

-----서술형
-- 데이터타입 NUMBER(숫자), DATE(날짜) <== 자료형크기 제시X
--			CHARACTER(문자) 1.CHAR 2.VARCHAR2
-- CHAR : 고정길이 최대2000BYTE 남으면그대로 VARCHAR2 : 가변길이 최대4000BYTE 남으면삭제
-- CHAR(100) 100BYTE의 고정길이 문자열

--SQL(Structured Query Language) : 구조적 질의 언어
--DQL(Data Query Language) (질의어)	: 데이터 검색		SELECT(데이터 조회) <= DML로도 분류
--DML(Data Manipulation Language)	: 데이터 조작		INSERT(데이터 삽입), UPDATE(데이터 수정), DELETE(데이터 삭제)
----------------CRUD------------------------------------------------------------------------------------------------------------------------
--DDL(Data Definition Language)	: 데이터 정의(테이블관련)	CREATE(데이터베이스 객체를 생성), DROP, ALTER
--DCL(Data Control Language)		: 데이터 제어 (권한주고뺏고)	GRANT, REVOKE
--TCL(Transaction Control Language)	: 트랜잭션 제어		COMMIT(트랜잭션에 임시저장된 데이터를 DB에 반영)
														--ROLLBACK(트랜잭션에 임시저장된 데이터를 삭제하고 직전 COMMIT으로 돌아감)

-- DML UPDATE : 데이터베이스에 등록되어있는 데이터를 수정

SELECT SYSDATE FROM DUAL; --오늘날짜
SELECT EMAIL FROM EMPLOYEE WHERE EMAIL LIKE '___#_%' ESCAPE '#'; -- _ 앞에 세글자인 이메일 출력('#' == 탈출)

SELECT EMP_NAME, HIRE_DATE, ABS(TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE))) || '개월' "근무개월"
FROM EMPLOYEE; -- EMP_NAME , HIRE_DATE, 근무개월을 조회 <= SYSDATE과 HIRE_DATE의 위치가 바뀌면 -가되니 ABS를 해주고 내림하면 값이바뀔수도있으니 TRUNC
SELECT TO_CHAR(TO_DATE('210505', 'YYMMDD'), 'YYYY"년" MM"월" DD"일" HH24:MI:SS DAY') FROM DUAL; -- TO_CHAR 날짜형,숫자형 데이터를 문자타입으로 바꿔주는 함수
--																								210505 문자열데이터 2021년 05월 05일로 변환
SELECT BONUS, NVL(BONUS, 0) FROM EMPLOYEE; -- NVL 함수 : NULL인 컬럼값을 다른 값으로 변경 / BONUS가 NULL인 컬럼의 값을 0으로 변경;

-- DECODE / CASE END 구문
-- 직원의 급여를 인상하고자 한다.
-- 직급 코드가 J7인 직원은 20%, J6인 직원은 15%, J5인 직원은 10%, 그 외 직급은 5% 인상
-- 이름, 직급코드, 원래 급여, 인상률, 인상된 급여
SELECT EMP_NAME "이름", JOB_CODE "직급코드", SALARY "원래급여", DECODE(JOB_CODE, 'J7', '20%', 'J6', '15%', 'J5', '10%', '5%') "인상률",
DECODE(JOB_CODE, 'J7', SALARY * '1.2', 'J6', SALARY * '1.15', 'J5', SALARY * '1.1', SALARY * '1.05') "인상된 급여"
FROM EMPLOYEE;

SELECT EMP_NAME "이름", JOB_CODE "직급코드", SALARY "원래급여",
CASE 
	WHEN JOB_CODE = 'J7' THEN '20%'
	WHEN JOB_CODE = 'J6' THEN '15%'
	WHEN JOB_CODE = 'J5' THEN '10%'
	ELSE '5%'
END "인상률",
CASE 
	WHEN JOB_CODE = 'J7' THEN SALARY * '1.2'
	WHEN JOB_CODE = 'J6' THEN SALARY * '1.15'
	WHEN JOB_CODE = 'J5' THEN SALARY * '1.1'
	ELSE SALARY * '1.05'
END "인상된 급여"
FROM EMPLOYEE;

SELECT UPPER(EMAIL) FROM EMPLOYEE;-- UPPER 함수 조회한 컬럼이 영문자일 경우 대문자로 바꿔주는 함수

-- DDL(DATA DEFINITION LANGUAGE : 데이터 정의 언어) = 객체를 만들고(CREATE), 삭제하고(DROP), 수정(ALTER)
-- CREATE TABLE하는 방법 CREATE TABLE 테이블명(컬럼명1 자료형(크기), 컬럼명2 자료형(용량),....); <== 날짜랑 숫자는 용량X
-- 제약조건 : 사용자가 원하는 조건의 데이터만 유지하기 위해서 특정 컬럼에 설정하는 제약. 데이터 무결성 보장을 목적으로 함. -> 중복데이터X
--PRIMARY KEY, NOT NULL, UNIQUE, CHECK, FOREIGN KEY <= NOT NULL은 컬럼레벨에서만 가능, 나머지는 컬럼레벨 테이블레벨에서 지정가능
CREATE TABLE USER_GRADE( -- FOREIGN 참고용 테이블 생성
	GRADE_CODE NUMBER PRIMARY KEY,
	GRADE_NAME VARCHAR2(30) NOT NULL
);

INSERT INTO USER_GRADE VALUES(10, '일반회원');
INSERT INTO USER_GRADE VALUES(20, '우수회원');
INSERT INTO USER_GRADE VALUES(30, '특별회원');

SELECT * FROM USER_GRADE;

CREATE TABLE EMP(
	USER_NO NUMBER CONSTRAINT EMP_NO_PK PRIMARY KEY, -- 중복되지 않는값이 필수로 존재해야 하는 고유식별자역할 NOT NULL + UNIQUE
													-- (학번 등 한행의 정보를 찾기 위해 사용할 컬럼) 테이블당 한개만 설정할수있다
	USER_ID VARCHAR2(30) UNIQUE, -- 컬럼에 입력값에 대해서 중복을 제한하는 제약조건, NULL값은 중복 가능
	GRADE_CODE NUMBER CONSTRAINT GRADE_CODE_FK REFERENCES USER_GRADE/*(GRADE_CODE)*/, -- 컬럼명 미작성시 USER_GRADE 테이블의 pk를 자동 참조
	-- 테이블관에 관계형성, 참조된 다른 테이블의 컬럼이 제공하는 값만 사용, 그 외에는 NULL을 사용
	EMAIL VARCHAR2(50) NOT NULL -- 해당 컬럼에 반드시 값이 기록되어야하는 경우 사용
	--, CONSTRAINT USER_ID_U UNIQUE(USER_ID) : 테이블레벨에서 UNIQUE 지정(복합키는 무조건 테이블레벨에서 -> 모두 같아야 위배)
	--, CONSTRAINT USER_NO_PK PRIMARY KEY(USER_NO) : 테이블레벨에서 PRIMARY 지정
	--, CONSTRAINT GRADE_CODE_FK FOREIGN KEY(GRADE_CODE) REFERENCES USER_GRADE
);

SELECT * FROM EMP;

DROP TABLE USER_GRADE;
DROP TABLE EMP;

--문제해결시나리오
--사용자계정에서 test라는 이름과 비밀번호가 1234인 계정을 생성하기위해 
--create했는데 실행X 이유와 해결법은?
-- 이유: 계정생성 권한은 최고관리자인 SYSTEM계정밖에없기때문에 SYSTEM계정으로 접속해서 실행해야함  
-- 해결: sys as sysdba or system계정으로 접속해서 실행후
--		CREATE USER test IDENTIFIED BY 1234;
--		GRANT RESOURCE, CONNECT TO test <== 권한 부여

-- 연산자 우선순위
SELECT EMP_ID, EMP_NAME, EMAIL, DEPT_CODE, HIRE_DATE, SALARY
FROM EMPLOYEE
WHERE EMAIL LIKE '____#_%' ESCAPE '#'
AND (DEPT_CODE = 'D9' OR DEPT_CODE = 'D6') -- AND연산자가 OR 연산자보다 우선순위가 높아서 괄호로 묶어줌
AND HIRE_DATE BETWEEN '1990-01-01' AND '2000-12-13'
AND SALARY >= 2700000;


-- IS NULL : NULL(값이 없음) 인 경우 조회 / IS NOT NULL : NULL이 아닌 경우 (<> 이런거 안씀)
-- EMPLOYEE 테이블에서 보너스가 있는/없는 사원의 이름, 보너스 조회
SELECT EMP_NAME, BONUS FROM EMPLOYEE WHERE BONUS IS NOT NULL;
SELECT EMP_NAME, BONUS FROM EMPLOYEE WHERE BONUS IS NULL;

