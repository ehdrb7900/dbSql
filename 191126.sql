SELECT ename, sal, deptno, 
        RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) rank,
        DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) d_rank,
        ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rown
FROM emp;

-- �м��Լ� / window �Լ� (�ǽ� ana1)
-- ����� ��ü �޿� ������ rank, dense_rank, row_number�� �̿��Ͽ� ���ϼ���
-- ��, �޿��� ������ ��� ����� ���� ����� ���������� �ǵ��� �ۼ��ϼ���
SELECT empno, ename, sal, deptno,
        RANK() OVER (ORDER BY sal DESC, empno) sal_rank,
        DENSE_RANK() OVER (ORDER BY sal DESC, empno) sal_dense_rank,
        ROW_NUMBER() OVER (ORDER BY sal DESC, empno) sal_row_number
FROM emp;

-- �м��Լ� / window �Լ� (�ǽ� no_ana2)
-- ������ ��� ������ Ȱ���Ͽ� ��� ����� ���� �����ȣ, �̸�, �μ� ��ȣ
-- �ش� ����� ���� �μ��� ��� ���� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT empno, ename, e1.deptno, cnt
FROM emp e1, (SELECT deptno, COUNT(*) cnt
                FROM emp
                GROUP BY deptno) e2
WHERE e1.deptno = e2.deptno
ORDER BY deptno;

-- �м��Լ��� ���� �μ��� ���� �� ���ϱ�
SELECT empno, ename, deptno,
        COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

-- SUM �м��Լ�
SELECT empno, ename, deptno,
        SUM(sal) OVER (PARTITION BY deptno) sum_sal
FROM emp;

-- �м��Լ� / window �Լ� (�ǽ� ana2)
-- window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�,
-- ���� �޿�, �μ���ȣ�� �ش����� ���� �μ��� �޿� ����� ��ȸ�ϴ� ������ �ۼ��ϼ���
-- (�޿� ����� �Ҽ��� ��° �ڸ����� ���Ѵ�.)
SELECT empno, ename, sal, deptno,
        ROUND(AVG(sal) OVER (PARTITION BY deptno), 2) avg_sal
FROM emp;

-- �м��Լ� / window �Լ� (�ǽ� ana3)
-- window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�,
-- ���α޿�, �μ���ȣ�� �ش� ����� ���� �μ��� ���� ���� �޿��� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT empno, ename, sal, deptno,
        MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;

-- �м��Լ� / window �Լ� (�ǽ� ana4)
-- window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�,
-- ���α޿�, �μ���ȣ�� �ش� ����� ���� �μ��� ���� ���� �޿��� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT empno, ename, sal, deptno,
        MIN(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;

-- �м��Լ� / window �Լ� (�׷� �� �� ����)
-- �μ��� �����ȣ�� ���� ���� ���
SELECT empno, ename, deptno,
        FIRST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) f_emp
FROM emp;

-- �μ��� �����ȣ�� ���� ���� ���
SELECT empno, ename, deptno,
        LAST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno DESC
                                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) l_emp
FROM emp;

-- LAG (������)
-- ������
-- LEAD (������)
-- �޿��� ���������� �������� �� ���κ��� �Ѵܰ� �޿��� ���� ����� �޿�,
--                             ���κ��� �Ѵܰ� �޿��� ���� ����� �޿�
SELECT empno, ename, sal, LAG(sal) OVER (ORDER BY sal) lag_sal, 
                           LEAD(sal) OVER (ORDER BY sal) lead_sal
FROM emp;

-- �м��Լ� / window �Լ� (�׷쳻 �� ���� �ǽ� ana5)
-- window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�, �Ի�����
-- �޿�, ��ü ����� �޿� ������ �Ѵܰ� ���� ����� �޿��� ��ȸ�ϴ� ������ �ۼ��ϼ���.
-- (�޿��� ���� ��� �Ի����� ���� ����� ��������)
SELECT empno, ename, hiredate, sal, 
        LEAD(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp;

-- �м��Լ� / window �Լ� (�׷쳻 �� ���� �ǽ� ana6)
-- window function�� �̿��Ͽ� ��� ����� ���� �����ȣ, ����̸�, �Ի�����, ����(job)
-- �޿� ������ ������(JOB) �� �޿� ������ �Ѵܰ� ���� ����� �޿��� ��ȸ�ϴ� ������ �ۼ��ϼ���.
-- (�޿��� ���� ��� �Ի����� ���� ����� ��������)
SELECT empno, ename, hiredate, job, sal,
        LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) lag_sal
FROM emp;

-- �м��Լ� / window �Լ� (�׷쳻 �� ���� - �����غ���, �ǽ� no_ana3)
-- ��� ����� ���� �����ȣ, ����̸�, �Ի�����, �޿��� �޿��� ���������� ��ȸ�غ���
-- �ڽź��� �켱������ ���� ������ �ڽ��� �޿� ���� ���ο� �÷��� �־��
-- (�޿��� ������ ��� �����ȣ�� ��������� �켱������ ����)
-- (window �Լ� ����)
SELECT empno, ename, e1.sal, SUM(e2.sal) c_sum
FROM emp e1, (SELECT sal FROM emp ORDER BY sal) e2
WHERE e1.sal >= e2.sal
GROUP BY e1.empno, e1.ename, e1.sal
ORDER BY e1.sal, empno;

SELECT e1.empno, ename, e1.sal, SUM(e2.sal) c_sum
FROM (SELECT e.*, ROWNUM rn
        FROM (SELECT empno, ename, sal
               FROM emp
               ORDER BY sal)e ) e1, 
      (SELECT e.*, ROWNUM rn
               FROM (SELECT empno, sal
                      FROM emp
                      ORDER BY sal) e) e2
WHERE e1.rn >= e2.rn
GROUP BY e1.empno, ename, e1.sal
ORDER BY sal, empno;

-- WINDOWING
-- UNBOUNDED PRECEDING : ���� ���� �������� �����ϴ� ��� ��
-- CURRENT ROW : ���� ��
-- UNBOUNDED FOLLOWING : ���� ���� �������� �����ϴ� ��� ��
-- N(����) PRECEDING : ���� ���� �������� �����ϴ� N���� ��
-- N(����) FOLLOWING : ���� ���� �������� �����ϴ� N���� ��

SELECT empno, ename, sal,
        SUM(sal) OVER (ORDER BY sal, empno 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal,  
                                          -- AND CURRENT ROW ���� ����
        SUM(sal) OVER (ORDER BY sal, empno 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_sal2,
        
        SUM(sal) OVER (ORDER BY sal, empno 
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_sal3
FROM emp;

-- �м��Լ� / window �Լ� (�׷쳻 �� ���� �ǽ� ana7)
-- �����ȣ, ����̸�, �μ���ȣ, �޿� ������ �μ����� �޿�, �����ȣ ������������
-- �������� ��, �ڽ��� �޿��� �����ϴ� ������� �޿� ���� ��ȸ�ϴ�
-- ������ �ۼ��ϼ��� (window �Լ� ���)
SELECT empno, ename, deptno, sal, 
        SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno) c_sum
FROM emp;

SELECT empno, ename, deptno, sal,
        SUM(sal) OVER (ORDER BY sal 
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_sum,
        SUM(sal) OVER (ORDER BY sal 
                        ROWS UNBOUNDED PRECEDING) row_sum2,
        SUM(sal) OVER (ORDER BY sal 
                        RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) range_sum,
        SUM(sal) OVER (ORDER BY sal 
                        RANGE UNBOUNDED PRECEDING) range_sum2
FROM emp;