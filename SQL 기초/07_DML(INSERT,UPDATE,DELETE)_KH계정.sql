--파일명 : 07_DML(INSERT,UPDATE,DELETE)_KH계정

/*
    DML(DATA MANIPULATION LANGUAGE)
    
    데이터 조작언어
    테이블에 새로운 데이터를 삽입, 수정, 삭제 하는 구문
    
    1. INSERT : 새로운 행을 추가하는 구문
    
    [표현법]
    1)INSERT INTO 테이블명 VALUES(값1,값2,...);
    - 해당 테이블에 모든 컬럼에 데이터를 추가하고자 할때 사용하는 구문
    - 컬럼의 순서,자료형 개수를 맞춰서 VALUES 괄호 안에 나열해야 한다.
    - 나열된 데이터가 정해진 컬럼보다 적을 경우 : NOT ENOUGH VALUES 오류
    - 나열된 데이터가 정해진 컬럼보다 많을 경우 : NOT MANY VALUES 오류
    
    2)INSERT INTO 테이블명(컬럼명,컬럼명,...) VALUES(값1,값2,...)
    - 한 행 단위로 추가되기 때문에 선택되지 않은 컬럼은 기본값 OR NULL이 삽입
    - DEFAULT 설정이 되어있다면 DEFAULT 삽입
    - NOT NULL제약조건이 설정되어 있다면 선택하여 값을 제시하거나 DEFAULT값이 설정되어야한다.
    
    3) INSERT INTO 테이블명 (서브쿼리);
        -VALUES로 직접 값을 기입하는 것이 아니라
        서브쿼리로 조회된 데이터를 INSERT 하는 구문
        여러행을 한번에 INSERT 할 수 있다.
*/


--EMPLOYEE테이블에 사원 데이터 추가하기
SELECT * FROM EMPLOYEE;
INSERT INTO EMPLOYEE VALUES (900,'김지환','950716-1029481','kim50504376@gmail.com','01068994376',
    'D9','J1','S1',1000000,0.1,207,SYSDATE,NULL,DEFAULT);
    
INSERT INTO EMPLOYEE(
    EMP_ID
    ,EMP_NAME
    ,EMP_NO
    ,JOB_CODE
    ,SAL_LEVEL)
VALUES(901,'김사원','950888-2949194','J6','S6');

SELECT * FROM EMPLOYEE WHERE EMP_ID = '901';
   
--테이블 생성
CREATE TABLE EMP_COPY01(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    DEPT_TITLE VARCHAR2(20)
);
SELECT * FROM EMP_COPY01;
    
--전체 사원들의 사번,이름,부서명을 조회한 결과를 테이블에 넣기
SELECT
    EMP_ID 
    ,EMP_NAME
    ,NVL(DEPT_TITLE,'부서없음')
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID);
--조회구문을 이용하여 데이터 삽입해보기
INSERT INTO EMP_COPY01 (
    SELECT
        EMP_ID 
        ,EMP_NAME
        ,NVL(DEPT_TITLE,'부서없음')
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID));
SELECT * FROM EMP_COPY01;

/*
    INSERT ALL
    두개 이상의 테이블에 각각 INSERT할 때 사용하는 구문
    조건 : 사용하는 서브쿼리가 동일해야한다.
    
    [표현법]
    INSERT ALL
    INTO 테이블명1 VALUES (컬럼명,컬럼명,...)
    INTO 테이블명2 VALUES (컬럼명,컬럼명,...)
    서브쿼리;

*/
/*
    실습
    테스트용 테이블 생성하기
    첫번째 테이블 사번,사원명,직급명
    두번째 테이블 사번,사원명,부서명
    
    두 테이블 모두 데이터 없이 EMPLOYEE 테이블 형식만 참조하여 만들기
    첫번째 테이블은 CREATE TABLE 구문으로 각 데이터 컬럼 정의
    두번째 테이블은 CREATE TABLE 서브쿼리 구문으로 생성하기
*/

CREATE TABLE EMP_EX01(
    EMP_ID VARCHAR2(3), 
    EMP_NAME VARCHAR2(20),
    JOB_TITLE  VARCHAR2(35)
);

CREATE TABLE EMP_EX02 AS(
    SELECT
        EMP_ID 사번
        ,EMP_NAME 이름
        ,JOB_NAME 직업명
    FROM EMPLOYEE
    JOIN JOB USING (JOB_CODE)
    WHERE 1=0
);

