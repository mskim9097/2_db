/*
    * SUBQUERY (서브쿼리)
    - 하나의 SQL문 안에 포함된 또다른 SQL(SELECT)문
    - 메인쿼리(기존쿼리)를 위해 보조 역할을 하는 쿼리문
    -- SELECT, FROM, WHERE, HAVING 절에서 사용가능

*/  

-- 서브쿼리 예시 1.
-- 부서코드가 노옹철 사원과 같은 소속의 직원의 
-- 이름, 부서코드 조회하기

-- 1) 사원명이 노옹철인 사람의 부서코드 조회

SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';

-- 2) 부서코드가 D9인 직원을 조회

SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9'

-- 3) 부서코드가 노옹철사원과 같은 소속의 직원 명단 조회   

SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE  
WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '노옹철');
                   
                   
-- 서브쿼리 예시 2.
-- 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의 
-- 사번, 이름, 직급코드, 급여 조회

-- 1) 전 직원의 평균 급여 조회하기

SELECT CEIL(AVG(SALARY)) 
FROM EMPLOYEE;

-- 2) 직원들중 급여가 3047663원 이상인 사원들의 사번, 이름, 직급코드, 급여 조회

SELECT EMP_NO, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= '3047663';

-- 3) 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원 조회

SELECT EMP_NO, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= (SELECT CEIL(AVG(SALARY)) FROM EMPLOYEE);



-------------------------------------------------------------------

/*  서브쿼리 유형

    - 단일행 (단일열) 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 1개일 때 
    -> 조회 결과가 1행1열
    
    - 다중행 (단일열) 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 여러개일 때
    -> 행은 여러개 컬럼은 1개
    
    - 다중열 서브쿼리 : 서브쿼리의 SELECT 절에 자열된 항목수가 여러개 일 때
    -> 컬럼이 여러개, 행은 1개
    
    - 다중행 다중열 서브쿼리 : 조회 결과 행 수와 열 수가 여러개일 때 
    -> 행도 여러개 컬럼도 여러개
    
    - 상관 서브쿼리 : 서브쿼리가 만든 결과 값을 메인 쿼리가 비교 연산할 때 
                     메인 쿼리 테이블의 값이 변경되면 서브쿼리의 결과값도 바뀌는 서브쿼리
                     --> 메인이 먼저, 서브가 나중에 해석된다.
                     
    - 스칼라 서브쿼리 : 상관 쿼리이면서 결과 값이 하나인 서브쿼리
    
   * 서브쿼리 유형에 따라 서브쿼리 앞에 붙은 연산자가 다름
    
*/


-- 1. 단일행 서브쿼리 (SINGLE ROW SUBQUERY)
--    서브쿼리의 조회 결과 값의 개수가 1개인 서브쿼리
--    단일행 서브쿼리 앞에는 비교 연산자 사용
--    <, >, <=, >=, =, !=/^=/<>


-- 전 직원의 급여 평균보다 많은(초과) 급여를 받는 직원의 
-- 이름, 직급, 부서, 급여를 직급 순으로 정렬하여 조회

SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE)
ORDER BY JOB_CODE;

-- 가장 적은 급여를 받는 직원의
-- 사번, 이름, 직급, 부서코드, 급여, 입사일을 조회

SELECT EMP_NO, EMP_NAME, JOB_NAME, DEPT_CODE, SALARY, HIRE_DATE
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE SALARY = (SELECT MIN(SALARY) FROM EMPLOYEE);

-- 노옹철 사원의 급여보다 많이 받는 직원의 
SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME = '노옹철';
-- 사번, 이름, 부서, 직급, 급여를 조회

SELECT EMP_NO, EMP_NAME, DEPT_TITLE, JOB_NAME, SALARY
FROM EMPLOYEE 
NATURAL JOIN JOB
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE SALARY > (SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME = '노옹철');

-- 부서별(부서가 없는 사람 포함) 급여의 합계 중 가장 큰 부서의
-- 부서명, 급여 합계를 조회 

-- 1) 부서별 급여 합 중 가장 큰값 조회

SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 2) 부서별 급여합이 17700000인 부서의 부서명과 급여 합 조회

SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) = '17700000';

-- 3) 위의 두 서브쿼리 합쳐 부서별 급여 합이 큰 부서의 부서명, 급여 합 조회
       
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY)) FROM EMPLOYEE GROUP BY DEPT_CODE);
                      
-------------------------------------------------------------------------

-- 2. 다중행 서브쿼리 (MULTI ROW SUBQUERY)
--    서브쿼리의 조회 결과 값의 개수가 여러행일 때 

/*  >> 다중행 서브쿼리 앞에는 일반 비교연산자 사용 불가.

    - IN / NOT IN : 여러 개의 결과값 중에서 한 개라도 일치하는 값이 있다면
                    혹은 없다면 이라는 의미(가장 많이 사용!)
    - > ANY, < ANY : 여러개의 결과값 중에서 한개라도 큰 / 작은 경우
                     가장 작은 값보다 큰가? / 가장 큰 값 보다 작은가?
    - > ALL, < ALL : 여러개의 결과값의 모든 값보다 큰 / 작은 경우
                     가장 큰 값 보다 큰가? / 가장 작은 값 보다 작은가?
    - EXISTS / NOT EXISTS : 값이 존재하는가? / 존재하지 않는가?
    
*/

-- 부서별 최고 급여를 받는 직원의 
-- 이름, 직급, 부서, 급여를 부서 순으로 정렬하여 조회

SELECT MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE; -- 7행 1열

SELECT EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN(SELECT MAX(SALARY) FROM EMPLOYEE GROUP BY DEPT_CODE)
ORDER BY DEPT_CODE;

-- 부서별 최고 급여(SUBQUERY)

-- 사수에 해당하는 직원에 대해 조회 
--  사번, 이름, 부서명, 직급명, 구분(사수 / 직원)
-- * 사수 == MANAGER_ID 컬럼에 작성된 사번

-- 1) 사수에 해당하는 사원 번호 조회

SELECT DISTINCT MANAGER_ID -- DISTINCT : 중복제거
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL;

-- 2) 직원의 사번, 이름, 부서명, 직급 조회

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '사수' "구분"
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE);

-- 3) 사수에 해당하는 직원에 대한 정보 추출 조회 (이때, 구분은 '사수'로)

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID 
				FROM EMPLOYEE 
				WHERE MANAGER_ID IS NOT NULL);

-- 4) 일반 직원에 해당하는 사원들 정보 조회 (이때, 구분은 '사원'으로)

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '사원' "구분"
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID 
					FROM EMPLOYEE 
					WHERE MANAGER_ID IS NOT NULL);


-- 5) 3, 4의 조회 결과를 하나로 합침 -> SELECT절 SUBQUERY
-- * SELECT 절에도 서브쿼리 사용할 수 있음
	
-- 집합연산자 중 선택함수(DECODE or CASE문) 사용!
--> DECODE(컬럼명, 값1, 1인경우, 값2, 2인경우,.... 일치하지 않는경우)
--> CASE WHEN 조건1 THEN 값1
--	     WHEN 조건2 THEN 값2	
--	     ELSE 값
--  END 별칭	  

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME,
	CASE WHEN EMP_ID IN (SELECT DISTINCT MANAGER_ID 
						FROM EMPLOYEE 
						WHERE MANAGER_ID IS NOT NULL)
					THEN '사수'
					ELSE '사원'
				END "구분"
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
ORDER BY EMP_ID;
	      
-- * 집합 연산자(UNION, 합집합) 사용 방법
-- 쉽긴하지만 정렬을 하려고하면 RESULT SET을 SELECT하는 구문이 또 필요함

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '사수' "구분"
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID 
				FROM EMPLOYEE 
				WHERE MANAGER_ID IS NOT NULL)
UNION	
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '사원' "구분"
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID 
					FROM EMPLOYEE 
					WHERE MANAGER_ID IS NOT NULL);
				    
-- 정렬을 하려고 할 때 RESULT SET 대한 SELECT 구문이 또 필요함~!				    
				    



