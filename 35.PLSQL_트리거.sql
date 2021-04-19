/*
Ʈ����(TRIGGER)
Ʈ���Ŵ� ���̺� �����ؼ� ����ϴ� ���·� INSERT, UPDATE, DELETE �۾���
����� �� Ư�� �ڵ尡 �����ϵ��� �ϴ� �����̴�.

Ʈ������ ����
AFTER - DML�� ���Ŀ� �����ϴ� Ʈ����
BEFORE - DML�� ������ �����ϴ� Ʈ����
INSTEAD OF - �信 �����ϴ� Ʈ����

Ʈ������ ����
CREATE OR REPLACE TRIGGER Ʈ���Ÿ�
    Ʈ����Ÿ��
    ON ������ų ���̺�
    OPTION(FOR EACH ROW)
BEGIN

END;
*/

SET SERVEROUTPUT ON;

CREATE TABLE TBL_TEST
    (
     ID NUMBER(10),
     TEXT VARCHAR2(50)
    );
    
CREATE OR REPLACE TRIGGER TBL_TEST_TRI
    AFTER DELETE OR UPDATE --���� OR ������Ʈ ���Ŀ� ����
    ON TBL_TEST --������ų ���̺�
    FOR EACH ROW --����࿡ �����ϴ� OPTION
BEGIN
    DBMS_OUTPUT.PUT_LINE('Ʈ���Ű� ������');
END;

--Ʈ���� ���� Ȯ��
INSERT INTO TBL_TEST VALUES(1, 'ȫ�浿');
INSERT INTO TBL_TEST VALUES(2, '�̼���');

UPDATE TBL_TEST
SET TEXT = 'ȫ����'
WHERE ID = 1;

DELETE FROM TBL_TEST
WHERE ID = 2;

-----------------------------------------------------
/*
Ʈ���� ���� ���� Ű����
:OLD - ���� �� COLUMN�� (INSERT : �Է� �� �ڷ�, UPDATE : ���� �� �ڷ�, DELETE : ���� �� �ڷ�)
:NEW - ���� �� COLUMN�� (INSERT : �Է� �� �ڷ�, UPDATE : ���� �� �ڷ�)
*/

--UPDATE OR DELETE�� �õ��ϸ� ���� �ڷḦ ��� ���̺� ����

--AFTER Ʈ���Ŵ� ���� UPDATE, DELETE ��� (:OLD, :NEW)
--BEFORE Ʈ���Ŵ� ���� INSERT ��� (:OLD, :NEW)
CREATE TABLE TBL_USER
    (
     ID VARCHAR2(30) PRIMARY KEY,
     NAME VARCHAR(30)
    );

CREATE TABLE TBL_USER_BACKUP
    (
     ID VARCHAR2(30),
     NAME VARCHAR2(30),
     UPDATE_DATE DATE DEFAULT SYSDATE, -- ���� ��¥
     MODIFY_TYPE CHAR(1), -- ���� OR ���� Ÿ��
     MODIFY_USER VARCHAR2(30) --������ ���
    );
    
    
--AFTER Ʈ����
CREATE OR REPLACE TRIGGER USER_BACKUP_TRI
    AFTER UPDATE OR DELETE
    ON TBL_USER
    FOR EACH ROW
DECLARE
    V_TYPE VARCHAR2(10); -- Ʈ���ſ��� ����� ����
BEGIN
    IF UPDATING THEN --UPDATING�� �ý��ۿ��� �����ϴ� ����
        V_TYPE := 'U';
    ELSIF DELETING THEN --DELETE �Ǿ��� ��
        V_TYPE := 'D';
    END IF;
    
    --BACKUP ���̺� ������ ���
    --USER()�� ���� ����
    INSERT INTO TBL_USER_BACKUP VALUES(:OLD.ID, :OLD.NAME, SYSDATE, V_TYPE, USER());
END;

--Ʈ���� Ȯ��
INSERT INTO TBL_USER VALUES ('TEST1', 'ADMIN1');
INSERT INTO TBL_USER VALUES ('TEST2', 'ADMIN2');
INSERT INTO TBL_USER VALUES ('TEST3', 'ADMIN3');

UPDATE TBL_USER
SET NAME = 'ȫ�浿'
WHERE ID = 'TEST1';

DELETE FROM TBL_USER
WHERE ID = 'TEST2';

SELECT * FROM TBL_USER_BACKUP;

-----------------------------------------------

--BEFORE Ʈ����
--TBL_USER ���̺� �̸��� ����� �� **�� �ٿ��� ����

CREATE OR REPLACE TRIGGER USER_INSERT_TRI
   BEFORE INSERT
   ON TBL_USER
   FOR EACH ROW
DECLARE
    
BEGIN
    --INSERT���� :OLD�� ���� NULL
    :NEW.NAME := SUBSTR(:NEW.NAME, 1, 1) || '***';
    
    DBMS_OUTPUT.PUT_LINE(:NEW.NAME);
END;

--Ʈ���� ����
INSERT INTO TBL_USER VALUES('A123', 'ȫ�浿');
INSERT INTO TBL_USER VALUES('B123', '�̼���');
INSERT INTO TBL_USER VALUES('C123', '����ȣ');

SELECT * FROM TBL_USER;

------------------------------------------

/*
Ʈ���� ����
�ֹ� ������̺�: �ֹ���ȣ 50000��
*/

--�ֹ���
CREATE TABLE ORDER_DETAIL
    (
     DETAIL_NO NUMBER(10) PRIMARY KEY,
     O_NO NUMBER(10), --FK(�ֹ���ȣ)
     P_NO NUMBER(10), --FK(��ǰ��ȣ)
     DETAIL_TOTAL NUMBER(10), --�ֹ�����
     DETAIL_PRICE NUMBER(10) --�ֹ��ݾ�
    );

DROP TABLE ORDER_DETAIL;
--��
CREATE TABLE PRODUCT
    (
     P_NO NUMBER(10) PRIMARY KEY,
     P_NAME VARCHAR2(20),
     P_TOTAL NUMBER(5), --��������
     P_PRICE NUMBER(10)
    );
    
INSERT INTO PRODUCT VALUES(1, '����', 100, 10000);
INSERT INTO PRODUCT VALUES(2, 'ġŲ', 100, 15000);
INSERT INTO PRODUCT VALUES(3, '�ܹ���', 100, 5000);

SELECT * FROM PRODUCT;

--�ֹ��� ������ ��ǰ���̺��� ���� ���� Ʈ����
CREATE OR REPLACE TRIGGER ORDER_DETAIL_TRI
    AFTER INSERT
    ON ORDER_DETAIL
    FOR EACH ROW
DECLARE
    V_DETAIL_TOTAL NUMBER(10) := :NEW.DETAIL_TOTAL; --�ֹ��� ������ ����
    V_NO PRODUCT.P_NO%TYPE := :NEW.P_NO; --�ֹ��� ������ ��ǰ��ȣ
BEGIN
    --��ǰ���̺� ����� UPDATE��
    UPDATE PRODUCT
    SET P_TOTAL = P_TOTAL - V_DETAIL_TOTAL
    WHERE P_NO = V_NO;
END;

--Ʈ���� ���� Ȯ��
INSERT INTO ORDER_DETAIL VALUES(1, 50000, 1, 5, 50000);
INSERT INTO ORDER_DETAIL VALUES(2, 50000, 2, 2, 30000);
INSERT INTO ORDER_DETAIL VALUES(3, 50000, 3, 3, 15000);

SELECT * FROM PRODUCT;