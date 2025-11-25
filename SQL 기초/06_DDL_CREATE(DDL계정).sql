-- 파일명 : 06_DDL_CREATE(DDL계정)

/*
    DDL(DATA DEFINITION LANGUAGE)
    데이터 정의 언어
    
    객체들을 새롭게 생성(CREATE)하고 수정(ALTER)하고 삭제(DROP)하는 구문들
    
    1. CREATE 객체 생성 구문
    2. ALTER 객체 생성 구문
    3. DROP 객체 생성 구문
    
    - 테이블 생성 구문
    *테이블 :
        행(ROW),열(COLUMN)으로 구성되는 가장 기본적인 데이터베이스 객체 종류 중 하나로
        모든 데이터는 테이블을 통해 저장된다(데이터를 조작하고자 하려면 테이블을 생성하고 데이터를 넣어야한다.)
        
    [표현법]
    CREATE TABLE 테이블명(
        컬렴명 자료형,
        컬럼명 자료형,
        ...
    );
        
    <자료형>
    -문자 CAHR(크기)/ VARCHAR2(크기)
        크기는 BYTE단위이며 숫자,영문,특수문자는 한 글자당 1BYTE 한글은 3BYTE를 차지한다.
        -CHAR : 고정길이(크기만큼 데이터가 들어오지 않으면 남는 자리는 공백)
        -VARCHAR2 : 가변길이(크기보다 적은 데이터가 들어오면 값에 맞춰 크기 유지)
        
        NUMBER : 정수/실수 상관없이 NUMBER로 표기
        DATE : 날짜 데이터를 담는 자료형(년/월/일/시/분/초)형식으로 저장
*/

--회원들의 정보를 담을 테이블 생성해보기 (아이디 비밀번호 이름 생년월일)
CREATE TABLE MEMBER(
    MEMBER_ID VARCHAR2(20)
    ,MEMBER_pwd varchar2(20) --소문자로 써도 대문자로 입력됨
    ,MEMBER_NAME VARCHAR2(20)
    ,MEMBER_DATE DATE
);

--테이블 확인
SELECT *
FROM MEMBER;

--데이터 딕셔너리 이용하여 테이블 확인
/*
    데이터 딕셔너리
    다양한 객체들의 정보를 저장하고 있는 시스템 테이블
*/

--테이블 확인
SELECT*
FROM USER_TABLES;

--컬럼 확인
SELECT *
FROM USER_TAB_COLUMNS;

/*
    COMMENTS 적어두기
    컬럼에 대한 설명을 달아둘 수 있다.
    
    [표현법]
    COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
    
*/

-- 주석 달기
COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원 아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PWD IS '회원 비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원 이름';
COMMENT ON COLUMN MEMBER.MEMBER_DATE IS '생년월일';

/*
    DML : INSERT 사용하여 데이터 추가해보기
    
    [표현법]
    INSERT INTO 테이블명 VALUEW(값,값,...);
        값의 순서가 중요하다 (테이블 컬럼 정의 순서와 맞추기)
*/

INSERT INTO MEMBER VALUES ('user01','pass01','김유저','000101');
INSERT INTO MEMBER VALUES ('user02','qwe123','박유저','991001');


--확인
SELECT*
FROM MEMBER;

INSERT INTO MEMBER VALUES ('user01','zxc123','최유저','980101'); --아이디 중복 데이터
--아이디 중복데이터를 허용하지 않기 위해서 제약조건을 부여해야한다.

/*
    <제약조건 CONSTRAINT>
    원하는 데이터만 유지하기 위해 특정 컬럼마다 설정하는 제약
    제약 조건이 부여된 컬럼에 들어올 데이터에 문제가 없는지 검사해준다.
    
    종류
    NOT NULL/ UNIQUE /CHECK /PRIMARY KEY /FOREIGN KEY
    
    컬럼에 제약조건을 부여하는 방식 : 컬럼 레벨 방식 / 테이블 레벨 방식
    
    1. NOT NULL 제약조건
    해당 컬럼에는 반드시 값이 존재해야하는 경우 사용
    -삽입 / 수정시 NULL값을 허용하지 않게 됨
    -부여방식 : 컬럼 레벨 방식

*/

