-- 제약조건 활성화 / 비활성화
-- 어떤 제약조건을 활성화(비활성화) 시킬 대상 ??

-- emp FK 제약 (dept 테이블의 deptno 컬럼 참조)
-- FK_EMP_DEPT 비활성화
ALTER TABLE emp DISABLE CONSTRAINT pk_emp;

-- 제약조건에 위배되는 데이터가 들어갈 수 있지 않을까?
INSERT INTO emp (empno, ename, deptno)
VALUES (9999, 'brown', 80);

-- 제약조건에 위배되는 데이터 (소속 부서번호가 80번인 데이터)가 존재하여
-- 제약조건 활성화 불가
DELETE emp
WHERE empno = 9999;

-- FK_EMP_DEPT 활성화
ALTER TABLE emp ENABLE CONSTRAINT pk_emp;
COMMIT;

-- 현재 계정에 존재하는 테이블 목록 VIEW : USER_TABLES
-- 현재 계정에 존재하는 제약조건 VIEW : USER_CONSTRAINTS
-- 현재 계정에 존재하는 제약조건의 컬럼 VIEW : USER_CONS_COLUMNS
SELECT *
FROM user_constraints
WHERE table_name = 'CYCLE';

SELECT *
FROM USER_CONS_COLUMNS
WHERE constraint_name = 'PK_CYCLE';

-- 테이블에 설정된 제약조건 조회 (view 조인)
-- 테이블 명 / 제약조건 명 / 컬럼명 / 컬럼 포지션

SELECT a.table_name, a.constraint_name, b.column_name, b.position
FROM user_constraints a, user_cons_columns b
WHERE a.constraint_name = b.constraint_name
  AND a. constraint_type = 'P' -- PRIMARY KEY만 조회
ORDER BY a.table_name, b.position;

desc emp;

-- emp 테이블과 8가지 컬럼 주석달기
-- 테이블 주석 view : user_tab_comments
SELECT *
FROM user_tab_comments
WHERE table_name = 'EMP';

-- emp 테이블 주석
COMMENT ON TABLE emp IS '사원';

-- emp 테이블의 컬럼 주석
SELECT *
FROM user_col_comments
WHERE table_name = 'EMP';

-- EMPNO ENAME JOB MGR HIREDATE SAL COMM DEPTNO  
COMMENT ON COLUMN emp.empno IS '사원번호';
COMMENT ON COLUMN emp.ename IS '이름';
COMMENT ON COLUMN emp.job IS '담당업무';
COMMENT ON COLUMN emp.mgr IS '관리자 사번';
COMMENT ON COLUMN emp.hiredate IS '입사일자';
COMMENT ON COLUMN emp.sal IS '급여';
COMMENT ON COLUMN emp.comm IS '상여';
COMMENT ON COLUMN emp.deptno IS '소속부서번호';

-- DDL user_tab_comments, user_col_comments view를 이용하여
-- customer, product, cycle, daily 테이블과 컬럼의 주석 정보를 조회하는 쿼리를 써라
SELECT uc.table_name, table_type, ut.comments tab_comment, column_name, uc.comments col_comment
FROM user_col_comments uc, user_tab_comments ut
WHERE uc.table_name= ut.table_name
   AND uc.table_name IN ('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY');
   
-- VIEW 생성 (emp 테이블에서 sal, comm 두 개 컬럼 제외)
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

-- INLINE VIEW
SELECT *
FROM ( SELECT empno, ename, job, mgr, hiredate, deptno
        FROM emp );
        
-- VIEW (위 인라인뷰와 동일하다)
SELECT *
FROM v_emp;

-- 조인된 쿼리 결과를 view로 생성
-- emp, dept : 부서명, 사원번호, 사원명, 담당업무, 입사일자
CREATE OR REPLACE VIEW v_emp_dept AS 
SELECT d.dname, e.empno, e.ename, e.job, e.hiredate
FROM emp e, dept d
WHERE e.deptno = d.deptno;

SELECT * 
FROM v_emp_dept;

-- VIEW 제거
DROP VIEW v_emp;

-- VIEW를 구성하는 테이블의 데이터를 변경하면 VIEW에도 영향이 간다
-- dept 30 - SALES
SELECT *
FROM v_emp_dept;

-- dept 테이블의 SALES --> MARKET SALES
UPDATE dept SET dname = 'SALES'
WHERE deptno = 30;
ROLLBACK;

-- HR 계정에게 v_emp_dept view 조회권한을 준다
GRANT SELECT ON v_emp_dept TO hr;

-- SEQUENCE 생성 (게시글 번호 부여용 시퀀스)
CREATE SEQUENCE seq_post
INCREMENT BY 1
START WITH 1;

-- 게시글
SELECT seq_post.nextval, seq_post.currval
FROM dual;

-- 게시글 첨부파일
SELECT seq_post.currval
FROM dual;

SELECT *
FROM post
WHERE reg_id = 'brown'
AND title = '하하하하 재미있다'
AND reg_dt = TO_DATE ('2019/11/14 15:40:15', 'YYYY/MM/DD HH24:MI:SS');

SELECT *
FROM post
WHERE post_id = 1;

-- index
-- rowid : 테이블 행의 물리적 주소, 해당 주소를 알면 빠르게 테이블에
--          접근하는 것이 가능하다
SELECT product.*, ROWID
FROM product
WHERE ROWID = 'AAAFMCAAFAAAAFNAAA';