-- 조인 복습
-- 조인 왜 ??
-- RDBMS의 특성상 데이터 중복을 최대 배제한 설계를 한다.
-- EMP 테이블에는 직원의 정보가 존재, 해당 직원의 소속 부서정보는
--  부서번호만 갖고있고, 부서번호를 통해 dept 테이블과 조인을 통해
--  해당 부서의 정보를 가져올 수 있다.

-- 직원 번호, 직원 이름, 직원의 소속 부서번호, 부서이름
-- emp, dept
SELECT emp.empno, emp.ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- 부서번호, 부서명, 해당부서의 인원수
-- count(col) : col값이 존재하면 1, null : 0
--              행수가 궁금한 것이면 *
SELECT e.deptno, d.dname, count(dname) cnt
FROM emp e, (SELECT deptno, dname 
              FROM dept) d
WHERE e.deptno = d.deptno
GROUP BY e.deptno, d.dname;

-- TOTAL ROW : 14
SELECT COUNT(*), COUNT(EMPNO), COUNT(MGR), COUNT(COMM)
FROM emp;

select * from emp;

SELECT a.empno, a.ename, a.mgr, e2.ename mgr_name
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno);

-- OUTER JOIN : 조인에 실패도 기준이 되는 테이블의 데이터는 조회결과가 
--              나오도록 하는 조인 형태
-- LEFT OUTER JOIN : JOIN KEYWORD 왼쪽에 위치한 테이블이 조회 기준이
--                   되도록 하는 조인 형태
-- RIGHT OUTER JOIN : JOIN KEYWORD 왼쪽에 위치한 테이블이 조회 기준이
--                   되도록 하는 조인 형태
-- FULL OUTER JOIN : LEFT OUTER JOIN + RIGHT OUTER JOIN - 중복 데이터

-- 직원 정보와, 해당 직원의 관리자 정보 OUTER JOIN
-- 직원 번호, 직원 이름, 관리자 번호, 관리자 이름
SELECT a.empno, a.ename, a.mgr, b.ename mgr_name
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno);

-- oracle outer join (left, right만 존재 fullouter는 지원하지 않음)
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+);

-- ANSI LEFT OUTER
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr = b.empno AND b.deptno = 10);
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr = b.empno)
WHERE b.deptno = 10;

select * from emp where deptno = 10;

-- oracle outer 문법에서는 outer 테이블이 되는 모든 컬럼에 (+)를 붙여줘야
-- outer join이 정상적으로 동작한다.
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno (+)
   AND b.deptno (+)= 10;

SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno (+);

-- ANSI RIGHT OUTER
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a RIGHT OUTER JOIN emp b ON (a.mgr = b.empno);

-- 데이터 결합 outer join 실습 outerjoin 1
-- buyprod 테이블에 구매일자가 2005년 1월 25일인 데이터는 3품목밖에 없다.
-- 모든 품목이 나올 수 있도록 쿼리를 작성해보세요
-- ANSI
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM prod p LEFT OUTER JOIN buyprod b ON (b.buy_prod =  p.prod_id 
                                                AND b.buy_date = TO_DATE('050125','YYMMDD'));
                                                
-- ORACLE
SELECT TO_DATE('050125', 'YYMMDD') buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM prod p ,buyprod b
WHERE b.buy_prod(+) =  p.prod_id 
  AND b.buy_date(+) = TO_DATE('050125','YYMMDD');

-- 데이터 결합 outer join 실습 outerjoin 2
-- outerjoin 1에서 작업을 시작하세요. buy_date 컬럼이 null인 항목이 안나오도록 
-- 다음처럼 데이터를 채워지도록 쿼리를 작성하세요.
-- ANSI
SELECT TO_DATE('050125','YYMMDD') buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM prod p LEFT OUTER JOIN buyprod b ON (b.buy_prod =  p.prod_id 
                                                AND b.buy_date = TO_DATE('050125','YYMMDD'));
                                                
-- ORACLE
SELECT TO_DATE('050125', 'YYMMDD') buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM prod p ,buyprod b
WHERE b.buy_prod(+) =  p.prod_id 
  AND b.buy_date(+) = TO_DATE('050125','YYMMDD');
  
-- 데이터 결합 outer join 실습 outerjoin 3
-- outerjoin 2에서 작업을 시작하세요. buy_qty 컬럼이 null일 경우 0으로 보이도록 
-- 쿼리를 수정하세요.
-- ANSI
SELECT TO_DATE('050125','YYMMDD') buy_date, buy_prod, prod_id, prod_name, nvl(buy_qty, 0) buy_qty
FROM prod p LEFT OUTER JOIN buyprod b ON (b.buy_prod =  p.prod_id 
                                                AND b.buy_date = TO_DATE('050125','YYMMDD'));
                                                
