-- ���� where 11
-- job�� SALESMAN�̰ų� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ��ȸ
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR hiredate >= TO_DATE('19810601', 'YYYYMMDD');
   
-- ROWNUM
SELECT ROWNUM, emp.*
FROM emp;

-- ROWNOM�� ���� ����
-- ORDER BY���� SELECT�� ���Ŀ� ����
-- ROWNUM �����÷��� ����ǰ����� ���ĵǱ� ������
-- �츮�� ���ϴ´�� ù��° �����ͺ��� �������� ��ȣ �ο��� ���� �ʴ´�.
SELECT ROWNUM, e.*
FROM emp e
ORDER BY ename;

-- ORDER BY ���� ������ �ζ��� �並 ����
SELECT ROWNUM, a.*
FROM    (SELECT e.*
          FROM emp e
          ORDER BY ename) a;

-- ROWNUM : 1������ �о�� �ȴ�
-- WHERE���� ROWNUM���� �߰��� �д°� �Ұ���

-- �ȵǴ� ���̽�
-- WHERE ROWNUM = 2
-- WHERE ROWNUM >= 2

-- ������ ���̽�
-- WHERE ROWNUM = 1
-- WHERE ROWNUM <= 10
          
SELECT ROWNUM, a.*
FROM    (SELECT e.*
          FROM emp e
          ORDER BY ename) a;
          
-- ����¡ ó���� ���� �ļ� ROWNUM�� ��Ī�� �ο�, �ش�SQL�� INLINE VIEW�� ���ΰ�
-- ��Ī�� ���� ����¡ ó��

SELECT *
FROM    (SELECT ROWNUM rn, a.*
          FROM    (SELECT e.*
                    FROM emp e
                    ORDER BY ename) a)
WHERE rn BETWEEN 10 AND 14;

-- CONCAT : ���ڿ� ���� - �� ���� ���ڿ��� �����ϴ� �Լ�
-- SUBSTR : ���ڿ��� �κ� ���ڿ� (java : String.substring)
-- LENGTH : ���ڿ��� ����
-- INSTR : ���ڿ��� Ư�� ���ڿ��� �����ϴ� ù ��° �ε���
-- LPAD : ���ڿ��� Ư�� ���ڿ��� ����SELECT CONCAT('HELLO', ', WORLD') CONCAT,
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
        -- REPLACE(�������ڿ�, ���� ���ڿ����� �����ϰ��� �ϴ� ��� ���ڿ�, ���湮�ڿ�)
        REPLACE(REPLACE('HELLO, WORLD', 'HELLO', 'hello'), 'WORLD', 'world') replace,
        TRIM('HELLO, WORLD') trim,
        TRIM('H' FROM 'HELLO, WORLD') trim2
FROM dual;

-- ROWND(������, �ݿø� ��� �ڸ���)
SELECT ROUND(105.54, 1) r1, -- �Ҽ��� ��° �ڸ����� �ݿø�
        ROUND(105.55, 1) r2, -- �Ҽ��� ��° �ڸ����� �ݿø�
        ROUND(105.55, 0) r3, -- �Ҽ��� ù° �ڸ����� �ݿø�
        ROUND(105.55, -1) r4 -- ���� ù° �ڸ����� �ݿø�
FROM dual;

SELECT empno, ename, sal, /* ROUND(sal/1000) qutient, */ MOD(sal, 1000) reminder -- 0 ~ 999
FROM emp;

SELECT TRUNC(105.54, 1) T1, -- �Ҽ��� ��° �ڸ����� ����
TRUNC(105.55, 1) T2, -- �Ҽ��� ��° �ڸ����� ����
TRUNC(105.55, 0) T3, -- �Ҽ��� ù° �ڸ����� ����
TRUNC(105.55, -1) T4 -- ���� ù° �ڸ����� ����
FROM dual;

-- SYSDATE : ����Ŭ�� ��ġ�� ������ ���� ��¥ + �ð� ������ ����
-- ������ ���ڰ� ���� �Լ�

-- TO_CHAR : DATE Ÿ���� ���ڿ��� ��ȯ
-- ��¥�� ���ڿ��� ��ȯ�ÿ� ������ ����
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS'),
        TO_CHAR(SYSDATE + 1/24/60 *30, 'YYYY/MM/DD HH24:MI:SS')
FROM dual;

-- date �ǽ� fn1

-- 1. 2019�� 12�� 31���� date������ ǥ��
SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD')
FROM dual;
-- 2. 2019�� 12�� 31���� date������ ǥ���ϰ� 5�� ���� ��¥
SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') - 5 
FROM dual;
-- 3. ���� ��¥
SELECT TO_DATE(SYSDATE)
FROM dual;
-- 4. ���� ��¥���� 3�� �� ��
SELECT TO_DATE(SYSDATE) - 3
FROM dual;

-- �� 4���� �÷��� �����Ͽ� ��ȸ�ϴ� ���� �ۼ�
SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') "12�� 31��", TO_DATE('2019/12/31', 'YYYY/MM/DD') - 5 "12�� 31�� - 5��", 
        SYSDATE "���� ��¥", SYSDATE - 3 "���� ��¥ -3��" 
FROM dual;