SELECT * FROM EMP_EX01;
DROP TABLE EMP_EX01;
SELECT * FROM EMP_EX02;
DROP TABLE EMP_EX02;

--각각 테이블에 조회된 데이터 넣어보기
--급여 300만원 이상 받는 사원들의 사번,이름,직급명,부서명 조회

--조회구문
SELECT
    EMP_ID
    ,EMP_NAME
    ,JOB_NAME
    ,DEPT_TITLE
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
WHERE SALARY >=3000000;

--INSERT ALL 구문을 이용하여 각 테이블에 결과 삽입하기
INSERT ALL
    INTO EMP_EX01 VALUES(EMP_ID,EMP_NAME,JOB_NAME)
    INTO EMP_EX02 VALUES(EMP_ID,EMP_NAME,DEPT_TITLE)
SELECT
    EMP_ID
    ,EMP_NAME
    ,JOB_NAME
    ,DEPT_TITLE
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
WHERE SALARY >=3000000;


--INSERT ALL을 이용하여 여러행 한번에 대입하기
INSERT INTO EMP_EX01 VALUES (300,'김데모','대리');
INSERT INTO EMP_EX01 VALUES (301,'박연습','사원');
INSERT INTO EMP_EX01 VALUES (302,'최과장','과장');

--INSERT ALL 구문에서 서브쿼리로 위 데이터 한번에 처리하기
INSERT ALL
    INTO EMP_EX01 VALUES (300,'김데모','대리')
    INTO EMP_EX01 VALUES (301,'박연습','사원')
    INTO EMP_EX01 VALUES (302,'최과장','과장')
SELECT * FROM DUAL; --가상테이블을 이용하여 서브쿼리 구문 작성

SELECT * FROM EMP_EX01;

/*
    2)INSERT ALL
            WHEN 조건1 THEN
            INTO 테이블명 VALUES(컬럼명,컬럼명,...)
            WHEN 조건2 THEN
            INTO 테이블명 VALUES(컬럼명,컬럼명,...)
        서브쿼리
        
    조건에 맞는 값들을 삽입
*/

--테스트용 테이블 생성
--사번,사원명,입사일,급여를 담을 테이블 EMP_OLD/EMP_NEW 두개 만들기
CREATE TABLE EMP_OLD
AS(
    SELECT
        EMP_ID
        ,EMP_NAME
        ,HIRE_DATE
        ,SALARY
    FROM EMPLOYEE
    WHERE 1=0
    );
    
CREATE TABLE EMP_NEW
AS(
    SELECT
        EMP_ID
        ,EMP_NAME
        ,HIRE_DATE
        ,SALARY
    FROM EMPLOYEE
    WHERE 1=0
    );
SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

--서브쿼리로 이용할 구문 작성
--2010년 이전 이후 조건으로 조회
SELECT EMP_ID,EMP_NAME,HIRE_DATE,SALARY
FROM EMPLOYEE
WHERE HIRE_DATE<'2010/01/01'; --2010년 이전 입사자

SELECT EMP_ID,EMP_NAME,HIRE_DATE,SALARY
FROM EMPLOYEE
WHERE HIRE_DATE>='2010/01/01'; --2010년 이후 입사자

--INSERT ALL 구문에 조건 추가해보기
INSERT ALL
    WHEN HIRE_DATE<'2010/01/01' THEN
    INTO EMP_OLD(EMP_ID,EMP_NAME,HIRE_DATE,SALARY)
    WHEN HIRE_DATE>='2010/01/01' THEN
    INTO EMP_NEW(EMP_ID,EMP_NAME,HIRE_DATE,SALARY)
SELECT EMP_ID,EMP_NAME,HIRE_DATE,SALARY
FROM EMPLOYEE;

SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

---------------------------------------------------
/*
    2. UPDATE
    테이블에 기록된 기존 데이터를 수정하는 구문
    
    [표현법]
    UPDATE 테이블명
    SET
        컬럼명 = 바꿀값,
        컬럼명 = 바꿀값,
        ...
    WHERE 조건; -- WHERE 절은 생략 가능-> 모든 행에 수정작업 실행
*/

