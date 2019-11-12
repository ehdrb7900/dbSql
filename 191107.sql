-- emp 테이블에는 부서번호(deptno)만 존재
-- emp 테이블에서 부서명을 조회하기 위해서는
-- dept 테이블과 조인을 통해 부서명 조회

-- 조인 문법
-- ANSI : 테이블 JOIN 테이블2 ON (테이블.COL = 테이블2.COL)
--        emp JOIN dept ON (emp.deptno = dept.deptno)
-- ORACLE : FROM 테이블, 테이블2 WHERE 테이블.col = 테이블2.col
--          FROM emp, dept WHERE emp.deptno = dept.deptno

-- 사원번호, 사원명, 부서번호, 부서명
SELECT empno, ename, dept.deptno, dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

SELECT empno, ename, dept.deptno, dname
FROM emp, dept 
WHERE emp.deptno = dept.deptno;

-- 데이터 결합 실습 join 0_2
-- emp,dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요 (급여가 2500 초과)
-- ORACLE
SELECT empno, ename, sal, e.deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
   AND sal > 2500
ORDER BY deptno;

-- ANSI
SELECT empno, ename, sal, e.deptno, dname
FROM emp e JOIN dept d ON (e.deptno = d.deptno)
WHERE sal > 2500
ORDER BY deptno;

-- 데이터 결합 실습 join 0_3
-- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요 (급여 2500 초과, 사번이 7600보다 큰 직원)
SELECT empno, ename, sal, e.deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
   AND sal > 2500
   AND empno > 7600
ORDER BY deptno;

-- ANSI
SELECT empno, ename, sal, e.deptno, dname
FROM emp e JOIN dept d ON (e.deptno = d.deptno)
WHERE sal > 2500
   AND empno > 7600
ORDER BY deptno;

-- 데이터 결합 실습 join 0_4
-- emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요
-- (급여 2500 초과, 사번이 7600보다 크고 부서명이 RESEARCH인 부서에 속한 직원)
SELECT empno, ename, sal, d.deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
  AND sal > 2500
  AND empno > 7600
  AND dname = 'RESEARCH'
ORDER BY empno DESC;

-- 데이터 결합 base_tables.sql 실습 join 1
-- erd 다이어그램을 참고하여 prod 테이블과 lprod 테이블을 조인하여
-- 다음과 같은 결과가 나오는 쿼리를 작성해보세요
SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM prod, lprod
WHERE prod.prod_lgu = lprod.lprod_gu
ORDER BY prod_id;

-- 데이터 결합 실습 join 2
-- erd 다이어그램을 참고하여 buyer, prod 테이블을 조인하여 buyter별 담당하는제품 정보를
-- 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer b, prod p
WHERE b.buyer_id = p.prod_buyer
ORDER BY prod_id;

-- 데이터 결합 실습 join 3
-- erd 다이어그램을 참고하여 member, cart, prod 테이블을 조인하여 회원별 장바구니에 담은
-- 제품 정보를 다음과 같은 결과가 나오는 쿼리를 작성해보세요
-- ORACLE
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member m, cart c, prod p
WHERE m.mem_id = c.cart_member
  AND c.cart_prod = p.prod_id;
  
-- ANSI
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member m JOIN cart c ON (m.mem_id = c.cart_member)
                JOIN prod p ON (c.cart_prod = p.prod_id);
                
-- 데이터 결합 실습 join 4
-- erd 다이어그램을 참고하여 customer, cycle 테이블을 조인하여
-- 고객별 애음 제품, 애음요일, 개수를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
-- (고객명이 brown, sally인 고객만 조회)
SELECT cus.cid, cnm, pid, day, cnt
FROM customer cus, cycle cy
WHERE cus.cid = cy.cid
  AND cnm in ('brown', 'sally');
  
-- 데이터 결합 실습 join 5
-- erd 다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여
-- 고객별 애음 제품, 애음요일, 개수, 제품명을 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
-- (고객명이 brown, sally인 고객만 조회)
SELECT cus.cid, cnm, p.pid, pnm, day, cnt
FROM customer cus, cycle cy, product p
WHERE cus.cid = cy.cid
  AND cy.pid = p.pid
  AND cnm in ('brown', 'sally');
  
-- 데이터 결합 실습 join 6
-- erd 다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여
-- 애음 요일과 관계없이 고객별 애음 제품별, 개수의 합과, 제품명을 다음과 같은 결과가 나오도록 쿼리를 작성해 보세요
SELECT cus.cid, cnm, p.pid, pnm, cy.cnt
FROM customer cus, product p, (SELECT cid, pid, SUM(cnt) cnt
                                FROM cycle
                                GROUP BY cid, pid) cy
WHERE cus.cid = cy.cid
  AND cy.pid = p.pid;
  
  SELECT cid, pid, SUM(cnt) cnt
                                FROM cycle
                                GROUP BY cid, pid;
                                
SELECT * FROM CUSTOMER;
SELECT * FROM PRODUCT;
SELECT * FROM CYCLE ORDER BY CID, PID, DAY;

--------------------------------------------------------------------
SELECT cus.cid, cnm, p.pid, pnm, SUM(cnt) cnt
FROM cycle cy, customer cus, product p
WHERE cus.cid = cy.cid
  AND cy.pid = p.pid
GROUP BY cy.cid, cy.pid, cus.cid, cnm, p.pid, pnm
ORDER BY cid, pid;
--------------------------------------------------------------------
with cycle_groupby as (
    SELECT cid, pid, SUM(cnt) cnt
    FROM cycle
    GROUP BY cid, pid
)

SELECT cus.cid, cnm, p.pid, pnm, cy.cnt
FROM cycle_groupby cy, customer cus, product p
WHERE cus.cid = cy.cid
  AND cy.pid = p.pid;
  
-- 데이터 결합 실습 join 7
-- erd 다이어그램을 참고하여 cycle, product 테이블을 이용하여
-- 제품별, 개수의 합과, 제품명을 다음과 같은 결과가 나오도록 쿼리를 작성해보세요

SELECT p.pid, pnm, cy.cnt
FROM product p, (SELECT pid, SUM(cnt) cnt
                                FROM cycle
                                GROUP BY pid) cy
WHERE cy.pid = p.pid;

SELECT p.pid, pnm, SUM(cnt) cnt
FROM cycle cy, product p
WHERE cy.pid = p.pid
GROUP BY p.pid, pnm;