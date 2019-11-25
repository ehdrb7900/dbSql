-- member 테이블을 이용하여 member2 테이블을 생성
-- member2 테이블에서 김은대 회원(mem_id = 'a001')의 직업(mem_job)을
-- '군인'으로 변경 후 commit하고 조회

CREATE TABLE member2 AS
SELECT *
FROM member;

UPDATE member2 SET mem_job = '군인'
WHERE mem_id = 'a001';

commit;

SELECT mem_id, mem_name, mem_job
FROM member2
WHERE mem_id = 'a001';


-- 제품별 제품 구매 수량(BUY_QTY) 합계, 제품 구매(BUY_COST) 금액 합계
-- 제품코드, 제품명, 수량합계, 금액합계

-- VW_PROD_BUY(view 생성)

CREATE OR REPLACE VIEW vw_prod_buy AS
SELECT b.buy_prod, prod_name, SUM(buy_qty) sum_qty, SUM(buy_cost) sum_cost
FROM buyprod b, prod p 
WHERE b.buy_prod = p.prod_id
GROUP BY b.buy_prod, prod_name
ORDER BY b.buy_prod;

SELECT * 
FROM user_views;

-- 분석함수 / window 함수 (도전해보기 실습 ana0)
-- 사원의 부서별 급여(sal)별 순위 구하기
-- emp 테이블 사용
       
SELECT ename, sal, deptno, ROWNUM - (SELECT COUNT(*)
                                       FROM (SELECT ename, sal, deptno
                                              FROM emp
                                              ORDER BY deptno, sal DESC)
                                       WHERE deptno < e.deptno) sal_rank 
FROM (SELECT ename, sal, deptno
       FROM emp
       ORDER BY deptno, sal DESC) e;

--부서별 랭킹
SELECT a.ename, a.sal, a.deptno, b.rn
FROM
    (SELECT a.ename, a.sal, a.deptno, ROWNUM j_rn
     FROM
    (SELECT ename, sal, deptno
     FROM emp
     ORDER BY deptno, sal DESC) a ) a, 
(SELECT b.rn, ROWNUM j_rn
FROM 
(SELECT a.deptno, b.rn 
 FROM
    (SELECT deptno, COUNT(*) cnt --3, 5, 6
     FROM emp
     GROUP BY deptno )a,
    (SELECT ROWNUM rn --1~14
     FROM emp) b
WHERE  a.cnt >= b.rn
ORDER BY a.deptno, b.rn ) b ) b
WHERE a.j_rn = b.j_rn;

SELECT ename, sal, deptno,
        ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rank
FROM emp;