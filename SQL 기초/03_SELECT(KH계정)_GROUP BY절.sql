/*
    파일명 : 03_SELECT(KH계정)_GROUP BY절
    
    <GROUP BY절>
    
    그룹을 묶어줄 기준을 제시할 수 있는 구문 -> 그룹함수와 같이 사용된다.
    해당 제시된 기준별로 그룹을 묶을 수 있다.
    여러개의 값들을 하나의 그룹으로 묶어 처리할 목적으로 사용
    
    [표현법]
    GROUP BY 묶어줄 기준 컬럼
*/

--각 부서별로 총 급여의 합계
SELECT SUM(SALARY)
FROM EMPLOYEE; --전체 데이터가 하나의 그룹으로 처리됨

SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE ='D9'; --D9인 사원들의 급여합계

--각 부서를 그룹만들기 
SELECT DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE; --EMPLOYEE 테이블에 있는 DEPT_CODE 데이터 별로 그룹화 

--묶은 그룹 별로 합계 구하기 
SELECT DEPT_CODE,SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

--직급별 직급코드,급여합,사원수,보너스를 받는 사원수,평균 급여,최소급여,최고 급여 조회해보기
SELECT JOB_CODE
      ,SUM(SALARY)
      ,COUNT(*)
      ,COUNT(BONUS)
      ,AVG(SALARY)
      ,MIN(SALARY)
      ,MAX(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

--각 부서별 총 급여의 합을 부서별 오름차순 정렬 후 조회 
SELECT DEPT_CODE,SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

--각 부서별 부서코드,사원수,보너스받는 사원수,사수가있는 사원수,평균급여를 부서별 오름차순 정렬 조회하기 
SELECT DEPT_CODE
      ,COUNT(*)
      ,COUNT(BONUS)
      ,COUNT(MANAGER_ID)
      ,AVG(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

--성별 별 사원수 조회
SELECT SUBSTR(EMP_NO,8,1)
      ,COUNT(*)
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO,8,1); --함수 처리 결과로 그룹화 시키기

--DECODE를 이용하여 성별별 조회에서 남/여 로 나올 수 있도록 처리하기
SELECT DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여') 성별
      ,COUNT(*)
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO,8,1);

--각 부서별로 평균 급여가 300만원 이상인 부서 조회해보기 
SELECT DEPT_CODE
      ,AVG(SALARY)
FROM EMPLOYEE
WHERE AVG(SALARY) >= 3000000 -- WHERE절에는 그룹함수 작성 불가능 (WHERE은 단일행 처리이기때문)
GROUP BY DEPT_CODE;

/*
    <HAVING 절>
    그룹에 대한 조건을 제시하고자 할때 사용되는 구문
    (주로 그룹 함수를 이용하여 조건 제시) - GROUP BY절과 함께 사용된다.
    위치는 GROUP BY절 뒤에 작성
    
    SELECT 구문 실행 순서
    1.FROM : 조회하고자 하는 테이블
    2.WHERE : 조건식(단일행기준(그룹함수 불가))
    3.GROUP BY: 그룹 기준에 대한 컬럼 또는 함수식
    4.HAVING : 그룹함수식에 대한 조건식 (그룹 조건)
    5.SELECT : 조회하고자 하는 컬럼들 나열
    6.ORDER BY : 정렬 기준 작성
*/

--각 부서별로 평균 급여가 300만원 이상인 부서 조회
SELECT DEPT_CODE
      ,ROUND(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000; -- 그룹함수를 이용한 조건처리

--각 직급 별 총 급여합이 1000만원 이상인 직급코드 급여합 조회
SELECT JOB_CODE
      ,SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000;
--각 직급별 급여 평균이 300만원 이상인 직급코드,평균급여,사원수,최고급여,최소급여 조회하기
SELECT JOB_CODE
      ,AVG(SALARY)
      ,COUNT(*)
      ,MAX(SALARY)
      ,MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING AVG(SALARY) >= 3000000;

--각 부서별 보너스를 받는 사원이 없는 부서만을 조회(부서코드 사원수)
SELECT DEPT_CODE
      ,COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS)=0; --NULL을 세지 않기 때문에 0이라면 보너스를 받는 사원이 없다.

--각 부서별 평균 급여가 350만원 이하인 부서만을 조회(부서코드,평균급여)
SELECT NVL(DEPT_CODE,'부서없음') 부서정보
      ,ROUND(AVG(SALARY))||'원' 평균급여
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) <= 3500000;

SELECT COUNT(*)
FROM EMPLOYEE;

SELECT COUNT(1)
FROM EMPLOYEE; -- * 전부 표현과 마찬가지로 동작함 