CREATE TABLE MEM_NOTNULL(
    MEM_NO NUMBER NOT NULL
    ,MEM_ID VARCHAR2(20) NOT NULL
    ,MEM_PWD VARCHAR2(20) NOT NULL
    ,MEM_NAME VARCHAR2(20) NOT NULL
    ,GENDER CHAR(3)
    ,PHONE VARCHAR2(15)
    ,EMAIL VARCHAR2(30)
);
INSERT INTO MEM_NOTNULL VALUES(1,'user01','pass01','김유저','남','01049827724','user51@gmail.com');
SELECT * FROM MEM_NOTNULL;

--NULL 삽입해보기(제약조건으로 인해 오류 발생)
INSERT INTO MEM_NOTNULL VALUES(NULL,'user01','pass01','김유저','남','01049827724','user51@gmail.com');


--NOT NULL제약조건이 부여되지 않은 컬럼에 NULL 넣어보기 -허용됨
INSERT INTO MEM_NOTNULL VALUES(1,'user01','pass01','김유저',NULL,NULL,NULL);

/*
    2. UNIQUE 제약 조건
    컬럼에 중복값을 제한하는 제약조건
    삽입,수정시 기존에 중복값이 존재할 경우 추가,수정이 되지 않도록 제약
    
    부여방식 : 컬럼 레벨방식/테이블 방식
*/
CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER NOT NULL UNIQUE --컬럼 하나에 여러개의 제약조건 부여가능
    ,MEM_ID VARCHAR2(20) NOT NULL UNIQUE --컬럼 옆에 작성하는 방식(컬럼레벨방식)
    ,MEM_PWD VARCHAR2(20) NOT NULL
    ,MEM_NAME VARCHAR2(20) NOT NULL
    ,GENDER CHAR(3)
    ,PHONE VARCHAR2(15)
    ,EMAIL VARCHAR2(30)
);
SELECT*FROM MEM_UNIQUE;

--삽입
INSERT INTO MEM_UNIQUE VALUES(1,'user01','pass01','김유저','남','01063829495','dagw29@gmail.com');
--UNIQUE 제약조건 위배해보기(오류!)
INSERT INTO MEM_UNIQUE VALUES(2,'user01','pass31','박유저','남','01096622295','K3119@gmail.com');
INSERT INTO MEM_UNIQUE VALUES(1,'user03','pass31','박유저','남','01096622295','K3119@gmail.com');

--테이블 삭제
DROP TABLE MEM_UNIQUE;

--제약조건 테이블 방식으로 부여
CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER NOT NULL
    ,MEM_ID VARCHAR2(20) NOT NULL
    ,MEM_PWD VARCHAR2(20) NOT NULL
    ,MEM_NAME VARCHAR2(20) NOT NULL
    ,GENDER CHAR(3)
    ,PHONE VARCHAR2(15)
    ,EMAIL VARCHAR2(30)
    ,UNIQUE(MEM_NO)
    ,UNIQUE(MEM_ID)
    --UNIQUE(MEM_NO, MEM_ID)는 의미가 조금 다르다
);
SELECT*FROM MEM_UNIQUE;


--삽입
INSERT INTO MEM_UNIQUE VALUES(1,'user01','pass01','김유저','남','01063829495','dagw29@gmail.com');
--UNIQUE 제약조건 위배해보기(오류!)
INSERT INTO MEM_UNIQUE VALUES(2,'user01','pass31','박유저','남','01096622295','K3119@gmail.com');
INSERT INTO MEM_UNIQUE VALUES(1,'user03','pass31','박유저','남','01096622295','K3119@gmail.com');
--ORA-00001 : 무결성 제약조건(DLL.SYS_C008413)에 위배됩니다.
--SYS_C008413 : 해당 제약조건의 이름
--제약조건명은 별도로 작성하지 않으면 시스템이 SYS_C~~로 이름을 부여한다
--제약조건명은 중복될 수 없다.

