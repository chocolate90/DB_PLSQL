--���� ó�� ���� (EXCEPTION WHEN �������� THEN)

DECLARE
    V_NUM NUMBER := 0;
BEGIN
    V_NUM := 10/0;
    
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('0���� ���� �� �����ϴ�.');
END;
