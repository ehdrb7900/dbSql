-- 년 월 파라미터가 주어졌을 때 해당년월의 일수를 구하는 문제
-- 201911 --> 30 / 201912 --> 31

-- 한달 더한 후 원래값을 빼면 = 일수
-- 마지막날짜 구한 후 --> DD만 추출
SELECT :yyyymm as param, TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD') dt
FROM dual;

explain plan for
SELECT *
FROM emp
WHERE TO_CHAR(empno) = 7369;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT empno, ename, sal, TO_CHAR(sal, 'L999,999.99') sal_fmt
FROM emp;

-- function null
-- NVL(col1, col1이 null일 경우 대체할 값)
SELECT empno, ename, sal, comm, nvl(comm, 0) nvl_comm,
        sal + comm, sal + nvl(comm, 0), nvl(comm + sal, 0)
FROM emp;

-- NVL2(col1, col1이 null이 아닐 경우 표현되는 값, col1이 null일 경우 표현되는 값)
SELECT empno, ename, sal, comm, NVL2(comm, comm, 0) + sal
FROM emp;

-- NULLIF(expr1, expr2)
-- expr1 == expr2 같으면 null
-- else : expr1
SELECT empno, ename, sal, comm, NULLIF(sal, 1250)
FROM emp;

-- COALESCE (expr1, expr2, expr3....)
-- 함수 인자 중 NULL이 아닌 첫 번째 인자
SELECT empno, ename, sal, comm, coalesce (comm, sal)
FROM emp;

-- null 실습 fn4
-- emp 테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요
-- nvl
SELECT empno, ename, mgr, nvl(mgr, 9999) mgr_nvl,
-- nvl2
        nvl2(mgr, mgr, 9999) mgr_nvl2,
-- coalesce
        coalesce(mgr, 9999) mgr_coalesce
FROM emp;

SELECT userid, usernm, reg_dt
FROM users;

-- null 실습 fn5
-- users 테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요
-- reg_dt가 null일 경우 sysdate를 적용
SELECT userid, usernm, reg_dt, nvl(reg_dt, SYSDATE) n_reg_dt
FROM users;

-- case when
SELECT empno, ename, job, sal,
        case
            when job = 'SALESMAN' then sal * 1.05
            when job = 'MANAGER' then sal * 1.10
            when job = 'PRESIDENT' then sal * 1.20
            else sal
        end case_sal
FROM emp;

-- decode(col, search1, return1, search2, return2.... default)
SELECT empno, ename, job, sal,
        DECODE(job, 'SALESMAN', sal * 1.05, 'MANAGER', sal * 1.10, 'PRESIDENT', sal * 1.20, sal) decode_sal
FROM emp;

-- condition 실습 cond1
-- emp 테이블을 이용하여 deptno에 따라 부서명으로 변경해서 
-- 다음과 같이 조회되는 쿼리를 작성하세요
SELECT empno, ename, DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS', 'DDIT') dname
FROM emp;

-- condition 실습 cond2
-- emp 테이블을 이용하여 hiredate에 따라 올해 건강보험 검진 대상자인지
-- 조회하는 쿼리를 작성하세요. (생년을 기준으로 하나 여기서는 입사년도를 기준으로 한다.)
SELECT empno, ename, hiredate,
-- decode
        DECODE(MOD(TO_CHAR(SYSDATE, 'y') - TO_CHAR(hiredate, 'y'), 2), 0, '건강검진 대상자','건강검진 비대상자')  CONTACT_TO_DOCTOR_DECODE,
-- case when
        case
            when MOD( TO_CHAR(SYSDATE, 'yyyy') - TO_CHAR(hiredate, 'yyyy'), 2) = 0 then '건강검진 대상자'
            else '건강검진 비대상자'
        end CONTACT_TO_DOCTOR_CASE_WHEN
FROM emp;

