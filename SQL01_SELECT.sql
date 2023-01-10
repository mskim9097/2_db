-- [Basic SELECT]

-- 1. 춘 기술대학교의 학과 이름과 계열을 표기하시오. 단, 출력 헤더는 "학과 명", "계열"으로 표시하도록 한다.

SELECT DEPARTMENT_NAME "학과 명", CATEGORY "계열" -- 계열은 "" 안써도되는데 걍 쓰는걸로 통일
FROM TB_DEPARTMENT;

-- 2. 학과의 학과 정원을 다음과 같은 형태로 화면에 출력한다.

SELECT DEPARTMENT_NAME || '의 정원은 ' || CAPACITY || '명 입니다.' "학과별 정원" 
FROM TB_DEPARTMENT;

-- 3. "국어국문학과" 에 다니는 여학생 중 현재 휴학중인 여학생을 찾아달라는 요청이 들어왔다.
-- 누구인가? (국문학과의 '학과코드'는 학과 테이블(TB_DEPARTMENT)을 조회해서 찾아 내도록 하자

SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE SUBSTR(STUDENT_SSN, 8, 1) = '2' -- 여자 주민번호 2로 시작 주민번호의 '-' 포함 8번째에서 1개의 숫자 출력
AND DEPARTMENT_NO = 001 -- 국어국문학과
AND ABSENCE_YN = 'Y';

-- 4. 도서관에서 대출 도서 장기 연체자 들을 찾아 이름을 게시하고자 한다.
-- 그 대상자들의 학번이 다음과 같을 때 대상자들을 찾는 적절한 SQL 구문을 작성하시오.
-- A513079, A513090, A513091, A513110, A513119

SELECT STUDENT_NAME 
FROM TB_STUDENT
WHERE STUDENT_NO IN('A513079', 'A513090', 'A513091', 'A513110', 'A513119')
ORDER BY STUDENT_NAME DESC ;

-- 5. 입학정원이 20명 이상 30명 이하인 학과들의 학과 이름과 계열을 출력하시요.

SELECT DEPARTMENT_NAME, CATEGORY
FROM TB_DEPARTMENT
WHERE CAPACITY BETWEEN 20 AND 30; -- 20이상부터 30이하까지

-- 6. 춘 기술대학교는 총장을 제외하고 모든 교수들이 소속 학과를 가지고 있다.
-- 그럼 춘 기술대학교 총장의 이름을 알아낼 수 있는 SQL 문장을 작성하시오.

SELECT PROFESSOR_NAME 
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL; -- 값이 존재하지 않을때

-- 7. 혹시 전산상의 착오로 학과가 지정되어 있지 않은 학생이 있는지 확인하고자 한다.
-- 어떠한 SQL 문장을 사용하면 될 것인지 작성하시오.

SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE DEPARTMENT_NO IS NULL; -- 값이 존재하지 않을때

-- 8. 수강신청을 하려고 한다. 선수과목 여부를 확인해야 하는데,
-- 선수과목이 존재하는 과목들은 어떤 과목인지 과목번호를 조회해보시오.

SELECT CLASS_NO
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL; -- 존재할때

-- 9. 춘 대학에는 어떤 계열(CATEGORY)들이 있는지 조회해보시오.

SELECT DISTINCT CATEGORY -- 중복확인은 DISTINCT 단 맨앞에 한번만 사용가능
FROM TB_DEPARTMENT
ORDER BY CATEGORY; -- 오름차순 정렬

-- 10. 02학번 전주 거주자들의 모임을 만들려고 한다.
-- 휴학한 사람들은 제외한 재학중인 학생들의 학번, 이름, 주민번호를 출력하는 구문을 작성하시오.

SELECT STUDENT_NO, STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE ENTRANCE_DATE BETWEEN '2002-01-01' AND '2002-12-31' -- 학번
AND STUDENT_ADDRESS LIKE '전주%' -- 전주로 시작하는 
AND ABSENCE_YN = 'N'; -- 휴학중

----------------------------------------------------------------------------------------

--[Additional SELECT - 함수]

-- 1. 영어영문학과(학과코드 002) 학생들의 학번과 이름, 입학 년도를 입학 년도가 빠른 순으로
-- 표시하는 SQL 문장을 작성하시오.(단, 헤더는 "학번", "이름", "입학년도" 가 표시되도록 한다.)

SELECT STUDENT_NO "학번", STUDENT_NAME "이름", ENTRANCE_DATE "입학년도"
FROM TB_STUDENT
WHERE DEPARTMENT_NO = '002'
ORDER BY ENTRANCE_DATE;

-- 2. 춘 기술대학교의 교수 중 이름이 세 글자가 아닌 교수가 한 명 있다고 한다.
-- 그 교수의 이름과 주민번호를 화면에 출력하는 SQL 문장을 작성해보자.
-- (* 이때 올바르게 작성한 SQL 문장의 결과 값이 예상과 다르게 나올수 있다. 원인이 무엇일지 생각해볼 것)

SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE LENGTH(PROFESSOR_NAME) <> '3';

-------아직 안배웠음---------
-- 3. 춘 기술대학교의 남자 교수들의 이름과 나이를 출력하는 SQL 문장을 작성하시오.
-- 단, 이때 나이가 적은 사람에서 많은 사람 순서로 화면에 출력되도록 만드시오.
-- (단, 교수 중 2000년 이후 출생자는 없으며 출력헤더는 "교수이름", "나이"로 한다. 나이는 '만'으로 계산한다.)

SELECT PROFESSOR_NAME "교수이름", 
FLOOR(MONTHS_BETWEEN(SYSDATE, PROFESSOR_SSN) / 12) "나이"
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN, 8, 1) = '1'
ORDER BY PROFESSOR_SSN;

-- 4. 교수들의 이름 중 성을 제외한 이름만 출력하는 SQL 문장을 작성하시오.
-- 출력 헤더는 "이름" 이 찍히도록 한다. (성이 2자인 경우는 교수는 없다고 가정하시오)

SELECT SUBSTR(PROFESSOR_NAME, 2) "이름"
FROM TB_PROFESSOR;

-------- 아직 안배웠음--------
-- 5. 춘 기술대학교의 재수생 입학자를 구하려고 한다.
-- 어떻게 찾아낼 것인가? 이때, 19살에 입학하면 재수를 하지 않은 것으로 간주한다.

SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE 

--