-- �� �� �Ķ���Ͱ� �־����� �� �ش����� �ϼ��� ���ϴ� ����
-- 201911 --> 30 / 201912 --> 31

-- �Ѵ� ���� �� �������� ���� = �ϼ�
-- ��������¥ ���� �� --> DD�� ����
SELECT :yyyymm as param, TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD') dt
FROM dual;

explain plan for
SELECT *
FROM emp
WHERE TO_CHAR(empno) = 7369;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT empno, ename, sal, TO_CHAR(sal, 'L999,999.99') sal_fmt
FROM emp;

-- function null
-- NVL(col1, col1�� null�� ��� ��ü�� ��)
SELECT empno, ename, sal, comm, nvl(comm, 0) nvl_comm,
        sal + comm, sal + nvl(comm, 0), nvl(comm + sal, 0)
FROM emp;

-- NVL2(col1, col1�� null�� �ƴ� ��� ǥ���Ǵ� ��, col1�� null�� ��� ǥ���Ǵ� ��)
SELECT empno, ename, sal, comm, NVL2(comm, comm, 0) + sal
FROM emp;

-- NULLIF(expr1, expr2)
-- expr1 == expr2 ������ null
-- else : expr1
SELECT empno, ename, sal, comm, NULLIF(sal, 1250)
FROM emp;

-- COALESCE (expr1, expr2, expr3....)
-- �Լ� ���� �� NULL�� �ƴ� ù ��° ����
SELECT empno, ename, sal, comm, coalesce (comm, sal)
FROM emp;

-- null �ǽ� fn4
-- emp ���̺��� ������ ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���
-- nvl
SELECT empno, ename, mgr, nvl(mgr, 9999) mgr_nvl,
-- nvl2
        nvl2(mgr, mgr, 9999) mgr_nvl2,
-- coalesce
        coalesce(mgr, 9999) mgr_coalesce
FROM emp;

SELECT userid, usernm, reg_dt
FROM users;

-- null �ǽ� fn5
-- users ���̺��� ������ ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���
-- reg_dt�� null�� ��� sysdate�� ����
SELECT userid, usernm, reg_dt, nvl(reg_dt, SYSDATE) n_reg_dt
FROM users;

-- case when
SELECT empno, ename, job, sal,
        case
            when job = 'SALESMAN' then sal * 1.05
            when job = 'MANAGER' then sal * 1.10
            when job = 'PRESIDENT' then sal * 1.20
            else sal
        end case_sal
FROM emp;

-- decode(col, search1, return1, search2, return2.... default)
SELECT empno, ename, job, sal,
        DECODE(job, 'SALESMAN', sal * 1.05, 'MANAGER', sal * 1.10, 'PRESIDENT', sal * 1.20, sal) decode_sal
FROM emp;

-- condition �ǽ� cond1
-- emp ���̺��� �̿��Ͽ� deptno�� ���� �μ������� �����ؼ� 
-- ������ ���� ��ȸ�Ǵ� ������ �ۼ��ϼ���
SELECT empno, ename, DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS', 'DDIT') dname
FROM emp;

-- condition �ǽ� cond2
-- emp ���̺��� �̿��Ͽ� hiredate�� ���� ���� �ǰ����� ���� ���������
-- ��ȸ�ϴ� ������ �ۼ��ϼ���. (������ �������� �ϳ� ���⼭�� �Ի�⵵�� �������� �Ѵ�.)
SELECT empno, ename, hiredate,
-- decode
        DECODE(MOD(TO_CHAR(SYSDATE, 'y') - TO_CHAR(hiredate, 'y'), 2), 0, '�ǰ����� �����','�ǰ����� ������')  CONTACT_TO_DOCTOR_DECODE,
-- case when
        case
            when MOD( TO_CHAR(SYSDATE, 'yyyy') - TO_CHAR(hiredate, 'yyyy'), 2) = 0 then '�ǰ����� �����'
            else '�ǰ����� ������'
        end CONTACT_TO_DOCTOR_CASE_WHEN
FROM emp;