--COUNT에 선택함수를 넣어서 처리해보기 
SELECT CASE 
        WHEN SALARY > 3000000 THEN 1 
      END
FROM EMPLOYEE; -- 선택함수에서 조건에 부합하지 않으면 NULL 반환 

SELECT DEPT_CODE "부서코드"  
      ,COUNT(*) "부서별 사원수"
      ,COUNT(CASE WHEN SALARY >=3000000 THEN 1 END) "300이상 사원수"
FROM EMPLOYEE
GROUP BY DEPT_CODE;
--------------------------------------------------------------------------
/*
    <집합 연산자 SET OPERATOR>
    여러개의 쿼리문을 가지고 하나의 쿼리문을 만드는 연산자
    
    UNION(합집합) : 두 쿼리문을 수행한 결과값을 더한 후 중복되는 부분은 하나만 조회하는 결과
    UNION ALL : 두 쿼리문을 수행한 결과값을 더한 후 중복제거를 하지 않은 결과
    INTERSECT(교집합) : 두 쿼리문을 수행한 결과값의 중복되는 부분
    MINUS(차집합) : 선행 쿼리문 결과값에서 후행 쿼리문 결과값을 뺀 나머지 부분
    
*/
-- 1. UNION
--부서코드가 D5이거나 급여가 300만원 초과인 사원들 조회(사번,사원명,부서코드,급여)

--부서코드가 D5
SELECT 
    EMP_ID
    ,EMP_NAME
    ,DEPT_CODE
    ,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'; --6,7,8,9,10,15

--급여 300만원 초과
SELECT
    EMP_ID
    ,EMP_NAME
    ,DEPT_CODE
    ,SALARY
FROM EMPLOYEE
WHERE SALARY>3000000; --0,1,2,4,5,9,15,17

--둘의 UNION
SELECT 
    EMP_ID
    ,EMP_NAME
    ,DEPT_CODE
    ,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT
    EMP_ID
    ,EMP_NAME
    ,DEPT_CODE
    ,SALARY
FROM EMPLOYEE
WHERE SALARY>3000000
ORDER BY 1; --0,1,2,4,5,6,7,8,9,10,15,17(중복데이터는 한번만)
--같은 테이블에선 OR연산으로 표현 가능하지만 다른 테이블에 있는 데이터라면 집합 연산자를 이용해야한다.

--직급코드가 J6이거나 부서코드가 D1인 사원들 사번,사원명,부서코드,직급코드
SELECT
    EMP_NAME
    ,EMP_ID
    ,DEPT_CODE
    ,JOB_CODE
FROM EMPLOYEE
WHERE JOB_CODE= 'J6'
UNION
SELECT
    EMP_NAME
    ,EMP_ID
    ,DEPT_CODE
    ,JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1'; 

--UNION ALL(중복제거하지 않아서 UNION보다 빠름)
SELECT
    EMP_ID
    ,EMP_NAME
    ,DEPT_CODE
    ,JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1'
UNION ALL
SELECT
    EMP_ID
    ,EMP_NAME
    ,DEPT_CODE
    ,JOB_CODE
FROM EMPLOYEE
WHERE JOB_CODE = 'J6'
ORDER BY 1;

---------------------------------------춘대학 계정으로 실행하기
--학생정보
SELECT
    STUDENT_NO 번호
    ,STUDENT_NAME 성명
    ,STUDENT_SSN 주민번호
    ,STUDENT_ADDRESS 주소
    ,'학생'
FROM TB_STUDENT
WHERE STUDENT_ADDRESS LIKE '서울시%'
UNION
SELECT
    PROFESSOR_NO
    ,PROFESSOR_NAME
    ,PROFESSOR_SSN
    ,PROFESSOR_ADDRESS
    ,'교수'
FROM TB_PROFESSOR
WHERE PROFESSOR_ADDRESS LIKE '서울시%'
ORDER BY 2;
--컬럼명은 선행되는 SELECT구문의 컬럼명을 따라간다.
--------------------------------------------------KH계정으로
--INTERSECT : 교집합
SELECT
    EMP_ID
    ,EMP_NAME
    ,DEPT_CODE
    ,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT
    EMP_ID
    ,EMP_NAME
    ,DEPT_CODE
    ,SALARY
FROM EMPLOYEE
WHERE SALARY>3000000;
--MINUS
SELECT
    EMP_ID
    ,EMP_NAME
    ,DEPT_CODE
    ,SALARY
    ,'D5'
FROM EMPLOYEE
WHERE DEPT_CODE = 'D2'
MINUS
SELECT
    EMP_ID
    ,EMP_NAME
    ,DEPT_CODE
    ,SALARY
    ,'J6'
FROM EMPLOYEE
WHERE JOB_CODE='J1';
