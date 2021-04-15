-- DB���� ������ ����
SELECT TRUNC(DBMS_RANDOM.VALUE(1, 11)) FROM DUAL;


-- IF�� (IF ���� THEN ELSE END IF)
DECLARE
    NUM1 NUMBER := 5;
    NUM2 NUMBER := TRUNC(DBMS_RANDOM.VALUE(1, 11));
BEGIN
    IF NUM1 >= NUM2 THEN 
        DBMS_OUTPUT.PUT_LINE(NUM1 || ' ū��');
    ELSE  DBMS_OUTPUT.PUT_LINE(NUM2 || ' ū��');
    END IF;
END;

-- ELSIF��
DECLARE
    RAN_NUM NUMBER := TRUNC(DBMS_RANDOM.VALUE(1, 101));
BEGIN
    IF RAN_NUM >= 90 THEN
        DBMS_OUTPUT.PUT_LINE('A���� �Դϴ�.');
    ELSIF RAN_NUM >= 80 THEN
        DBMS_OUTPUT.PUT_LINE('B���� �Դϴ�.');
    ELSIF RAN_NUM >= 70 THEN
        DBMS_OUTPUT.PUT_LINE('C���� �Դϴ�.');
    ELSE DBMS_OUTPUT.PUT_LINE('�����ϼ��� �����Դϴ�.');
    END IF;
END;

/*
ù��° ���� ROWNUM�� �̿��Ѵ�.
1-120������ ������ ��ȣ�� �̿��ؼ� ���� DEPARTMENT_ID�� ù��° �ุ SELECT
���� ����� SALARY�� 9000�̻��̸� ����, 5000�̻��̸� �߰� �������� ����
*/

SELECT *
FROM DEPARTMENTS;

DECLARE
    NUM1 NUMBER := ROUND(DBMS_RANDOM.VALUE(1, 120), -1);
    EMP_SAL EMPLOYEES.SALARY%TYPE;
BEGIN
    SELECT SALARY
    INTO EMP_SAL
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID = NUM1 AND ROWNUM = 1;
    
    IF EMP_SAL >= 9000 THEN
        DBMS_OUTPUT.PUT_LINE(EMP_SAL || '����');
    ELSIF EMP_SAL >= 5000 THEN
        DBMS_OUTPUT.PUT_LINE(EMP_SAL || '�߰�');
    ELSE DBMS_OUTPUT.PUT_LINE(EMP_SAL || '����');
    END IF;
END;