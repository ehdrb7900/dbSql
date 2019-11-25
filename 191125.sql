-- member ���̺��� �̿��Ͽ� member2 ���̺��� ����
-- member2 ���̺��� ������ ȸ��(mem_id = 'a001')�� ����(mem_job)��
-- '����'���� ���� �� commit�ϰ� ��ȸ

CREATE TABLE member2 AS
SELECT *
FROM member;

UPDATE member2 SET mem_job = '����'
WHERE mem_id = 'a001';

commit;

SELECT mem_id, mem_name, mem_job
FROM member2
WHERE mem_id = 'a001';


-- ��ǰ�� ��ǰ ���� ����(BUY_QTY) �հ�, ��ǰ ����(BUY_COST) �ݾ� �հ�
-- ��ǰ�ڵ�, ��ǰ��, �����հ�, �ݾ��հ�

-- VW_PROD_BUY(view ����)

CREATE OR REPLACE VIEW vw_prod_buy AS
SELECT b.buy_prod, prod_name, SUM(buy_qty) sum_qty, SUM(buy_cost) sum_cost
FROM buyprod b, prod p 
WHERE b.buy_prod = p.prod_id
GROUP BY b.buy_prod, prod_name
ORDER BY b.buy_prod;

SELECT * 
FROM user_views;

-- �м��Լ� / window �Լ� (�����غ��� �ǽ� ana0)
-- ����� �μ��� �޿�(sal)�� ���� ���ϱ�
-- emp ���̺� ���
       
SELECT ename, sal, deptno, ROWNUM - (SELECT COUNT(*)
                                       FROM (SELECT ename, sal, deptno
                                              FROM emp
                                              ORDER BY deptno, sal DESC)
                                       WHERE deptno < e.deptno) sal_rank 
FROM (SELECT ename, sal, deptno
       FROM emp
       ORDER BY deptno, sal DESC) e;

--�μ��� ��ŷ
SELECT a.ename, a.sal, a.deptno, b.rn
FROM
    (SELECT a.ename, a.sal, a.deptno, ROWNUM j_rn
     FROM
    (SELECT ename, sal, deptno
     FROM emp
     ORDER BY deptno, sal DESC) a ) a, 
(SELECT b.rn, ROWNUM j_rn
FROM 
(SELECT a.deptno, b.rn 
 FROM
    (SELECT deptno, COUNT(*) cnt --3, 5, 6
     FROM emp
     GROUP BY deptno )a,
    (SELECT ROWNUM rn --1~14
     FROM emp) b
WHERE  a.cnt >= b.rn
ORDER BY a.deptno, b.rn ) b ) b
WHERE a.j_rn = b.j_rn;

SELECT ename, sal, deptno,
        ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rank
FROM emp;