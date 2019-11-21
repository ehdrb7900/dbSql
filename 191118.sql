SELECT *
FROM USER_VIEWS;
SELECT *
FROM ALL_VIEWS
WHERE OWNER = 'DKOH';

SELECT *
FROM dkoh.v_emp_dept;

-- dkoh 계정에서 조회권한을 받은 V_EMP_DEPT view를 hr 계정에서 조회하기 위해서는
-- 계정명.view이름 형식으로 기술을 해야한다.
-- 매번 계정명을 기술하기 귀찮으므로 시노님을 통해 다른 별칭을 생성

CREATE SYNONYM v_emp_dept FOR dkoh.v_emp_dept;

-- sem.v_emp_dept --> v_emp_dept
SELECT *
FROM v_emp_dept;

-- 시노님 삭제
DROP SYNONYM v_emp_dept;

-- hr 계정 비밀번호 : java
-- hr 계정 비밀번호 변경 : hr
ALTER USER hr IDENTIFIED BY java;
-- ALTER USER dkoh IDENTIFIED BY java; -- 본인 계정이 아니기 때문에 에러 발생

-- ditionary
-- 접두어 : USER : 사용자 소유 객체
--          ALL : 사용자가 사용 가능한 객체
--          DBA : 관리자 관점의 전체 객체 (일반 사용자는 사용 불가)
--          V$ : 시스템과 관련된 view (일반 사용자는 사용 불가)

SELECT *
FROM USER_TABLES;

SELECT *
FROM ALL_TABLES;

SELECT *
FROM DBA_TABLES
WHERE OWNER IN ('DKOH', 'HR');

-- 오라클에서 동일한 SQL이란?
-- 문자가 하나라도 틀리면 안됨
-- 다음 SQL들은 같은 결과를 만들어낼지 몰라도 DBMS에서는
-- 서로 다른 SQL로 인식된다.

-- SQL에서의 bind 변수 및 JAVA에서의 preparedStatement는 실행계획 공유를 위해 사용됨

SELECT /*bind test*/ * FROM emp;
Select /*bind test*/* FROM emp;
Select /*bind test*/*  FROM emp;



SELECT *
FROM v$SQL
WHERE SQL_TEXT LIKE '%emp%';


SELECT f1.loc LOCATION, ROUND(f1.cnt / f2.cnt, 2) BG_SCORE
FROM (SELECT COUNT(*) cnt, (sido || ' ' || sigungu) loc
        FROM fastfood
        WHERE gb IN ('버거킹','맥도날드','KFC')
        GROUP BY sido, sigungu) f1,
      (SELECT COUNT(*) cnt, (sido || ' ' || sigungu) loc
        FROM fastfood
        WHERE gb = '롯데리아'
        GROUP BY sido, sigungu) f2
WHERE f1.loc = f2.loc
ORDER BY BG_SCORE DESC;