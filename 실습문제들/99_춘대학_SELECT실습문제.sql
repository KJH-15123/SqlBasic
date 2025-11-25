--99_춘대학_SELECT실습문제

--1. 춘 기술대학교의 학과 이름과 계열을 표시하시오. 단, 출력 헤더는 "학과 명", "계열" 으로 표시하도록 한다.
SELECT DEPARTMENT_NAME "학과 명"
      ,CATEGORY 계열
FROM TB_DEPARTMENT;
--2. 학과의 학과 정원을 다음과 같은 형태로 화면에 출력한다.
SELECT DEPARTMENT_NAME||'의 정원은 '||CAPACITY||' 명 입니다.' "학과별 정원"
FROM TB_DEPARTMENT;
--3. "국어국문학과" 에 다니는 여학생 중 현재 휴학중인 여학생을 찾아달라는 요청이
--들어왔다. 누구인가? (국문학과의 '학과코드'는 학과 테이블(TB_DEPARTMENT)을 조회해서
--찾아 내도록 하자)
--STUDENT_NAME
----------------------
--핚수현
--국어국문학과 학과코드 조회하기
SELECT DEPARTMENT_NO,DEPARTMENT_NAME
FROM TB_DEPARTMENT
WHERE DEPARTMENT_NAME='국어국문학과';--001

--국어국문학과(001)에 다니는 휴학중인 여학생 조회 
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE DEPARTMENT_NO ='001' --학과번호
AND ABSENCE_YN = 'Y' --휴학중인
AND (STUDENT_SSN LIKE '_______2%'
  OR STUDENT_SSN LIKE '_______4%'); --성별자리가 2또는 4로 시작하는 (여학생)

--4. 도서관에서 대출 도서 장기 연체자 들을 찾아 이름을 게시하고자 핚다. 그 대상자들의
--학번이 다음과 같을 때 대상자들을 찾는 적젃핚 SQL 구문을 작성하시오.
--A513079, A513090, A513091, A513110, A513119
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO IN ('A513079','A513090','A513091','A513110','A513119')
ORDER BY 1 DESC;

--5. 입학정원이 20 명 이상 30 명 이하인 학과들의 학과 이름과 계열을 출력하시오.
--DEPARTMENT_NAME CATEGORY
SELECT DEPARTMENT_NAME,CATEGORY
FROM TB_DEPARTMENT
WHERE CAPACITY BETWEEN 20 AND 30;

--6. 춘 기술대학교는 총장을 제외하고 모든 교수들이 소속 학과를 가지고 있다. 그럼 춘
--기술대학교 총장의 이름을 알아낼 수 있는 SQL 문장을 작성하시오.
--PROFESSOR_NAME
----------------------
--임해정
SELECT PROFESSOR_NAME
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL;

--7. 혹시 젂산상의 착오로 학과가 지정되어 있지 않은 학생이 있는지 확인하고자 핚다. 
--어떠핚 SQL 문장을 사용하면 될 것인지 작성하시오.
SELECT *
FROM TB_STUDENT
WHERE DEPARTMENT_NO IS NULL;

--8. 수강신청을 하려고 핚다. 선수과목 여부를 확인해야 하는데, 선수과목이 존재하는
--과목들은 어떤 과목인지 과목번호를 조회해보시오.
--CLASS_NO.
SELECT CLASS_NO
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL;

--9. 춘 대학에는 어떤 계열(CATEGORY)들이 있는지 조회해보시오.
SELECT DISTINCT CATEGORY
FROM TB_DEPARTMENT
ORDER BY 1;

--10. 02 학번 젂주 거주자들의 모임을 맊들려고 핚다. 휴학핚 사람들은 제외핚 재학중인
--학생들의 학번, 이름, 주민번호를 출력하는 구문을 작성하시오.
--STUDENT_NO STUDENT_NAME STUDENT_SSN
SELECT STUDENT_NO,STUDENT_NAME,STUDENT_SSN
FROM TB_STUDENT
WHERE ENTRANCE_DATE LIKE '02%' --02학번
AND STUDENT_ADDRESS LIKE '전주%' --전주 거주
AND ABSENCE_YN ='N'; --휴학하지 않은






