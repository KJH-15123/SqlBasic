--05_SELECT(KH계정)_SUBQUERY

/*
    <SUBQUERY 서브쿼리>
    하나의 주된 SQL문 안에 포함된 또 하나의 SELECT 구문
    메인 SQL문을 위해 보조 역할로 사용된다.
    사용될 수 있는 구문) SELECT,INSERT,CREATE,UPDATE
*/

--노옹철 사원과 같은 부서인 사원들
SELECT
    *
FROM 
    EMPLOYEE
WHERE 
    DEPT_CODE IN(
        SELECT DEPT_CODE
        FROM EMPLOYEE
        WHERE EMP_NAME = '노옹철');
        
--전체 사원의 평균 급여보다 많은 급여를 받는 사원들의 사번,이름직급코드 조회
SELECT
    EMP_NO
    ,EMP_NAME
    ,DEPT_CODE
FROM
    EMPLOYEE
WHERE
    SALARY >(
        SELECT
            AVG(SALARY)
        FROM EMPLOYEE);

/*
    서브쿼리 구문
    서브쿼리의 수행 결과값이 몇행 몇열이냐에 따라서 분류된다.
    
    - 단일행 단일열 서브쿼리 : 결과값이 1개일때
    - 다중행 단일열 서브쿼리 : 결과값이 여러행이고 하나의 열일때
    - 단일행 다중열 서브쿼리 : 결과값이 하나의 행에 여러 컬럼으로 나뉠때
    - 다중행 다중열 서브쿼리 : 결과값이 여러행과 여러 열로 나뉠때
    
    서브쿼리를 수행한 결과 유형에 따라서 사용가능한 연산자가 다르다.
    
    1. 단일행 단일열 서브쿼리
        서브쿼리의 조회 결과가 오로지 1개일때
        일반 연산자 사용 가능 (=,<>,>=,<=,<,>)
    
    2. 다중행(단일열) 서브쿼리
    서브쿼리 조회 결과값이 여러 행일 경우
    - IN (10,20,30) : 결과 값 중에서 하나라도 일치하는것이 있다면
    - > ANY(10,20,30) : 결과값 중에서 하나라도 클 경우
    - < ANY(10,20,30) : 결과값 중에서 하나라도 작을 경우
    - > ALL : 여러개의 결과값이 모든 값보다 클 경우
    - < ALL : 여러개의 결과값이 모든 값보다 작을 경우
    
    3. (단일행)다중열 서브쿼리
    
    서브쿼리 조회결과가 한 행이지만 컬럼 개수가 여러개로 조회될때
    
    4. 다중행 다중열 서브쿼리
    서브쿼리의 조회결과가 다중행,다중열인경우
    
*/

--전 직원의 평균급여보다 더 적게 받는 사원들의 사원명,직급코드,급여 조회
SELECT
    EMP_NAME
    ,JOB_CODE
    ,SALARY
FROM
    EMPLOYEE
WHERE
    SALARY <
        (SELECT AVG(SALARY)
        FROM EMPLOYEE);
        
--최저 급여를 받는 사원의 사번,사원명,직급코드,급여,입사일 조회
 SELECT
    EMP_ID
    ,EMP_NAME
    ,JOB_CODE
    ,SALARY
    ,HIRE_DATE
FROM EMPLOYEE
WHERE
    SALARY = (
        SELECT MIN(SALARY)
        FROM EMPLOYEE);
--노옹철 사원의 급여보다 더 많이 받는 사원들의 사번,이름,부서코드,급여 조회
SELECT
    EMP_ID
    ,EMP_NAME
    ,DEPT_CODE
    SALARY
FROM EMPLOYEE
WHERE
    SALARY >(
        SELECT SALARY
        FROM EMPLOYEE
        WHERE EMP_NAME = '노옹철');
--노옹철 사원의 급여보다 더 많이 받는 사원들의 사번,이름,부서명,급여 조회
SELECT
    EMP_ID
    ,EMP_NAME
    ,DEPT_TITLE
    ,SALARY
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE
    SALARY <(
        SELECT SALARY
        FROM EMPLOYEE
        WHERE EMP_NAME = '노옹철');

--부서별 급여합이 가장 큰 부서 하나만 부서코드 부서명 급여합 조회
SELECT
    DEPT_CODE
    ,DEPT_TITLE
    ,SUM(SALARY)
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
GROUP BY
    DEPT_CODE
    ,DEPT_TITLE
HAVING
    SUM(SALARY) =(--부서별로 정리한 급여합중 최대값
        SELECT
            MAX(SUM(SALARY)) -- 서브쿼리로 나눠서 안정성 개선 요망
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
);

