-- GROUPING (cube, rollup절의 사용된 컬럼)
-- 해당 컬럼이 소계 계산에 사용된 경우 1
-- 사용되지 않은 경우 0

-- job 컬럼
-- case 1. GROUPING(job) = 1 AND GROUPING(deptno) = 1
--          job --> '총계'
-- case else
--          job --> job
SELECT CASE WHEN GROUPING(job) = 1 AND
                    GROUPING(deptno) = 1 THEN '총계'
              ELSE job
        END job,  
        CASE WHEN GROUPING(job) = 0 AND
                    GROUPING(deptno) = 1 THEN job || ' 소계 : ' 
            ELSE TO_CHAR(deptno) 
        END deptno, sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

DESC emp;

SELECT deptno, job, sum(sal) sal
FROM emp
GROUP BY ROLLUP(deptno, job);

SELECT *
FROM emp;


-- CUBE (col1, col2 ...)
-- CUBE절에 나열된 컬럼의 가능한 모든 조합에 대해 서브 그룹으로 생성
-- CUBE에 나열된 컬럼에 대해 방향성은 없다(ROLLUP과의 차이)
-- GROUP BY CUBE(job, deptno)
-- OO : GROUP BY job, deptno
-- OX : GROUP BY job
-- XO : GROUP BY deptno
-- XX : GROUP BY 모든 데이터

-- GROUP BY CUBE(job, deptno, mgr)

SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY CUBE(job, deptno);

-- subquery를 통한 업데이트
DROP TABLE emp_test;

-- emp 테이블의 데이터를 포함해서 모든 컬럼을 이용하여 emp_test 테이블로 생성
CREATE TABLE emp_test AS
SELECT *
FROM emp;

-- emp_test 테이블의 dept 테이블에서 관리되고있는 dname 컬럼(VARCHAR2(14))을 추가
ALTER TABLE emp_test ADD (dname VARCHAR2(14));

SELECT *
FROM emp_test;

-- emp_test 테이블의 dname 컬럼을 dept 테이블의 dname 컬럼 값으로 업데이트하는 쿼리 작성
UPDATE emp_test SET dname = ( SELECT dname
                                FROM dept
                                WHERE dept.deptno = emp_test.deptno);
-- WHERE empno IN (7369, 7499);
COMMIT;

DROP TABLE dept_test;
SELECT * FROM dept_test;

-- 서브쿼리 ADVANCED 실습 sub_a1
-- dept 테이블을 이용하여 dept_test 테이블 생성
CREATE TABLE dept_test AS
SELECT *
FROM dept;

-- dept_test 테이블에 empcnt(number) 컬럼 추가
ALTER TABLE dept_test ADD(empcnt number);

-- subquery를 이용하여 dept_test 테이블의 empcnt 컬럼에 해당 부서원 수를 update쿼리를 작성하세요
UPDATE dept_test SET empcnt = (SELECT COUNT(*) FROM emp WHERE dept_test.deptno = emp.deptno);
SELECT * FROM dept_test;

--
SELECT *
FROM dept_test;
INSERT INTO dept_test VALUES (40, 'OPERATIONS', 'BOSTON', 0);
INSERT INTO dept_test VALUES (98, 'IT', 'DAEJEON', 0);
INSERT INTO dept_test VALUES (99, 'IT', 'DAEJEON', 0);

DELETE dept_test WHERE (SELECT COUNT(*)
                          FROM emp 
                          WHERE dept_test.deptno = emp.deptno) = 0;

DELETE dept_test WHERE NOT EXISTS (SELECT 1
                                      FROM emp
                                      WHERE dept_test.deptno = emp.deptno);
                                      
DELETE dept_test WHERE (SELECT COUNT(*)
                          FROM emp
                          WHERE emp.deptno = dept_test.deptno
                          GROUP BY deptno) IS NULL;
                          
DELETE dept_test WHERE deptno NOT IN (SELECT deptno
                                        FROM emp);
                                        
-- 서브쿼리 ADVANCED 실습 sub_a3
DROP TABLE emp_test;
-- emp 테이블을 이용하여 emp_test 테이블 생성
CREATE TABLE emp_test AS
SELECT *
FROM emp;

-- SUBQUERY를 이용하여 emp_test 테이블에서 본인이 속한 부서의 (SAL) 평균 급여보다
-- 급여가 작은 직원의 급여를 현 급여에서 200을 추가해서 업데이트 하는 쿼리를 작성하세요.
UPDATE emp_test a
SET sal = sal + 200
WHERE sal < (SELECT AVG(SAL) FROM emp_test b GROUP BY deptno HAVING a.deptno = b.deptno);

-- emp, emp_test empno 컬럼으로 같은 값끼리 조회
-- 1. emp.empno, emp.ename, emp.sal, emp_test.sal
SELECT emp.empno, emp.ename, emp.sal, emp_test.sal
FROM emp, emp_test
WHERE emp.empno = emp_test.empno;

-- 2. emp.empno, emp.ename, emp.sal, emp_test.sal, deptno, 해당사원이 속한 부서의 급여평균 (emp 테이블 기준)
SELECT emp.empno, emp.ename, emp.sal, emp_test.sal upsal, emp.deptno, sal_avg, sal_avg - emp.sal difference,
        CASE WHEN sal_avg > emp.sal THEN '급여인상' ELSE '-' END ischanged
FROM emp, emp_test, (SELECT deptno, ROUND(AVG(SAL),2) sal_avg FROM emp GROUP BY deptno) a
WHERE emp.empno = emp_test.empno
AND emp.deptno = a.deptno;

