-- h_2 정보시스템부 하위의 조직 계층구조 조회 (dept0_02)
SELECT level lv, deptcd, LPAD(' ', 4*(level - 1), ' ') || deptnm deptnm, p_deptcd
FROM dept_h a
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;

-- 상향식 계층쿼리
-- 특정 노드로부터 자신의 부모노드를 탐색(트리 전체 탐색이 아니다)
-- 디자인팀을 시작으로 상위 부서를 조회
-- 디자인팀 dept0_00_0
SELECT *
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;

SELECT *
FROM h_sum;

-- 계층쿼리 실습 h_4
SELECT LPAD(' ', 4*(level - 1), ' ') || s_id s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id= ps_id;

-- 계층쿼리 실습 h_5
SELECT LPAD(' ', 4*(level - 1), ' ') || org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;

-- pruning branch (가지치기)
-- 계층쿼리에서 WHERE절은 START WITH, CONNECT BY절이 전부 적용된 이후에 실행된다.

-- dept_h 테이블을 최상위 노드부터 하향식으로 조회
SELECT deptcd, LPAD(' ', 4 * (level - 1), ' ') || deptnm deptnm, level
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

-- 계층쿼리가 완성된 이후 WHERE절이 적용된다.
SELECT deptcd, LPAD(' ', 4 * (level - 1), ' ') || deptnm deptnm
FROM dept_h
WHERE deptnm != '정보기획부'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT deptcd, LPAD(' ', 4 * (level - 1), ' ') || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd
            AND deptnm != '정보기획부';


-- CONNET_BY_ROOT(col) : col의 최상위 노드 컬럼 값
-- SYS_CONNECT_BY_PATH(col, 구분자) : col의 계층구조 순서를 구분자로 이은 경로
--      . LTRIM을 통해 최상위 노드 왼쪽의 구분자를 없애주는 형태가 일반적
-- CONNECT_BY_ISLEAF : 해당 row가 leaf node인지 판별(1 : (O), 0 : (X))
SELECT LPAD(' ', 4 * (level - 1), ' ') || org_cd org_cd,
        CONNECT_BY_ROOT(org_cd) root_org_cd,
        LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'), '-') path_org_cd,
        CONNECT_BY_ISLEAF
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;

-- 계층쿼리 실습 h6
SELECT seq, LPAD(' ', 4*(level - 1), ' ') || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq;

SELECT * FROM board_test;
SELECT seq, parent_seq, title, CASE WHEN level = 1 THEN 0 ELSE 1 END a 
       FROM board_test;
       
-- 계층쿼리 실습 h7
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

-- 글 그룹번호 컬럼 추가
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