--각 부서별 최고 급여를 받는 사원의 이름,직급코드,급여 조회
--각 부서별 최고 급여
SELECT
    DEPT_CODE
    ,MAX(SALARY)
FROM EMPLOYEE
GROUP BY
    DEPT_CODE;
-각 부서별 최고 급여를 받는 사원의 이름,직급코드,급여 조회
SELECT
    EMP_NAME
    ,JOB_CODE
    ,SALARY
FROM EMPLOYEE
WHERE 
    SALARY IN (
        SELECT MAX(SALARY)
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
);

--선동일 또는 유재식 사원과 같은 부서인 사원들을 조회(사원명,부서코드,급여)
SELECT
    EMP_NAME
    ,DEPT_CODE
    ,SALARY
FROM EMPLOYEE
WHERE 
    DEPT_CODE IN (
        SELECT
            DEPT_CODE
        FROM EMPLOYEE
        WHERE EMP_NAME IN ('선동일','유재석')
    );
--이오리 또는 하동운 사원가 같은 직급인 사원들 조회 (사원명,직급코드,부서코드,급여)
SELECT
    EMP_NAME
    ,DEPT_CODE
    ,JOB_CODE
    ,SALARY
FROM EMPLOYEE
WHERE
    JOB_CODE IN(
        SELECT
            JOB_CODE
        FROM EMPLOYEE
        WHERE EMP_NAME IN ('이오리','하동운')
    );
    
--대리 직급임에도 과장 직급의 급여보다 많이 받는 사원들 조회 (사번,사원명,직급명,급여)
SELECT
    EMP_ID
    ,EMP_NAME
    ,JOB_NAME
    ,SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE
    JOB_NAME = '대리'
    AND SALARY > ANY (
        SELECT SALARY
        FROM EMPLOYEE
        LEFT JOIN JOB USING (JOB_CODE)
        WHERE JOB_NAME = '과장'
        );
        
--과장 직급임에도 모든 차장 직급의 급여보다 많이 받는 직원 조회(사번,이름,직급명,급여)
SELECT
    EMP_ID
    ,EMP_NAME
    ,JOB_NAME
    ,SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE
    JOB_NAME = '과장'
    AND SALARY > ALL(
        SELECT
            SALARY
        FROM EMPLOYEE
        JOIN JOB USING (JOB_CODE)
        WHERE JOB_NAME = '차장'
    );

--하이유 사원과 같은 부서코드,직급코드에 해당하는 사원들 조회(사원명,부서코드,직급코드,고용일)
SELECT
    EMP_NAME
    ,DEPT_CODE
    ,JOB_CODE
FROM EMPLOYEE
WHERE 
    (DEPT_CODE,JOB_CODE) IN (
        SELECT
            DEPT_CODE
            ,JOB_CODE
        FROM EMPLOYEE
        WHERE EMP_NAME = '하이유'
        );

--박나리 사원과 같은 직급코드,같은 사수사번을 가진 사원들의 (사번,이름직급코드,사수사번)
SELECT
    EMP_ID
    ,EMP_NAME
    ,JOB_CODE
    ,MANAGER_ID
FROM EMPLOYEE
WHERE 
    (DEPT_CODE,MANAGER_ID) = (
        SELECT DEPT_CODE,MANAGER_ID
        FROM EMPLOYEE
        WHERE EMP_NAME = '박나라'
        );