-- 대리 직급의 직원들 중에서 과장 직급의 최소 급여보다 많이 받는 직원의
-- 사번, 이름, 직급, 급여를 조회하세요
-- 단, > ANY 혹은 < ANY 연산자를 사용하세요

-- > ANY, < ANY : 여러개의 결과값 중에서 하나라도 큰 / 작은 경우
--                     가장 작은 값보다 큰가? / 가장 큰 값 보다 작은가?

-- 1) 직급이 대리인 직원들의 사번, 이름, 직급명, 급여 조회
			
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리';

-- 2) 직급이 과장인 직원들 급여 조회

SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장';

-- 3) 대리 직급의 직원들 중에서 과장 직급의 최소 급여보다 많이 받는 직원
-- 3-1) MIN을 이용하여 단일행 서브쿼리를 만듦.

SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
AND SALARY > (SELECT MIN(SALARY)
			FROM EMPLOYEE
			JOIN JOB USING(JOB_CODE)
			WHERE JOB_NAME = '과장');

-- 3-2) ANY를 이용하여 과장 중 가장 급여가 적은 직원 초과하는 대리를 조회
			 
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
AND SALARY < ANY (SELECT SALARY
			FROM EMPLOYEE
			JOIN JOB USING(JOB_CODE)
			WHERE JOB_NAME = '과장');
-- > ANY : 과장급여 3개중, 최소금액인 220 보다 더 큰 SALARY
-- < ANY : 과장급여 3개중, 최대금액인 376 보다 더 작은 SALARY


-- 차장 직급의 급여의 가장 큰 값(280만)보다 많이 받는 과장 직급의 직원
-- 사번, 이름, 직급, 급여를 조회하세요
-- 단, > ALL 혹은 < ALL 연산자를 사용하세요
		
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'
AND SALARY > ALL (SELECT SALARY /* MAX(SALARY) */
			FROM EMPLOYEE
			JOIN JOB USING(JOB_CODE)
			WHERE JOB_NAME = '차장');
		
SELECT MAX(SALARY)
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '차장';

-- > ALL, < ALL : 여러개의 결과값의 모든 값보다 큰 / 작은 경우
--                     가장 큰 값 보다 크냐? / 가장 작은 값 보다 작냐?
				 --> ANY와 반대
	


-- 서브쿼리 중첩 사용(응용편!)
-- 서브쿼리 안에 서브쿼리...


-- LOCATION 테이블에서 NATIONAL_CODE가 KO인 경우의 LOCAL_CODE와
-- DEPARTMENT 테이블의 LOCATION_ID와 동일한 DEPT_ID가 
-- EMPLOYEE테이블의 DEPT_CODE와 동일한 사원을 구하시오.
--> TIP! 테이블 전체 조회부터 한줄씩 결과 찾아나가기

-- 1) LOCATION 테이블을 통해 NATIONAL_CODE가 KO인 LOCAL_CODE 조회

SELECT LOCAL_CODE
FROM LOCATION
WHERE NATIONAL_CODE = 'KO'; -- 'L1'

-- 2) DEPARTMENT 테이블에서 위의 결과와 동일한 LOCATION_ID를 가지고 있는 DEPT_ID를 조회

SELECT DEPT_ID
FROM DEPARTMENT
WHERE LOCATION_ID = (SELECT LOCAL_CODE
					FROM LOCATION
					WHERE NATIONAL_CODE = 'KO'); -- D1,D2,D3,D4,D9

-- 3) 최종적으로 EMPLOYEE 테이블에서 위의 결과들과 동일한 DEPT_CODE를 가지는 사원을 조회

SELECT EMP_NAME , DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IN (SELECT DEPT_ID
					FROM DEPARTMENT
					WHERE LOCATION_ID = (SELECT LOCAL_CODE
										FROM LOCATION
										WHERE NATIONAL_CODE = 'KO'));
					
-----------------------------------------------------------------------

-- 3. (단일행) 다중열 서브쿼리 (단일행 = 결과값은 한 행)
--    서브쿼리 SELECT 절에 나열된 컬럼 수가 여러개 일 때

