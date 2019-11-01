-- ����
-- WHERE
-- ������
-- �� : =, !=, <>, >=, >, <=, <
-- BETWEEN start AND end
-- IN (set)
-- LIKE 'S%' ( % : �ټ��� ���ڿ��� ��Ī, _ : ��Ȯ�� �ѱ��� ��Ī)
-- IS NULL ( != NULL )
-- AND, OR, NOT

-- emp ���̺��� �Ի����ڰ� 1981�� 6�� 1�Ϻ��� 1986�� 12�� 31�� ���̿� �ִ�
-- ���� ������ȸ
-- BETWEEN AND
SELECT *
FROM emp
WHERE hiredate BETWEEN TO_DATE('19810601', 'YYYYMMDD')
                   AND TO_DATE('19861231', 'YYYYMMDD');
-- >=, <=
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('19810601', 'YYYYMMDD')
  AND hiredate <= TO_DATE('19861231', 'YYYYMMDD');
  
-- emp ���̺��� ������(mgr)�� �ִ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- where 12 
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE '78%';
   
-- where 13
-- empno�� ���� 4�ڸ����� ���
-- empno : 78, 780, 789
-- emp ���̺��� job�� 'SALESMAN'�̰ų� �����ȣ�� 78�� �����ϴ� ������ ������ ������ ���� ��ȸ�ϼ���.
-- (like �����ڸ� ������� ������)
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno BETWEEN 7800 AND 7899;
   
-- where 14
-- emp ���̺��� job�� 'SALESMAN'�̰ų� �����ȣ�� 78�� �����ϸ鼭
-- �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ�ϼ���.
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE '78%'
  AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

-- order by �÷��� | ��Ī | �÷��ε��� [ASC | DESC]
-- order by ������ WHERE�� ������ ���
-- WHERE���� ���� ��� FROM�� ������ ���
-- ename �������� �������� ����
SELECT *
FROM emp
ORDER BY ename ASC;

-- ASC : default
-- ASC�� �Ⱥٿ��� �� ������ ������
SELECT *
FROM emp
ORDER BY ename;

-- �̸�(ename)�� �������� ��������
SELECT *
FROM emp
ORDER BY ename DESC;

-- job�� �������� ������������ ����, job�� �������
-- ���(empno)���� �������� ����
SELECT *
FROM emp
ORDER BY job DESC, empno;

-- ��Ī���� �����ϱ�
-- ��� ��ȣ(empno), �����(ename), ����(sal * 12) as year_sal
SELECT empno, ename, sal, sal*12 year_sal
FROM emp
ORDER BY year_sal;

-- orderby 1
-- dept ���̺��� ��� ������ �μ��̸����� �������� ���ķ� ��ȸ�ǵ��� ������ �ۼ��ϼ���
SELECT *
FROM dept
ORDER BY dname;

-- dept ���̺��� ��� ������ �μ���ġ�� �������� ���ķ� ��ȸ�ǵ��� ������ �ۼ��ϼ���
SELECT *
FROM dept
ORDER BY loc DESC;

-- orderby 2
-- emp ���̺��� ��(comm) ������ �ִ� ����鸸 ��ȸ�ϰ�, ��(comm)�� ���� �޴� �����
-- ���� ��ȸ�ǵ��� �ϰ�, �󿩰� ���� ��� ������� �������� �����ϼ���
SELECT *
FROM emp
WHERE comm IS NOT NULL
ORDER BY comm DESC, empno;

-- orderby 3
-- emp ���̺��� �����ڰ� �մ� ����鸸 ��ȸ�ϰ�, ����(job) ������ �������� �����ϰ�, 
-- ������ ���� ��� ����� ū ����� ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;

-- orderby 4
-- emp ���̺��� 10�� �μ�(deptno) Ȥ�� 30�� �μ��� ���ϴ� ��� ��
-- �޿�(sal)�� 1500�� �Ѵ� ����鸸 ��ȸ�ϰ� �̸����� �������� ���ĵǵ��� ������ �ۼ��ϼ���
SELECT *
FROM emp
WHERE deptno in(10, 30)
  AND sal > 1500
ORDER BY ename DESC;

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM = 2;

-- emp ���̺��� ���(empno), �̸�(ename)�� �޿� �������� �������� �����ϰ�
-- ���ĵ� ��������� ROWNUM
SELECT ROWNUM, a.*
FROM (  SELECT *
         FROM emp
         ORDER BY sal) a;

-- row_1
SELECT ROWNUM, a.*
FROM (  SELECT *
         FROM emp
         ORDER BY sal) a
WHERE ROWNUM <= 10;

-- row_2
SELECT *
FROM (  SELECT ROWNUM rn, a.*
         FROM (  SELECT empno, ename
                 FROM emp
                 ORDER BY sal) a
         WHERE ROWNUM <= 14 )
WHERE rn > 10;

-- FUNCTION
-- DUAL ���̺� ��ȸ
SELECT 'HELLO WORLD' as msg
FROM dual;

SELECT 'HELLO WORLD'
FROM emp;

-- ���ڿ� ��ҹ��� ���� �Լ�
-- LOWER, UPPER, INITCAP
SELECT LOWER('Hello, World'), UPPER('Hello, World'), INITCAP('Hello, World')
FROM dual;

SELECT LOWER('Hello, World'), UPPER('Hello, World'), INITCAP('Hello, World')
FROM emp
WHERE job = 'SALESMAN';

-- FUNCTION�� WHERE�������� ��밡��
SELECT *
FROM emp
WHERE ename = UPPER('smith');

SELECT *
FROM emp
WHERE LOWER(ename) = 'smith';

-- ������ SQL ĥ������
-- 1. �º��� �������� ���ƶ�(���̺� �ִ� �÷�)
-- �º�(TABLE�� �÷�)�� �����ϰ� �Ǹ� INDEX�� ���������� ������� ����
-- Function Based Index -> FBI

-- CONCAT : ���ڿ� ���� - �� ���� ���ڿ��� �����ϴ� �Լ�
-- SUBSTR : ���ڿ��� �κ� ���ڿ� (java : String.substring)
-- LENGTH : ���ڿ��� ����
-- INSTR : ���ڿ��� Ư�� ���ڿ��� �����ϴ� ù ��° �ε���
-- LPAD : ���ڿ��� Ư�� ���ڿ��� ����
SELECT CONCAT('HELLO', ', WORLD') CONCAT,
        SUBSTR('HELLO, WORLD', 0, 5) substr,
        SUBSTR('HELLO, WORLD', 1, 5) substr1,
        LENGTH('HELLO, WORLD') length,
        INSTR('HELLO, WORLD', 'O') instr,
         -- INSTR(���ڿ�, ã�� ���ڿ�, ���ڿ��� Ư�� ��ġ ���� ǥ��)
        INSTR('HELLO, WORLD', 'O', 6) instr1,
         -- LPAD(���ڿ�, ��ü ���ڿ�����, ���ڿ��� ��ü���ڿ����̿� ��ġ�� ���Ұ�� �߰��� ����);
        LPAD('HELLO, WORLD', 15, '*') lpad,
        LPAD('HELLO, WORLD', 15) lpad,
        LPAD('HELLO, WORLD', 15, ' ') lpad,
        RPAD('HELLO, WORLD', 15, '*') rpad,
FROM dual;
