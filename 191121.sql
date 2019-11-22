-- ��ü ������ �޿����
SELECT ROUND(AVG(sal), 2) sal_avg
FROM emp;

-- �μ��� ������ �޿� ��� 10 xxxx, 20 yyyy, 30 zzzz
SELECT deptno, ROUND(AVG(sal), 2) sal_avg
FROM emp
GROUP BY deptno
ORDER BY deptno;

-- �μ��� ��� �޿��� ���� ��ü�� �޿� ��պ��� ���� �μ��� �μ���ȣ��
-- �μ��� �޿� ��� �ݾ� ��ȸ
SELECT e2.deptno, e2.sal_avg
FROM ( SELECT ROUND(AVG(sal), 2) sal_avg
        FROM emp) e1, 
      ( SELECT deptno, ROUND(AVG(sal), 2) sal_avg
        FROM emp
        GROUP BY deptno) e2
WHERE e1.sal_avg < e2.sal_avg;

SELECT *
FROM 
(SELECT deptno, ROUND(AVG(sal), 2) d_avgsal
FROM emp
GROUP BY deptno);


-- ���� ���� WITH���� �����Ͽ� ������ �����ϰ� ǥ���Ѵ�.
WITH dept_avg_sal AS(
    SELECT deptno, ROUND(AVG(sal), 2) d_avgsal
    FROM emp
    GROUP BY deptno)
SELECT *
FROM dept_avg_sal
WHERE d_avgsal > (SELECT ROUND(AVG(sal), 2) FROM emp);

-- �޷� �����
-- STEP 1. �ش� ����� ���� �����
-- CONNECT BY LEVEL
SELECT a.iw, 
        MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tue,   
        MAX(DECODE(d, 4, dt)) wed, MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri, 
        MAX(DECODE(d, 7, dt)) sat
FROM
    (SELECT (TO_DATE(:YYYYMM, 'YYYYMM') + level - 1) dt,
            TO_CHAR((TO_DATE(:YYYYMM, 'YYYYMM') + level), 'iw') iw,
            TO_CHAR((TO_DATE(:YYYYMM, 'YYYYMM') + level - 1), 'd') d
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD')) a
GROUP BY a.iw
ORDER BY a.iw;

SELECT
        MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tue,   
        MAX(DECODE(d, 4, dt)) wed, MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri, 
        MAX(DECODE(d, 7, dt)) sat
FROM
    (SELECT (TO_DATE(:YYYYMM, 'YYYYMM') + level - 1) dt,
            TO_CHAR((TO_DATE(:YYYYMM, 'YYYYMM') + level), 'iw') iw,
            CEIL((level - 1 - (TO_CHAR((TO_DATE(:YYYYMM, 'YYYYMM') + level - 1), 'd'))) / 7) aa,
            TO_CHAR((TO_DATE(:YYYYMM, 'YYYYMM') + level - 1), 'd') d
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD')) a
GROUP BY a.aa
ORDER BY a.aa;



SELECT MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tue,   
        MAX(DECODE(d, 4, dt)) wed, MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri, 
        MAX(DECODE(d, 7, dt)) sat
FROM
    (SELECT (TO_DATE(:YYYYMM, 'YYYYMM') + level - 1) dt,
            TO_CHAR((TO_DATE(:YYYYMM, 'YYYYMM') + level), 'iw') iw,
            CEIL((level - 1 - (TO_CHAR((TO_DATE(:YYYYMM, 'YYYYMM') + level - 1), 'd'))) / 7) aa,
            TO_CHAR((TO_DATE(:YYYYMM, 'YYYYMM') + level - 1), 'd') d
     FROM dual
     CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD')) a
GROUP BY a.aa
ORDER BY a.aa;

-- ����, ���� ������ ���
SELECT MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tue,   
        MAX(DECODE(d, 4, dt)) wed, MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri, 
        MAX(DECODE(d, 7, dt)) sat
FROM
    (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + level - TO_CHAR((TO_DATE(:YYYYMM, 'YYYYMM')), 'd') dt,
            CEIL(level / 7) aa,
            (MOD(level - 1, 7 ) + 1) d
     FROM dual
     CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD') 
                         + TO_CHAR((TO_DATE(:YYYYMM, 'YYYYMM')), 'd')
                         + 6 - TO_CHAR((LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM'))), 'd')) a        
GROUP BY a.aa
ORDER BY a.aa;

SELECT TO_CHAR((LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM'))), 'd')
FROM DUAL;


-- calendar 1
-- �޷¸���� ���� ������.sql�� �Ϻ� ���� �����͸� �̿��Ͽ�
-- 1~6���� ���� ���� �����͸� ������ ���� ���ϼ���
SELECT MAX(DECODE(TO_CHAR(dt,'MM'), '01', SUM(sales))) JAN,
        MAX(DECODE(TO_CHAR(dt,'MM'), '02', SUM(sales))) FEB,
        NVL(MAX(DECODE(TO_CHAR(dt,'MM'), '03', SUM(sales))),0) MAR,
        MAX(DECODE(TO_CHAR(dt,'MM'), '04', SUM(sales))) APR,
        MAX(DECODE(TO_CHAR(dt,'MM'), '05', SUM(sales))) MAY,
        MAX(DECODE(TO_CHAR(dt,'MM'), '06', SUM(sales))) JUN
FROM sales
GROUP BY TO_CHAR(dt,'MM');

-- ��������
-- START WITH : ������ ���� �κ��� ����
-- CONNECT BY : ������ ���� ������ ����

-- ����� ���� ���� (���� �ֻ��� ������������ ��� ������ Ž��)
SELECT *
FROM dept_h;
