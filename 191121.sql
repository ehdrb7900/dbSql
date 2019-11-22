-- 전체 직원의 급여평균
SELECT ROUND(AVG(sal), 2) sal_avg
FROM emp;

-- 부서별 직원의 급여 평균 10 xxxx, 20 yyyy, 30 zzzz
SELECT deptno, ROUND(AVG(sal), 2) sal_avg
FROM emp
GROUP BY deptno
ORDER BY deptno;

-- 부서별 평균 급여가 직원 전체의 급여 평균보다 높은 부서의 부서번호와
-- 부서별 급여 평균 금액 조회
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


-- 쿼리 블럭을 WITH절에 선언하여 쿼리를 간단하게 표현한다.
WITH dept_avg_sal AS(
    SELECT deptno, ROUND(AVG(sal), 2) d_avgsal
    FROM emp
    GROUP BY deptno)
SELECT *
FROM dept_avg_sal
WHERE d_avgsal > (SELECT ROUND(AVG(sal), 2) FROM emp);

-- 달력 만들기
-- STEP 1. 해당 년월의 일자 만들기
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

-- 전월, 다음 월까지 출력
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
-- 달력만들기 복습 데이터.sql의 일별 실적 데이터를 이용하여
-- 1~6월의 월별 실적 데이터를 다음과 같이 구하세요
SELECT MAX(DECODE(TO_CHAR(dt,'MM'), '01', SUM(sales))) JAN,
        MAX(DECODE(TO_CHAR(dt,'MM'), '02', SUM(sales))) FEB,
        NVL(MAX(DECODE(TO_CHAR(dt,'MM'), '03', SUM(sales))),0) MAR,
        MAX(DECODE(TO_CHAR(dt,'MM'), '04', SUM(sales))) APR,
        MAX(DECODE(TO_CHAR(dt,'MM'), '05', SUM(sales))) MAY,
        MAX(DECODE(TO_CHAR(dt,'MM'), '06', SUM(sales))) JUN
FROM sales
GROUP BY TO_CHAR(dt,'MM');

-- 계층쿼리
-- START WITH : 계층의 시작 부분을 정의
-- CONNECT BY : 계층간 연결 조건을 정의

-- 하향식 계층 쿼리 (가장 최상위 조직에서부터 모든 조직을 탐색)
SELECT *
FROM dept_h;
