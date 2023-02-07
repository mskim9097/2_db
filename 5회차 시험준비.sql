-- NUMBER : 숫자 자료형(오라클에서 실수,정수)
-- VARCHAR2 : 가변길이문자 최대 4000바이트 남으면삭제
-- CHAR : 고정길이문자 최대 2000바이트 남아도 그대로

-- TCL(Transaction Control Language) : 트랜잭션 제어 언어
-- COMMIT : 트랜잭션에 임시 저장된 데이터를 DB에 반영
-- ROLLBACK : 트랜잭션에 임시저장된 데이터 삭제 후 직전 커밋 OR 지정된 SAVEPOINT 지점으로 보냄

-- SUBQUERY : 하나의 SQL문안에 포함된 또다른 SQL문(보조역할)

-- 1. 단일행 서브쿼리(서브쿼리 조회결과 1개) : 앞에 비교연산자 사용
-- 2. 다중행 서브쿼리(서브쿼리 조회결과 N개) : 앞에 비교연산자 사용 불가
-- IN / NOT IN
-- > ANY(하나라도 크면) <= 최소값보다 크면 / < ANY(하나라도 작으면) <= 최댓값보다 작으면
-- > ALL (최대값보다 크면) / < ALL (최소값보다 작으면)
-- EXIST / NOT EXISTS

-- 3. 다중열 서브쿼리(나열된 컬럼수가 N개일때)
-- WHERE절에 작성된 컬럼 순서에 맞게 서브쿼리에 조회된 컬럼과 비교하여 일치하는 행만 조회
-- (컬럼 순서가 중요!) (WHERE (컬럼1, 컬럼2) = (SELECT 컬럼1, 컬럼2 FROM ~~~~)

-- 4. 다중행 다중열 서브쿼리 (서브쿼리 조회결과 행,열 수가 여러개일때)
-- 5. 상[호연]관 서브쿼리 (메인쿼리의 값이 변경되면 서브쿼리의 결과값도 바뀜)
-- SELECT EMP_NAME, JOB_CODE, SALARY (직급별 평균급여보다 많은 사람찾기)
-- FROM EMPLOYEE MAIN
-- WHERE SALARY > (SELECT AVG(SALARY)
		-- FROM EMPLOYEE SUB
		-- WHERE SUB.JOB_CODE = MAIN.JOB_CODE);
-- 6. 스칼라 서브쿼리 (SELECT절에 사용되는 서브쿼리 결과로 1행만 반환)
-- SELECT EMP_ID, EMP_NAME, NVL(MANAGER_ID, '없음'), (스칼라+상관커리 연습)
-- NVL((SELECT EMP_NAME 
	-- FROM EMPLOYEE SUB 
	-- WHERE MAIN.MANAGER_ID = SUB.EMP_ID
	-- ), '없음') "관리자명"
-- FROM EMPLOYEE MAIN;

--7. 인라인뷰(FROM절에서 서브쿼리사용) = 서브쿼리가 만든 RESULT SET을 테이블 대신 사용
-- ROWNUM(1,2,3,4,... 순서대로)
-- RANK() OVER (ORDER BY SALARY DESC) = 동일 순위 이후의 등수를 동일 인원수만큼 건너뛰고 순위 계산(공동1등2명이면 다음은 3등)
-- DENSE_RANK() OVER (ORDER BY SALARY DESC) = 동일 순위 이후 등수를 이후의 순위로 계산(공동1등 2명이여도 다음은 2등)
-- WITH 별칭 AS (셀렉문) == 서브쿼리에 이름 붙여주고 사용시 이름사용, 실행속도 빨라짐

-- Set Operator 종류
-- UNION : 선행 SELECT문의 결과와 나중 SELECT문의 결과의 합집합
-- UNION과 UNION ALL의 차이 : UNION ALL은 중복결과를 포함 / 중복제거작업 생략으로 속도가 더빠름
-- INTERSECT : 선행 SELECT문의 결과와 나중 SELECT문의 결과의 교집합
-- MINUS : 선행 SELECT문의 결과에서 나중 SELECT문의 결과를 뺀 차집합

-- DDL(Data Definition Language) : 데이터 정의 언어(CREATE, ALTER, DROP)
-- 객체를 만들고 수정하고 삭제하는 언어(COMMIT/ROLLBACK이 안되기때문에 신중하게 해야함)
									--(DML과 섞어쓰지말것)

-- PRIMARY KEY : 중복되지 않는값이 필수로 존재해야하는 고유식별자역할
				--(NOT NULL + UNIQUE) 테이블당 한개만 설정할수있다
-- FOREIGN KEY : 테이블관 관계형성, 참조된 다른 테이블의 컬럼이 제공하는 값만 사용
-- ON DELETE CASCADE = 부모키 삭제하면 자식키도 삭제되는 옵션
-- ON DELETE SET NULL = 부모키 삭제시 자식키를 NULL로 변경하는 옵션
-- CHECK : 범위나 조건을 지정하여 그안에 값만 허용하는 제약조건(비교값은 리터럴만사용가능)
-- DEFAULT : 데이터 삽입시 컬럼에 값을 입력하지 않았을때 자동으로 입력되는 기본값
-- ALTER TABLE 테이블명 ADD (컬럼명 데이터타입 [DEFAULT '값'];
-- ALTER TABLE 테이블명 MODIFY 컬럼명 DEFAULT '값';

-- VIEW : SELECT문의 RESULT SET을 저장하는 객체(가상테이블)
-- 사용 목적 1. SELECT문을 쉽게 재사용 2. 보안상 유리
-- 주의 사항 1. 실제테이블x -> ALTER구문 사용불가 2. DML이 가능한경우도 있지만 많은 제약때문에 SELECT용도 사용 권장

-- SEQUENCE : 순차적 번호 자동 발생기 역할의 객체
-- (객체 생성 후 호출하면 지정된 범위내 일정한간격으로 증가하는 숫자가 순차적으로 출력)

-- DCL(Data Control Language) : 데이터 제어 언어
--(계정에 DB, DB객체에 대한 접근 권한을 부여(GRANT), 회수(REVOKE)하는 언어)

-- 문제해결 시나리오--

-- 크레이트한 테이블에 알터이용해서 프라이머리키 삽입하는방법?
-- ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] PRIMARY KEY(컬럼명);
-- 사용자계정을 만든다음에 접속하려고했는데 에러발생 접속하려면?
-- ORA-01045: 사용자 계정은 CREATE SESSION 권한을 가지고있지 않음; 로그온이 거절되었습니다
-- 원인 : 사용자계정을 만들 당시 접속 권한을 가지고 있지않음 -> 시스템계정에서 사용자 계정에 권한부여
-- GRANT CREATE SESSION TO 아이디;
어떤테이블에 어떤코드순으로 오름차순하려고했는데 오류발생

SELECT DEPT_CODE, JOB_CODE, AVG(SALARY) FROM EMPLOYEE GROUP BY DEPT_CODE, JOB_CODE ORDER BY 2, 3 DESC , 1;

ALTER TABLE TB_TEST ADD(TEST VARCHAR2(3));
ALTER TABLE TB_TEST DROP(TEST);
