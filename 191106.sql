-- 그룹함수
-- multi row function : 여러 개의 행을 입력으로 하나의 결과 행을 생성
-- SUM, MAX, MIN, AVG, COUNT
-- GROUP BY col | express
-- SELECT절에는 GROUP BY절에 기술 COL, EXPRESS 표기 가능

-- 직원 중 가장 높은 급여 조회
-- 14개의 행이 입력으로 들어가 하나의 결과가 도출
SELECT MAX(sal) max_sal
FROM emp;

-- 부서별로 가장 높은 급여 조회
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

SELECT *
FROM dept;

SELECT *
FROM emp;

-- group function 실습 grp3
-- emp 테이블을 이용하여 다음을 구하시오
-- grp2에서 작성한 쿼리를 활용하여 deptno 대신 부서명이 나올 수 있도록 수정하시오.
SELECT DECODE(deptno, 10, 'ACOOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS') dname, 
        MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal, 
        COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY DECODE(deptno, 10, 'ACOOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS')
ORDER BY dname;

-- group function 실습 grp4 
-- emp 테이블을 이용하여 다음을 구하시오
-- 직원의 입사 년월별로 몇명의 직원이 입사했는지 조회하는 쿼리를 작성하세요
SELECT TO_CHAR(hiredate, 'YYYYMM') hire_YYYYMM, COUNT(TO_CHAR(hiredate, 'YYYYMM')) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM');

-- group function 실습 grp5
-- emp 테이블을 이용하여 다음을 구하시오
-- 직원의 입사 년별로 몇명의 직원이 입사했는지 조회하는 쿼리를 작성하세요
SELECT TO_CHAR(hiredate, 'YYYY') hire_YYYYMM, COUNT(TO_CHAR(hiredate, 'YYYYMM')) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY')
ORDER BY TO_CHAR(hiredate, 'YYYY');

-- group function 실습 grp6
-- 회사에 존재하는 부서의 개수는 몇 개인지 조회하는 쿼리를 작성하시오
SELECT COUNT(deptno) cnt
FROM dept;

-- JOIN
-- emp 테이블에는 dname 컬럼이 없다. --> 부서번호(deptno)밖에 없음
desc emp;

-- emp 테이블에 부서이름을 저장할 수 있는 dname 컬럼 추가
ALTER TABLE emp ADD (dname VARCHAR2(14));

SELECT *
FROM emp;

UPDATE emp SET dname = 'ACCOUNTING' WHERE DEPTNO = 10;
UPDATE emp SET dname = 'RESEARCH' WHERE DEPTNO = 20;
UPDATE emp SET dname = 'SALES' WHERE DEPTNO = 30;
COMMIT;

SELECT dname, MAX(sal) max_sal
FROM emp
GROUP BY dname;

ALTER TABLE emp DROP COLUMN DNAME;

SELECT *
FROM emp;

-- ansi natural join : 조인하는 테이블의 컬럼명이 같은 컬럼을 기준으로 JOIN
SELECT DEPTNO, ENAME, DNAME
FROM emp NATURAL JOIN dept;

-- ORACLE join
SELECT emp.empno, emp.ename, emp.deptno, dept.dname, dept.loc
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- ANSI JOIN WITH USING
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept USING (deptno);

-- from절에 조인 대상 테이블 나열
-- where절에 조인조건 기술
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- job이 SALES인 사람만 대상으로 조회
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.job = 'SALESMAN';

-- JOIN with ON (개발자가 조인 컬럼을 on절에 직접 기술)
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- SELF join : 같은 테이블끼리 조인
-- emp 테이블의 mgr 정보를 참고하기 위해서 emp 테이블과 조인을 해야한다.
-- a : 직원 정보, b : 관리자
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno)
WHERE a.empno BETWEEN 7369 AND 7698;

-- oracle
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno
  AND a.empno BETWEEN 7369 AND 7698;
  
-- non-equijoin (등식 조인이 아닌경우)
SELECT *
FROM salgrade;

-- 직원의 급여 등급은?
SELECT a.empno, a.ename, a.sal, b.*
FROM emp a, salgrade b
WHERE a.sal BETWEEN b.losal AND b.hisal;

SELECT a.empno, a.ename, a.sal, b.*
FROM emp a JOIN salgrade b ON(a.sal BETWEEN b.losal AND b.hisal);

-- non_equijoin
SELECT empno, ename, dept.deptno
FROM emp, dept
WHERE emp.deptno != dept.deptno
   AND empno = 7369;
   
-- 데이터 결합 실습 join 0
-- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요
SELECT empno, ename, a.deptno, dname
FROM emp a, dept b
WHERE a.deptno = b.deptno
ORDER BY a.deptno;

-- 데이터 결합 실습 join0_1
-- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요
-- (부서번호가 10, 30인 데이터만 조회)
SELECT empno, ename, a.deptno, dname
FROM emp a, dept b
WHERE a.deptno = b.deptno
  AND a.deptno in (10, 30);