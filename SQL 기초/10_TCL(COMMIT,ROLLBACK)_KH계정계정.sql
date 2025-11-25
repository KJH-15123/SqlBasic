/*
    -파일명 : 10_TCL(COMMIT,ROLLBACK)_KH계정
    
    TCL(TRANSACTION CONTROL LANGUAGE)
    트랜잭션 제어 언어
    
    *트랜잭션(TRANSACTION)
    -데이터 베이스의 논리적 작업 단위
    -데이터의 변경사항(DML)들을 하나의 트랜잭션으로 묶어서 처리
    -COMMIT(확정)하기 전까지의 변경사항들을 하나의 트랜잭션으로 처리
    -트랜잭션의 대상이 되는 SQL-DML 구문(INSERT,UPDATE,DELETE)
    
        *트랜잭션
        -COMMIT
            하나의 트랜잭션에 담겨있는 변경사항들을 실제 DB에 적용하겠다는 의미
            실제 DB에 반영시킨 후 트랜잭션은 비워진다(확정)
        -ROLLBACK
            하나의 트랜잭션에 담겨있는 변경사항등릉 실제 DB에 적용하지 않고
            트랜잭션에 담겨있는 변경사항을 삭제한 뒤 마지막 COMMIT 시점으로 되돌아간다.
        -SAVEPOINT 포인트명
            현재 시점에 임시 저장점을 정의하는 것
        -ROLLBACK TO 포인트명
            전체 변경사항들을 삭제하는 것이 아닌SAVEPOINT 지점까지만 되돌린다.
*/
CREATE TABLE EMP_01 AS
    SELECT
        EMP_ID
        ,EMP_NAME
        ,DEPT_TITLE
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID);

--ROLLBACK으로 돌아가는 지점
SELECT * FROM EMP_01;

DELETE FROM EMP_01
WHERE EMP_ID = '901';

UPDATE EMP_01
SET DEPT_TITLE = '인사부'
WHERE EMP_ID = '214';

INSERT INTO EMP_01 VALUES('999','김구구','운영관리부');

ROLLBACK;
--
UPDATE EMP_01
SET DEPT_TITLE = '인사부'
WHERE EMP_ID = '214';

INSERT INTO EMP_01 VALUES('999','김구구','운영관리부');
SELECT*FROM EMP_01;
COMMIT;
--롤백을 해도 COMMIT한 것들은 확정 되었기에 변하지 않는다.
ROLLBACK;

/*
    SAVEPOINT로 임시지점 기록하기
*/
--일반 ROLLBACK 지점
--25행으로 시작
DELETE
    FROM EMP_01
    WHERE EMP_ID IN(900,901,999); --23행
--SAVE POINT 지정
SAVEPOINT SP1;
SELECT * FROM  EMP_01;
DELETE
    FROM EMP_01
    WHERE EMP_ID >300;  --1행
SELECT* FROM EMP_01;
ROLLBACK; --25행으로 돌아감
ROLLBACK TO SP1; --23행으로 돌아감

/*
    주의 사항
    DDL구문(CREATE,ALTER,DROP)를 실행하면
    기존 트랜잭션에 있던 변경 사항들이 반영된다. (COMMIT)
    그 이후 DDL구문이 수행됨
    따라서 DDL구문을 수행하기 전에 DML 변경 작업이 있었다면
    COMMMIT 또는 ROLLBACK으로 확정지어주고 진행해야한다.
*/

