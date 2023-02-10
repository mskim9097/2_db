-- 로그인 SQL

SELECT MEMBER_NO, MEMBER_ID, MEMBER_NM, MEMBER_GENDER, 
TO_CHAR(ENROLL_DATE, 'YYYY"년" MM"월" DD"일" HH24:MI:SS') ENROLL_DATE
FROM MEMBER
WHERE MEMBER_ID = ? 
AND MEMBER_PW = ? 
AND SECESSION_FL = 'N';


-- 아이디 중복검사

SELECT COUNT(*) FROM MEMBER
WHERE MEMBER_ID = 'user01'
AND SECESSION_FL = 'N';

-- 회원가입

INSERT INTO MEMBER
VALUES(SEQ_MEMBER_NO.NEXTVAL, ?, ?, ?, ?, DEFAULT, DEFAULT);

-- 정보변경

UPDATE MEMBER SET MEMBER_NM = '김일tnd' WHERE MEMBER_ID = 'user01';

INSERT INTO MEMBER VALUES(SEQ_MEMBER_NO.NEXTVAL, 'user06', 'pass06', '황인범', 'M', DEFAULT, DEFAULT);

SELECT * FROM MEMBER;

DELETE FROM MEMBER
WHERE MEMBER_ID = 'user04';

GRANT RESOURCE, CONNECT TO member_ms;

SELECT * FROM "COMMENT";

SELECT * FROM BOARD;

COUNT(*)
FROM "COMMENT"
F

SELECT BOARD_NO || ',' || MEMBER_NO
FROM "COMMENT"
LEFT JOIN "MEMBER" USING(MEMBER_NO);

-- 댓글 수 조회
SELECT BOARD_NO, BOARD_TITLE, CREATE_DT
FROM "COMMENT"
FULL JOIN BOARD USING(BOARD_NO)
FULL JOIN "MEMBER" USING(MEMBER_NO)
ORDER BY CREATE_DT;

-- 게시글 목록 조회

SELECT DISTINCT BOARD_NO, BOARD_TITLE, NVL(COUNT(COMMENT_NO), 0) COMMENT_COUNT, MEMBER_NM, B.CREATE_DT, READ_COUNT
FROM BOARD B
LEFT JOIN MEMBER M ON (M.MEMBER_NO = B.MEMBER_NO)
FULL JOIN "COMMENT" C USING(BOARD_NO)
GROUP BY BOARD_NO, BOARD_TITLE, MEMBER_NM, B.CREATE_DT, READ_COUNT
ORDER BY B.CREATE_DT DESC;

SELECT BOARD_NO, BOARD_TITLE, MEMBER_NM, READ_COUNT, 
		CASE
			WHEN SYSDATE - CREATE_DT < 1/24/60
			THEN FLOOR((SYSDATE - CREATE_DT) * 24 * 60 * 60) || '초 전'
			WHEN SYSDATE - CREATE_DT < 1/24
			THEN FLOOR((SYSDATE - CREATE_DT) * 24 * 60) || '분 전'
			WHEN SYSDATE - CREATE_DT < 1
			THEN FLOOR((SYSDATE - CREATE_DT) * 24) || '시간 전'
			ELSE TO_CHAR(CREATE_DT, 'YYYY-MM-DD')
		END CREATE_DT,
		(SELECT COUNT(*)
		FROM "COMMENT" C
		WHERE C.BOARD_NO = B.BOARD_NO) COMMENT_COUNT
		FROM BOARD B
		JOIN MEMBER USING(MEMBER_NO)
		WHERE DELETE_FL = 'N'
		ORDER BY BOARD_NO DESC;




-- 게시글 상세 조회
SELECT BOARD_NO, BOARD_TITLE, BOARD_CONTENT, MEMBER_NM, CREATE_DT, READ_COUNT
FROM BOARD
LEFT JOIN MEMBER USING(MEMBER_NO)
WHERE BOARD_NO = '1'
ORDER BY CREATE_DT;

-- 댓글 목록
SELECT COMMENT_NO, COMMENT_CONTENT, CREATE_DT, MEMBER_NM
FROM "COMMENT"
LEFT JOIN MEMBER USING(MEMBER_NO)
WHERE BOARD_NO = '3';


INSERT INTO "COMMENT"
VALUES(SEQ_COMMENT_NO.NEXTVAL, '댓글 샘플 4번', DEFAULT, DEFAULT, 3, 1 );