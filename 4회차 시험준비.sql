-- 00sys계정 01SELECT 02함수 03GROUPBYHAVING 05DML 06TCL 07서브쿼리 08,09 DDL 
-- 뷰 시퀀스 인덱스 DCL 안나옴 1월 20일 배운거까지

-- DBMS란? 데이터베이스에서 데이터 추출, 조작, 정의, 제어 등을 할 수 있게 해주는 데이터베이스 전용 관리 프로그램
-- 오라클 데이터베이스 숫자 자료형 = NUMBER (정수,실수) 
-- CHAR(100) = 100바이트 고정길이문자열 (영어 100자) (VARCHAR2 = 가변길이문자열)
INNER JOIN이란 ? 연결되는 컬럼값이 일치하는 행들만 조인됨.
OUTER JOIN 컬럼값이 일치하지않은 행도 조인에 포함시킴
-- TABLE이란? 데이터를 표형태로 표현한거
--SQL(Structured Query Language) 구조적 질의 언어 - DQL, DML, DDL, DCL, TCL
--RESULT SET OR 결과 SET 이란? SELCT구문에 의해 조회된 행들의 집합
문자열데이터 날짜로 바꾸는 셀렉트구문작성
MINUS? 차집합 셀렉결과랑 다음셀렉결과의 겹치는 결과를 제외한 나머지
날짜변환문제 여러개있음
SELECT SUBSTR(EMAIL, 1, INSTR(EMAIL, '@') -1 ) FROM EMPLOYEE; -- EMAIL의 1번째 부터 INSTR - 1(@전)까지의 문자 출력
-- UPPER	: 조회한 컬럼이 영문자일 경우 대문자로 바꿔주는 함수
SELECT UPPER(EMAIL) FROM EMPLOYEE;
-- INITCAP  : 조회한 컬럼이 영문자일 경우 앞글자를 대문자로 변환해 주는 함수
SELECT INITCAP(EMAIL) FROM EMPLOYEE;
TRIM이란?
-- DECODE / CASE END 구문
-- 직원의 급여를 인상하고자 한다.
-- 직급 코드가 J7인 직원은 20%, J6인 직원은 15%, J5인 직원은 10%, 그 외 직급은 5% 인상
-- 이름, 직급코드, 원래 급여, 인상률, 인상된 급여
SELECT EMP_NAME "이름", JOB_CODE "직급코드", SALARY "원래급여", DECODE(JOB_CODE, 'J7', '20%', 'J6', '15%', 'J5', '10%', '5%') "인상률",
DECODE(JOB_CODE, 'J7', SALARY * '1.2', 'J6', SALARY * '1.15', 'J5', SALARY * '1.1', SALARY * '1.05') "인상된 급여"
FROM EMPLOYEE;

랭크오버 / 덴스랭크오버 시험에나옴
그룹바이 해빙절 작성법

MEMBER_KH
MNO NUMBER PRIMARY KEY 회원번호
MNAME VARCHAR2(300) NOTNULL 회원명
ADDRESS VARCHAR2(1000) 주소
INSERT (1,~~~~
INSERT (1,~~~~
생성안됨 이유는? PRIMARY키는 중복허용안하고 필수로 있어야하는 고유식별자이기때문에)

ROLL UP 함수: 그룹별로 중간 집계 처리를 하는 함수

TRIM 함수 : 조회한 컬럼 양 끝에 띄어쓰기나 빈칸이 있을 경우, 이를 제거해주는 역할을 한다.


UNION과 UNION ALL의 차이 : UNION 대신 UNION ALL은 중복결과를 포함한 결과를 나타낸다. UNION은 중복을 제거하는 작업을 해야하기 때문에 UNION ALL이 속도가 빠르다.



[Set Operator]

INTERSECT : 선행 SELECT 결과에서 다음 SELECT 결과와 겹치는 부분만을 추출한 것(교집합)


MINUS: 선행 SELECT 결과에서 다음 SELECT 결과와 겹치는 부분을 제외한 나머지 부분 추출(차집합)


CONCAT 함수 : 여러 문자열을 하나로 합쳐주는 역할

ex) SELECT EMP_ID || ', ' || EMP_NAME || ', ' || EMP_NO FROM EMPLOYEE;

위 SELECT 구문을 CONCAT 을 이용하여 변경 가능

SELECT CONCAT(CONCAT(CONCAT(CONCAT(EMP_ID, ', '), EMP_NAME), ', '), EMP_NO) FROM EMPLOYEE;

사진있음

결과는 같음.