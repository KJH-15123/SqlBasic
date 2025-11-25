--00_시스템계정에서 CHUN계정 생성.sql
--춘대학 계정 생성 
--계정명 비밀번호 모두 CHUN 으로 작성 후 가장 기본 권한 ROLE 부여하기 
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE; --오라클 내부 스크립트 실행 설정
CREATE USER CHUN IDENTIFIED BY CHUN;
GRANT CONNECT,RESOURCE TO CHUN;
GRANT UNLIMITED TABLESPACE TO CHUN;
-- + 테이블 생성공간 할당(노리밋)