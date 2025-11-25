/*
    파일명 : 09_DCL(GRANT,REVOKE)_TEST 계정
*/

--테이블 생성해보기
CREATE TABLE TEST(
    NO NUMBER,
    NAME VARCHAR2(20)
);
--ORA-01031: 권한이 불충분합니다

--권한 부여 후
CREATE TABLE TEST(
    NO NUMBER,
    NAME VARCHAR2(20)
);

--INSERT COLUMN 실행해보기
INSERT INTO TEST VALUES(1,'김일번');
--SQL 오류: ORA-01950: 테이블스페이스 'USERS'에 대한 권한이 없습니다
--권한 부여 후
INSERT INTO TEST VALUES(1,'김일번');

--VIEW 생성해보기
--VIEW : SELECT 구문을 저장하여 마치 테이블처럼 조회할 수 있는 OBJECT
CREATE VIEW VW_TEST AS
    SELECT * FROM TEST;
--ORA-01031: 권한이 불충분합니다 -> VIEW 생성권한이 없음
--권한 부여 이후
CREATE VIEW VW_TEST AS
    SELECT * FROM TEST;
    
SELECT *
FROM VW_TEST;

--TEST 계정에서 다른 계정에 있는 테이블에 접근해보기(KH 계정)
--계정명.테이블명 으로 접근
SELECT * FROM KH.EMPLOYEE; --접근 권한 부여하지 않아서 조회 불가

--권한 부여 후
SELECT * FROM KH.EMPLOYEE;
--권한 
INSERT INTO KH.DEPT_COPY2 VALUES('미국');
SELECT * FROM KH.DEPT_COPY2;
--다른 계정이나 다른 세션은 아직 COMMIT되지 않은 변경 사항을 볼 수 없음
--트랜잭션 반영
COMMIT;
--------------------------------------------------------------------------
--SYSTEM에서 CREATE TABLE 권한 회수
CREATE TABLE NEWTABLE(
    NO NUMBER
    ,NAME VARCHAR(15)
); --ORA-01031: 권한이 불충분합니다

