-- SMITH, WARD가 속하는 부서의 직원들 조회
SELECT *
FROM emp
WHERE deptno IN (20, 30);

SELECT *
FROM emp
WHERE deptno = 20
    OR deptno = 30;
    
SELECT *
FROM emp
WHERE deptno IN (  SELECT deptno
                    FROM emp
                    WHERE ename IN ('SMITH', 'WARD'));
                    
SELECT *
FROM emp
WHERE deptno IN (  SELECT deptno
                    FROM emp
                    WHERE ename IN (:name1, :name2));
                    
-- ANY : SET 중에 만족하는게 하나라도 있으면 참으로 (크기비교)
-- SMITH 또는 WARD 보다 적은 급여를 받는 직원 정보 조회

SELECT *
FROM emp
WHERE sal < ANY(  SELECT sal
                    FROM emp
                    WHERE ename IN ('SMITH', 'WARD'));
                    
-- SMITH와 WARD보다 급여가 높은 직원 조회
-- SMITH보다도 급여가 높고 WARD보다도 급여가 높은사람(AND)
SELECT *
FROM emp
WHERE sal > ALL(  SELECT sal
                    FROM emp
                    WHERE ename IN ('SMITH', 'WARD'));

SELECT *
FROM emp
WHERE sal < ANY(  SELECT sal
                    FROM emp
                    WHERE ename IN ('SMITH', 'WARD'));
                    
-- NOT IN

-- 관리자 직원정보
SELECT DISTINCT mgr
FROM emp;

-- 어떤 직원의 관리자 역할을 하는 직원 정보 조회
SELECT *
FROM emp
WHERE empno IN (7839, 7782, 7698, 7902, 7566, 7788);

SELECT *
FROM emp
WHERE empno IN (   SELECT mgr 
                    FROM emp);
                    
-- 어떤 직원의 관리자가 아닌 직원들의 정보 조회
-- 단, NOT IN 연산자 사용시 SET에 NULL이 포함될 경우 정상적으로 동작하지 않는다.
-- NULL처리 함수나 WHERE절을 통해 NULL값을 처리한 이후 사용
SELECT *
FROM emp
WHERE empno NOT IN (7839, 7782, 7698, 7902, 7566, 7788);

SELECT *
FROM emp        -- empno가 7839, 7782, 7698, 7902, 7566, 7788에 포함되지 않는 사원 조회
WHERE empno NOT IN (SELECT mgr 
                      FROM emp
                      WHERE mgr IS NOT NULL);
                      
-- pair wise
-- 사번 7499, 7782인 직원의 관리자, 부서번호 조회
-- 7698     30
-- 7839     10
-- 직원중에 관리자와 부서번호가 (7698, 30)이거나, (7839, 10)인 사람
-- mgr, deptno 컬럼은 [동시]에 만족시키는 직원 정보 조회
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                         FROM emp
                         WHERE empno IN (7499, 7782));

SELECT *
FROM emp
WHERE mgr = (SELECT mgr
              FROM emp
              WHERE empno = 7499)
AND deptno = (SELECT deptno
               FROM emp
               WHERE empno = 7499)
OR mgr = (SELECT mgr
              FROM emp
              WHERE empno = 7782)
AND deptno = (SELECT deptno
               FROM emp
               WHERE empno = 7782);
-- 직원중에 관리자와 부서번호가 (7698, 30), (7698, 10), (7839,30), (7839,10)인 사람
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
                         FROM emp
                         WHERE empno IN (7499, 7782))
AND deptno IN ( SELECT deptno
                         FROM emp
                         WHERE empno IN (7499, 7782));                     

SELECT *
FROM emp
WHERE mgr = (SELECT mgr
              FROM emp
              WHERE empno = 7499)
AND (deptno = (SELECT deptno
               FROM emp
               WHERE empno = 7499)
     OR deptno = (SELECT deptno
                  FROM emp
                  WHERE empno = 7782))
OR mgr = (SELECT mgr
              FROM emp
              WHERE empno = 7782)
AND deptno = (SELECT deptno
               FROM emp
               WHERE empno = 7782)
    OR deptno = (SELECT deptno
                 FROM emp
                 WHERE empno = 7499);
               
-- SCALAR SUBQUERY : SELECT절에 등장하는 서브 쿼리(단, 값이 하나의 행, 하나의 컬럼)
-- 직원의 소속 부서명을 JOIN을 사용하지 않고 조회
SELECT empno, ename, deptno, (SELECT dname
                               FROM dept
                               WHERE deptno = emp.deptno) dname -- => 15번 수행
FROM emp;

SELECT dname
FROM dept
WHERE deptno = 20;

