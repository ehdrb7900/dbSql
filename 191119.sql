--�ܹ��� ���� ����
--�������� ����

--����ŷ, �Ƶ�����, kfc����

SELECT gb, sido, sigungu
FROM fastfood
WHERE sido = '����������'
AND gb IN ('����ŷ', '�Ƶ�����', 'KFX')
ORDER BY SIDO, SIGUNGU, GB;

--�Ե�����
SELECT gb, sido, sigungu
FROM fastfood
WHERE sido = '����������'
AND gb IN ('�Ե�����')
ORDER BY SIDO, SIGUNGU, GB;

--���� ���� ���������� '����������' ����(��������)
SELECT a.sido, a.sigungu, a.cnt, b.cnt, round(a.cnt/b.cnt,2) point
FROM
(SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE gb IN ('����ŷ', '�Ƶ�����', 'KFC')
GROUP BY SIDO, SIGUNGU )a
,
(SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE gb IN ('�Ե�����')
GROUP BY SIDO, SIGUNGU) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY point DESC;

SELECT sido, sigungu, sal
FROM TAX
ORDER BY sal desc;
--ORDER BY point desc;

--�������� �õ�, �ñ��� | �������� �õ�, �ñ���
--�õ� �ñ���, ��������, �õ�, �ñ���, �������� ���Ծ�
-- ���� �ೢ�� ����


--ORDER BY ���� SELECT�� ���Ŀ� ����ȴ�
--�׷��� ROWNUM�� ������ �ٽ� �ζ��κ信 ���̸� ���ϴ� ���� ������ ����.
--SELECT rownum ,a.sido, a.sigungu, a.point,b.sido, b.sigungu, b.sal
SELECT cc.rank_cc, cc.sido, cc.sigungu, cc.point, dd.*
FROM
    (SELECT rownum rank_cc, c.*
    FROM
        (SELECT  a.sido, a.sigungu,  round(a.cnt/b.cnt,2) point
        FROM
        (SELECT sido, sigungu, COUNT(*) cnt
        FROM fastfood
        WHERE gb IN ('����ŷ', '�Ƶ�����', 'KFC')
        GROUP BY SIDO, SIGUNGU )a
        ,
        (SELECT  sido, sigungu, COUNT(*) cnt
        FROM fastfood
        WHERE gb IN ('�Ե�����')
        GROUP BY SIDO, SIGUNGU) b
        WHERE a.sido = b.sido
        AND a.sigungu = b.sigungu
        ORDER BY point DESC)c )cc
,
    (SELECT rownum rank_dd, d.*
    FROM
        (SELECT  sido, sigungu, sal
        FROM TAX
        ORDER BY sal desc) d) dd
WHERE cc.rank_cc = dd.rank_dd;

-- ���ù������� ���� ������ Ǯ��!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
SELECT a.*, b.*
FROM 
    (SELECT a.*, ROWNUM RN 
     FROM
        (SELECT a.sido, a.sigungu, a.cnt kmb, b.cnt l,
               round(a.cnt/b.cnt, 2) point
        FROM 
            --140��
            (SELECT SIDO, SIGUNGU, COUNT(*) cnt
            FROM fastfood
            WHERE gb IN ('KFC', '����ŷ', '�Ƶ�����')
            GROUP BY SIDO, SIGUNGU) a,
            
            --188��
            (SELECT SIDO, SIGUNGU, COUNT(*) cnt
            FROM fastfood
            WHERE gb IN ('�Ե�����')
            GROUP BY SIDO, SIGUNGU) b
            WHERE a.sido = b.sido
            AND a.sigungu = b.sigungu
        ORDER BY point DESC )a ) a,
    
    (SELECT b.*, rownum rn
    FROM 
    (SELECT sido, sigungu
    FROM TAX
    ORDER BY sal DESC) b ) b
WHERE b.rn = a.rn(+)
ORDER BY b.rn;

---------------------------------------

--emp_test ���̺� ����
drop table emp_test;

--multiple insert�� ���� �׽�Ʈ ���̺� ����
--empno, ename �ΰ��� �÷��� ���� emp_test, emptest2 ���̺���
--emp ���̺�� ���� �����Ѵ�. (CTAS)
--�����ʹ� �������� �ʴ´�.

CREATE TABLE emp_test AS;
CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp
WHERE 1=2;

--INSERT ALL
--�ϳ��� INSERT SQL �������� ��� ���̺� �����͸� �Է�
INSERT ALL
    INTO emp_test
    INTO emp_test2
SELECT 1, 'brown' FROM dual UNION ALL
SELECT 2, 'sally' FROM dual;

--INSERT ������ Ȯ��
SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;

--INSERT ALL �÷� ����
ROLLBACK;

INSERT ALL
    INTO emp_test (empno) VALUES (empno)
    INTO emp_test2 VALUES (empno,ename)
