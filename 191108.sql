-- ���� ����
-- ���� �� ??
-- RDBMS�� Ư���� ������ �ߺ��� �ִ� ������ ���踦 �Ѵ�.
-- EMP ���̺��� ������ ������ ����, �ش� ������ �Ҽ� �μ�������
--  �μ���ȣ�� �����ְ�, �μ���ȣ�� ���� dept ���̺�� ������ ����
--  �ش� �μ��� ������ ������ �� �ִ�.

-- ���� ��ȣ, ���� �̸�, ������ �Ҽ� �μ���ȣ, �μ��̸�
-- emp, dept
SELECT emp.empno, emp.ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- �μ���ȣ, �μ���, �ش�μ��� �ο���
-- count(col) : col���� �����ϸ� 1, null : 0
--              ����� �ñ��� ���̸� *
SELECT e.deptno, d.dname, count(dname) cnt
FROM emp e, (SELECT deptno, dname 
              FROM dept) d
WHERE e.deptno = d.deptno
GROUP BY e.deptno, d.dname;

-- TOTAL ROW : 14
SELECT COUNT(*), COUNT(EMPNO), COUNT(MGR), COUNT(COMM)
FROM emp;

select * from emp;

SELECT a.empno, a.ename, a.mgr, e2.ename mgr_name
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno);

-- OUTER JOIN : ���ο� ���е� ������ �Ǵ� ���̺��� �����ʹ� ��ȸ����� 
--              �������� �ϴ� ���� ����
-- LEFT OUTER JOIN : JOIN KEYWORD ���ʿ� ��ġ�� ���̺��� ��ȸ ������
--                   �ǵ��� �ϴ� ���� ����
-- RIGHT OUTER JOIN : JOIN KEYWORD ���ʿ� ��ġ�� ���̺��� ��ȸ ������
--                   �ǵ��� �ϴ� ���� ����
-- FULL OUTER JOIN : LEFT OUTER JOIN + RIGHT OUTER JOIN - �ߺ� ������

-- ���� ������, �ش� ������ ������ ���� OUTER JOIN
-- ���� ��ȣ, ���� �̸�, ������ ��ȣ, ������ �̸�
SELECT a.empno, a.ename, a.mgr, b.ename mgr_name
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno);

-- oracle outer join (left, right�� ���� fullouter�� �������� ����)
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+);

-- ANSI LEFT OUTER
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr = b.empno AND b.deptno = 10);
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr = b.empno)
WHERE b.deptno = 10;

select * from emp where deptno = 10;

-- oracle outer ���������� outer ���̺��� �Ǵ� ��� �÷��� (+)�� �ٿ����
-- outer join�� ���������� �����Ѵ�.
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno (+)
   AND b.deptno (+)= 10;

SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno (+);

-- ANSI RIGHT OUTER
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a RIGHT OUTER JOIN emp b ON (a.mgr = b.empno);

-- ������ ���� outer join �ǽ� outerjoin 1
-- buyprod ���̺� �������ڰ� 2005�� 1�� 25���� �����ʹ� 3ǰ��ۿ� ����.
-- ��� ǰ���� ���� �� �ֵ��� ������ �ۼ��غ�����
-- ANSI
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM prod p LEFT OUTER JOIN buyprod b ON (b.buy_prod =  p.prod_id 
                                                AND b.buy_date = TO_DATE('050125','YYMMDD'));
                                                
-- ORACLE
SELECT TO_DATE('050125', 'YYMMDD') buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM prod p ,buyprod b
WHERE b.buy_prod(+) =  p.prod_id 
  AND b.buy_date(+) = TO_DATE('050125','YYMMDD');

-- ������ ���� outer join �ǽ� outerjoin 2
-- outerjoin 1���� �۾��� �����ϼ���. buy_date �÷��� null�� �׸��� �ȳ������� 
-- ����ó�� �����͸� ä�������� ������ �ۼ��ϼ���.
-- ANSI
SELECT TO_DATE('050125','YYMMDD') buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM prod p LEFT OUTER JOIN buyprod b ON (b.buy_prod =  p.prod_id 
                                                AND b.buy_date = TO_DATE('050125','YYMMDD'));
                                                
-- ORACLE
SELECT TO_DATE('050125', 'YYMMDD') buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM prod p ,buyprod b
WHERE b.buy_prod(+) =  p.prod_id 
  AND b.buy_date(+) = TO_DATE('050125','YYMMDD');
  
