/* SELECT (DQL 또는 DML) : 조회
 * 
 * - 데이터를 조회(SELECT)하면 조건에 맞는 행들이 조회됨.
 * 이 때, 조회된 행들의 집합을 "RESULT SET" 조회 결과의 집합 이라고 한다.
 * 
 * - RESULT SET은 0개 이상의 행을 포함할 수 있다.
 * 왜 0개? 조건에 맞는 행이 없을 수도 있어서!
 * 
 * */

-- [작성법]
-- SELECT 컬럼명 FROM 테이블명;
--> 어떤 테이블의 특정 컬럼을 조회하겠다.

SELECT * FROM EMPLOYEE;
-- '*' : ALL, 모든, 전부

-- 사번, 직원이름, 휴대전화번호 조회
SELECT EMP_ID, EMP_NAME, PHONE FROM EMPLOYEE;

--------------------------------------------------------------

-- <컬럼 값 산술 연산>
-- 컬럼 값: 테이블 내 한 칸 (== 한 셀)에 작성된 값(DATA)

-- EMPLOYEE 테이블에서 모든 사원의 사번, 이름, 급여, 연봉(급여 *12) 조회
SELECT EMP_ID, EMP_NAME, SALARY, SALARY * 12 FROM EMPLOYEE;

SELECT EMP_NAME + 10 FROM EMPLOYEE;
-- ORA-01722: 수치가 부적합합니다
-- 산술 연산은 숫자(NUMBER 타입)만 가능하다!

---------------------------------------------------------------

-- 날짜(DATA) 타입 조회

-- EMPLOYEE 테이블에서 이름, 입사일, 오늘 날짜 조회
SELECT EMP_NAME, HIRE_DATE, SYSDATE 
FROM EMPLOYEE;

-- 1990-02-06 00:00:00.000
-- SYSDATE : 시스템상의 현재 시간(날짜)를 나타내는 상수


-- 현재 시간만 조회하기
SELECT SYSDATE FROM DUAL;
-- DUAL(DUmmy tAbLe) 테이블: 가짜 테이블(임시 조회용 테이블)

-- 날짜 + 산술연산(+, -)
SELECT SYSDATE - 1, SYSDATE, SYSDATE + 1
FROM DUAL;
-- 날짜에 +/- 연산 시 일 단위로 계산이 진행됨


---------------------------------------------------------------

-- <컬럼 별칭 지정>

/* 컬럼명 AS 별칭 : 별칭 띄어쓰기 X, 특수문자X, 문자만O
 * 
 * 컬럼명 AS "별칭" : 별칭 띄어쓰기 O, 특수문자O, 문자O
 * 
 * AS는 생략 가능
 */

-- SELECT 조회 결과의 집합인 RESULT SET에 출력되는 컬럼명을 지정
SELECT SYSDATE - 1 "하루 전", SYSDATE AS 현재시간, SYSDATE  + 1 내일
FROM DUAL;

------------------------------------------------------------------

-- JAVA 리터럴 : 값 자체를 의미

-- DB 리터럴 : 임의로 지정한 값을 기존 테이블에 존재하는 값처럼 사용하는 것
--> (필수) DB의 리터럴 표기법은 ' ' 홑따옴표
--> " " 쌍따옴표는 특수문자, 대소문자, 기호 등을 구분하여 나타낼 때 사용하는 표기법
--> 쌍따옴표 안에 작성되는 것들이 하나의 단어이다.

SELECT EMP_NAME, SALARY, '원 입니다' FROM EMPLOYEE;


---------------------------------------------------------------------

-- DISTINCT : 조회 시 컬럼에 포함된 중복 값을 한 번만 표기
-- 주의사항 1) DISTINCT 구문은 SELECT 마다 딱 한번씩만 작성 가능
-- 주의사항 2) DISTINCT 구문은 SELECT 제일 앞에 작성되어야 한다.


SELECT DISTINCT DEPT_CODE, JOB_CODE FROM EMPLOYEE;


---------------------------------------------------------------------

