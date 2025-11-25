/*
    파일명 : 15_TRIGGER_KH계정
    
    <TRIGGER>
    지정한 테이블에 INSERT,UPDATE,DELETE 등의 DML문에 의해 변경사항이 생길때
    자동으로 실행할 내용을 정의해둘 수 있는 객체
    
    EX)
    회원탈퇴시 기존의 회원 테이블에서 데이터를 DELETE 또는 UPDATE하여 상태값을 변경하고
    탈퇴한 회원들만 따로 보관하는 테이블에 INSERT 처리
    입출고에 대한 데이터가 INSERT될때마다 해당 상품에 대한 재고 수량을 UPDATE할때 등등..
    
    *트리거의 종류
    SQL문의 시행시기에 따른 분류
    -BEFORE TIRGGER : 지정한 테이블에 이벤트(INSERT,UPDATE,DELETE)가 발생되기 전에 트리거 실행
    -AFTER TRIGGER : 지정한 테이블에 이벤트가 발생된 후에 트리거 실행
    
    SQL문에 의해 영향을 받는 각 행에 따른 분류
    -STATEMENT TRIGGER(문장 트리거) : 이벤트가 발생된 SQL문에 대해 한번만 트리거 실행
    -ROW TRIGGER(행트리거) : 해당 SQL문 실행시 각 행에 대해서 트리거가 개별적으로 실행 (FOR EACH ROW옵션 설정)
    -[:OLD] : BEFORE UPDATE(수정전 자료),BEFORE DELETE(삭제전 자료)
    -[:NEW] : AFTER INSERT(추가된 자료),AFTER UPDATE(수정 후 자료)
    
    *트리거 생성 구문
    [표현식]
    CREATE [OR REPLACE] TRIGGER 트리거명
    [BEFORE | AFTER] [INSERT|UPDATE|DELETE] ON 테이블명 - 해당 컬럼에만 동작 (UPDATE OF 컬럼명 ON 테이블명)
    [FOR EACH ROW]
    DECLARE
        선언부(생략가능)
    BEGIN 
        실행부
    EXCEPTION
        예외처리부(생략가능)
    END;
    /

*/

--EMPLOYEE 테이블에 새로운 행이 INSERT될때마다 자동으로 메시지를 출력하는 트리거
CREATE OR REPLACE TRIGGER TRG_01
AFTER INSERT ON EMPLOYEE
BEGIN
    DBMS_OUTPUT.PUT_LINE('정보가 등록되었습니다.');
END;
/
SELECT*FROM EMPLOYEE;
INSERT INTO EMPLOYEE(EMP_ID,EMP_NAME,EMP_NO,JOB_CODE,SAL_LEVEL)
VALUES(000,'김공공','000000-0000000','J0','S0');

--EMPLOYEE 테이블에서
--DELETE가 동작하면  정보가 삭제되었습니다 를 출력하는 TRIGGER 를 생성해보세요
--방금 넣은 000 사원 삭제후 확인해보기

CREATE OR REPLACE TRIGGER TRG_DELETE
AFTER DELETE ON EMPLOYEE
BEGIN
    DBMS_OUTPUT.PUT_LINE('정보가 삭제되었습니다.');
END;
/

DELETE FROM EMPLOYEE
WHERE EMP_ID = 000;

-----------------------------------
--상품 입고 및 출고 관련 예시
--1.상품에 대한 데이터를 보관할 테이블 생성하기
CREATE TABLE TB_PRODUCT(
    PCODE NUMBER PRIMARY KEY, --상품번호
    PNAME VARCHAR2(30) NOT NULL, --상품명
    BRAND VARCHAR2(30) NOT NULL, --브랜드명
    PRICE NUMBER, --가격
    STOCK NUMBER DEFAULT 0 -- 재고 수량
);

--상품 번호에는 시퀀스 이용하기
CREATE SEQUENCE SEQ_PCODE
START WITH 200
NOCACHE;

--샘플 데이터 추가
INSERT INTO TB_PRODUCT VALUES (SEQ_PCODE.NEXTVAL,'아이폰17','애플',1290000,10);
INSERT INTO TB_PRODUCT VALUES (SEQ_PCODE.NEXTVAL,'애플워치울트라3','애플',1390000,20);
INSERT INTO TB_PRODUCT VALUES (SEQ_PCODE.NEXTVAL,'갤럭시폴드2','삼성',1450000,0);

SELECT * FROM TB_PRODUCT;
COMMIT;