/*
    제약조건 명 부여 방법
    
    -컬럼 레벨 방식
    CREATE TABLE 테이블명(
        컬럼명 자료형 CONTRAINT 제약조건명 제약조건
        ,...
    );
    
    -테이블 레벨 방식
    CREATE TABLE 테이블명(
        컬럼명 자료형,
        ...
        CONSTRAINT 제약조건명 제약조건(컬럼)
    )
*/

CREATE TABLE MEM_CON_NN(
    MEM_NO NUMBER NOT NULL
    ,MEM_ID VARCHAR2(20) CONSTRAINT MEM_ID_NN NOT NULL
    ,MEM_PWD VARCHAR2(20) NOT NULL
    ,MEM_NAME VARCHAR(20) NOT NULL
    ,GENDER CHAR(3)
    ,PHONE VARCHAR2(15)
    ,EMAIL VARCHAR2(30)
    ,CONSTRAINT MEM_NO_UQ UNIQUE(MEM_NO) --테이블 레벨 방식
);

--삽입
INSERT INTO MEM_CON_NN VALUES(1,'user01','pass01','김유저','남','01063829495','dagw29@gmail.com');
--UNIQUE 제약조건 위배해보기(오류!)
INSERT INTO MEM_CON_NN VALUES(2,'user01','pass31','박유저','남','01096622295','K3119@gmail.com');
INSERT INTO MEM_CON_NN VALUES(1,'user03','pass31','박유저','남','01096622295','K3119@gmail.com');


/*
    3. CHECK 제약조건
    특정 컬럼에 특정 값만 들어갈 수 있도록 제약하는 제약 조건
    EX)성별에 남/여 만 들어갈 수 있도록
    
    [표현법]
    CHECK(조건)
*/

CREATE TABLE MEM_CHECK(
    MEM_NO NUMBER NOT NULL
    ,MEM_ID VARCHAR2(20) NOT NULL
    ,MEM_PWD VARCHAR2(20) NOT NULL
    ,MEM_NAME VARCHAR2(20) NOT NULL
    ,GENDER CHAR(3) CHECK(GENDER IN ('남','여')) --체크 제약조건
    ,PHONE VARCHAR2(15)
    ,EMAIL VARCHAR2(30)
    ,MEM_DATE DATE
);
--삽입
INSERT INTO MEM_CHECK VALUES(1,'user01','pass01','김유저','남','01063829495','dagw29@gmail.com',SYSDATE);
--제약조건 위배
INSERT INTO MEM_CHECK VALUES(1,'user01','pass01','김유저','하','01063829495','dagw29@gmail.com',SYSDATE);
--NULL은 NOT NULL제약조건에서만 처리
INSERT INTO MEM_CHECK VALUES(1,'user01','pass01','김유저',NULL,'01063829495','dagw29@gmail.com',SYSDATE);
SELECT * FROM MEM_CHECK;

/*
    DEFAULT 설정
    특정 컬럼에 데이터가 들어갈 때 기본적으로 들어가는 기본값이 있다면
    해당 값을 기본으로 설정 가능
    -제약조건이 아님
    EX)퇴사여부 N /입사일 SYSDATE / 휴학여부 Y/N,...
*/
DROP TABLE MEM_CHECK;
CREATE TABLE MEM_CHECK(
    MEM_NO NUMBER NOT NULL
    ,MEM_ID VARCHAR2(20) NOT NULL
    ,MEM_PWD VARCHAR2(20) NOT NULL
    ,MEM_NAME VARCHAR2(20) NOT NULL
    ,GENDER CHAR(3)
    ,PHONE VARCHAR2(15)
    ,EMAIL VARCHAR2(30)
    ,MEM_DATE DATE DEFAULT SYSDATE NOT NULL --기본값을 SYSDATE로 한다. -- 제약조건은 DEFAULT 뒤에 작성
    ,CONSTRAINT CK_GEN CHECK(GENDER IN ('남','여'))
);
SELECT * FROM MEM_CHECK;
--삽입
INSERT INTO MEM_CHECK VALUES(1,'user01','pass01','김유저','남','01063829495','dagw29@gmail.com',SYSDATE);
--제약 위배
INSERT INTO MEM_CHECK VALUES(1,'user01','pass01','김유저','하','01063829495','dagw29@gmail.com',SYSDATE);
--DEFAULT 확인
INSERT INTO MEM_CHECK VALUES(1,'user01','pass01','김유저','여','01063829495','dagw29@gmail.com',DEFAULT);