-- 3. SELECT절 : SELECT 컬럼명
-- 1. FROM절 : FROM 테이블명
-- 2. WHERE절(조건절) : WHERE 컬럼명 연산자 값;
-- 4. ORDER BY 컬럼명 | 별칭 | 컬럼 순서 [ASC | DESC] [NULLS FIRST | LAST]
--									(오름 / 내림차순)

-- EMPLOYEE 테이블에서 급여가 3백만원 초과인 사원의
-- 사번, 이름, 급여, 부서코드를 조회

SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- EMPLOYEE 테이블에서 부서코드가 'D9' 인 사원의
-- 사번, 이름, 부서코드, 직급코드 조회

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9'; -- 비교연산자(=) / 대입연산자 (:=)

-- 비교연산자 : >, <, >=, <=, =(같다), !=, <> (같지 않다)

---------------------------------------------------------------------

-- 논리 연산자(AND, OR)

-- EMPLOYEE 테이블에서 급여가 300만 미만 또는 500만 이상인 사원의
-- 사번, 이름, 급여, 전화번호 조회

SELECT EMP_ID, EMP_NAME, SALARY, PHONE
FROM EMPLOYEE
WHERE SALARY < 3000000 OR SALARY >= 5000000;


-- EMPLOYEE 테이블에서 급여가 300만 이상 500만 미만인 사원의
-- 사번, 이름, 급여, 전화번호 조회

SELECT EMP_ID, EMP_NAME, SALARY, PHONE
FROM EMPLOYEE
WHERE SALARY >= 3000000 AND SALARY < 5000000;

-- BETWEEN A AND B : A이상 B이하

-- 300만 이상, 600만 이하

SELECT EMP_ID, EMP_NAME, SALARY, PHONE
FROM EMPLOYEE
WHERE SALARY BETWEEN 3000000 AND 6000000;

--NOT 연산자

SELECT EMP_ID, EMP_NAME, SALARY, PHONE
FROM EMPLOYEE
WHERE SALARY NOT BETWEEN 3000000 AND 6000000;

-- 날짜(DATE)에 BETWEEN 이용하기
-- EMPLOYEE 테이블에서 입사일이 1990-01-01 ~ 1999-12-31 사이인 직원의
-- 이름, 입사일 조회

SELECT EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '1990-01-01' AND '1999-12-31';


-- ex) 1 = '1'

SELECT  '같음'
FROM DUAL
WHERE 1 = '1';

--------------------------------------------------------------------

-- LIKE : ~처럼, ~같은
-- 비교하려는 값이 특정한 패턴을 만족 시키면 조회하는 연산자

-- [작성법]
-- WHERE 컬럼명 LIKE '패턴이 적용된 값'

-- LIKE의 패턴을 나타내는 문자(와일드 카드)
--> '%' : 포함
--> '_' : 글자 수

-- '%' 예시
-- 'A%' : A로 시작하는 문자열
-- '%A' : A로 끝나는 문자열
-- '%A%' : A를 포함하는 문자열

-- '_' 예시
-- 'A_' : A로 시작하는 두 글자 문자열
-- '___A' : A로 끝나는 네 글자 문자열
-- '__A__' : 세 번째 문자가 A인 다섯글자 문자열
-- '_____' : 다섯 글자 문자열

-- EMPLOYEE 테이블에서 성이 '전'씨인 사원의 사번, 이름 조회

SELECT EMP_ID, EMP_NAME 
FROM EMPLOYEE
--WHERE EMP_NAME LIKE '전%';
WHERE EMP_NAME LIKE '전__';

-- EMPLOYEE 테이블에서 전화번호가 010으로 시작하지 않는 사원의
-- 사번, 이름, 전화번호 조회

SELECT  EMP_ID, EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%';

-- EMPLOYEE 테이블에서 EMAIL의 _앞에 글자가 세글자 인 사원 조회

SELECT EMP_NAME, EMAIL 
FROM EMPLOYEE
WHERE EMAIL LIKE '____%';

