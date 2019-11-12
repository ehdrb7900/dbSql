-- �ǽ� sub 9
SELECT *
FROM product
WHERE NOT EXISTS (SELECT 1 FROM cycle WHERE cid = 1 AND pid = product.pid);

SELECT *
FROM dept;

DELETE dept WHERE deptno = 99;
COMMIT;

INSERT INTO dept VALUES(99, 'DDIT','dayjeon');

INSERT INTO emp(empno, ename, job)
VALUES (9999, 'brown',null);

SELECT *
FROM emp
WHERE empno = 9999;

rollback;

desc emp;

SELECT *
FROM user_tab_columns
WHERE table_name = 'EMP'
ORDER BY column_id;

INSERT INTO emp
VALUES (9999, 'brown', 'ranger', null, sysdate, 2500, null, 40);

SELECT *
FROM emp;

-- SELECT ��� (������)�� INSERT

-- UPDATE
--  UPDATE ���̺� SET �÷� = ��, �÷� = ��...
--  WHERE condition
UPDATE dept SET dname = '���IT', loc='ym'
WHERE deptno = 99;

-- DELECT ���̺��
-- WHERE condition

-- �����ȣ�� 9999�� ������ emp ���̺��� ����
DELETE emp
WHERE empno = 9999;

-- �μ����̺��� �̿��ؼ� emp ���̺� �Է��� 5��(4��)�� �����͸� ����
-- 10, 20, 30, 40, 99 --> empno < 100, empno BETWEEN 10 AND 99
DELETE emp
WHERE empno < 100;

SELECT *
FROM emp
WHERE empno < 100;

rollback;

DELETE emp
WHERE empno BETWEEN 10 AND 99;

SELECT *
FROM emp
WHERE empno BETWEEN 10 AND 99;

DELETE emp
WHERE empno IN (SELECT deptno FROM dept);

SELECT *
FROM emp;

DELETE emp WHERE empno = 9999;

-- LV1 --> LV3
SET TRANSACTION
isolation LEVEL SERIALIZABLE;

-- DML ������ ���� Ʈ����� ����
INSERT INTO dept
VALUES (99, 'ddit','daejeon');

-- DDL : AUTO COMMIT, rollback�� �ȵȴ�.
-- CREATE
CREATE TABLE ranger_new(
    ranger_no NUMBER, -- ���� Ÿ��
    ranger_name VARCHAR2(50), -- ���� : [VARCHAR2], CHAR
    reg_dt DATE DEFAULT sysdate -- DEFAULT : SYSDATE
);
desc ranger_new;
SELECT * FROM ranger_new;

-- ddl�� rollback�� ������� �ʴ´�
rollback; -- ���� ��� : �ѹ� �Ϸ�, but ���� X

INSERT INTO ranger_new (ranger_no, ranger_name)
VALUES(1000, 'brown');
commit;

-- ��¥ Ÿ�Կ��� Ư�� �ʵ尡������
-- ex : sysdate���� �⵵�� ��������
SELECT TO_CHAR(sysdate, 'yyyy')
FROM dual;

SELECT ranger_no, ranger_name, reg_dt, TO_CHAR(reg_dt, 'MM'), 
        EXTRACT(MONTH FROM reg_dt) mm,
        EXTRACT(YEAR FROM reg_dt) year,
        EXTRACT(DAY FROM reg_dt) day
FROM ranger_new;

-- ��������
-- DEPT ����ؼ� DEPT_TEST ����
desc dept_test;
DROP table dept_test;
CREATE TABLE dept_test(
    deptno number(2) PRIMARY KEY,  -- deptno �÷��� �ĺ��ڷ� ����
    dname varchar2(14),             -- �ĺ��ڷ� ������ �Ǹ� ���� �ߺ���
    loc varchar2(13)                -- �� �� ������, null�� ���� ����.
);

-- PRIMARY KEY ���� ���� Ȯ��
-- 1. deptno �÷��� null�� �� �� ����.
-- 2. deptno �÷��� �ߺ��� ���� �� �� ����.
INSERT INTO dept_test (deptno, dname, loc)
VALUES (null, 'ddit', 'daejeon');

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon');

ROLLBACK;

-- ����� ���� �������Ǹ��� �ο��� PRIMARY KEY
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_DEPT_TEST PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

-- TABLE CONSTRAINT
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT PK_DEPT_TEST PRIMARY KEY (deptno, dname)
);

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon');

SELECT * FROM dept_test;
ROLLBACK;

-- NOT NULL
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES(1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(2, null, 'daejeon');

-- UNIQUE
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) UNIQUE,
    loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES(1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(2, 'ddit', 'daejeon');