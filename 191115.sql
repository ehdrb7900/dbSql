SELECT SUM(sal)
FROM emp;

-- emp 테이블에 empno 컬럼을 기준으로 PRIMARY KEY를 생성
-- PRIMARY KEY = UNIQUE + NOT NULL
-- UNIQUE ==> 해당 컬럼으로 UNIQUE INDEX를 자동으로 생성

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE emp DROP CONSTRAINT pk_emp;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7369;

SELECT *
FROM TABLE(dbms_xplan.display);

-- empno 컬럼으로 인덱스가 존재하는 상황에서
-- 다른 컬럼 값으로 데이터를 조회하는 경우
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);

-- 인덱스 구성 컬럼만 SELECT절에 기술한 경우 테이블 접근이 필요 없다.

EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno=7782;

SELECT *
FROM TABLE(dbms_xplan.display);

-- 컬럼에 중복이 가능한 non-unique 인덱스 생성 후 
-- unique index와의 실행계획 비교
-- PRIMARY KEY 제약조건 삭제(unique 인덱스 삭제)
ALTER TABLE emp DROP CONSTRAINT pk_emp;
CREATE /*UNIQUE*/ INDEX IDX_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno=7782;

SELECT *
FROM TABLE(dbms_xplan.display);

-- emp 테이블에 job 컬럼으로 두 번째 인덱스 생성
-- job 컬럼은 중복 값이 존재하는 컬럼이다.
CREATE INDEX idx_emp_02 ON emp (job);
DROP INDEX idx_emp_02;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

-- emp 테이블에 job, ename 컬럼을 기준으로 non-unique 인덱스 생성 
CREATE INDEX IDX_emp_03 ON emp (job, ename);
DROP INDEX IDX_emp_03;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

-- emp 테이블에 ename, job 컬럼으로 non-unique 인덱스 생성
CREATE INDEX IDX_emp_04 ON emp (ename, job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE '%C';

SELECT *
FROM TABLE(dbms_xplan.display);

-- HINT를 사용한 실행계획 제어
EXPLAIN PLAN FOR
SELECT /*+ INDEX ( emp idx_emp_04 ) */ *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE '%C';

SELECT *
FROM TABLE(dbms_xplan.display);

-- DDL Index 실습 idx 1
-- CREATE TABLE DEPT_TEST AS SELECT * FROM DEPT WHERE 1 = 1 구문으로
-- DEPT_TEST 테이블 생성 후 다음 조건에 맞는 인덱스를 생성하세요
DROP TABLE DEPT_TEST;

CREATE TABLE DEPT_TEST AS 
SELECT * 
FROM DEPT 
WHERE 1 = 1;

-- 1) deptno 컬럼을 기준으로 unique 인덱스 생성
CREATE UNIQUE INDEX IDX_dept_test_01 ON dept_test (deptno);
-- 2) dname 컬럼을 기준으로 non-unique 인덱스 생성
CREATE INDEX IDX_dept_test_02 ON dept_test (dname);
-- 3) deptno, dname 컬럼을 기준으로 non-unique 인덱스 생성
CREATE INDEX IDX_dept_test_03 ON dept_test (deptno, dname);

-- DDL Index 실습 idx 2
-- 실습 idx1 에서 생성한 인덱스를 삭제하는 DDL문을 작성하세요.
DROP INDEX IDX_dept_test_01;
DROP INDEX IDX_dept_test_02;
DROP INDEX IDX_dept_test_03;
DROP INDEX IDX_emp_01;
DROP INDEX IDX_emp_02;
DROP INDEX IDX_emp_03;
DROP INDEX IDX_emp_04;

-- DDL Index 실습 idx 3

SELECT deptno, COUNT(*) 
FROM emp 
GROUP BY deptno 
ORDER BY deptno;

SELECT * FROm emp ORDER BY sal;
CREATE UNIQUE INDEX idx_emp_pk ON emp(empno);
CREATE INDEX idx_emp_deptno ON emp(deptno);
DROP INDEX idx_emp_deptno;
CREATE INDEX idx_emp_ename ON emp(ename);
DROP INDEX idx_emp_ename;
CREATE INDEX idx_emp_mgr ON emp(mgr);
DROP INDEX idx_emp_mgr;
CREATE INDEX idx_emp_mgr_empno ON emp(mgr, empno);
DROP INDEX idx_emp_mgr_empno;

EXPLAIN PLAN FOR
SELECT b.*
FROM emp a, emp b
WHERE a.deptno = 30;

SELECT *
FROM TABLE(dbms_xplan.display);