-- ESCAPE
-- ESCAPE문자 뒤에 작성된 _ 는 일반 문자로 탈출 한다는 뜻
-- #, ^ 를 많이 씀.
SELECT EMP_NAME, EMAIL 
FROM EMPLOYEE
WHERE EMAIL LIKE '___#_%' ESCAPE '#';

------------------------------------------------------------------

-- 연습문제!!!

-- EMPLOYEE 테이블에서
-- 이메일 '_'앞이 4글자 이면서
-- 부서코드가 'D9' 또는 'D6'이고 -> AND가 OR 보다 우선순위가 높다, () 사용 가능
-- 입사일이 1990-01-01 ~ 2000-12-13 이고
-- 급여가 270만 이상인 사원의
-- 사번, 이름, 이메일, 부서코드, 입사일, 급여 조회

SELECT EMP_ID, EMP_NAME, EMAIL, DEPT_CODE, HIRE_DATE, SALARY
FROM EMPLOYEE
WHERE EMAIL LIKE '____#_%' ESCAPE '#'
AND (DEPT_CODE = 'D9' OR DEPT_CODE = 'D6')
AND HIRE_DATE BETWEEN '1990-01-01' AND '2000-12-13'
AND SALARY >= 2700000;

-- 연산자 우선순위

/*
 *  1. 산술연산자 ( + - / * )
 * 	2. 연결연산자 ( || )
 *  3. 비교연산자 ( > < >= <= = != <> )
 *  4. IS NULL / IS NOT NULL, LIKE, IN /NOT IN
 *  5. BETWEEN AND / NOT BETWEEN AND
 *  6. NOT(논리연산자)
 *  7. AND(논리연산자)
 *  8. OR(논리연산자)
 * 
 * */


-------------------------------------------------------------------

/* IN 연산자
 * 
 * 비교하려는 값과 목록에 작성된 값 중
 * 일치하는 것이 있으면 조회하는 연산자
 * 
 * [작성법]
 * WHERE 컬럼명 IN(값1, 값2, 값3......)
 */

-- EMPLOYEE 테이블에서
-- 부서코드가 D1, D6, D9 인 사원의
-- 사번, 이름, 부서코드 조회

SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IN('D1', 'D6', 'D9'); -- 9명
/*
WHERE DEPT_CODE = 'D1'
OR DEPT_CODE  = 'D6'
OR DEPT_CODE = 'D9';
*/

-- NOT IN
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE NOT IN('D1', 'D6', 'D9') -- 12명
OR DEPT_CODE IS NULL; -- 부서코드 없는 2명 포함 14명

-- IS NULL
-- IS NOT NULL

--------------------------------------------------------------------

-- NULL 처리 연산자

-- JAVA에서 NULL : 참조하는 객체가 없음을 의미하는 값
-- DB에서 NULL : 컬럼에 값이 없음을 의미하는 값

-- 1) IS NULL : NULL 인 경우 조회
-- 2) IS NOT NULL : NULL이 아닌 경우

-- EMPLOYEE 테이블에서 보너스가 있는 사원의 이름, 보너스 조회

SELECT EMP_NAME, BONUS
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;

--------------------------------------------------------------------

-- ORDER BY 절
-- EMPLOYEE 테이블 급여 오름 차순으로
-- 사번, 이름, 급여 조회

SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY; -- ASC가 기본값

-- 급여 200만 이상인 사원의
-- 사번, 이름, 급여 조회
-- 단, 급여 내림 차순으로 조회

SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY >= 2000000
ORDER BY SALARY DESC;

-- 입사일 순서대로 이름, 입사일 조회(별칭사용)

SELECT EMP_NAME 이름, HIRE_DATE 입사일
FROM EMPLOYEE
ORDER BY 입사일;

-- 부서별 (DEPT_CODE)로 급여 내림차순 정렬
-- D1부서에서 가장 많은~ 가장 적은사람까지 내림차순 정렬
-- D2부서에서 ...

/* 정렬 중첩 : 대분류 정렬 후 소분류 정렬 */
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
ORDER BY DEPT_CODE, SALARY DESC;