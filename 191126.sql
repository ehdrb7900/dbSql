SELECT ename, sal, deptno, 
        RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) rank,
        DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) d_rank,
        ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rown
FROM emp;

-- 분석함수 / window 함수 (실습 ana1)
-- 사원의 전체 급여 순위를 rank, dense_rank, row_number를 이용하여 구하세요
-- 단, 급여가 동일할 경우 사번이 빠른 사람이 높은순위가 되도록 작성하세요
SELECT empno, ename, sal, deptno,
        RANK() OVER (ORDER BY sal DESC, empno) sal_rank,
        DENSE_RANK() OVER (ORDER BY sal DESC, empno) sal_dense_rank,
        ROW_NUMBER() OVER (ORDER BY sal DESC, empno) sal_row_number
FROM emp;

-- 분석함수 / window 함수 (실습 no_ana2)
-- 기존에 배운 내용을 활용하여 모든 사원에 대해 사원번호, 이름, 부서 번호
-- 해당 사원이 속한 부서의 사원 수를 조회하는 쿼리를 작성하세요.
SELECT empno, ename, e1.deptno, cnt
FROM emp e1, (SELECT deptno, COUNT(*) cnt
                FROM emp
                GROUP BY deptno) e2
WHERE e1.deptno = e2.deptno
ORDER BY deptno;

-- 분석함수를 통한 부서별 직원 수 구하기
SELECT empno, ename, deptno,
        COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

-- SUM 분석함수
SELECT empno, ename, deptno,
        SUM(sal) OVER (PARTITION BY deptno) sum_sal
FROM emp;

-- 분석함수 / window 함수 (실습 ana2)
-- window function을 이용하여 모든 사원에 대해 사원번호, 사원이름,
-- 본인 급여, 부서번호와 해당사원이 속한 부서의 급여 평균을 조회하는 쿼리를 작성하세요
-- (급여 평균은 소수점 둘째 자리까지 구한다.)
SELECT empno, ename, sal, deptno,
        ROUND(AVG(sal) OVER (PARTITION BY deptno), 2) avg_sal
FROM emp;

-- 분석함수 / window 함수 (실습 ana3)
-- window function을 이용하여 모든 사원에 대해 사원번호, 사원이름,
-- 본인급여, 부서번호와 해당 사원이 속한 부서의 가장 높은 급여를 조회하는 쿼리를 작성하세요.
SELECT empno, ename, sal, deptno,
        MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;

-- 분석함수 / window 함수 (실습 ana4)
-- window function을 이용하여 모든 사원에 대해 사원번호, 사원이름,
-- 본인급여, 부서번호와 해당 사원이 속한 부서의 가장 낮은 급여를 조회하는 쿼리를 작성하세요.
SELECT empno, ename, sal, deptno,
        MIN(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;

-- 분석함수 / window 함수 (그룹 내 행 순서)
-- 부서별 사원번호가 가장 빠른 사람
SELECT empno, ename, deptno,
        FIRST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) f_emp
FROM emp;

-- 부서별 사원번호가 가장 느린 사람
SELECT empno, ename, deptno,
        LAST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno DESC
                                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) l_emp
FROM emp;

-- LAG (이전행)
-- 현재행
-- LEAD (다음행)
-- 급여가 높은순으로 정렬했을 때 본인보다 한단계 급여가 낮은 사람의 급여,
--                             본인보다 한단계 급여가 높은 사람의 급여
SELECT empno, ename, sal, LAG(sal) OVER (ORDER BY sal) lag_sal, 
                           LEAD(sal) OVER (ORDER BY sal) lead_sal
FROM emp;

-- 분석함수 / window 함수 (그룹내 행 순서 실습 ana5)
-- window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 입사일자
-- 급여, 전체 사원중 급여 순위가 한단계 낮은 사람의 급여를 조회하는 쿼리를 작성하세요.
-- (급여가 같을 경우 입사일이 빠른 사람이 높은순위)
SELECT empno, ename, hiredate, sal, 
        LEAD(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp;

-- 분석함수 / window 함수 (그룹내 행 순서 실습 ana6)
-- window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 입사일자, 직군(job)
-- 급여 정보와 담당업무(JOB) 별 급여 순위가 한단계 높은 사람의 급여를 조회하는 쿼리를 작성하세요.
-- (급여가 같을 경우 입사일이 빠른 사람이 높은순위)
SELECT empno, ename, hiredate, job, sal,
        LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) lag_sal
FROM emp;

-- 분석함수 / window 함수 (그룹내 행 순서 - 생각해보기, 실습 no_ana3)
-- 모든 사원에 대해 사원번호, 사원이름, 입사일자, 급여를 급여가 낮은순으로 조회해보자
-- 자신보다 우선순위가 낮은 사람들과 자신의 급여 합을 새로운 컬럼에 넣어보자
-- (급여가 동일할 경우 사원번호가 빠른사람이 우선순위가 높다)
-- (window 함수 없이)
SELECT empno, ename, e1.sal, SUM(e2.sal) c_sum
FROM emp e1, (SELECT sal FROM emp ORDER BY sal) e2
WHERE e1.sal >= e2.sal
GROUP BY e1.empno, e1.ename, e1.sal
ORDER BY e1.sal, empno;

SELECT e1.empno, ename, e1.sal, SUM(e2.sal) c_sum
FROM (SELECT e.*, ROWNUM rn
        FROM (SELECT empno, ename, sal
               FROM emp
               ORDER BY sal)e ) e1, 
      (SELECT e.*, ROWNUM rn
               FROM (SELECT empno, sal
                      FROM emp
                      ORDER BY sal) e) e2
WHERE e1.rn >= e2.rn
GROUP BY e1.empno, ename, e1.sal
ORDER BY sal, empno;

-- WINDOWING
-- UNBOUNDED PRECEDING : 현재 행을 기준으로 선행하는 모든 행
-- CURRENT ROW : 현재 행
-- UNBOUNDED FOLLOWING : 현재 행을 기준으로 후행하는 모든 행
-- N(정수) PRECEDING : 현재 행을 기준으로 선행하는 N개의 행
-- N(정수) FOLLOWING : 현재 행을 기준으로 후행하는 N개의 행

SELECT empno, ename, sal,
        SUM(sal) OVER (ORDER BY sal, empno 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal,  
                                          -- AND CURRENT ROW 생략 가능
        SUM(sal) OVER (ORDER BY sal, empno 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_sal2,
        
        SUM(sal) OVER (ORDER BY sal, empno 
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_sal3
FROM emp;

-- 분석함수 / window 함수 (그룹내 행 순서 실습 ana7)
-- 사원번호, 사원이름, 부서번호, 급여 정보를 부서별로 급여, 사원번호 오름차순으로
-- 정렬했을 때, 자신의 급여와 선행하는 사원들의 급여 합을 조회하는
-- 쿼리를 작성하세요 (window 함수 사용)
SELECT empno, ename, deptno, sal, 
        SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno) c_sum
FROM emp;

SELECT empno, ename, deptno, sal,
        SUM(sal) OVER (ORDER BY sal 
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_sum,
        SUM(sal) OVER (ORDER BY sal 
                        ROWS UNBOUNDED PRECEDING) row_sum2,
        SUM(sal) OVER (ORDER BY sal 
                        RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) range_sum,
        SUM(sal) OVER (ORDER BY sal 
                        RANGE UNBOUNDED PRECEDING) range_sum2
FROM emp;