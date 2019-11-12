-- SMITH, WARD�� ���ϴ� �μ��� ������ ��ȸ
SELECT *
FROM emp
WHERE deptno IN (20, 30);

SELECT *
FROM emp
WHERE deptno = 20
    OR deptno = 30;
    
SELECT *
FROM emp
WHERE deptno IN (  SELECT deptno
                    FROM emp
                    WHERE ename IN ('SMITH', 'WARD'));
                    
SELECT *
FROM emp
WHERE deptno IN (  SELECT deptno
                    FROM emp
                    WHERE ename IN (:name1, :name2));
                    
-- ANY : SET �߿� �����ϴ°� �ϳ��� ������ ������ (ũ���)
-- SMITH �Ǵ� WARD ���� ���� �޿��� �޴� ���� ���� ��ȸ

SELECT *
FROM emp
WHERE sal < ANY(  SELECT sal
                    FROM emp
                    WHERE ename IN ('SMITH', 'WARD'));
                    
-- SMITH�� WARD���� �޿��� ���� ���� ��ȸ
-- SMITH���ٵ� �޿��� ���� WARD���ٵ� �޿��� �������(AND)
SELECT *
FROM emp
WHERE sal > ALL(  SELECT sal
                    FROM emp
                    WHERE ename IN ('SMITH', 'WARD'));

SELECT *
FROM emp
WHERE sal < ANY(  SELECT sal
                    FROM emp
                    WHERE ename IN ('SMITH', 'WARD'));
                    
-- NOT IN

-- ������ ��������
SELECT DISTINCT mgr
FROM emp;

-- � ������ ������ ������ �ϴ� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE empno IN (7839, 7782, 7698, 7902, 7566, 7788);

SELECT *
FROM emp
WHERE empno IN (   SELECT mgr 
                    FROM emp);
                    
-- � ������ �����ڰ� �ƴ� �������� ���� ��ȸ
-- ��, NOT IN ������ ���� SET�� NULL�� ���Ե� ��� ���������� �������� �ʴ´�.
-- NULLó�� �Լ��� WHERE���� ���� NULL���� ó���� ���� ���
SELECT *
FROM emp
WHERE empno NOT IN (7839, 7782, 7698, 7902, 7566, 7788);

SELECT *
FROM emp        -- empno�� 7839, 7782, 7698, 7902, 7566, 7788�� ���Ե��� �ʴ� ��� ��ȸ
WHERE empno NOT IN (SELECT mgr 
                      FROM emp
                      WHERE mgr IS NOT NULL);
                      
-- pair wise
-- ��� 7499, 7782�� ������ ������, �μ���ȣ ��ȸ
-- 7698     30
-- 7839     10
-- �����߿� �����ڿ� �μ���ȣ�� (7698, 30)�̰ų�, (7839, 10)�� ���
-- mgr, deptno �÷��� [����]�� ������Ű�� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                         FROM emp
                         WHERE empno IN (7499, 7782));

SELECT *
FROM emp
WHERE mgr = (SELECT mgr
              FROM emp
              WHERE empno = 7499)
AND deptno = (SELECT deptno
               FROM emp
               WHERE empno = 7499)
OR mgr = (SELECT mgr
              FROM emp
              WHERE empno = 7782)
AND deptno = (SELECT deptno
               FROM emp
               WHERE empno = 7782);
-- �����߿� �����ڿ� �μ���ȣ�� (7698, 30), (7698, 10), (7839,30), (7839,10)�� ���
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
                         FROM emp
                         WHERE empno IN (7499, 7782))
AND deptno IN ( SELECT deptno
                         FROM emp
                         WHERE empno IN (7499, 7782));                     

SELECT *
FROM emp
WHERE mgr = (SELECT mgr
              FROM emp
              WHERE empno = 7499)
AND (deptno = (SELECT deptno
               FROM emp
               WHERE empno = 7499)
     OR deptno = (SELECT deptno
                  FROM emp
                  WHERE empno = 7782))
OR mgr = (SELECT mgr
              FROM emp
              WHERE empno = 7782)
AND deptno = (SELECT deptno
               FROM emp
               WHERE empno = 7782)
    OR deptno = (SELECT deptno
                 FROM emp
                 WHERE empno = 7499);
               
-- SCALAR SUBQUERY : SELECT���� �����ϴ� ���� ����(��, ���� �ϳ��� ��, �ϳ��� �÷�)
-- ������ �Ҽ� �μ����� JOIN�� ������� �ʰ� ��ȸ
SELECT empno, ename, deptno, (SELECT dname
                               FROM dept
                               WHERE deptno = emp.deptno) dname -- => 15�� ����
FROM emp;

SELECT dname
FROM dept
WHERE deptno = 20;

-- sub4 ������ ����
INSERT INTO dept VALUES(99, 'ddit','daejeon');
COMMIT;