-- ���ش� ¦���⵵�ΰ� Ȧ���⵵�ΰ�
-- 1. ���� �⵵ ���ϱ� (DATE --> TO_CHAR(DATE, FORMAT))
-- 2. ���� �⵵�� ¦������ ���
--    � ���� 2�� ������ �������� �׻� 2���� �۴�
--    2�� ������� �������� 0, 1
-- MOD(���, ������)
SELECT TO_CHAR(SYSDATE, 'YYYY') ����, DECODE(MOD(TO_CHAR(SYSDATE, 'y'), 2), 0,'¦���⵵', 'Ȧ���⵵') ¦������
FROM dual;

-- emp ���̺��� �Ի�⵵�� Ȧ������ ¦������ Ȯ��
SELECT empno, ename, hiredate, MOD(TO_CHAR(hiredate, 'YYYY'), 2)
FROM emp;

-- condition �ǽ� cond3
-- users ���̺��� �̿��Ͽ� reg_dt�� ���� ���� �ǰ����� ���� ��������� 
-- ��ȸ�ϴ� ������ �ۼ��ϼ���. (������ �������� �ϳ� ���⼭�� reg_dt�� �������� �Ѵ�.)
SELECT userid, usernm, alias, reg_dt,
-- decode
        DECODE(MOD(TO_CHAR(SYSDATE, 'y') - TO_CHAR(reg_dt, 'y'), 2), 0, '�ǰ����� �����','�ǰ����� ������')  CONTACT_TO_DOCTOR_DECODE,
-- case when
        case
            when MOD( TO_CHAR(SYSDATE, 'yyyy') - TO_CHAR(reg_dt, 'yyyy'), 2) = 0 then '�ǰ����� �����'
            else '�ǰ����� ������'
        end CONTACT_TO_DOCTOR_CASE_WHEN
FROM users;

-- �׷��Լ� ( AVG, MAX, MIN, SUM, COUNT )
-- �׷��Լ��� NULL���� ����󿡼� �����Ѵ�. SUM(comm) -> �ΰ� ���� �հ� ���, (COUNT(*) != COUNT(mgr))
-- ���� �� ���� ���� �޿��� �޴»���� �޿�
-- ���� �� ���� ���� �޿��� �޴»���� �޿�
-- ������ �޿� ��� (�Ҽ��� ��°�ڸ������� ������ --> �Ҽ��� ��°�ڸ����� �ݿø�)
-- ������ �޿� ��ü ��
-- ������ ��
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal, 
        SUM(sal) sum_sal, COUNT(*) emp_cnt, COUNT(sal) sal_cnt, COUNT(mgr) mgr_cnt, SUM(comm) comm_sum
FROM emp
GROUP BY deptno
ORDER BY deptno;

-- �μ��� ���� ���� �޿��� �޴»���� �޿�
-- GROUP BY ���� ������� ���� �÷��� SELECT ���� ����� ��� ����
-- �׷��Լ��� ������� ���ڿ� ����� �� �� �ִ�.
SELECT deptno, MAX(sal) max_sal, 'test', 1
FROM emp
GROUP BY deptno
ORDER BY deptno;

-- �μ��� �ִ� �޿�
SELECT deptno, MAX(sal) max_sal
FROM emp
-- WHERE MAX(sal) > 3000 ����
GROUP BY deptno
HAVING MAX(sal) > 3000;

-- group function �ǽ� grp1
-- emp ���̺��� �̿��Ͽ� ������ ���Ͻÿ�
-- ���� �� ���� ���� �޿�, ���� �޿�
-- ������ �޿� ���, ��
-- ���� �� �޿��� �ִ� ���� ��, ����ڰ� �ִ� ���� ��(null ����)
-- ��ü ������ ��
SELECT MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal, 
        COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp;

-- group function �ǽ� grp2
-- emp ���̺��� �̿��Ͽ� ������ ���Ͻÿ�
-- �μ� ���� ���� �� ���� ���� �޿�, ���� �޿�
-- �μ� ���� ������ �޿� ���(�Ҽ��� ��°�ڸ�����), ��
-- �μ��� ���� �� �޿��� �ִ� ���� ��, ����ڰ� �ִ� ���� ��(null ����)
-- �μ��� ������ ��
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal, 
        COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY deptno;
