SELECT *
FROM USER_VIEWS;
SELECT *
FROM ALL_VIEWS
WHERE OWNER = 'DKOH';

SELECT *
FROM dkoh.v_emp_dept;

-- dkoh �������� ��ȸ������ ���� V_EMP_DEPT view�� hr �������� ��ȸ�ϱ� ���ؼ���
-- ������.view�̸� �������� ����� �ؾ��Ѵ�.
-- �Ź� �������� ����ϱ� �������Ƿ� �ó���� ���� �ٸ� ��Ī�� ����

CREATE SYNONYM v_emp_dept FOR dkoh.v_emp_dept;

-- sem.v_emp_dept --> v_emp_dept
SELECT *
FROM v_emp_dept;

-- �ó�� ����
DROP SYNONYM v_emp_dept;

-- hr ���� ��й�ȣ : java
-- hr ���� ��й�ȣ ���� : hr
ALTER USER hr IDENTIFIED BY java;
-- ALTER USER dkoh IDENTIFIED BY java; -- ���� ������ �ƴϱ� ������ ���� �߻�

-- ditionary
-- ���ξ� : USER : ����� ���� ��ü
--          ALL : ����ڰ� ��� ������ ��ü
--          DBA : ������ ������ ��ü ��ü (�Ϲ� ����ڴ� ��� �Ұ�)
--          V$ : �ý��۰� ���õ� view (�Ϲ� ����ڴ� ��� �Ұ�)

SELECT *
FROM USER_TABLES;

SELECT *
FROM ALL_TABLES;

SELECT *
FROM DBA_TABLES
WHERE OWNER IN ('DKOH', 'HR');

-- ����Ŭ���� ������ SQL�̶�?
-- ���ڰ� �ϳ��� Ʋ���� �ȵ�
-- ���� SQL���� ���� ����� ������ ���� DBMS������
-- ���� �ٸ� SQL�� �νĵȴ�.

-- SQL������ bind ���� �� JAVA������ preparedStatement�� �����ȹ ������ ���� ����

SELECT /*bind test*/ * FROM emp;
Select /*bind test*/* FROM emp;
Select /*bind test*/*  FROM emp;



SELECT *
FROM v$SQL
WHERE SQL_TEXT LIKE '%emp%';


SELECT f1.loc LOCATION, ROUND(f1.cnt / f2.cnt, 2) BG_SCORE
FROM (SELECT COUNT(*) cnt, (sido || ' ' || sigungu) loc
        FROM fastfood
        WHERE gb IN ('����ŷ','�Ƶ�����','KFC')
        GROUP BY sido, sigungu) f1,
      (SELECT COUNT(*) cnt, (sido || ' ' || sigungu) loc
        FROM fastfood
        WHERE gb = '�Ե�����'
        GROUP BY sido, sigungu) f2
WHERE f1.loc = f2.loc
ORDER BY BG_SCORE DESC;