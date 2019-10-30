-- SELECT : ��ȸ�� �÷� ���
--         - ��ü �÷� ��ȸ : *
--         - �Ϻ� �÷� : �ش� �÷��� ���� (,����)
-- FROM : ��ȸ�� ���̺� ���
-- ������ �����ٿ� ����� �ۼ��ص� ��� ����
-- �� keyword�� �ٿ��� �ۼ�

-- ��� �÷��� ��ȸ
SELECT * 
FROM prod;

-- Ư�� �÷��� ��ȸ
SELECT prod_id, prod_name
FROM prod;

-- 1] 1prod ���̺��� ��� �÷���ȸ
SELECT *
FROM lprod;

-- 2] buyer ���̺��� buyer_id, buyer_name �÷��� ��ȸ�ϴ� ������ �ۼ��ϼ���
SELECT buyer_id, buyer_name
FROM buyer;

-- 3] cart ���̺��� ��� �����͸� ��ȸ�ϴ� ������ �ۼ��ϼ���
SELECT *
FROM cart;

-- 4] member ���̺��� mem_id, mem_pass, mem_name �÷��� ��ȸ�ϴ� ������ �ۼ��ϼ���
SELECT mem_id, mem_pass, mem_name
FROM member;

-- 5] remain ���̺��� remain_year, remain_prod, remain_date �÷��� ��ȸ�ϴ� ������ �ۼ��ϼ��� (X)

-- ������ / ��¥����
-- date type + ���� : ���ڸ� ���Ѵ�.
-- null�� ������ ������ ����� �׻� null�̴�.
SELECT userid ���̵�, usernm �̸�, reg_dt "��� ����", reg_dt + 5 "������ ��¥", reg_dt - 5 "���� ��¥"
FROM users;

COMMIT;
UPDATE users SET reg_dt = null
WHERE userid = 'moon';

DELETE USERS
WHERE userid not in ('brown', 'cony', 'sally', 'james', 'moon');

SELECT *
FROM users;

COMMIT;

-- 1] prod ���̺��� prod_id, prod_name �� �÷��� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
--      (��, prod_id -> id, prod_name -> name���� �÷� ��Ī�� ����)
SELECT prod_id id, prod_name name
FROM prod;

-- 2] lprod ���̺��� lprod_gu, lprod_nm �� �÷��� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
--      (��, lprod_gu -> gu, lprod_nm -> nm���� �÷� ��Ī�� ����)
SELECT lprod_gu gu, lprod_nm nm
FROM lprod;

-- 3] buyer ���̺��� buyer_id, buyer_name �� �÷��� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
--      (��, buyer_id -> ���̾���̵�, buyer_name -> �̸����� �÷� ��Ī�� ����)
SELECT buyer_id ���̾���̵�, buyer_name �̸�
FROM buyer;

-- ���ڿ� ����
-- java + --> sql ||
-- CONCAT(str, str) �Լ�
-- users ���̺��� userid, usernm
SELECT userid, usernm, userid || usernm "id+name",
        CONCAT (userid, usernm)
FROM users;

-- ���ڿ� ��� (�÷��� ��� �����Ͱ� �ƴ϶� �����ڰ� ���� �Է��� ���ڿ�)
SELECT '����� ���̵� : ' , userid
       -- CONCAT('����� ���̵� : ', userid)
FROM users;

-- �ǽ� sel_conl]
SELECT 'SELECT * FROM ' || table_name QUERY
FROM user_tables;