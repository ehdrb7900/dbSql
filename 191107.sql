-- emp ���̺��� �μ���ȣ(deptno)�� ����
-- emp ���̺��� �μ����� ��ȸ�ϱ� ���ؼ���
-- dept ���̺�� ������ ���� �μ��� ��ȸ

-- ���� ����
-- ANSI : ���̺� JOIN ���̺�2 ON (���̺�.COL = ���̺�2.COL)
--        emp JOIN dept ON (emp.deptno = dept.deptno)
-- ORACLE : FROM ���̺�, ���̺�2 WHERE ���̺�.col = ���̺�2.col
--          FROM emp, dept WHERE emp.deptno = dept.deptno

-- �����ȣ, �����, �μ���ȣ, �μ���
SELECT empno, ename, dept.deptno, dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

SELECT empno, ename, dept.deptno, dname
FROM emp, dept 
WHERE emp.deptno = dept.deptno;

-- ������ ���� �ǽ� join 0_2
-- emp,dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ��� (�޿��� 2500 �ʰ�)
-- ORACLE
SELECT empno, ename, sal, e.deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
   AND sal > 2500
ORDER BY deptno;

-- ANSI
SELECT empno, ename, sal, e.deptno, dname
FROM emp e JOIN dept d ON (e.deptno = d.deptno)
WHERE sal > 2500
ORDER BY deptno;

-- ������ ���� �ǽ� join 0_3
-- emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ��� (�޿� 2500 �ʰ�, ����� 7600���� ū ����)
SELECT empno, ename, sal, e.deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
   AND sal > 2500
   AND empno > 7600
ORDER BY deptno;

-- ANSI
SELECT empno, ename, sal, e.deptno, dname
FROM emp e JOIN dept d ON (e.deptno = d.deptno)
WHERE sal > 2500
   AND empno > 7600
ORDER BY deptno;

-- ������ ���� �ǽ� join 0_4
-- emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���
-- (�޿� 2500 �ʰ�, ����� 7600���� ũ�� �μ����� RESEARCH�� �μ��� ���� ����)
SELECT empno, ename, sal, d.deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
  AND sal > 2500
  AND empno > 7600
  AND dname = 'RESEARCH'
ORDER BY empno DESC;

-- ������ ���� base_tables.sql �ǽ� join 1
-- erd ���̾�׷��� �����Ͽ� prod ���̺�� lprod ���̺��� �����Ͽ�
-- ������ ���� ����� ������ ������ �ۼ��غ�����
SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM prod, lprod
WHERE prod.prod_lgu = lprod.lprod_gu
ORDER BY prod_id;

-- ������ ���� �ǽ� join 2
-- erd ���̾�׷��� �����Ͽ� buyer, prod ���̺��� �����Ͽ� buyter�� ����ϴ���ǰ ������
-- ������ ���� ����� �������� ������ �ۼ��غ�����
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer b, prod p
WHERE b.buyer_id = p.prod_buyer
ORDER BY prod_id;

-- ������ ���� �ǽ� join 3
-- erd ���̾�׷��� �����Ͽ� member, cart, prod ���̺��� �����Ͽ� ȸ���� ��ٱ��Ͽ� ����
-- ��ǰ ������ ������ ���� ����� ������ ������ �ۼ��غ�����
-- ORACLE
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member m, cart c, prod p
WHERE m.mem_id = c.cart_member
  AND c.cart_prod = p.prod_id;
  
-- ANSI
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member m JOIN cart c ON (m.mem_id = c.cart_member)
                JOIN prod p ON (c.cart_prod = p.prod_id);
                
-- ������ ���� �ǽ� join 4
-- erd ���̾�׷��� �����Ͽ� customer, cycle ���̺��� �����Ͽ�
-- ���� ���� ��ǰ, ��������, ������ ������ ���� ����� �������� ������ �ۼ��غ�����
-- (������ brown, sally�� ���� ��ȸ)
SELECT cus.cid, cnm, pid, day, cnt
FROM customer cus, cycle cy
WHERE cus.cid = cy.cid
  AND cnm in ('brown', 'sally');
  
-- ������ ���� �ǽ� join 5
-- erd ���̾�׷��� �����Ͽ� customer, cycle, product ���̺��� �����Ͽ�
-- ���� ���� ��ǰ, ��������, ����, ��ǰ���� ������ ���� ����� �������� ������ �ۼ��غ�����
-- (������ brown, sally�� ���� ��ȸ)
SELECT cus.cid, cnm, p.pid, pnm, day, cnt
FROM customer cus, cycle cy, product p
WHERE cus.cid = cy.cid
  AND cy.pid = p.pid
  AND cnm in ('brown', 'sally');
  
-- ������ ���� �ǽ� join 6
-- erd ���̾�׷��� �����Ͽ� customer, cycle, product ���̺��� �����Ͽ�
-- ���� ���ϰ� ������� ���� ���� ��ǰ��, ������ �հ�, ��ǰ���� ������ ���� ����� �������� ������ �ۼ��� ������
SELECT cus.cid, cnm, p.pid, pnm, cy.cnt
FROM customer cus, product p, (SELECT cid, pid, SUM(cnt) cnt
                                FROM cycle
                                GROUP BY cid, pid) cy
WHERE cus.cid = cy.cid
  AND cy.pid = p.pid;
  
  SELECT cid, pid, SUM(cnt) cnt
                                FROM cycle
                                GROUP BY cid, pid;
                                
SELECT * FROM CUSTOMER;
SELECT * FROM PRODUCT;
SELECT * FROM CYCLE ORDER BY CID, PID, DAY;

--------------------------------------------------------------------
SELECT cus.cid, cnm, p.pid, pnm, SUM(cnt) cnt
FROM cycle cy, customer cus, product p
WHERE cus.cid = cy.cid
  AND cy.pid = p.pid
GROUP BY cy.cid, cy.pid, cus.cid, cnm, p.pid, pnm
ORDER BY cid, pid;
--------------------------------------------------------------------
with cycle_groupby as (
    SELECT cid, pid, SUM(cnt) cnt
    FROM cycle
    GROUP BY cid, pid
)

SELECT cus.cid, cnm, p.pid, pnm, cy.cnt
FROM cycle_groupby cy, customer cus, product p
WHERE cus.cid = cy.cid
  AND cy.pid = p.pid;
  
-- ������ ���� �ǽ� join 7
-- erd ���̾�׷��� �����Ͽ� cycle, product ���̺��� �̿��Ͽ�
-- ��ǰ��, ������ �հ�, ��ǰ���� ������ ���� ����� �������� ������ �ۼ��غ�����

SELECT p.pid, pnm, cy.cnt
FROM product p, (SELECT pid, SUM(cnt) cnt
                                FROM cycle
                                GROUP BY pid) cy
WHERE cy.pid = p.pid;

SELECT p.pid, pnm, SUM(cnt) cnt
FROM cycle cy, product p
WHERE cy.pid = p.pid
GROUP BY p.pid, pnm;