SET SERVEROUTPUT ON;

--�ݺ���(WHILE, FOR IN), Ż�⹮(EXIT, CONTINUE)

--�ݺ��� WHILE
DECLARE
    I NUMBER := 1;
BEGIN
    
    WHILE I <= 9
    LOOP
    
    DBMS_OUTPUT.PUT_LINE(I);
    
    I := I + 1; --���� 1����
    END LOOP;
    
END;

DECLARE
    I NUMBER := 1;
BEGIN

    WHILE I <= 9
    LOOP
    
    DBMS_OUTPUT.PUT_LINE( '3 * '|| I || ' = ' || 3*I);
    
    I := I + 1;
    END LOOP;

END;

--Ż�⹮ EXIT WHEN ����

--1~10���� ȸ�� 5�� �� Ż��
DECLARE
    I NUMBER := 1;
BEGIN

    WHILE I <= 10
    LOOP
    
    DBMS_OUTPUT.PUT_LINE(I);
    EXIT WHEN I = 5; --Ż��
    
    I := I + 1;
    END LOOP;

END;

--CONTINUE WHEN ����

DECLARE
    I NUMBER := 0;
BEGIN
    WHILE I < 10
    LOOP
    I := I + 1;
    CONTINUE WHEN MOD(I,2) = 1;
    DBMS_OUTPUT.PUT_LINE(I);
    
    
    END LOOP;
END;

--FOR�� FOR I IN ����

DECLARE
    
BEGIN
    FOR I IN 1..9
    LOOP
    
    DBMS_OUTPUT.PUT_LINE(I*3);
    END LOOP;
END;

--�������� 1
--2~9�ܱ��� ���

DECLARE

BEGIN

    FOR I IN 2..9
    LOOP
    
    DBMS_OUTPUT.PUT_LINE( I || '��');
        FOR J IN 1..9
            LOOP
            
            DBMS_OUTPUT.PUT_LINE(I || ' * ' || J || ' = ' ||J * I);
            
            END LOOP;
    
    END LOOP;

END;

--�������� 2
--�������� �̿��ؼ� 300�� INSERT
CREATE TABLE TEST1(
    BNO NUMBER(10) PRIMARY KEY,
    WRITER VARCHAR2(30),
    TITLE VARCHAR2(30)
);

CREATE SEQUENCE TEST1_SEQ
    INCREMENT BY 1
    START WITH 1;
    
DECLARE

BEGIN
    FOR I IN 1..300
    LOOP
    
    INSERT INTO TEST1 VALUES (TEST1_SEQ.NEXTVAL, 'TEST', 'TEST');
    
    END LOOP;
END;

SELECT * FROM TEST1;