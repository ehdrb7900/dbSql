-- SELECT : 조회할 컬럼 명시
--         - 전체 컬럼 조회 : *
--         - 일부 컬럼 : 해당 컬럼명 나열 (,구분)
-- FROM : 조회할 테이블 명시
-- 쿼리를 여러줄에 나누어서 작성해도 상관 없다
-- 단 keyword는 붙여서 작성

-- 모든 컬럼을 조회
SELECT * 
FROM prod;

-- 특정 컬럼만 조회
SELECT prod_id, prod_name
FROM prod;

-- 1] 1prod 테이블의 모든 컬럼조회
SELECT *
FROM lprod;

-- 2] buyer 테이블에서 buyer_id, buyer_name 컬럼만 조회하는 쿼리를 작성하세요
SELECT buyer_id, buyer_name
FROM buyer;

-- 3] cart 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요
SELECT *
FROM cart;

-- 4] member 테이블에서 mem_id, mem_pass, mem_name 컬럼만 조회하는 쿼리를 작성하세요
SELECT mem_id, mem_pass, mem_name
FROM member;

-- 5] remain 테이블에서 remain_year, remain_prod, remain_date 컬럼만 조회하는 쿼리를 작성하세요 (X)

-- 연산자 / 날짜연산
-- date type + 정수 : 일자를 더한다.
-- null을 포함한 연산의 결과는 항상 null이다.
SELECT userid 아이디, usernm 이름, reg_dt "등록 일자", reg_dt + 5 "더해진 날짜", reg_dt - 5 "빼진 날짜"
FROM users;

COMMIT;
UPDATE users SET reg_dt = null
WHERE userid = 'moon';

DELETE USERS
WHERE userid not in ('brown', 'cony', 'sally', 'james', 'moon');

SELECT *
FROM users;

COMMIT;

-- 1] prod 테이블에서 prod_id, prod_name 두 컬럼을 조회하는 쿼리를 작성하시오.
--      (단, prod_id -> id, prod_name -> name으로 컬럼 별칭을 지정)
SELECT prod_id id, prod_name name
FROM prod;

-- 2] lprod 테이블에서 lprod_gu, lprod_nm 두 컬럼을 조회하는 쿼리를 작성하시오.
--      (단, lprod_gu -> gu, lprod_nm -> nm으로 컬럼 별칭을 지정)
SELECT lprod_gu gu, lprod_nm nm
FROM lprod;

-- 3] buyer 테이블에서 buyer_id, buyer_name 두 컬럼을 조회하는 쿼리를 작성하시오.
--      (단, buyer_id -> 바이어아이디, buyer_name -> 이름으로 컬럼 별칭을 지정)
SELECT buyer_id 바이어아이디, buyer_name 이름
FROM buyer;

-- 문자열 결합
-- java + --> sql ||
-- CONCAT(str, str) 함수
-- users 테이블의 userid, usernm
SELECT userid, usernm, userid || usernm "id+name",
        CONCAT (userid, usernm)
FROM users;

-- 문자열 상수 (컬럼에 담긴 데이터가 아니라 개발자가 직접 입력한 문자열)
SELECT '사용자 아이디 : ' , userid
       -- CONCAT('사용자 아이디 : ', userid)
FROM users;

-- 실습 sel_conl]
SELECT 'SELECT * FROM ' || table_name QUERY
FROM user_tables;