--2.상품 입출고 상세 이력 테이블 
--상품이 언제 입고 됐고 언제 출고가 되었는지에대한 정보 저장 테이블
CREATE TABLE TB_PRODETAIL(
    DCODE NUMBER PRIMARY KEY, --이력번호
    PCODE NUMBER REFERENCES TB_PRODUCT, --상품번호(상품테이블 외래키 설정)
    PDATE DATE NOT NULL, --상품 입출고 날짜 기록
    AMOUNT NUMBER NOT NULL, --입출고 수량
    STATUS CHAR(6) CHECK(STATUS IN('입고','출고')) NOT NULL --상태값
);

--이력번호로 사용할 시퀀스 생성
CREATE SEQUENCE SEQ_DCODE
NOCACHE;

SELECT * FROM TB_PRODETAIL;
SELECT * FROM TB_PRODUCT;

--202번 상품이 오늘 10개 입고되었다.
INSERT INTO TB_PRODETAIL VALUES (SEQ_DCODE.NEXTVAL,202,SYSDATE,10,'입고');
--202번 상품이 입고되었으니 해당 수만큼 PRODUCT 테이블에 STOCK 을 + 해주어야한다.
UPDATE TB_PRODUCT
SET STOCK = STOCK + 10
WHERE PCODE = 202;

COMMIT;

--201번 상품이 현재 날짜 기준으로 5개 출고되었다. 이에 맞는 작업을 수행하시오
INSERT INTO TB_PRODETAIL VALUES (SEQ_DCODE.NEXTVAL,201,SYSDATE,5,'출고');
UPDATE TB_PRODUCT
SET STOCK = STOCK - 5
WHERE PCODE = 201;

SELECT * FROM TB_PRODUCT;
SELECT * FROM TB_PRODETAIL;

--위와 같이 작업이 같이 진행되어야하는 경우는 트리거를 이용하여 일괄 처리 해준다면 
--실수 또는 데이터 오류를 줄일 수 있다.
--TB_PRODETAIL 테이블에 INSERT(입출고기록)가 된다면 
--TB_PRODUCT 테이블의 재고 수량을 UPDATE하는 트리거 정의해보기

CREATE OR REPLACE TRIGGER STOCK_MANAGER
AFTER INSERT ON TB_PRODETAIL
FOR EACH ROW --각 행마다 개별적으로 트리거 동작
BEGIN
    -- :NEW 를 이용하여 새로 추가된 정보로부터 필요 데이터 추출하기
    -- :NEW - 추가된 행 데이터 자체
    --상품이 입고된 경우? STATUS를 확인하여 입고라면 AMOUNT 값을 이용하여 STOCK 값 변경하기 
    IF :NEW.STATUS = '입고'
        THEN 
            UPDATE TB_PRODUCT
            SET STOCK = STOCK + :NEW.AMOUNT --기존 재고에 추가하기
            WHERE PCODE = :NEW.PCODE;
    ELSE -- 출고인경우
         UPDATE TB_PRODUCT
        SET STOCK = STOCK - :NEW.AMOUNT   --기존 재고에서 감소시키기
        WHERE PCODE = :NEW.PCODE;
    END IF;
END;
/

SELECT * FROM TB_PRODUCT;-- 10,15,10
SELECT * FROM TB_PRODETAIL;

--입출고 기록 남기기 
INSERT INTO TB_PRODETAIL VALUES (SEQ_DCODE.NEXTVAL,200,SYSDATE,5,'출고');

--TB_PRODETAIL의 데이터가 수정(UPDATE)된다면 TB_PRODUCT의 재고를 수정(UPDATE)시키는 작업을 하는
--트리거를 만들어 봅시다
--기존 데이터가 입고 또는 출고에 따라서 수정 전 데이터를 이용하여 재고 증가 또는 감소를 취소 시키고
--다시 수정된 새로운 데이터를 이용하여 재고 증가 또는 감소 수행하기

CREATE OR REPLACE TRIGGER STOCK_TRG
AFTER UPDATE ON TB_PRODETAIL
FOR EACH ROW
BEGIN
    --기존 데이터를 이용하여 기존데이터가 잘못되었으니 취소 작업 처리해야한다.
    --새 데이터로 다시 업데이트 까지 처리하기 
    --:OLD -기존데이터 :NEW -새데이터
    IF :OLD.STATUS = '입고'
        THEN 
            UPDATE TB_PRODUCT
            SET STOCK = STOCK - :OLD.AMOUNT + :NEW.AMOUNT --기존에 증가되었던 데이터 감소시키기 (입고 취소 후 증가)
            WHERE PCODE = :OLD.PCODE;
    ELSE --출고
        UPDATE TB_PRODUCT
        SET STOCK = STOCK + :OLD.AMOUNT - :NEW.AMOUNT --기존에 감소되었던 데이터 증가시키기 (출고 취소 후 감소)
        WHERE PCODE = :OLD.PCODE;
   END IF;     
END;
/