SELECT *
FROM emp
ORDER BY deptno;

-- �������� �ǽ� sub4
-- dept ���̺��� �ű� ��ϵ� 99�� �μ��� ���� ����� ����
-- ������ ������ ���� �μ��� ��ȸ�ϴ� ������ �ۼ��غ�����
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                       FROM emp
                       WHERE deptno IS NOT NULL);
        
-- �������� �ǽ� sub5
-- cycle, product ���̺��� �̿��Ͽ� cid = 1�� ���� �������� �ʴ�
-- ��ǰ�� ��ȸ�ϴ� ������ �ۼ��ϼ���
SELECT *
FROM product
WHERE pid NOT IN (SELECT pid
                    FROM cycle
                    WHERE cid = 1
                      AND pid IS NOT NULL);

-- �������� �ǽ� sub 6
SELECT *
FROM cycle
WHERE pid IN (SELECT pid
                FROM cycle
                WHERE cid = 2)
   AND cid = 1;
   
-- �������� �ǽ� sub 7
SELECT 1, cnm, pid, (SELECT pnm FROM product WHERE pid = cycle.pid) pnm, day, cnt
FROM cycle, customer
WHERE pid IN (SELECT pid
                FROM cycle
                WHERE cid = 2)
  AND cycle.cid = 1
  AND cycle.cid = customer.cid;

SELECT 1, cnm, c.pid, p.pnm, day, cnt
FROM cycle c, product p, customer
WHERE c.pid IN ( SELECT pid
                FROM cycle
                WHERE cid = 2)
  AND c.pid = p.pid
  AND c.cid = 1
  AND customer.cid = c.cid;

-- EXISTS MAIN ������ �÷��� ����ؼ� SUBQUERY�� �����ϴ� ������ �ִ��� üũ
-- �����ϴ� ���� �ϳ��� �����ϸ� ���̻� �������� �ʰ� ���߱� ������
-- ���ɸ鿡�� ����

-- MGR�� �����ϴ� ���� ��ȸ
SELECT *
FROM emp a
WHERE EXISTS (SELECT 1 
                FROM emp 
                WHERE empno = a.mgr);
                
SELECT *
FROM emp
WHERE mgr IS NOT NULL;
                
-- MGR�� �����ϴ� ���� ��ȸ
SELECT *
FROM emp a
WHERE NOT EXISTS (SELECT 1
                FROM emp 
                WHERE empno = a.mgr);
                
SELECT *
FROM emp
WHERE mgr IS NULL;

-- �������� �ǽ� sub8
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- �μ��� �Ҽӵ� ������ �ִ� �μ� ���� ��ȸ
SELECT *
FROM dept d
WHERE EXISTS (SELECT 1 FROM emp WHERE deptno = d.deptno)
ORDER BY deptno;

SELECT *
FROM dept
WHERE deptno IN (10, 20, 30);

-- �������� �ǽ� sub9
-- customer, product ���̺��� �̿��Ͽ� cid = 1�� ���� �������� �ʴ�
-- ��ǰ�� ��ȸ�ϴ� ������ EXISTS �����ڸ� �̿��Ͽ� �ۼ��ϼ���
SELECT *
FROM product
WHERE NOT EXISTS (SELECT 1 FROM cycle WHERE cid = 1 AND product.pid = pid);

SELECT *
FROM cycle;

-- ���տ���
-- UNION : ������, �ߺ��� ����
--         DBMS������ �ߺ��� �����ϱ����� �����͸� ���� 
--         (�뷮�� �����Ϳ� ���� ���Ľ� ����)
-- UNION ALL : UNION�� ��������
--             �ߺ��� �������� �ʰ�, �� �Ʒ� ������ ���� => �ߺ�����
--             �� �Ʒ� ���տ� �ߺ��Ǵ� �����Ͱ� ���ٴ� ���� Ȯ���ϸ�
--             UNION �����ں��� ���ɸ鿡�� ����
-- ����� 7566 �Ǵ� 7698�� ��� ��ȸ (���, �̸�)

-- UNION
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION

-- ����� 7369 �Ǵ� 7499�� ��� ��ȸ (���, �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7369 OR empno = 7499;
--------------------------------------------------------------
-- UNION ALL
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION ALL

-- ����� 7369 �Ǵ� 7499�� ��� ��ȸ (���, �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7369 OR empno = 7499;

-- INTERSECT(������ : �� �Ʒ� ���հ� ���뵥����)
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7499);

-- MINUS (������ : �� ���տ��� �Ʒ� ������ ����)
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7499);
-----------------------------------------------
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7499)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369);


SELECT 1 n, 'x' m
FROM dual
UNION
select 2, 'y' -- Ÿ�Կ� ���� �÷� ���� ����
FROM dual
ORDER BY m desc;
 