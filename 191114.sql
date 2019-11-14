-- �������� Ȱ��ȭ / ��Ȱ��ȭ
-- � ���������� Ȱ��ȭ(��Ȱ��ȭ) ��ų ��� ??

-- emp FK ���� (dept ���̺��� deptno �÷� ����)
-- FK_EMP_DEPT ��Ȱ��ȭ
ALTER TABLE emp DISABLE CONSTRAINT pk_emp;

-- �������ǿ� ����Ǵ� �����Ͱ� �� �� ���� ������?
INSERT INTO emp (empno, ename, deptno)
VALUES (9999, 'brown', 80);

-- �������ǿ� ����Ǵ� ������ (�Ҽ� �μ���ȣ�� 80���� ������)�� �����Ͽ�
-- �������� Ȱ��ȭ �Ұ�
DELETE emp
WHERE empno = 9999;

-- FK_EMP_DEPT Ȱ��ȭ
ALTER TABLE emp ENABLE CONSTRAINT pk_emp;
COMMIT;

-- ���� ������ �����ϴ� ���̺� ��� VIEW : USER_TABLES
-- ���� ������ �����ϴ� �������� VIEW : USER_CONSTRAINTS
-- ���� ������ �����ϴ� ���������� �÷� VIEW : USER_CONS_COLUMNS
SELECT *
FROM user_constraints
WHERE table_name = 'CYCLE';

SELECT *
FROM USER_CONS_COLUMNS
WHERE constraint_name = 'PK_CYCLE';

-- ���̺� ������ �������� ��ȸ (view ����)
-- ���̺� �� / �������� �� / �÷��� / �÷� ������

SELECT a.table_name, a.constraint_name, b.column_name, b.position
FROM user_constraints a, user_cons_columns b
WHERE a.constraint_name = b.constraint_name
  AND a. constraint_type = 'P' -- PRIMARY KEY�� ��ȸ
ORDER BY a.table_name, b.position;

desc emp;

-- emp ���̺�� 8���� �÷� �ּ��ޱ�
-- ���̺� �ּ� view : user_tab_comments
SELECT *
FROM user_tab_comments
WHERE table_name = 'EMP';

-- emp ���̺� �ּ�
COMMENT ON TABLE emp IS '���';

-- emp ���̺��� �÷� �ּ�
SELECT *
FROM user_col_comments
WHERE table_name = 'EMP';

-- EMPNO ENAME JOB MGR HIREDATE SAL COMM DEPTNO  
COMMENT ON COLUMN emp.empno IS '�����ȣ';
COMMENT ON COLUMN emp.ename IS '�̸�';
COMMENT ON COLUMN emp.job IS '������';
COMMENT ON COLUMN emp.mgr IS '������ ���';
COMMENT ON COLUMN emp.hiredate IS '�Ի�����';
COMMENT ON COLUMN emp.sal IS '�޿�';
COMMENT ON COLUMN emp.comm IS '��';
COMMENT ON COLUMN emp.deptno IS '�ҼӺμ���ȣ';

-- DDL user_tab_comments, user_col_comments view�� �̿��Ͽ�
-- customer, product, cycle, daily ���̺�� �÷��� �ּ� ������ ��ȸ�ϴ� ������ ���
SELECT uc.table_name, table_type, ut.comments tab_comment, column_name, uc.comments col_comment
FROM user_col_comments uc, user_tab_comments ut
WHERE uc.table_name= ut.table_name
   AND uc.table_name IN ('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY');
   
-- VIEW ���� (emp ���̺��� sal, comm �� �� �÷� ����)
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

-- INLINE VIEW
SELECT *
FROM ( SELECT empno, ename, job, mgr, hiredate, deptno
        FROM emp );
        
-- VIEW (�� �ζ��κ�� �����ϴ�)
SELECT *
FROM v_emp;

-- ���ε� ���� ����� view�� ����
-- emp, dept : �μ���, �����ȣ, �����, ������, �Ի�����
CREATE OR REPLACE VIEW v_emp_dept AS 
SELECT d.dname, e.empno, e.ename, e.job, e.hiredate
FROM emp e, dept d
WHERE e.deptno = d.deptno;

SELECT * 
FROM v_emp_dept;

-- VIEW ����
DROP VIEW v_emp;

-- VIEW�� �����ϴ� ���̺��� �����͸� �����ϸ� VIEW���� ������ ����
-- dept 30 - SALES
SELECT *
FROM v_emp_dept;

-- dept ���̺��� SALES --> MARKET SALES
UPDATE dept SET dname = 'SALES'
WHERE deptno = 30;
ROLLBACK;

-- HR �������� v_emp_dept view ��ȸ������ �ش�
GRANT SELECT ON v_emp_dept TO hr;

-- SEQUENCE ���� (�Խñ� ��ȣ �ο��� ������)
CREATE SEQUENCE seq_post
INCREMENT BY 1
START WITH 1;

-- �Խñ�
SELECT seq_post.nextval, seq_post.currval
FROM dual;

-- �Խñ� ÷������
SELECT seq_post.currval
FROM dual;

SELECT *
FROM post
WHERE reg_id = 'brown'
AND title = '�������� ����ִ�'
AND reg_dt = TO_DATE ('2019/11/14 15:40:15', 'YYYY/MM/DD HH24:MI:SS');

SELECT *
FROM post
WHERE post_id = 1;

-- index
-- rowid : ���̺� ���� ������ �ּ�, �ش� �ּҸ� �˸� ������ ���̺�
--          �����ϴ� ���� �����ϴ�
SELECT product.*, ROWID
FROM product
WHERE ROWID = 'AAAFMCAAFAAAAFNAAA';