SELECT * FROM TB_PRODUCT; -- 5,15,10 

SELECT * FROM TB_PRODETAIL; --10,5,5
--201 번 STOCK 15   ( 20개에서 5개 출고 되어 15개)
-- 10개 입고였다 (20+10 == 30)
UPDATE TB_PRODETAIL
SET AMOUNT = 10
   ,STATUS = '입고'
WHERE DCODE = 2;


--위 트리거를 이용하면 입고/출고 데이터가 변경되었을때에 맞춰서 재고 변경이 수행되지 않는 문제가 있다.
--입 출고 기록 관련해서 변경이 없는 경우는 잘 처리됨

--아래에선 입출고 기록이 변경되는 경우에도 해당 작업이 수행 될 수 있도록 처리해보기 

CREATE OR REPLACE TRIGGER STOCK_TRG
AFTER UPDATE ON TB_PRODETAIL
FOR EACH ROW
BEGIN
    IF :OLD.STATUS = '입고'
        THEN 
            UPDATE TB_PRODUCT
            SET STOCK = STOCK - :OLD.AMOUNT --기존에 증가되었던 데이터 감소시키기 (입고 취소)
            WHERE PCODE = :OLD.PCODE;
    ELSE --출고
        UPDATE TB_PRODUCT
        SET STOCK = STOCK + :OLD.AMOUNT --기존에 감소되었던 데이터 증가시키기 (출고 취소)
        WHERE PCODE = :OLD.PCODE;
   END IF;     
   
   --새로 변경된 정보를 통해 입출고 조건 확인 하여 처리 
   IF :NEW.STATUS = '입고'
    THEN 
        UPDATE TB_PRODUCT
        SET STOCK = STOCK + :NEW.AMOUNT --새로들어온 값으로 변경
        WHERE PCODE = :NEW.PCODE;
    ELSE
        UPDATE TB_PRODUCT
        SET STOCK = STOCK - :NEW.AMOUNT 
        WHERE PCODE = :NEW.PCODE;
   END IF;
END;
/

SELECT * FROM TB_PRODUCT; --5,10,5
SELECT * FROM TB_PRODETAIL; -- 5,10,5 
--200번상품이 5개 출고되어 재고가 5개인 상황 
--알고보니 15개 입고된 상황
UPDATE TB_PRODETAIL
SET AMOUNT = 15
   ,STATUS = '입고'
WHERE DCODE = 3;
--200번 재고가 25개로 변경되는지 확인

--급여 변경 이력 테이블을 생성하여 급여 변경 이력을 기록해보기
CREATE TABLE TB_SALARY_HISTORY(
    HISTORY_ID NUMBER PRIMARY KEY,
    EMP_ID VARCHAR2(10),
    EMP_NAME VARCHAR2(30),
    OLD_SALARY NUMBER,
    NEW_SALARY NUMBER,
    CHANGE_AMOUNT NUMBER,
    CHANGE_DATE DATE DEFAULT SYSDATE
);

CREATE SEQUENCE SEQ_SHNO
NOCACHE;

CREATE TABLE SALARY_TEST
AS SELECT * FROM EMPLOYEE;

--SALARY_TEST 에 사원들의 급여가 변경되면 해당 변경사항이 
--TB_SALARY_HISTORY 테이블에 INSERT 될 수 있도록 처리하는 트리거를 작성해보세요

SELECT * FROM TB_SALARY_HISTORY;

CREATE OR REPLACE TRIGGER TRG_SAL_HISTORY
AFTER UPDATE OF SALARY ON SALARY_TEST --해당 컬럼에만 동작 (UPDATE OF 컬럼명 ON 테이블명)
FOR EACH ROW
BEGIN
    --급여항목이 실제 변경되었을때에 대한 조건 
--    IF :OLD.SALARY != :NEW.SALARY
--        THEN
            INSERT INTO TB_SALARY_HISTORY 
            VALUES(SEQ_SHNO.NEXTVAL
                  ,:OLD.EMP_ID  --사번
                  ,:OLD.EMP_NAME --사원명
                  ,:OLD.SALARY --이전 급여
                  ,:NEW.SALARY--변경된 급여
                  ,ABS((:OLD.SALARY - :NEW.SALARY)) --급여 차이
                  ,SYSDATE --변경 날짜 
                  ); 
--    END IF;
END;
/

SELECT * FROM SALARY_TEST;
SELECT * FROM TB_SALARY_HISTORY;
--SALARY_TEST 테이블에 SALARY 변경해보기 
UPDATE SALARY_TEST
SET SALARY = 6000000
WHERE EMP_ID = 201;

UPDATE SALARY_TEST
SET BONUS = 0.55
WHERE EMP_ID = 555;