-- 올해는 짝수년도인가 홀수년도인가
-- 1. 올해 년도 구하기 (DATE --> TO_CHAR(DATE, FORMAT))
-- 2. 올해 년도가 짝수인지 계산
--    어떤 수를 2로 나누면 나머지는 항상 2보다 작다
--    2로 나눌경우 나머지는 0, 1
-- MOD(대상, 나눌값)
SELECT TO_CHAR(SYSDATE, 'YYYY') 올해, DECODE(MOD(TO_CHAR(SYSDATE, 'y'), 2), 0,'짝수년도', '홀수년도') 짝수여부
FROM dual;

-- emp 테이블에서 입사년도가 홀수인지 짝수인지 확인
SELECT empno, ename, hiredate, MOD(TO_CHAR(hiredate, 'YYYY'), 2)
FROM emp;

-- condition 실습 cond3
-- users 테이블을 이용하여 reg_dt에 따라 올해 건강보험 검진 대상자인지 
-- 조회하는 쿼리를 작성하세요. (생년을 기준으로 하나 여기서는 reg_dt를 기준으로 한다.)
SELECT userid, usernm, alias, reg_dt,
-- decode
        DECODE(MOD(TO_CHAR(SYSDATE, 'y') - TO_CHAR(reg_dt, 'y'), 2), 0, '건강검진 대상자','건강검진 비대상자')  CONTACT_TO_DOCTOR_DECODE,
-- case when
        case
            when MOD( TO_CHAR(SYSDATE, 'yyyy') - TO_CHAR(reg_dt, 'yyyy'), 2) = 0 then '건강검진 대상자'
            else '건강검진 비대상자'
        end CONTACT_TO_DOCTOR_CASE_WHEN
FROM users;

-- 그룹함수 ( AVG, MAX, MIN, SUM, COUNT )
-- 그룹함수는 NULL값을 계산대상에서 제외한다. SUM(comm) -> 널값 제외 합계 출력, (COUNT(*) != COUNT(mgr))
-- 직원 중 가장 높은 급여를 받는사람의 급여
-- 직원 중 가장 낮은 급여를 받는사람의 급여
-- 직원의 급여 평균 (소수점 둘째자리까지만 나오게 --> 소수점 셋째자리에서 반올림)
-- 직원의 급여 전체 합
-- 직원의 수
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal, 
        SUM(sal) sum_sal, COUNT(*) emp_cnt, COUNT(sal) sal_cnt, COUNT(mgr) mgr_cnt, SUM(comm) comm_sum
FROM emp
GROUP BY deptno
ORDER BY deptno;

-- 부서별 가장 높은 급여를 받는사람의 급여
-- GROUP BY 절에 기술되지 않은 컬럼이 SELECT 절에 기술될 경우 에러
-- 그룹함수와 상관없는 문자열 상수는 올 수 있다.
SELECT deptno, MAX(sal) max_sal, 'test', 1
FROM emp
GROUP BY deptno
ORDER BY deptno;

-- 부서별 최대 급여
SELECT deptno, MAX(sal) max_sal
FROM emp
-- WHERE MAX(sal) > 3000 에러
GROUP BY deptno
HAVING MAX(sal) > 3000;

-- group function 실습 grp1
-- emp 테이블을 이용하여 다음을 구하시오
-- 직원 중 가장 높은 급여, 낮은 급여
-- 직원의 급여 평균, 합
-- 직원 중 급여가 있는 직원 수, 상급자가 있는 직원 수(null 제외)
-- 전체 직원의 수
SELECT MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal, 
        COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp;

-- group function 실습 grp2
-- emp 테이블을 이용하여 다음을 구하시오
-- 부서 기준 직원 중 가장 높은 급여, 낮은 급여
-- 부서 기준 직원의 급여 평균(소수점 둘째자리까지), 합
-- 부서의 직원 중 급여가 있는 직원 수, 상급자가 있는 직원 수(null 제외)
-- 부서별 직원의 수
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal, 
        COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY deptno;
