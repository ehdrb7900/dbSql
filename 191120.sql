-- GROUPING (cube, rollup���� ���� �÷�)
-- �ش� �÷��� �Ұ� ��꿡 ���� ��� 1
-- ������ ���� ��� 0

-- job �÷�
-- case 1. GROUPING(job) = 1 AND GROUPING(deptno) = 1
--          job --> '�Ѱ�'
-- case else
--          job --> job
SELECT CASE WHEN GROUPING(job) = 1 AND
                    GROUPING(deptno) = 1 THEN '�Ѱ�'
              ELSE job
        END job,  
        CASE WHEN GROUPING(job) = 0 AND
                    GROUPING(deptno) = 1 THEN job || ' �Ұ� : ' 
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
-- CUBE���� ������ �÷��� ������ ��� ���տ� ���� ���� �׷����� ����
-- CUBE�� ������ �÷��� ���� ���⼺�� ����(ROLLUP���� ����)
-- GROUP BY CUBE(job, deptno)
-- OO : GROUP BY job, deptno
-- OX : GROUP BY job
-- XO : GROUP BY deptno
-- XX : GROUP BY ��� ������

-- GROUP BY CUBE(job, deptno, mgr)

SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY CUBE(job, deptno);

-- subquery�� ���� ������Ʈ
DROP TABLE emp_test;

-- emp ���̺��� �����͸� �����ؼ� ��� �÷��� �̿��Ͽ� emp_test ���̺�� ����
CREATE TABLE emp_test AS
SELECT *
FROM emp;

-- emp_test ���̺��� dept ���̺��� �����ǰ��ִ� dname �÷�(VARCHAR2(14))�� �߰�
ALTER TABLE emp_test ADD (dname VARCHAR2(14));

SELECT *
FROM emp_test;

-- emp_test ���̺��� dname �÷��� dept ���̺��� dname �÷� ������ ������Ʈ�ϴ� ���� �ۼ�
UPDATE emp_test SET dname = ( SELECT dname
                                FROM dept
                                WHERE dept.deptno = emp_test.deptno);
-- WHERE empno IN (7369, 7499);
COMMIT;

DROP TABLE dept_test;
SELECT * FROM dept_test;

-- �������� ADVANCED �ǽ� sub_a1
-- dept ���̺��� �̿��Ͽ� dept_test ���̺� ����
CREATE TABLE dept_test AS
SELECT *
FROM dept;

-- dept_test ���̺� empcnt(number) �÷� �߰�
ALTER TABLE dept_test ADD(empcnt number);

-- subquery�� �̿��Ͽ� dept_test ���̺��� empcnt �÷��� �ش� �μ��� ���� update������ �ۼ��ϼ���
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
                                        
-- �������� ADVANCED �ǽ� sub_a3
DROP TABLE emp_test;
-- emp ���̺��� �̿��Ͽ� emp_test ���̺� ����
CREATE TABLE emp_test AS
SELECT *
FROM emp;

-- SUBQUERY�� �̿��Ͽ� emp_test ���̺��� ������ ���� �μ��� (SAL) ��� �޿�����
-- �޿��� ���� ������ �޿��� �� �޿����� 200�� �߰��ؼ� ������Ʈ �ϴ� ������ �ۼ��ϼ���.
UPDATE emp_test a
SET sal = sal + 200
WHERE sal < (SELECT AVG(SAL) FROM emp_test b GROUP BY deptno HAVING a.deptno = b.deptno);

-- emp, emp_test empno �÷����� ���� ������ ��ȸ
-- 1. emp.empno, emp.ename, emp.sal, emp_test.sal
SELECT emp.empno, emp.ename, emp.sal, emp_test.sal
FROM emp, emp_test
WHERE emp.empno = emp_test.empno;

-- 2. emp.empno, emp.ename, emp.sal, emp_test.sal, deptno, �ش����� ���� �μ��� �޿���� (emp ���̺� ����)
SELECT emp.empno, emp.ename, emp.sal, emp_test.sal upsal, emp.deptno, sal_avg, sal_avg - emp.sal difference,
        CASE WHEN sal_avg > emp.sal THEN '�޿��λ�' ELSE '-' END ischanged
FROM emp, emp_test, (SELECT deptno, ROUND(AVG(SAL),2) sal_avg FROM emp GROUP BY deptno) a
WHERE emp.empno = emp_test.empno
AND emp.deptno = a.deptno;

