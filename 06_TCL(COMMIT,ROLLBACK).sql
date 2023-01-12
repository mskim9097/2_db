-- TCL(TRANSACTION CONTROL LANGUAGE) : 트랜잭션 제어 언어
-- COMMIT(트랜잭션 종료 후 저장), ROLLBACK(트랜잭션 취소), SAVEPOINT(임시저장)

-- DML(INSERT, UPDATE, DELETE) 관련 되어 있다.


/* TRANSACTION 이란?
 * 
 * - 데이터베이스 논리적 연산 단위
 * ==> 데이터베이스의 상태를 변화 시키기 위해서, 수행하는 작업 단위
 * 
 * - 데이터 변경 사항을 묶어 하나의 트랜잭션에 담아 처리함.
 * 
 * - 트랜잭션의 대상이 되는 데이터 변경 사항: INSERT, UPDATE, DELETE(DML) + MERGE
 * 
 * EX)  INSERT 수행 -------------------------------------> DB 반영(X)
 * 
 * 		INSERT 수행 ---> 트랜잭션에 추가 ---> COMMIT ----> DB반영(O)
 * 
 * 		INSERT 10번 수행 --> 1개 트랜잭션에 10개 추가  --> ROLLBACK --> DB 반영 안됨
 * 
 * 
 * 1) COMMIT : 메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경 사항을 DB에 반영
 * 
 * 2) ROLLBACK : 메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경 사항을 삭제하고
 * 					마지막 COMMIT 상태(시점)로 돌아감. (DB에 변경 내용 반영 X)
 * 
 * 3) SAVEPOINT : 메모리 버퍼(트랜잭션)에 저장 지점을 정의하여
 * 					ROLLBACK 수행 시 전체 작업을 삭제하는 것이 아닌
 * 					저장 지점까지만 일부 ROLLBACK
 * 
 * [SAVEPOINT 사용법]
 * 
 * SAVEPOINT 포인트명1;
 * ...
 * SAVEPOINT 포인트명2;
 * ...
 * ROLLBACK TO 포인트명1; -- 포인트1 지점까지 데이터 변경사항 삭제
 */

SELECT * FROM DEPARTMENT2;

-- 새로운 데이터 INSERT
INSERT INTO DEPARTMENT2 VALUES('T1', '개발1팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T2', '개발2팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T3', '개발3팀', 'L2');

-- INSERT 확인
SELECT * FROM DEPARTMENT2;
--> DB에 반영된 것 처럼 보이지만
-- SQL 수행 시 트랜잭션에 임시 저장된 상태
-- (실제로 아직 DB 반영 X)

ROLLBACK;
SELECT * FROM DEPARTMENT2;

-- 새로운 데이터 INSERT
INSERT INTO DEPARTMENT2 VALUES('T1', '개발1팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T2', '개발2팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T3', '개발3팀', 'L2');

SELECT * FROM DEPARTMENT2;

COMMIT;

SELECT * FROM DEPARTMENT2;

ROLLBACK;

SELECT * FROM DEPARTMENT2; --> 롤백 안됨!

-----------------------------------------------------------------


-- SAVEPOINT 확인
INSERT INTO DEPARTMENT2 VALUES('T4', '개발4팀', 'L2');
SAVEPOINT SP1; -- SAVEPOINT 지정
SELECT * FROM DEPARTMENT2;

INSERT INTO DEPARTMENT2 VALUES('T5', '개발5팀', 'L2');
SAVEPOINT SP2;
SELECT * FROM DEPARTMENT2;

INSERT INTO DEPARTMENT2 VALUES('T6', '개발6팀', 'L2');
SAVEPOINT SP3;
SELECT * FROM DEPARTMENT2;


ROLLBACK TO SP1;

SELECT * FROM DEPARTMENT2;