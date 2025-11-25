/*
    파일명 : 08_DDL(ALTER,DROP) KH계정
    
    DDL(DATA DEFINITION LANGUAGE)
    데이터 언어 정의
    
    객체들을 생성(CREATE), 수정(ALTER)하고 삭제(DROP)하는 구문
    
    1. ALTER
    객체 구조를 수정하는 구문
    
    <테이블 수정>
    [표현법]
    ALTER TABLE 테이블명 수정내용
    
    -수정할 내용
    1)컬럼 추가/수정/삭제
    2)제약조건 추가/삭제 - 수정은 불가능
    3)테이블명/컬럼명/제약조건명 수정
    
    1)컬럼 추가/수정/삭제
    --컬럼추가 ADD
        ADD 컬럼명 자료형 DEFAULT 기본값 (DEFAULT 생략 가능)
    --컬럼수정 MODIFY
        MODIFY 컬럼명 자료형 DEFAULT 기본값 (DEFAULT 생략 가능)
            바꿀 자료형으로 표현할 수 없는 데이터가 이미 있다면 변경 불가
    --컬럼 삭제DROP COLUMN
        DROP CLOUMN 컬럼명
            테이블의 모든 열을 삭제할 수는 없다.
    --제약조건 삭제
        PRIMARY KEY,FOREIGN KEY, UNIQUE,CHECK 수정시
            ->DROP CONSTRINT 제약조건명
        NOT NULL 수정시
            ->MODIFY 컬럼명 NULL
    2)컬럼명,제약조건명,테이블명 변경(RENAME)
    --컬럼명 변경
        RENAME COLUMN 기존컬럼명 TO 바꿀컬럼명
    --제약조건명 변경
        RENAME CONSTRAINT 기존제약조건명 TO 바꿀제약조건명
    --테이블 명 변경
        RENAME TO 바꿀 테이블명
*/

SELECT * FROM DEPT_COPY;
--CNAME 컬럼 추가
ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20) DEFAULT '한국';

ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(20);

--DEPT_COPY 테이블의 DEPT_ID 컬럼 자료형을 CHAR(3)으로 변경해보기
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);

--DEPT_ID 컬럼 자료형 크기를 CHAR(1)로 변경해뵉
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(1);
--ORA-01441 일부 값이 너무 커서 자료형을 줄일 수 없다.
--담겨있는 데이터보다 작은 크기로 변경 불가

--한번에 여러개 변경해보기
ALTER TABLE DEPT_COPY
    MODIFY DEPT_TITLE VARCHAR2(50)
    MODIFY LOCATION_ID VARCHAR2(10)
    MODIFY LNAME DEFAULT '미국';

--DEPT_COPY 테이블의 DEPT_ID컬럼 자료형을 NUMBER로 변경해보기
ALTER TABLE DEPT_COPY MODIFY DEPT_ID NUMBER;
--기존 데이터는 기본값에 영향을 받지 않는다.

INSERT INTO DEPT_COPY(DEPT_ID,DEPT_TITLE,LOCATION_ID)
    VALUES('D9','테스트부서','L5');
    
--컬럼 삭제(DROP COLUMN) CROP CLOUMN 컬럼명
CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPT_COPY;

ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_ID;
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY2 DROP COLUMN LOCATION_ID;
ALTER TABLE DEPT_COPY2 DROP COLUMN LNAME;
ALTER TABLE DEPT_COPY2 DROP COLUMN CNAME;
SELECT * FROM DEPT_COPY2; --오류

/*
    제약조건 추가
    ADD PRIMARY KEY (컬럼명)
    ADD UNIQUE (컬럼명)
    ADD CHECK(컬럼명)
    ADD FOREIGN KEY (컬럼명) REFERENCES 참조테이블명(컬럼명)
    MODIFY 컬럼명 NOT NULL
    
    제약조건명을 부여하고자 한다면
    CONSTRAINT 제약조건명을 앞에 붙이기
    
*/


--DEPT_COPY 테이블에
--DEPT_ID 컬럼에 PK추가 DEPT_TITLE 컬럼에 UNIQUE 추가
--LNAME 컬럼에 NOT NULL 추가 (제약조건명 DCOPY_NN)
ALTER TABLE DEPT_COPY
    ADD PRIMARY KEY(DEPT_ID)
    ADD UNIQUE(DEPT_TITLE)
    MODIFY CNAME CONSTRAINT DCOPY_NN NOT NULL; --이미 해당 컬럼에 NULL이 있어서 오류
    
--DEPT_COPY 테이블에 있는 제약조건들 지워보기
--PK,NOT NULL,UNIQUE 제약조건명 확인후 지워보기
ALTER TABLE DEPT_COPY
    DROP CONSTRAINT SYS_C008516
    DROP CONSTRAINT SYS_C008517
    MODIFY CNAME NULL;
    
--DEPT_COPY에서 DEPT_TITLE을 DEPT_NAME으로 바꾸기
ALTER TABLE DEPT_COPY
    RENAME COLUMN DEPT_TITLE TO DEPT_NAME;
SELECT * FROM DEPT_COPY;

ALTER TABLE DEPT_COPY
    RENAME CONSTRAINT SYS_C008579 TO NN;

ALTER TABLE DEPT_COPY
    RENAME TO DEPT_TEST;

---------------------------------------------
/*
    DROP
    객체를 삭제하는 구문
    [표현법]
    DROP TALBE 테이블명;
*/

CREATE TABLE DROPTABLE
AS SELECT * FROM DEPT_TEST;

SELECT * FROM DROPTABLE;

DROP TABLE DROPTABLE; -- 삭제

---
ALTER TABLE DEPT_TEST
    DROP CONSTRAINT SYS_C008586; 
---

--부모 테이블을 삭제하는 경우
--DEPT_TEST 테이블 DEPT_ID 컬럼에 PK추가
ALTER TABLE DEPT_TEST
    ADD CONSTRAINT DTEST_PK PRIMARY KEY(DEPT_ID);
    
ALTER TABLE EMPLOYEE_COPY2
ADD CONSTRAINT ECOPY2_FF FOREIGN KEY(DEPT_CODE) REFERENCES DEPT_TEST;

--부모테이블 삭제해보기
DROP TABLE DEPT_TEST; --외래 키에 참조되는 고유/기본키가 테이블에 있다. ,삭제 불가
--삭제방법 2가지
/*
    1.자식테이블 지우고 부모테이블 지우기
    DROP TABLE 자식테이블
    DROP TABLE 부모테이블
    
    2. 테이블 삭제할때 제약조건까지 삭제하는 옵션 부여하기
    [표현법]DROP TABLE 부모테이블명 CASECADE CONSTRAINTS;
*/

DROP TABLE DEPT_TEST CASCADE CONSTRAINTS;
SELECT * FROM DEPT_TEST;


