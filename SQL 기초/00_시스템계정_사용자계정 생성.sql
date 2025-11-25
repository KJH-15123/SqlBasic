--한줄 주석 

/*
    여러줄 주석
*/
--관리자 계정(SYSTEM) : DB의 생성과 관리를 담당하는 계정으로 모든 권한과 책임을 가지는 계정
--사용자 계정 : DB에 대해서 질의,갱신,보고서 작성등의 작업을 수행할 수 있는 계정, 업무에 필요한 최소한의 권한만
--            가지는것을 원칙으로 한다.

--계정 생성
--일반 사용자 계정을 만들 수 있는 권한은 관리자 계정에 있다.
--사용자 계정 생성 방법
--12C 이후 버전부터 계정명 앞에 C## 접두사 부여 
--[표현법] CREATE USER 계정명 IDENTIFIED BY 비밀번호;
CREATE USER C##KH IDENTIFIED BY KH; -- CTRL + ENTER 한줄 실행
--C##접두어 붙이지 않고 계정 생성하기 위한 설정 
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE; --오라클 내부 스크립트 실행 설정
--위 설정을 하면 사용자 계정에 C## 을 붙이지 않아도 된다. FALSE 가 되어있으면 C##필요 
CREATE USER KH IDENTIFIED BY KH; --계정생성 
GRANT CONNECT,RESOURCE TO KH; -- 권한 부여 
--테이블 생성공간 부여 권한 TABLE SPACE (계정 만들어 있을때 수정 처리)
--용량 제한 권한수정 
ALTER USER KH QUOTA 100M ON USERS; 
--또는 무제한 사용 권한 부여
GRANT UNLIMITED TABLESPACE TO KH;


--사용자 계정을 생성한 뒤 권한을 부여해야 접속을 할 수 있다.
--생성된 사용자 계정에 최소한의 권한 부여하기 
--[권한부여 표현법] GRANT 권한1,권한2,...TO 계정명;
--부여할 권한 ROLE : CONNECT ,RESOURCE
--CONNECT : 접속 권한 (CREATE SESSION) / RESOURCE -- 작업권한 CREATE,INSERT,UPDATE,DELETE 등등...
GRANT CONNECT,RESOURCE TO C##KH;


--계정 삭제 구문 
--[표현법] DROP USER 계정명;
DROP USER C##KH;