-- ORACLE
SELECT TO_DATE('050125', 'YYMMDD') buy_date, buy_prod, prod_id, prod_name, nvl(buy_qty, 0) buy_qty
FROM prod p ,buyprod b
WHERE b.buy_prod(+) =  p.prod_id 
  AND b.buy_date(+) = TO_DATE('050125','YYMMDD');

-- 데이터 결합 outer join 실습 outerjoin 4
-- cycle, product 테이블을 이용하여 고객이 애음하는 제품 명칭을 표현하고,
-- 애음하지 않는 제품도 다음과 같이 조회되도록 쿼리를 작성하세요
-- (고객은 cid=1인 고객만 나오도록 제한, null 처리)
-- ANSI
SELECT p.pid, pnm, '1' cid, nvl(day ,0) day, nvl(cnt, 0) cnt
FROM product p LEFT OUTER JOIN cycle c ON(c.pid = p.pid AND cid = 1);

-- ORACLE
SELECT p.pid, pnm, '1' cid, nvl(day ,0) day, nvl(cnt, 0) cnt
FROM product p ,cycle c 
WHERE c.pid (+) = p.pid 
   AND cid (+) = 1;
   
-- 데이터 결합 outer join 실습 outerjoin 5
-- cycle, product 테이블을 이용하여 고객이 애음하는 제품 명칭을 표현하고,
-- 애음하지 않는 제품도 다음과 같이 조회되도록 쿼리를 작성하세요
-- (고객은 cid=1인 고객만 나오도록 제한, null 처리)
-- ANSI
SELECT pc.pid , pnm, pc.cid, c.cnm, pc.day, pc.cnt
FROM customer c ,(SELECT p.pid, pnm, '1' cid, nvl(day ,0) day, nvl(cnt, 0) cnt
FROM product p LEFT OUTER JOIN cycle c ON(c.pid = p.pid AND cid = 1)) pc
WHERE c.cid = pc.cid
ORDER BY pid DESC, day DESC;

-- ORACLE
SELECT pc.pid , pnm, pc.cid, c.cnm, pc.day, pc.cnt
FROM customer c ,(SELECT p.pid, pnm, '1' cid, nvl(day ,0) day, nvl(cnt, 0) cnt
                FROM product p ,cycle c 
                WHERE c.pid (+) = p.pid 
                   AND cid (+) = 1) pc
WHERE c.cid = pc.cid
ORDER BY pid DESC, day DESC;

-- 데이터 결합 cross join 실습 crossjoin 1
-- customer, product 테이블을 이용하여 고객이 애음 가능한 모든 제품의 정보를 결합하여 
-- 다음과 같이 조회되도록 쿼리를 작성하세요
-- ANSI
SELECT cid, cnm, pid, pnm
FROM customer CROSS JOIN product;

-- ORACLE
SELECT cid, cnm, pid, pnm
FROM customer, product;

-- subquery : main쿼리에 속하는 부분 쿼리
-- 사용되는 위치 :
-- SELECT - scalar subquery (하나의 행과, 하나의 컬럼만 조회되는 쿼리이어야 한다)
-- FROM - inline view
-- WHERE - subquery

-- SCALAR subquery
SELECT empno, ename, SYSDATE now /*현재날짜*/
FROM emp;

SELECT empno, ename, (SELECT SYSDATE FROM dual) now
FROM emp;

-- SMITH가 속한 부서에 누가 있을까
SELECT *
FROM emp
WHERE deptno = ( SELECT deptno
                  FROM emp
                  WHERE ename = 'SMITH');

-- 서브쿼리 실습 sub 1
-- 평균 급여보다 높은 급여를 받는 직원의 수를 조회하세요
SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT AVG(sal) 
              FROM emp);
              
-- 서브쿼리 실습 sub 2
-- 평균 급여보다 높은 급여를 받는 직원의 정보를 조회하세요
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal) 
              FROM emp);
              
-- 서브쿼리 실습 sub 3
--SMITH와 WARD 사원이 속한 부서의 모든 사원 정보를 조회하는 쿼리를 다음과 같이 작성하세요
SELECT *
FROM emp
WHERE deptno in (SELECT deptno 
                  FROM emp 
                  WHERE ename in('SMITH','WARD'))
ORDER BY deptno, empno DESC;