SELECT 1 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;


SELECT *
FROM emp_test;

SELECT *
FROM emp_test2; 

--multiple insert (conditional insert)
ROLLBACK;
INSERT ALL
    WHEN empno < 10 THEN
        INTO emp_test (empno) VALUES (empno)
    ELSE    --������ ������� ���� ���� ����
      INTO emp_test2 VALUES (empno,ename)
SELECT 20 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;

SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;

--INSERT FIRST
--���ǿ� �����ϴ� ù��° INSERT ������ ����
ROLLBACK;
INSERT FIRST
    WHEN empno > 10 THEN
        INTO emp_test (empno) VALUES (empno)
    WHEN empno > 5 THEN    
      INTO emp_test2 VALUES (empno,ename)
SELECT 20 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;

SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;

--MERGE : ���ǿ� �����ϴ� �����Ͱ� ������ UPDATE
--        ���ǿ� �����ϴ� �����Ͱ� ������ INSERT
--empno�� 7369�� �����͸� emp ���̺�� ���� emp_test���̺� ����(insert)
INSERT INTO emp_test 
SELECT empno, ename
FROM emp
WHERE empno = 7369;

select *
from emp_test;
delete emp_test where empno=7369;
--emp���̺��� �������� emp_test ���̺��� empno�� ���� ���� ���� �����Ͱ� �������
-- emp_test.ename = ename || '_merge' ������ update
-- �����Ͱ� ���� ��쿡�� emp_test���̺� insert
ALTER TABLE emp_test MODIFY (ename VARCHAR2(20)); --���̺� ename�÷� ũ�� ��ȯ

MERGE INTO emp_test
USING emp
 ON (emp.empno = emp_test.empno)
WHEN MATCHED THEN
    UPDATE SET ename = emp.ename || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES (emp.empno, emp.ename);

rollback; 
--�ٸ� ���̺��� ������ �ʰ� ���̺� ��ü�� ������ ���� ������
--merge �ϴ� ���

-- empno = 1, ename = 'brown'
-- empno�� ���� ���� ������ ename�� 'brown'���� update
-- empno�� ���� ���� ������ �ű� insert

MERGE INTO emp_test
USING dual
  ON ( emp_test.empno = 1)
WHEN MATCHED THEN
    UPDATE SET ename = ' brown' || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES (1,'brown');
------------------------------------------------
--���� Ŀ������ ������� ������ �Ʒ� 3���� ���������� �ؾ��Ѵ�.
select 'X'
from emp_test
where empno=1;

update emp_test set ename = 'brown' || '_merge'
where empno = 1;

insert into emp_test values(1, 'brown');
--------------------------------------------------
select * 
from emp_test;

--�ǽ� GROUP_AD1
-- �׷캰 �հ�, ��ü �հ踦 ������ ���� ���Ϸ���??
--  table : emp;
-- ���Ʒ� �ΰ��� ������ ��ġ���� �����Լ�(UNION ALL)
-- �μ��� �޿� ��
SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno 

union all --�ΰ��� ������ ��ħ
--��� ������ �޿���
SELECT null, SUM(sal)
FROM emp;

--�� ������ ROLLUP���·� ����    (ROLLUP sql_d �ܰ���)
SELECT deptno, sum(sal) sal
FROM emp
GROUP BY ROLLUP(deptno);


--rollup
-- group by�� ���� �׷��� ����
-- GROUP BY ROLLUP( {col,} )
-- �÷��� �����ʿ��� ���� �����ذ��鼭 ���� ����׷���
-- GROUP BY �Ͽ� UNION �� �Ͱ� ����
-- ex : GROUP BY ROLLUP (job, deptno)
--      GROUP BY job, deptno
--      UNION
--      GROUP BY job
--      UNION
--      GROUP BY --> �Ѱ� (��� �࿡ ���� �׷��Լ� ����)
SELECT job, deptno, sum(sal) sal
FROM emp
GROUP BY ROLLUP(job,deptno);


--GROUPING SETS (col1, col2...)
--GROUPING SETS�� ������ �׸��� �ϳ��� ����׷����� GROUP BY ���� �̿�ȴ�.

--GROUP BY col1
--UNON ALL
--GROUP BY col2
-- �� ������ ������.

--emp ���̺��� �̿��Ͽ� �μ���  �޿��հ�, ������(job)�� �޿����� ���Ͻÿ�.

--�μ���ȣ, job, �޿��հ�
SELECT deptno, null job,SUM(sal)
FROM emp
GROUP BY deptno

UNION ALL

SELECT null, job, SUM(sal)
FROM emp
GROUP BY job;

--���� ������ GROUPING SETS ���·� ��ȯ
SELECT deptno, job, SUM(sal)
FROM emp
GROUP BY GROUPING SETS(deptno, job, (deptno, job));