SELECT * FROM EMP;

-- report group function �ǽ� GROUP_AD3
SELECT deptno, job, SUM(sal) sal
FROM emp
GROUP BY ROLLUP (deptno, job);

-- report group function �ǽ� GROUP_AD4
SELECT (SELECT dname FROM dept WHERE deptno = emp.deptno) dname, job, SUM(sal) sal
FROM emp
GROUP BY ROLLUP (deptno, job);

-- report group function �ǽ� GROUP_AD5
SELECT NVL((SELECT dname FROM dept WHERE deptno = emp.deptno), '����') dname, job, SUM(sal) sal
FROM emp
GROUP BY ROLLUP (deptno, job);