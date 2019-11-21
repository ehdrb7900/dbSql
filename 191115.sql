SELECT SUM(sal)
FROM emp;

-- emp ���̺� empno �÷��� �������� PRIMARY KEY�� ����
-- PRIMARY KEY = UNIQUE + NOT NULL
-- UNIQUE ==> �ش� �÷����� UNIQUE INDEX�� �ڵ����� ����

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE emp DROP CONSTRAINT pk_emp;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7369;

SELECT *
FROM TABLE(dbms_xplan.display);

-- empno �÷����� �ε����� �����ϴ� ��Ȳ����
-- �ٸ� �÷� ������ �����͸� ��ȸ�ϴ� ���
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);

-- �ε��� ���� �÷��� SELECT���� ����� ��� ���̺� ������ �ʿ� ����.

EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno=7782;

SELECT *
FROM TABLE(dbms_xplan.display);

-- �÷��� �ߺ��� ������ non-unique �ε��� ���� �� 
-- unique index���� �����ȹ ��
-- PRIMARY KEY �������� ����(unique �ε��� ����)
ALTER TABLE emp DROP CONSTRAINT pk_emp;
CREATE /*UNIQUE*/ INDEX IDX_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno=7782;

SELECT *
FROM TABLE(dbms_xplan.display);

-- emp ���̺� job �÷����� �� ��° �ε��� ����
-- job �÷��� �ߺ� ���� �����ϴ� �÷��̴�.
CREATE INDEX idx_emp_02 ON emp (job);
DROP INDEX idx_emp_02;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

-- emp ���̺� job, ename �÷��� �������� non-unique �ε��� ���� 
CREATE INDEX IDX_emp_03 ON emp (job, ename);
DROP INDEX IDX_emp_03;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

-- emp ���̺� ename, job �÷����� non-unique �ε��� ����
CREATE INDEX IDX_emp_04 ON emp (ename, job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE '%C';

SELECT *
FROM TABLE(dbms_xplan.display);

-- HINT�� ����� �����ȹ ����
EXPLAIN PLAN FOR
SELECT /*+ INDEX ( emp idx_emp_04 ) */ *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE '%C';

SELECT *
FROM TABLE(dbms_xplan.display);

-- DDL Index �ǽ� idx 1
-- CREATE TABLE DEPT_TEST AS SELECT * FROM DEPT WHERE 1 = 1 ��������
-- DEPT_TEST ���̺� ���� �� ���� ���ǿ� �´� �ε����� �����ϼ���
DROP TABLE DEPT_TEST;

CREATE TABLE DEPT_TEST AS 
SELECT * 
FROM DEPT 
WHERE 1 = 1;

-- 1) deptno �÷��� �������� unique �ε��� ����
CREATE UNIQUE INDEX IDX_dept_test_01 ON dept_test (deptno);
-- 2) dname �÷��� �������� non-unique �ε��� ����
CREATE INDEX IDX_dept_test_02 ON dept_test (dname);
-- 3) deptno, dname �÷��� �������� non-unique �ε��� ����
CREATE INDEX IDX_dept_test_03 ON dept_test (deptno, dname);

-- DDL Index �ǽ� idx 2
-- �ǽ� idx1 ���� ������ �ε����� �����ϴ� DDL���� �ۼ��ϼ���.
DROP INDEX IDX_dept_test_01;
DROP INDEX IDX_dept_test_02;
DROP INDEX IDX_dept_test_03;
DROP INDEX IDX_emp_01;
DROP INDEX IDX_emp_02;
DROP INDEX IDX_emp_03;
DROP INDEX IDX_emp_04;

-- DDL Index �ǽ� idx 3

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