-- ������ ���� outer join �ǽ� outerjoin 3
-- outerjoin 2���� �۾��� �����ϼ���. buy_qty �÷��� null�� ��� 0���� ���̵��� 
-- ������ �����ϼ���.
-- ANSI
SELECT TO_DATE('050125','YYMMDD') buy_date, buy_prod, prod_id, prod_name, nvl(buy_qty, 0) buy_qty
FROM prod p LEFT OUTER JOIN buyprod b ON (b.buy_prod =  p.prod_id 
                                                AND b.buy_date = TO_DATE('050125','YYMMDD'));
                                                
-- ORACLE
SELECT TO_DATE('050125', 'YYMMDD') buy_date, buy_prod, prod_id, prod_name, nvl(buy_qty, 0) buy_qty
FROM prod p ,buyprod b
WHERE b.buy_prod(+) =  p.prod_id 
  AND b.buy_date(+) = TO_DATE('050125','YYMMDD');

-- ������ ���� outer join �ǽ� outerjoin 4
-- cycle, product ���̺��� �̿��Ͽ� ���� �����ϴ� ��ǰ ��Ī�� ǥ���ϰ�,
-- �������� �ʴ� ��ǰ�� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���
-- (���� cid=1�� ���� �������� ����, null ó��)
-- ANSI
SELECT p.pid, pnm, '1' cid, nvl(day ,0) day, nvl(cnt, 0) cnt
FROM product p LEFT OUTER JOIN cycle c ON(c.pid = p.pid AND cid = 1);

-- ORACLE
SELECT p.pid, pnm, '1' cid, nvl(day ,0) day, nvl(cnt, 0) cnt
FROM product p ,cycle c 
WHERE c.pid (+) = p.pid 
   AND cid (+) = 1;
   
-- ������ ���� outer join �ǽ� outerjoin 5
-- cycle, product ���̺��� �̿��Ͽ� ���� �����ϴ� ��ǰ ��Ī�� ǥ���ϰ�,
-- �������� �ʴ� ��ǰ�� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���
-- (���� cid=1�� ���� �������� ����, null ó��)
-- ANSI
SELECT pc.pid , pnm, pc.cid, c.cnm, pc.day, pc.cnt
FROM customer c ,(SELECT p.pid, pnm, '1' cid, nvl(day ,0) day, nvl(cnt, 0) cnt
FROM product p LEFT OUTER JOIN cycle c ON(c.pid = p.pid AND cid = 1)) pc
WHERE c.cid = pc.cid
ORDER BY pid DESC, day DESC;

-- ORACLE
SELECT pc.pid , pnm, pc.cid, c.cnm, pc.day, pc.cnt
FROM customer c ,(SELECT p.pid, pnm, '1' cid, nvl(day ,0) day, nvl(cnt, 0) cnt
                FROM product p ,cycle c 
                WHERE c.pid (+) = p.pid 
                   AND cid (+) = 1) pc
WHERE c.cid = pc.cid
ORDER BY pid DESC, day DESC;

-- ������ ���� cross join �ǽ� crossjoin 1
-- customer, product ���̺��� �̿��Ͽ� ���� ���� ������ ��� ��ǰ�� ������ �����Ͽ� 
-- ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���
-- ANSI
SELECT cid, cnm, pid, pnm
FROM customer CROSS JOIN product;

-- ORACLE
SELECT cid, cnm, pid, pnm
FROM customer, product;

-- subquery : main������ ���ϴ� �κ� ����
-- ���Ǵ� ��ġ :
-- SELECT - scalar subquery (�ϳ��� ���, �ϳ��� �÷��� ��ȸ�Ǵ� �����̾�� �Ѵ�)
-- FROM - inline view
-- WHERE - subquery

-- SCALAR subquery
SELECT empno, ename, SYSDATE now /*���糯¥*/
FROM emp;

SELECT empno, ename, (SELECT SYSDATE FROM dual) now
FROM emp;

-- SMITH�� ���� �μ��� ���� ������
SELECT *
FROM emp
WHERE deptno = ( SELECT deptno
                  FROM emp
                  WHERE ename = 'SMITH');

-- �������� �ǽ� sub 1
-- ��� �޿����� ���� �޿��� �޴� ������ ���� ��ȸ�ϼ���
SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT AVG(sal) 
              FROM emp);
              
-- �������� �ǽ� sub 2
-- ��� �޿����� ���� �޿��� �޴� ������ ������ ��ȸ�ϼ���
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal) 
              FROM emp);
              
-- �������� �ǽ� sub 3
--SMITH�� WARD ����� ���� �μ��� ��� ��� ������ ��ȸ�ϴ� ������ ������ ���� �ۼ��ϼ���
SELECT *
FROM emp
WHERE deptno in (SELECT deptno 
                  FROM emp 
                  WHERE ename in('SMITH','WARD'))
ORDER BY deptno, empno DESC;