--각 직급별 최소급여를 받는 사원들 조회(사번,사원명,직급코드,급여)
--1)직급별 최소급여 조회
SELECT DEPT_CODE ,MIN(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY 1;
--위 조회 결과와 일치하는 사원들 조회
SELECT EMP_ID,EMP_NAME,JOB_CODE,SALARY
FROM EMPLOYEE
WHERE
    (JOB_CODE,SALARY) IN (
        SELECT JOB_CODE,MIN(SALARY)
        FROM EMPLOYEE
        GROUP BY JOB_CODE);
        
--각 부서별 최고급여를 받는 사원들 조회 (사번,사원명,부서코드,급여)
SELECT EMP_ID,EMP_NAME,NVL(DEPT_CODE,'부서없음') 부서,SALARY
FROM EMPLOYEE
WHERE 
    (NVL(DEPT_CODE,'X'),SALARY) IN (
        SELECT NVL(DEPT_CODE,'X'),MAX(SALARY)
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
        )
ORDER BY 3;
-----------------------------------------------------------
/*
    5. 인라인뷰(INLINE VIEW)
    FROM절에서 서브쿼리를 제시하여
    조회된 결과(RESULT SET)를 테이블처럼 이용하는 구문
    
    -사용처
        1. TOP-N 분석
            데이터베이스상에 있는 자료 중 최상위 N개의 자료를 보기위해 사용하는 기능
            *ROWNUM : 오라클에서 제공하는 가상컬럼으로 1부터 순번을 부여해준다.
            
*/
--보너스 포함 연봉이 3000만원이상인 사원들의 사번,이름,보너스포함연봉,부서코드 조회
SELECT 사번,사원명,"최종 연봉",부서
FROM(
    SELECT
        EMP_ID 사번
        ,EMP_NAME 사원명
        ,(SALARY+SALARY*NVL(BONUS,0)*12) "최종 연봉"
        ,NVL(DEPT_CODE,'없음') "부서"
    FROM EMPLOYEE)
WHERE "최종 연봉">=30000000;

--ROWNUM 예시
SELECT ROWNUM,EMP_NAME,SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;
--ORDER BY구문은 항상 마지막에 실행되기 때문ㅇ
--ROWNUM에서 순번을 먼저 부여한 뒤 정렬되어 ROWNUM의 순서가 섞이게 된 것.
--해결방법 : 순번을 부여하기 전에 정렬된 조회구문을 인라인 뷰로 사용하게 정렬 후 순번 부여하기
SELECT ROWNUM,EMP_NAME,SALARY
FROM (
    SELECT*
    FROM EMPLOYEE
    ORDER BY SALARY DESC);

-- 전 직원 중 급여가 높은 상위 3개의 부서 조회 (부서코드,평균급여)
SELECT
    ROWNUM
    ,DEPT_CODE
    ,"ROUND(AVG(SALARY))"
FROM (
    SELECT DEPT_CODE,ROUND(AVG(SALARY))
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
    ORDER BY AVG(SALARY) DESC)
WHERE ROWNUM <=3;

--가장 최근에 입사한 사원 5명 조회(사원명,급여,입사일,순번)
SELECT
    ROWNUM
    ,EMP_NAME
    ,SALARY
    ,HIRE_DATE
FROM (
    SELECT *
    FROM EMPLOYEE
    ORDER BY HIRE_DATE DESC)
WHERE ROWNUM <=5;

/*
    RANK() OVER(정렬기준)
    DENSE_RANK() OVER(정렬기준)
    
    - RANK() OVER(정렬기준) : 절대적인 순위값 매기기(공동1등이 2명이면 그 뒤는 3등 )
    - DENSE_RANK() OVER(정렬기준) : 빈틈없이 순위 매기기(공동 1등2명이어도 그 다음 2등)
    
    정렬 기준 : ORDER BY절(정렬기준 컬럼,오름차순/내림차순)
    
    **RANK OVER 함수는 SELECT절에서만 사용 가능
*/

--사원들의 급여가 높은 순서대로 사원명 급여 순위 조회
--RANK() OVER()
SELECT
    EMP_NAME 이름
    ,SALARY 월급
    ,RANK() OVER(
        ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;
--DENSE_RANK() OVER()
SELECT
    EMP_NAME 이름
    ,SALARY 월급
    ,DENSE_RANK() OVER(
        ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;

--위 내용 10위까지만 표기해보기
--RANK() OVER()
SELECT
    SUB.*
FROM(
    SELECT
        EMP_NAME 이름
        ,SALARY 월급
        ,RANK() OVER(
            ORDER BY SALARY DESC) 순위
    FROM EMPLOYEE) SUB
WHERE 순위 <= 10;
--DENSE_RANK() OVER()
SELECT
    SUB.*
FROM(
    SELECT
        EMP_NAME 이름
        ,SALARY 월급
        ,DENSE_RANK() OVER(
            ORDER BY SALARY DESC) 순위
    FROM EMPLOYEE
    ) SUB
WHERE 순위 <=10;

--WITH : 서브쿼리를 선언해놓고 사용 (해당 SELECT절에서 사용 가능하다.
--서브쿼리 구문이 길어진다면 해당 구문을 미리 선언해놓고 테이블처럼 사용 가능하다.
WITH SAL_TOTAL AS (
    SELECT
        NVL(DEPT_TITLE,'미지정') 부서명
        ,SUM(SALARY) 급여합
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
    GROUP BY DEPT_TITLE
)
SELECT *
FROM SAL_TOTAL
WHERE 급여합 > (
    SELECT
        SUM(SALARY)*0.2
        FROM EMPLOYEE
);

--부서명과 부서별 급여 합계 조회
--급여 합과 급여 평균 조회
--WITH는 여러개 선언 가능 ,로 구분지어서 처리
WITH SAL_TOTAL AS (
        SELECT SUM(SALARY)
        FROM EMPLOYEE),
    SAL_AVG AS(
        SELECT AVG(SALARY)
        FROM EMPLOYEE)
SELECT
    *
FROM SAL_TOTAL
UNION
SELECT
    *
FROM SAL_AVG
;
