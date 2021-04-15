/*
PL/SQL�� ���α׷���� SQL���̴�.
���������� �������� � ������ �ϰ�ó���ϱ� ���� �뵵�� ����Ѵ�.

������SQL�� ������ �����ȿ��� �������ϴ� �������� �����Ѵ�.
*/

SET SERVEROUTPUT ON; -- ��¹� Ȱ��ȭ

DECLARE -- ���� ����
    VI_NUM NUMBER; -- ���� ����
BEGIN -- ����
    VI_NUM := 10; -- :=�� ����
    DBMS_OUTPUT.PUT_LINE(VI_NUM);
END; -- ��

--������ (*, +, -, /, <>, =, **(����))
DECLARE
    A NUMBER := (2 * 3 + 2) **3;
BEGIN
    DBMS_OUTPUT.PUT_LINE('A=' || A );
END;


/*
DML���� ȥ���ؼ� ���
DDL������ ����� �� ���� �Ϲ������� SELECT������ ����Ѵ�.
Ư���� ���� SELECT�� �Ʒ��� INTO���� ����Ѵ�.
*/

DECLARE
    EMP_NAME VARCHAR2(50);
    DEP_NAME VARCHAR2(50);
BEGIN
    SELECT E.FIRST_NAME,
           D.DEPARTMENT_NAME
    INTO EMP_NAME,
         DEP_NAME
    FROM EMPLOYEES E
    LEFT OUTER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
    WHERE EMPLOYEE_iD = 100;
    
    DBMS_OUTPUT.PUT_LINE(EMP_NAME || '�� �μ��� ' || DEP_NAME);
END;


/*
������ ������ SELECT�� ��ȸ�� ����� ������ Ÿ���� �ٸ��� ������ �߻���Ű�µ�
�ش� ���̺��� �÷��� ������ Ÿ���� ������ �����Ϸ��� ���̺�.�÷���%TYPE���� ����Ѵ�.
*/
DECLARE
    EMP_NAME EMPLOYEES.FIRST_NAME%TYPE;
    EMP_DATE EMPLOYEES.HIRE_DATE%TYPE;
    EMP_SAL EMPLOYEES.SALARY%TYPE;
BEGIN
    SELECT FIRST_NAME,
           HIRE_DATE,
           SALARY
    INTO EMP_NAME,
         EMP_DATE,
         EMP_SAL
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = 100;
    
    DBMS_OUTPUT.PUT_LINE(EMP_NAME || '�� �Ի����� ' || EMP_DATE || ' �޿��� ' || EMP_SAL);
END;

/*
SELECT���� INSERT�� DML���� ���� ����� �� �ִ�.
*/

CREATE TABLE EMP_SAL(
    EMP_YEARS VARCHAR(50),
    EMP_SALARY NUMBER(10)
);

SELECT SUM(SALARY)
FROM EMPLOYEES
WHERE TO_CHAR(HIRE_DATE, 'YYYY') = 2008;

-- �⵵�� ����� �޿����� ���ؼ� ���ο� ���̺� INSERT
DECLARE
    EMP_SUM EMPLOYEES.SALARY%TYPE;
    EMP_YEARS EMP_SAL.EMP_YEARS%TYPE := 2008;
BEGIN
    -- SELECT
    SELECT SUM(SALARY)
    INTO EMP_SUM
    FROM EMPLOYEES
    WHERE TO_CHAR(HIRE_DATE, 'YYYY') = EMP_YEARS;
    
    -- INSERT
    INSERT INTO EMP_SAL
    VALUES (EMP_YEARS, EMP_SUM);
    
    --COMMIT
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(EMP_SUM);
END;

SELECT *
FROM EMP_SAL;