--복사본 테이블 만들기
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;
DROP TABLE DEPT_COPY;
ROLLBACK; --되돌리기 (이전 COMMIT 시점으로)
--DEPT_COPY 테이블에서 D9 부서의 부서명을 전략기획부로 수정
UPDATE DEPT_COPY
SET
    DEPT_TITLE = '전략기획부'
WHERE
    DEPT_ID = 'D9';
--WHERE 조건에 따라서 1개 또는 여러개의 행을 변경할 수 있다.

--복사본 테이블 생성하기
--테이블명 EMP_SALARY /컬럼 EMP_ID,EMP_NAME,DEPT_CODE,SALARY,BONUS (데이터도)

CREATE TABLE EMP_SALARY
AS SELECT
    EMP_ID
    ,EMP_NAME
    ,DEPT_CODE
    ,SALARY
    ,BONUS
FROM EMPLOYEE;

SELECT * FROM EMP_SALARY;

--노옹철 사원 급여 1000만원으로
UPDATE EMP_SALARY
SET SALARY = 10000000
WHERE EMP_NAME = '노옹철';
--선동일 사원 급여 700만원, 보너스 0.2로
UPDATE EMP_SALARY
SET 
    SALARY = 7000000,
    BONUS = 0.2
WHERE EMP_NAME = '선동일';

--전체 사원 급여에 20퍼센트 인상한 금액으로
UPDATE EMP_SALARY
SET
    SALARY = SALARY*1.2;
    
/*
    UPDATE 구문에 서브쿼리 이용하기
    서브쿼리를 수행한 결과로 기존값으로 부터 변경하겠다.
    
    [표현법]
    UPDATE 테이블명
    SET 컬럼명 = 서브쿼리
    WHERE 조건;      --생략가능
    
*/

--EMP_SALARY 테이블에 있는 김유저 사원의 부서코드를 유하진 사원의 부서코드와 동일하게
UPDATE EMP_SALARY
SET DEPT_CODE =
    (SELECT
        DEPT_CODE
    FROM EMP_SALARY
    WHERE EMP_NAME = '하이유')
WHERE EMP_NAME = '유하진';

SELECT * FROM EMP_SALARY;

--방명수 사원의 급여와 보너스를 유재식 사원과 같게 만들기
UPDATE EMP_SALARY
SET SALARY = (SELECT SALARY FROM EMP_SALARY WHERE EMP_NAME='유재식')
    ,BONUS = (SELECT BONUS FROM EMP_SALARY WHERE EMP_NAME='유재식')
WHERE EMP_NAME = '방명수';

SELECT * FROM EMP_SALARY;

--다중열 서브쿼리 이용하기
UPDATE EMP_SALARY
SET (SALARY,BONUS) 
    = (SELECT SALARY,BONUS FROM EMP_SALARY WHERE EMP_NAME='유재식')
WHERE EMP_NAME = '방명수';

--노옹철 사원의 사번을 변경해보기
UPDATE EMPLOYEE
SET EMP_ID = 200
WHERE EMP_NAME = '노옹철'; -- 무결성 제약조건 위배 오류

/*
    DELETE
    테이블에 기록된 데이터를 행 단위로 삭제하는 구문
    [표현법]
    DELETE FROM 테이블명
    WHERE 조건; - 생략시 전체 대상
    
*/

--EMP_SALARY 테이블
DELETE FROM EMP_SALARY; --전체 삭제
SELECT * FROM EMP_SALARY; --조회
DROP TABLE EMP_SALARY; --테이블까지 깔끔하게

--조건을 이용해 김사원 삭제해보기
DELETE 
FROM EMP_SALARY
WHERE EMP_NAME = '김사원';

DELETE FROM EMP_SALARY
WHERE EMP_NAME = (
    SELECT EMP_NAME
    FROM EMP_SALARY
    WHERE EMP_ID=220
);

/*
    (DDL)
    TRUNCATE : 테이블의 전체행을 삭제할때 사용하는 구문(절삭)
        DELETE 구문보다 수행속도가 빠르고 별도의 조건을 제시할 필요 없음
        테이블 데이터가 절삭되는 DDL구문이기에 ROLLBACK으로 되돌릴 수 없음
    
    [표현법]
    TRUNCATE TABLE 테이블명;
*/

COMMIT;
SELECT * FROM EMP_SALARY; --22명
DELETE FROM EMP_SALARY;