-- 퇴사한 여직원과 같은 부서, 같은 직급에 해당하는
-- 사원의 이름, 직급, 부서, 입사일을 조회        

-- 1) 퇴사한 여직원 조회

SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE ENT_YN = 'Y' -- 퇴직한사람
AND SUBSTR(EMP_NO, 8, 1) = '2';  -- 여직원

-- 2) 퇴사한 여직원과 같은 부서, 같은 직급 (다중 열 서브쿼리)

SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
					FROM EMPLOYEE
					WHERE ENT_YN = 'Y' -- 퇴직한사람
					AND SUBSTR(EMP_NO, 8, 1) = '2')
AND JOB_CODE = (SELECT JOB_CODE
					FROM EMPLOYEE
					WHERE ENT_YN = 'Y' -- 퇴직한사람
					AND SUBSTR(EMP_NO, 8, 1) = '2');

-- 단일행 서브쿼리 2개를 사용해서 조회
--> 서브쿼리가 같은 테이블, 같은 조건, 다른 컬럼 조회

-- 다중열 서브쿼리
--> WHERE절에 작성된 컬럼 순서에 맞게
--	서브쿼리의 조회된 컬럼과 비교하여 일치하는 행만 조회
--  (컬럼 순서가 중요!)
				
/*SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE, JOB_CODE
					FROM EMPLOYEE
					WHERE ENT_YN = 'Y' -- 퇴직한사람
					AND SUBSTR(EMP_NO, 8, 1) = '2');*/
-- ORA-00913: 값의 수가 너무 많습니다

SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
					FROM EMPLOYEE
					WHERE ENT_YN = 'Y' -- 퇴직한사람
					AND SUBSTR(EMP_NO, 8, 1) = '2');

-------------------------- 연습문제 ------------------------------- (전부 다중열 서브쿼리)
-- 1. 노옹철 사원과 같은 부서, 같은 직급인 사원을 조회하시오. (단, 노옹철 사원은 제외)
--    사번, 이름, 부서코드, 직급코드, 부서명, 직급명

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE 
								FROM EMPLOYEE
								WHERE EMP_NAME = '노옹철')
							AND EMP_NAME <> '노옹철';

-- 2. 2000년도에 입사한 사원의 부서와 직급이 같은 사원을 조회하시오
--    사번, 이름, 부서코드, 직급코드, 고용일
						
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE 
								FROM EMPLOYEE 
								WHERE EXTRACT(YEAR FROM HIRE_DATE) = '2000');

-- 3. 77년생 여자 사원과 동일한 부서이면서 동일한 사수를 가지고 있는 사원을 조회하시오
--    사번, 이름, 부서코드, 사수번호, 주민번호, 고용일    

SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID, EMP_NO, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, MANAGER_ID) = (SELECT DEPT_CODE, MANAGER_ID 
								FROM EMPLOYEE 
								WHERE SUBSTR(EMP_NO, 1, 2) = '77' 
								AND SUBSTR(EMP_NO, 8, 1) = '2');

----------------------------------------------------------------------

-- 4. 다중행 다중열 서브쿼리
--    서브쿼리 조회 결과 행 수와 열 수가 여러개 일 때

-- 본인 직급의 평균 급여를 받고 있는 직원의
-- 사번, 이름, 직급, 급여를 조회하세요
-- 단, 급여와 급여 평균은 만원단위로 계산하세요 TRUNC(컬럼명, -4)    

-- 1) 급여를 200, 600만 받는 직원 (200만, 600만이 평균급여라 생각 할 경우)
			
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN('2000000', '6000000');

-- 2) 직급별 평균 급여

SELECT JOB_CODE, TRUNC(AVG(SALARY), -4)
FROM EMPLOYEE
GROUP BY JOB_CODE;

-- 3) 본인 직급의 평균 급여를 받고 있는 직원

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, TRUNC(AVG(SALARY), -4)
						FROM EMPLOYEE
						GROUP BY JOB_CODE);
            

-------------------------------------------------------------------------------