-- sub4 데이터 생성
INSERT INTO dept VALUES(99, 'ddit','daejeon');
COMMIT;

SELECT *
FROM emp
ORDER BY deptno;

-- 서브쿼리 실습 sub4
-- dept 테이블에는 신규 등록된 99번 부서에 속한 사람은 없음
-- 직원이 속하지 않은 부서를 조회하는 쿼리를 작성해보세요
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                       FROM emp
                       WHERE deptno IS NOT NULL);
        
-- 서브쿼리 실습 sub5
-- cycle, product 테이블을 이용하여 cid = 1인 고객이 애음하지 않는
-- 제품을 조회하는 쿼리를 작성하세요
SELECT *
FROM product
WHERE pid NOT IN (SELECT pid
                    FROM cycle
                    WHERE cid = 1
                      AND pid IS NOT NULL);

-- 서브쿼리 실습 sub 6
SELECT *
FROM cycle
WHERE pid IN (SELECT pid
                FROM cycle
                WHERE cid = 2)
   AND cid = 1;
   
-- 서브쿼리 실습 sub 7
SELECT 1, cnm, pid, (SELECT pnm FROM product WHERE pid = cycle.pid) pnm, day, cnt
FROM cycle, customer
WHERE pid IN (SELECT pid
                FROM cycle
                WHERE cid = 2)
  AND cycle.cid = 1
  AND cycle.cid = customer.cid;

SELECT 1, cnm, c.pid, p.pnm, day, cnt
FROM cycle c, product p, customer
WHERE c.pid IN ( SELECT pid
                FROM cycle
                WHERE cid = 2)
  AND c.pid = p.pid
  AND c.cid = 1
  AND customer.cid = c.cid;

-- EXISTS MAIN 쿼리의 컬럼을 사용해서 SUBQUERY에 만족하는 조건이 있는지 체크
-- 만족하는 값이 하나라도 존재하면 더이상 진행하지 않고 멈추기 때문에
-- 성능면에서 유리

-- MGR가 존재하는 직원 조회
SELECT *
FROM emp a
WHERE EXISTS (SELECT 1 
                FROM emp 
                WHERE empno = a.mgr);
                
SELECT *
FROM emp
WHERE mgr IS NOT NULL;
                
-- MGR가 존재하는 직원 조회
SELECT *
FROM emp a
WHERE NOT EXISTS (SELECT 1
                FROM emp 
                WHERE empno = a.mgr);
                
SELECT *
FROM emp
WHERE mgr IS NULL;

-- 서브쿼리 실습 sub8
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- 부서에 소속된 직원이 있는 부서 정보 조회
SELECT *
FROM dept d
WHERE EXISTS (SELECT 1 FROM emp WHERE deptno = d.deptno)
ORDER BY deptno;

SELECT *
FROM dept
WHERE deptno IN (10, 20, 30);

-- 서브쿼리 실습 sub9
-- customer, product 테이블을 이용하여 cid = 1인 고객이 애음하지 않는
-- 제품을 조회하는 쿼리를 EXISTS 연산자를 이용하여 작성하세요
SELECT *
FROM product
WHERE NOT EXISTS (SELECT 1 FROM cycle WHERE cid = 1 AND product.pid = pid);

SELECT *
FROM cycle;

-- 집합연산
-- UNION : 합집합, 중복을 제거
--         DBMS에서는 중복을 제거하기위해 데이터를 정렬 
--         (대량의 데이터에 대해 정렬시 부하)
-- UNION ALL : UNION과 같은개념
--             중복을 제거하지 않고, 위 아래 집합을 결합 => 중복가능
--             위 아래 집합에 중복되는 데이터가 없다는 것을 확신하면
--             UNION 연산자보다 성능면에서 유리
-- 사번이 7566 또는 7698인 사원 조회 (사번, 이름)

-- UNION
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION

-- 사번이 7369 또는 7499인 사원 조회 (사번, 이름)
SELECT empno, ename
FROM emp
WHERE empno = 7369 OR empno = 7499;
--------------------------------------------------------------
-- UNION ALL
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION ALL

-- 사번이 7369 또는 7499인 사원 조회 (사번, 이름)
SELECT empno, ename
FROM emp
WHERE empno = 7369 OR empno = 7499;

-- INTERSECT(교집합 : 위 아래 집합간 공통데이터)
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7499);

-- MINUS (차집합 : 위 집합에서 아래 집합을 제거)
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7499);
-----------------------------------------------
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7499)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369);


SELECT 1 n, 'x' m
FROM dual
UNION
select 2, 'y' -- 타입에 따른 컬럼 순서 유의
FROM dual
ORDER BY m desc;
 