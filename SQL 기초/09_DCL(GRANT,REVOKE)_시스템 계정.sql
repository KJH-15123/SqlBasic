/*
    파일명 : 09_DCL(GRANT,REVOKE)_시스템 계정
    DCL (DATA CONTROL LANGUAGE)
    데이터 제어 언어
    
    계정에게 시스템 권한 또는 객체 접근 권한을 부여(GRANT) 하거나 회수(REVOKE)하는 언어
    
    -권한부여(GRANT)
    GRANT 권한1,권한2,..TO 계정명;
    
        -시스템 권한 종류
        CREATE SESSION : 계정 접속 권한
        CREATE TABLE : 테이블 생성 권한
        CREATE VIEW : 뷰 생성 권한
        CREATE SEQUENCE : 시퀀스 생성 권한
        CREATE UWER : 계정 생성 권한
        ...
*/

--스크립트 세팅 C##처리 안해도 되도록
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
--1 TEST 계정 생성
CREATE USER TEST IDENTIFIED BY TEST;
/*상태: 실패 -테스트 실패:
    ORA-01045: 
    사용자 TEST는 CREATE SESSION 권한을 가지고있지 않음;
    로그온이 거절되었습니다
    
    CREATE SESSION 권한을 부여하지 않았기 때문에 접속 불가
*/

--2.접속 권한 부여하기
GRANT CREATE SESSION TO TEST;

--3.테이블 생성 권한 부여하기
GRANT CREATE TABLE TO TEST;

--4.테이블 스페이스 권한 부여하기
GRANT UNLIMITED TABLESPACE TO TEST;

--5.VIEW 생성 권한 부여하기
GRANT CREATE VIEW TO TEST;

/*
    OBJECT 접근 권한
    SELECT,INSERT,UPDATE,DELETE
    
    [표현법]
    GRANT 권한종류 ON 대상 OBJECT TO 계정명
    
    권한 종류 별 대상 OBJECT
    -SELECT : TABLE,VIEW,SEQUENCE
    -INSERT,UPDATE,DELETE : TABLE,VIEW
*/

--6.TEST계정에 KH계정 EMPLOYEE테이블 SELECT 권한 부여하기
GRANT SELECT ON KH.EMPLOYEE TO TEST;

--7.TEST계정에 KH계정 DEPT_COPY2 테이블 INSERT,SELECT 권한 부여하기
GRANT INSERT,SELECT ON KH.DEPT_COPY2 TO TEST;

/*
    <ROLE>
    특정 권한들을 하나의 집합으로 묶어놓은 것
    CONNECT : CREATE SESSSION(접속권한)
    RESOURCE : CREATE TABLE,CREATE SEQUENCE,SELECT,INSERT,...
*/

--권한 조회 구문 조회
SELECT * 
FROM DBA_SYS_PRIVS
WHERE GRANTEE IN('CONNECT','RESOURCE')
ORDER BY 1;

-------------------------------------------------------------
/*
    권한 쇠수(REVOKE)
    권한을 회수하는 구문
    
    [표현법]
    REVOKE 권한1,권한2,... FROM 계정명
*/

--8.TEST에 부여한 권한 회수하기
REVOKE CREATE TABLE FROM TEST;