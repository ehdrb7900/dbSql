-- 복습
-- WHERE
-- 연산자
-- 비교 : =, !=, <>, >=, >, <=, <
-- BETWEEN start AND end
-- IN (set)
-- LIKE 'S%' ( % : 다수의 문자열과 매칭, _ : 정확히 한글자 매칭)
-- IS NULL ( != NULL )
-- AND, OR, NOT

-- emp 테이블에서 입사일자가 1981년 6월 1일부터 1986년 12월 31일 사이에 있는
-- 직원 정보조회
-- BETWEEN AND
SELECT *
FROM emp
WHERE hiredate BETWEEN TO_DATE('19810601', 'YYYYMMDD')
                   AND TO_DATE('19861231', 'YYYYMMDD');
-- >=, <=
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('19810601', 'YYYYMMDD')
  AND hiredate <= TO_DATE('19861231', 'YYYYMMDD');
  
-- emp 테이블에서 관리자(mgr)가 있는 직원만 조회
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- where 12 
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE '78%';
   
-- where 13
-- empno는 정수 4자리까지 허용
-- empno : 78, 780, 789
-- emp 테이블에서 job이 'SALESMAN'이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회하세요.
-- (like 연산자를 사용하지 마세요)
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno BETWEEN 7800 AND 7899;
   
-- where 14
-- emp 테이블에서 job이 'SALESMAN'이거나 사원번호가 78로 시작하면서
-- 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요.
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE '78%'
  AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

-- order by 컬럼명 | 별칭 | 컬럼인덱스 [ASC | DESC]
-- order by 구문은 WHERE절 다음에 기술
-- WHERE절이 없을 경우 FROM절 다음에 기술
-- ename 기준으로 오름차순 정렬
SELECT *
FROM emp
ORDER BY ename ASC;

-- ASC : default
-- ASC를 안붙여도 위 쿼리와 동일함
SELECT *
FROM emp
ORDER BY ename;

-- 이름(ename)을 기준으로 내림차순
SELECT *
FROM emp
ORDER BY ename DESC;

-- job을 기준으로 내림차순으로 정렬, job이 같을경우
-- 사번(empno)으로 오름차순 정렬
SELECT *
FROM emp
ORDER BY job DESC, empno;

-- 별칭으로 정렬하기
-- 사원 번호(empno), 사원명(ename), 연봉(sal * 12) as year_sal
SELECT empno, ename, sal, sal*12 year_sal
FROM emp
ORDER BY year_sal;

-- orderby 1
-- dept 테이블의 모든 정보를 부서이름으로 오름차순 정렬로 조회되도록 쿼리를 작성하세요
SELECT *
FROM dept
ORDER BY dname;

-- dept 테이블의 모든 정보를 부서위치로 내림차순 정렬로 조회되도록 쿼리를 작성하세요
SELECT *
FROM dept
ORDER BY loc DESC;

-- orderby 2
-- emp 테이블에서 상여(comm) 정보가 있는 사람들만 조회하고, 상여(comm)를 많이 받는 사람이
-- 먼저 조회되도록 하고, 상여가 같을 경우 사번으로 오름차순 정렬하세요
SELECT *
FROM emp
WHERE comm IS NOT NULL
ORDER BY comm DESC, empno;

-- orderby 3
-- emp 테이블에서 관리자가 잇는 사람들만 조회하고, 직군(job) 순으로 오름차순 정렬하고, 
-- 직업이 같을 경우 사번이 큰 사원이 먼저 조회되도록 쿼리를 작성하세요
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;

-- orderby 4
-- emp 테이블에서 10번 부서(deptno) 혹은 30번 부서에 속하는 사람 중
-- 급여(sal)가 1500이 넘는 사람들만 조회하고 이름으로 내림차순 정렬되도록 쿼리를 작성하세요
SELECT *
FROM emp
WHERE deptno in(10, 30)
  AND sal > 1500
ORDER BY ename DESC;

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM = 2;

-- emp 테이블에서 사번(empno), 이름(ename)을 급여 기준으로 오름차순 정렬하고
-- 정렬된 결과순으로 ROWNUM
SELECT ROWNUM, a.*
FROM (  SELECT *
         FROM emp
         ORDER BY sal) a;

-- row_1
SELECT ROWNUM, a.*
FROM (  SELECT *
         FROM emp
         ORDER BY sal) a
WHERE ROWNUM <= 10;

-- row_2
SELECT *
FROM (  SELECT ROWNUM rn, a.*
         FROM (  SELECT empno, ename
                 FROM emp
                 ORDER BY sal) a
         WHERE ROWNUM <= 14 )
WHERE rn > 10;

-- FUNCTION
-- DUAL 테이블 조회
SELECT 'HELLO WORLD' as msg
FROM dual;

SELECT 'HELLO WORLD'
FROM emp;

-- 문자열 대소문자 관련 함수
-- LOWER, UPPER, INITCAP
SELECT LOWER('Hello, World'), UPPER('Hello, World'), INITCAP('Hello, World')
FROM dual;

SELECT LOWER('Hello, World'), UPPER('Hello, World'), INITCAP('Hello, World')
FROM emp
WHERE job = 'SALESMAN';

-- FUNCTION은 WHERE절에서도 사용가능
SELECT *
FROM emp
WHERE ename = UPPER('smith');

SELECT *
FROM emp
WHERE LOWER(ename) = 'smith';

-- 개발자 SQL 칠거지악
-- 1. 좌변을 가공하지 말아라(테이블에 있는 컬럼)
-- 좌변(TABLE의 컬럼)을 가공하게 되면 INDEX를 정상적으로 사용하지 못함
-- Function Based Index -> FBI

-- CONCAT : 문자열 결합 - 두 개의 문자열을 결합하는 함수
-- SUBSTR : 문자열의 부분 문자열 (java : String.substring)
-- LENGTH : 문자열의 길이
-- INSTR : 문자열에 특정 문자열이 등장하는 첫 번째 인덱스
-- LPAD : 문자열에 특정 문자열을 삽입
SELECT CONCAT('HELLO', ', WORLD') CONCAT,
        SUBSTR('HELLO, WORLD', 0, 5) substr,
        SUBSTR('HELLO, WORLD', 1, 5) substr1,
        LENGTH('HELLO, WORLD') length,
        INSTR('HELLO, WORLD', 'O') instr,
         -- INSTR(문자열, 찾을 문자열, 문자열의 특정 위치 이후 표시)
        INSTR('HELLO, WORLD', 'O', 6) instr1,
         -- LPAD(문자열, 전체 문자열길이, 문자열이 전체문자열길이에 미치지 못할경우 추가할 문자);
        LPAD('HELLO, WORLD', 15, '*') lpad,
        LPAD('HELLO, WORLD', 15) lpad,
        LPAD('HELLO, WORLD', 15, ' ') lpad,
        RPAD('HELLO, WORLD', 15, '*') rpad,
FROM dual;