-- date format
-- �⵵ : YYYY, YY, RR : �� �ڸ��϶��� 4�ڸ� �϶��� �ٸ�
-- RR : 50���� Ŭ ��� ���ڸ��� 19, ���� ��� ���ڸ��� 20
-- YYYY, RRRR�� ����. �������̸� ���������� ǥ��
-- D : ������ ���ڷ� ǥ�� ( �Ͽ��� - 1, ������ - 2, ȭ���� - 3, ... , ����� - 7 )
SELECT TO_CHAR(TO_DATE('35/03/01', 'RR/MM/DD'), 'YYYY/MM/DD') r1,
        TO_CHAR(TO_DATE('55/03/01', 'RR/MM/DD'), 'YYYY/MM/DD') r2,
        TO_CHAR(TO_DATE('35/03/01', 'YY/MM/DD'), 'YYYY/MM/DD') y1,
        TO_CHAR(SYSDATE, 'D') d, -- ������ ������ - 2
        TO_CHAR(SYSDATE, 'IW') iw, -- ���� ǥ��
        TO_CHAR(TO_DATE('20191230', 'YYYYMMDD'), 'IW') this_year
FROM dual;

-- date �ǽ� fn2
-- ���� ��¥�� ������ ���� �������� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
-- 1. ��-��-��
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD'),
-- 2. ��-��-�� �ð�(24)-��-��
        TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'),
-- 3. ��-��-��
        TO_CHAR(SYSDATE, 'DD-MM-YYYY')
FROM dual;

-- ��¥�� �ݿø� (ROUND), ����(TRUNC)
-- ROUND (DATE, '����') YYYY, MM, DD
desc emp;
SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') as hiredate,
        TO_CHAR(ROUND(hiredate, 'YYYY'), 'YYYY/MM/DD HH24:MI:SS') as round_yyyy,
        TO_CHAR(ROUND(hiredate, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as round_mm,
        TO_CHAR(ROUND(hiredate, 'DD'), 'YYYY/MM/DD HH24:MI:SS') as round_DD,
        TO_CHAR(ROUND(hiredate - 1, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as round_mm,
        TO_CHAR(ROUND(hiredate - 2, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as round_mm
FROM emp
WHERE ename = 'SMITH';

SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') as hiredate,
        TO_CHAR(TRUNC(hiredate, 'YYYY'), 'YYYY/MM/DD HH24:MI:SS') as trunc_yyyy,
        TO_CHAR(TRUNC(hiredate, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as trunc_mm,
        TO_CHAR(TRUNC(hiredate, 'DD'), 'YYYY/MM/DD HH24:MI:SS') as trunc_DD,
        TO_CHAR(TRUNC(hiredate - 1, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as trunc_mm,
        TO_CHAR(TRUNC(hiredate - 2, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as trunc_mm
FROM emp
WHERE ename = 'SMITH';

-- ��¥ ���� �Լ�
-- MONTHS_BETWEEN(DATE, DATE) : �� ��¥ ������ ���� ��
-- 19801217 ~ 20191104 --> 20191117
SELECT ename, TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS') hiredate,
        MONTHS_BETWEEN(SYSDATE, hiredate) months_between,
        MONTHS_BETWEEN(TO_DATE('20191117', 'YYYYMMDD'), hiredate) months_between
FROM emp
WHERE ename = 'SMITH';

-- ADD_MONTHS(DATE, ������) : DATE�� �������� ���� ��¥
-- �������� ����ϰ�� �̷�, ������ ��� ����
SELECT ename, TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS') hiredate,
        ADD_MONTHS(hiredate, 467) add_months,
        ADD_MONTHS(hiredate, -467) add_months
FROM emp
WHERE ename = 'SMITH';

-- NEXT_DAY(DATE, ����) : DATE ���� ù��° ������ ��¥
SELECT SYSDATE, NEXT_DAY(SYSDATE, 7) first_sat, -- ���ó�¥ ���� ù ����� ����
        NEXT_DAY(SYSDATE, '�����') first_sat -- ���ó�¥ ���� ù ����� ����
FROM dual;

-- LAST_DAY(DATE) �ش� ��¥�� ���� ���� ������ ����
SELECT SYSDATE, LAST_DAY(SYSDATE) LAST_DAY,
        LAST_DAY(ADD_MONTHS (SYSDATE, 1)) LAST_DAY_12
FROM dual;

-- DATE + ���� = DATE (DATE���� ������ŭ ������ DATE)
-- D1 + ���� = D2
-- �纯���� D2 ����
-- D1 + ���� - D2 = D2 - D2
-- D1 + ���� - D2 = 0
-- D1 + ���� = D2
-- �纯�� D1 ����
-- D1 + ���� - D1 = D2 - D1
-- ���� = D2 - D1
-- ��¥���� ��¥�� ���� ���ڰ� ���´�
SELECT TO_DATE('20191104', 'YYYYMMDD') - TO_DATE('20191101', 'YYYYMMDD') D1,
        TO_DATE('20191201', 'YYYYMMDD') - TO_DATE('20191101', 'YYYYMMDD') D2,
        -- 201908 : 2019�� 8���� �ϼ� : 31
        ADD_MONTHS(TO_DATE('201908', 'YYYYMM'), 1) - TO_DATE('201908', 'YYYYMM') D3
FROM dual;