/*
    INSERT 구문에서 컬럼명을 나열해주면 나열되지 않은 컬럼에 대해서는 기본값이 삽입된다.
    [표현법]
    INSERT INTO 테이블명 (컬럼,컬럼2,컬럼3,...) VALUEW (값,값2,값3);
    테이블명 뒤에 컬럼명을 나열하는데 이때 나열되지 않은 컬럼에는 기본값인 NULL이 들어가고
    만약 DEFAUT가 설정되어 있는 컬럼이라면 DEFAULT에 설정한 값이 들어간다.
    
    NOT NULL 제약조건이 걸려있는 컬럼은 컬럼나열에 꼭 포함시키거나 DEFAULT 설정이 되어있어야한다.
*/
--컬럼 나열하지 않은 데이터에는 기본값이 들어간다 만약 DEFAULT 설정을 하면 해당 값이 들어간다.
INSERT INTO MEM_CHECK(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME) VALUES (3,'qwe123','qwerty','최유저');
SELECT * FROM MEM_CHECK;

/*
    4. PRIMARY KEY 기본키 제약 조건
    테이블에서 각 행들의 정보를 유일하게 식별할 수 있는 컬럼에 부여하는 제약조건
    - 각 행들을 구분할 수 있는 식별자의 역할
    EX)사번,부서코드,직급코드,...
    --NOT NULL과 UNIQUE제약조건이 걸려있다.
    
    * 한 테이블에는 하나만 지정 가능 (고유 식별자의 역할)
*/

CREATE TABLE MEM_PK(
    MEM_NO NUMBER CONSTRAINT MEM_NO_PK PRIMARY KEY
    ,MEM_ID VARCHAR2(20) NOT NULL UNIQUE
    ,MEM_PWD VARCHAR2(20) NOT NULL
    ,MEM_NAME VARCHAR2(20) NOT NULL
    ,GENDER CHAR(3) CHECK(GENDER IN ('남','여'))NOT NULL
    ,PHONE VARCHAR2(15)
    ,EMAIL VARCHAR2(30)
    ,HIRE_DATE DATE DEFAULT SYSDATE
);

INSERT INTO MEM_PK(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GENDER) VALUES (1,'qwe123','qwerty','최유저','남');
SELECT * FROM MEM_PK;
--PK에 UNIQUE 제약조건 확인
INSERT INTO MEM_PK(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GENDER) VALUES (1,'ASD2552','3erT1','박유저','여');
--PK에 NOT NULL제약조건 확인
INSERT INTO MEM_PK(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GENDER) VALUES (NULL,'ASD2552','3erT1','박유저','여');

--한 테이블에 기본키(PK)FMF를 여러개 설정 가능한지 확인해보기 -하나만 가능
CREATE TABLE MEM_PK2(
    MEM_NO NUMBER CONSTRAINT MEM_NO_PK PRIMARY KEY
    ,MEM_ID VARCHAR2(20) NOT NULL UNIQUE
    ,MEM_PWD VARCHAR2(20) NOT NULL
    ,MEM_NAME VARCHAR2(20) NOT NULL
    ,GENDER CHAR(3) CHECK(GENDER IN ('남','여'))NOT NULL
    ,PHONE VARCHAR2(15)
    ,EMAIL VARCHAR2(30)
    ,HIRE_DATE DATE DEFAULT SYSDATE
    ,CONSTRAINT MEM_ID_PK PRIMARY KEY(MEM_ID)
);
SELECT * FROM MEM_PK2;

