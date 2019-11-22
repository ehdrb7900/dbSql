-- h_2 �����ý��ۺ� ������ ���� �������� ��ȸ (dept0_02)
SELECT level lv, deptcd, LPAD(' ', 4*(level - 1), ' ') || deptnm deptnm, p_deptcd
FROM dept_h a
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;

-- ����� ��������
-- Ư�� ���κ��� �ڽ��� �θ��带 Ž��(Ʈ�� ��ü Ž���� �ƴϴ�)
-- ���������� �������� ���� �μ��� ��ȸ
-- �������� dept0_00_0
SELECT *
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;

SELECT *
FROM h_sum;

-- �������� �ǽ� h_4
SELECT LPAD(' ', 4*(level - 1), ' ') || s_id s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id= ps_id;

-- �������� �ǽ� h_5
SELECT LPAD(' ', 4*(level - 1), ' ') || org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

-- pruning branch (����ġ��)
-- ������������ WHERE���� START WITH, CONNECT BY���� ���� ����� ���Ŀ� ����ȴ�.

-- dept_h ���̺��� �ֻ��� ������ ��������� ��ȸ
SELECT deptcd, LPAD(' ', 4 * (level - 1), ' ') || deptnm deptnm, level
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

-- ���������� �ϼ��� ���� WHERE���� ����ȴ�.
SELECT deptcd, LPAD(' ', 4 * (level - 1), ' ') || deptnm deptnm
FROM dept_h
WHERE deptnm != '������ȹ��'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT deptcd, LPAD(' ', 4 * (level - 1), ' ') || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd
            AND deptnm != '������ȹ��';


-- CONNET_BY_ROOT(col) : col�� �ֻ��� ��� �÷� ��
-- SYS_CONNECT_BY_PATH(col, ������) : col�� �������� ������ �����ڷ� ���� ���
--      . LTRIM�� ���� �ֻ��� ��� ������ �����ڸ� �����ִ� ���°� �Ϲ���
-- CONNECT_BY_ISLEAF : �ش� row�� leaf node���� �Ǻ�(1 : (O), 0 : (X))
SELECT LPAD(' ', 4 * (level - 1), ' ') || org_cd org_cd,
        CONNECT_BY_ROOT(org_cd) root_org_cd,
        LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'), '-') path_org_cd,
        CONNECT_BY_ISLEAF
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

-- �������� �ǽ� h6
SELECT seq, LPAD(' ', 4*(level - 1), ' ') || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq;

SELECT * FROM board_test;
SELECT seq, parent_seq, title, CASE WHEN level = 1 THEN 0 ELSE 1 END a 
       FROM board_test;
       
-- �������� �ǽ� h7
SELECT a.seq, LPAD(' ', 4*(level - 1), ' ') || a.title title
FROM board_test a, (SELECT seq, CASE WHEN level = 1 THEN seq ELSE 0 END aa 
                     FROM board_test 
                     START WITH parent_seq IS NULL
                     CONNECT BY PRIOR seq = parent_seq) b
WHERE a.seq = b.seq
START WITH parent_seq IS NULL
CONNECT BY PRIOR a.seq = a.parent_seq
ORDER SIBLINGS BY b.aa DESC, seq;
----------------------------------------------------------------------
SELECT seq, LPAD(' ', 4*(level - 1), ' ') || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY CASE WHEN parent_seq IS NULL THEN seq END DESC, seq;
------------------------------------------------------------------------
SELECT *
FROM ( SELECT seq, LPAD(' ', 4*(level - 1), ' ') || title title, connect_by_root(seq) r_seq
        FROM board_test
        START WITH parent_seq IS NULL
        CONNECT BY PRIOR seq = parent_seq)
ORDER BY r_seq DESC, seq;


SELECT *
FROM board_test;

-- �� �׷��ȣ �÷� �߰�
ALTER TABLE board_test ADD (gn NUMBER);

SELECT seq, LPAD(' ', 4*(level-1), ' ') || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq;


SELECT a.ename, a.sal, b.sal L_SAL
FROM ( SELECT ename, sal, ROWNUM rn
        FROM ( SELECT ename, sal
                FROM emp
                ORDER BY sal DESC)) a LEFT OUTER JOIN
        (SELECT ename, sal, ROWNUM rn
         FROM ( SELECT ename, sal
                 FROM emp
                 ORDER BY sal DESC)) b ON a.rn + 1 = b.rn;