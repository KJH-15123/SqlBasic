--파일명 : 12_OBJECT(SQUENCE)_KH계정
/*
    <시퀀스 SEQUENCE>
    자동으로 번호를 발생시켜주는 객체
    정수값을 순차적으로 발생시킨다.
    EX)회원번호,사번,게시글 번호 등등.. 순차적으로 겹치지 않는 숫자로 채번할때 사용한다.
    
    시퀀스 객체 생성 구문
    [표현법]
    CREATE SEQUENCE 시퀀스명
    START WITH 시작값
    INCREMENT BY 증가값
    MAXVALUE
    MINVALUE
    CYCLE/NOCYCLE
    CACHE 바이트 크기 / NOCACHE(CACHE_SIZE 기본값 20BYTE)
    
    캐시메모리
    -시퀀스로부터 미리 발생될 값들을 생성하여 저장한다
    캐시메모리에 미리 생성된 값을 저장하고 가져다 쓰게 되면
    매번 숫자를 발생시키는것보다 속도가 더 빠르지만
    접속이 끊긴뒤 다시 접속을 할 경우 기존 캐시메모리에 저장해놓은 값이 사라지고
    그 다음 번호부터 발행된다.
*/
--시퀀스 생성
CREATE SEQUENCE SEQ_TEST;
--현재 접속한 계정이 소유한 시퀀스 정보 조회
SELECT *
FROM USER_SEQUENCES;

/*
    시퀀스 사용 구문
    
    시퀀스명.CURRVAL : 현재 시퀀스의 값(마지막으로 발생된 NEXTVAL의 값)
    시퀀스명.NEXTVAL : 현재 시퀀스의 값을 증가시키고 증가된 시퀀스의 값
    
    -시퀀스 생성 후 첫 NEXTVAL은 START WITH로 지정된 시작값으로 발생한다.
    시퀀스 생성 후 NEXTVAL을 사용하지 않고 CURRVAL을 수행할 수 없다
        (값이 뽑혀야 현재값을 보여줄 수 있기 때문)
*/

--현재값 조회
SELECT SEQ_TEST.CURRVAL
FROM DUAL; -- DUAL가상테이블 이용하여 번호 확인
--CURRVAL은 해당 시퀀스의 마지막으로 뽑힌 NEXTVAL을 보여주는 임시값이기 때문에
--생성 후 아직 NEXTVAL을 하지 않으면 CURRVAL을 볼 수 없다.

--번호 뽑기
SELECT SEQ_TEST.NEXTVAL
FROM DUAL; --실행할때마다 시퀀스 값이 늘어난다.

--여러 옵션을 부여한 시퀀스 생성해보기
CREATE SEQUENCE SEQ_EMPID
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;

--다음번호
SELECT SEQ_EMPID.NEXTVAL
FROM DUAL; --300
--현재 번호
SELECT SEQ_EMPID.CURRVAL
FROM DUAL;
--설정 보기
SELECT *
FROM USER_SEQUENCES;
--번호 더 뽑기
SELECT SEQ_EMPID.NEXTVAL
FROM DUAL; --305
SELECT SEQ_EMPID.NEXTVAL
FROM DUAL; --310
SELECT SEQ_EMPID.NEXTVAL
FROM DUAL; --MAXVALUE 초과로 오류
SELECT SEQ_EMPID.CURRVAL
FROM DUAL; --현재 값 추출 -> 310으로 나온다

/*
    시퀀스 변경
    
    [표현법]
    ALTER SEQUENCE 시퀀스명
        INCREMENT BY 증가값
        MAXVALUE 최대값
        MINVALUE 최소값
        CYCLE/NOCYCLE 순환여부
        CACHE/NOCACHE 캐시메모리 사용 여부
        
    -시퀀스 수정구문으로 START WITH는 변경 불가(시작값)
    만약 START WITH를 변경하고자 한다면 삭제 후 재생성(DROP)
*/

ALTER SEQUENCE SEQ_EMPID
    INCREMENT BY 10
    MAXVALUE 400;
    
SELECT SEQ_EMPID.NEXTVAL FROM DUAL;

--SEQUENCE 삭제
DROP SEQUENCE SEQ_EMPID;

SELECT *
FROM USER_SEQUENCES;

--SEQ_EMPID라는 이름의 시퀀스를
--250을 시작값으로 1씩 증가하여 최대 300까지 증가하는 시퀀스로 만들기
--해당 시퀀스를 이용해여 EMPLOYEE테이블에 사원데이터 2개를 넣어보시오
--이때 사번은 시퀀스를 이용할것, 나머지 데이터는 자유롭게 작성
CREATE SEQUENCE SEQ_EMPID
START WITH 250
INCREMENT BY 1
MAXVALUE 300;

SELECT * FROM EMPLOYEE;

INSERT INTO EMPLOYEE(EMP_ID,EMP_NAME,EMP_NO,JOB_CODE,SAL_LEVEL)
    VALUES (SEQ_EMPID.NEXTVAL,'김지환2','950716-1049275','J2','S5');
INSERT INTO EMPLOYEE(EMP_ID,EMP_NAME,EMP_NO,JOB_CODE,SAL_LEVEL)
    VALUES (SEQ_EMPID.NEXTVAL,'김지환3','750716-1049275','J1','S4');
    
SELECT
    *
FROM EMPLOYEE
WHERE EMP_NAME LIKE '김지환%';

DELETE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '김지환%';