--두개의 컬럼을 하나로 묶어서 PK지정하기
CREATE TABLE MEM_PK3(
    MEM_NO NUMBER
    ,MEM_ID VARCHAR2(20) NOT NULL
    ,MEM_PWD VARCHAR2(20) NOT NULL
    ,MEM_NAME VARCHAR2(20) NOT NULL
    ,GENDER CHAR(3) CHECK(GENDER IN ('남','여'))
    ,PHONE VARCHAR2(15)
    ,EMAIL VARCHAR2(30)
    ,HIRE_DATE DATE DEFAULT SYSDATE
    ,CONSTRAINT MEM_ID_PK PRIMARY KEY(MEM_NO,MEM_ID)
);
SELECT * FROM MEM_PK3;
DROP TABLE MEM_PK3;
--위와 같이 복합키를 설정하면 해당 컬럼들 모두 같은 값이어야 중복이라고 판단한다.
INSERT INTO MEM_PK3(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME) VALUES (1,'qwe123','qwerty','최유저');
INSERT INTO MEM_PK3(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME) VALUES (2,'qwe123','qwerty','최유저');
INSERT INTO MEM_PK3(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME) VALUES (1,'7SBX23','qwerty','최유저');
INSERT INTO MEM_PK3(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME) VALUES (1,'qwe123','qwerty','최유저');

/*
    5. FOREIGN KEY (외래키)
    해당 컬럼에 다른 테이블에 존재하는 값만 허용하도록 컬럼에 부여하는 제약조건
    - 다른 테이블을 참조한다.
    참조된 다른 테이블이 가지고 있는 값만 허용
    JOIN 구문에서 활용하기 좋은 컬럼
    
    [표현법]
    -컬럼레벨 방식
    컬럼명 자료형 CONSTRAINT 제약조건명 REFERENCES 참조테이블명(참조컬럼명)
    
    -테이블레벨 방식
    CONSTRAINT 제약조건명 FOREIGN KEY(컬럼명) REFERENCES 참조테이블명(참조컬럼명)
    -생략 가능한 것 : CONSTRAINT / 참조컬럼명 (생략시 참조테이블에 기본키(PK)로 설정
    
    주의 : 참조할 컬럼타입과 외래키로 지정할 컬럼 타입이 같아야한다.
*/

--회원 등급에 대한 데이터(등급코드,등급명)보관테이블
--참조 테이블(부모)
CREATE TABLE MEM_GRADE(
    GRADE_CODE CHAR(2) PRIMARY KEY,
    GRADE_NAME VARCHAR(20) NOT NULL
);

--등급테이블에 데이터 삽입
INSERT INTO MEM_GRADE VALUES('G1','일반회원');
INSERT INTO MEM_GRADE VALUES('G2','우수회원');
INSERT INTO MEM_GRADE VALUES('G3','특별회원');

SELECT * FROM MEM_GRADE;

--자식테이블
CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    GRADE_ID CHAR(2),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    HIRE_DATE DATE DEFAULT SYSDATE
);

INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME) VALUES (1,'qwe123','qwerty','최유저');
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID) VALUES (2,'qwe423','qwerty','최유저','P1');
SELECT * FROM MEM;

DROP TABLE MEM;
--외래키 작업 후 생성
CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    GRADE_ID CHAR(2) REFERENCES MEM_GRADE(GRADE_CODE), --컬럼레벨방식
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    HIRE_DATE DATE DEFAULT SYSDATE
);
--외래키 적용 확인
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME) VALUES (1,'qwe123','qwerty','최유저');
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID) VALUES (2,'32EG','qwerty','최유저','G1');
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID) VALUES (3,'GW2EG','qwerty','최유저','F1');
SELECT * FROM MEM;

--외래키로 설정된 컬럼은 조인 구문 활용 가능
SELECT
    MEM_ID
    ,MEM_NAME
    ,GRADE_NAME
FROM MEM
LEFT JOIN MEM_GRADE ON (GRADE_ID=GRADE_CODE);


/*
    참조하고 있는 부모테이블이 삭제되거나 참조하는 컬럼데이터가 삭제될 경우?
    데이터 삭제 구문 : DML -DELETE

    [표현법]
    DELETE FROM 테이블명 조건(WHERE구문); --조건을 작성하지 않으면 해당 테이블 모든 데이터 삭제
*/

DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 'G1';

/*
    자식 테이블 생성시(외래키 제약조건 부여시)
    부모테이블의 데이터가 삭제되었을때 자식테이블에는 어떻게 처리할 것인지 옵선으로 지정
    
    FOREIGN KEY 삭제 옵션
    -ON DELETE SET NULL : NULL로 변경
    -ON DELETE CASCADE : 같이 삭제한다.
    -ON DELETE RESTRICTED : 삭제 제한걸기(기본값)
*/

DROP TABLE MEM;
--1) ON DELETE SET NULL 옵션 확인
CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    GRADE_ID CHAR(2) REFERENCES MEM_GRADE(GRADE_CODE) ON DELETE SET NULL,
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    HIRE_DATE DATE DEFAULT SYSDATE
);
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID) VALUES (1,'32EG','qwerty','최유저','G1');
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID) VALUES (2,'3GHQ2EG','qwerty','박유저','G2');
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID) VALUES (3,'wohi22EG','qwerty','이유저','G3');
SELECT * FROM MEM;

--부모테이블에서 G3 데이터 삭제해보기
DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 'G3';

--2) ON DELETE CASCADE - 부모 데이터 삭제시 자식데이터 삭제
DROP TABLE MEM;
INSERT INTO MEM_GRADE VALUES('G3','특별회원');

CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    GRADE_ID CHAR(2),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    HIRE_DATE DATE DEFAULT SYSDATE,
    --테이블 방식으로 작성해보기
    FOREIGN KEY(GRADE_ID) REFERENCES MEM_GRADE ON DELETE CASCADE --참조 컬럼 생략 (PK로 잡힙)
);
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID) VALUES (1,'32EG','qwerty','최유저','G1');
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID) VALUES (2,'3GHQ2EG','qwerty','박유저','G2');
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID) VALUES (3,'wohi22EG','qwerty','이유저','G3');
SELECT * FROM MEM;

--부모테이블에서 G3 데이터 삭제해보기
DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 'G3';

COMMIT;


---------------------------------------------------------------------
--KH계정에서 진행
/*
     서브쿼리를 이용하여 테이블을 생성해보기(테이블 복사)
     메인SQL문 SELECT,CREATE,INSERT,UPDATE를 보조하는 구문(서브쿼리)
     [표현법]
     CREATE TABLE 테이블명
     AS 서브쿼리;
*/

--EMPLOYEE 테이블 조회
SELECT *
FROM EMPLOYEE;

--EMPLOYEE 테이블에 담긴 데이터 그대로 복사 테이블 만들어보기
--컬럼형식,데이터 복사 / 제약조건,COMMENT,DEFAULT 들은 복사되지 않음
CREATE TABLE EMPLOYEE_COPY
AS SELECT * FROM EMPLOYEE;
--확인
SELECT * FROM EMPLOYEE_COPY;

--위 조건으로 컬럼구조만 복사한 테이블 만들기
CREATE TABLE EMPLOYEE_COPY2
AS (
    SELECT *
    FROM EMPLOYEE
    WHERE EMP_ID = 1000
);
SELECT * FROM EMPLOYEE_COPY2;

DROP TABLE EMPLOYEE_COPY2;
--향상된 방법
SELECT *
FROM EMPLOYEE
WHERE 1=0;
---적용
CREATE TABLE EMPLOYEE_COPY2
AS(
    SELECT *
    FROM EMPLOYEE
    WHERE 1=0
);
SELECT * FROM EMPLOYEE_COPY2;

--전체 사원의 사번,사원명,급여,연봉 조회 결과를 이용하여 테이블을 복사해보기
CREATE TABLE EMPLOYEE_COPY3
AS(
    SELECT
        EMP_ID 사번
        ,EMP_NAME 사원명
        ,SALARY 급여
        ,(SALARY+NVL(BONUS,0)*SALARY)*12 연봉
    FROM EMPLOYEE
);
SELECT * FROM EMPLOYEE_COPY3;
