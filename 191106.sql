-- �׷��Լ�
-- multi row function : ���� ���� ���� �Է����� �ϳ��� ��� ���� ����
-- SUM, MAX, MIN, AVG, COUNT
-- GROUP BY col | express
-- SELECT������ GROUP BY���� ��� COL, EXPRESS ǥ�� ����

-- ���� �� ���� ���� �޿� ��ȸ
-- 14���� ���� �Է����� �� �ϳ��� ����� ����
SELECT MAX(sal) max_sal
FROM emp;

-- �μ����� ���� ���� �޿� ��ȸ
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

SELECT *
FROM dept;

SELECT *
FROM emp;

-- group function �ǽ� grp3
-- emp ���̺��� �̿��Ͽ� ������ ���Ͻÿ�
-- grp2���� �ۼ��� ������ Ȱ���Ͽ� deptno ��� �μ����� ���� �� �ֵ��� �����Ͻÿ�.
SELECT DECODE(deptno, 10, 'ACOOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS') dname, 
        MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal, 
        COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY DECODE(deptno, 10, 'ACOOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS')
ORDER BY dname;

-- group function �ǽ� grp4 
-- emp ���̺��� �̿��Ͽ� ������ ���Ͻÿ�
-- ������ �Ի� ������� ����� ������ �Ի��ߴ��� ��ȸ�ϴ� ������ �ۼ��ϼ���
SELECT TO_CHAR(hiredate, 'YYYYMM') hire_YYYYMM, COUNT(TO_CHAR(hiredate, 'YYYYMM')) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM');

-- group function �ǽ� grp5
-- emp ���̺��� �̿��Ͽ� ������ ���Ͻÿ�
-- ������ �Ի� �⺰�� ����� ������ �Ի��ߴ��� ��ȸ�ϴ� ������ �ۼ��ϼ���
SELECT TO_CHAR(hiredate, 'YYYY') hire_YYYYMM, COUNT(TO_CHAR(hiredate, 'YYYYMM')) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY')
ORDER BY TO_CHAR(hiredate, 'YYYY');

-- group function �ǽ� grp6
-- ȸ�翡 �����ϴ� �μ��� ������ �� ������ ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
SELECT COUNT(deptno) cnt
FROM dept;

-- JOIN
-- emp ���̺��� dname �÷��� ����. --> �μ���ȣ(deptno)�ۿ� ����
desc emp;

-- emp ���̺� �μ��̸��� ������ �� �ִ� dname �÷� �߰�
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

-- ansi natural join : �����ϴ� ���̺��� �÷����� ���� �÷��� �������� JOIN
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

-- from���� ���� ��� ���̺� ����
-- where���� �������� ���
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- job�� SALES�� ����� ������� ��ȸ
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.job = 'SALESMAN';

-- JOIN with ON (�����ڰ� ���� �÷��� on���� ���� ���)
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- SELF join : ���� ���̺��� ����
-- emp ���̺��� mgr ������ �����ϱ� ���ؼ� emp ���̺�� ������ �ؾ��Ѵ�.
-- a : ���� ����, b : ������
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno)
WHERE a.empno BETWEEN 7369 AND 7698;

-- oracle
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno
  AND a.empno BETWEEN 7369 AND 7698;
  
-- non-equijoin (��� ������ �ƴѰ��)
SELECT *
FROM salgrade;

-- ������ �޿� �����?
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
   
-- ������ ���� �ǽ� join 0
-- emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���
SELECT empno, ename, a.deptno, dname
FROM emp a, dept b
WHERE a.deptno = b.deptno
ORDER BY a.deptno;

-- ������ ���� �ǽ� join0_1
-- emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���
-- (�μ���ȣ�� 10, 30�� �����͸� ��ȸ)
SELECT empno, ename, a.deptno, dname
FROM emp a, dept b
WHERE a.deptno = b.deptno
  AND a.deptno in (10, 30);