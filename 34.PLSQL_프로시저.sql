/*
���� ���ν��� - �ϳ��� �Լ�ó�� �����ϱ� ���� ������ ����

����� ������ �����ϴ� ������ ������ �ۼ��Ѵ�.
*/

CREATE OR REPLACE PROCEDURE NEW_JOB_PROC --�Ű�����

IS --������ ����

BEGIN --���� ����
    DBMS_OUTPUT.PUT_LINE('HELLO WORLD!');
END;

--���ν����� ����
EXEC NEW_JOB_PROC;

--���ν����� �Ű����� IN����
CREATE OR REPLACE PROCEDURE NEW_JOB_PROC
    (P_JOB_ID IN JOBS.JOB_ID%TYPE,
     P_JOB_TITLE IN JOBS.JOB_TITLE%TYPE,
     P_MIN_SAL IN JOBS.MIN_SALARY%TYPE,
     P_MAX_SAL IN JOBS.MAX_SALARY%TYPE
    ) 
IS

BEGIN
    INSERT INTO JOBS VALUES (P_JOB_ID, P_JOB_TITLE, P_MIN_SAL, P_MAX_SAL);
END;

EXEC NEW_JOB_PROC('SM_MAN1', 'SAMPLE TEST', 1000, 5000);

SELECT * FROM JOBS;

--���ν����� IN������ Ȱ��(Ű���� �ִٸ� UPDATE, ���ٸ� INSERT)

CREATE OR REPLACE PROCEDURE NEW_JOB_PROC
    (P_JOB_ID IN JOBS.JOB_ID%TYPE,
     P_JOB_TITLE IN JOBS.JOB_TITLE%TYPE,
     P_MIN_SAL IN JOBS.MIN_SALARY%TYPE,
     P_MAX_SAL IN JOBS.MAX_SALARY%TYPE
    )
IS
    V_COUNT NUMBER := 0; --��������
BEGIN
    SELECT COUNT(*)
    INTO V_COUNT
    FROM JOBS
    WHERE JOB_ID = P_JOB_ID; --���ν����� �Ű������� ������ ��
    
    IF V_COUNT = 0 THEN
        INSERT INTO JOBS VALUES (P_JOB_ID, P_JOB_TITLE, P_MIN_SAL, P_MAX_SAL);
    ELSE
        UPDATE JOBS
        SET JOB_TITLE = P_JOB_TITLE,
            MIN_SALARY = P_MIN_SAL,
            MAX_SALARY = P_MAX_SAL
        WHERE JOB_ID = P_JOB_ID;
    END IF;
END;

EXEC NEW_JOB_PROC('SM_MAN1', 'SAMPLE TEST', 10000, 20000);

SELECT * FROM JOBS;


--���ν����� ����Ʈ �Ű��� ����

EXEC NEW_JOB_PROC('SM_MAN1', 'SAMPLE TEST'); -- �Ű����� �����ʾ� ����

CREATE OR REPLACE PROCEDURE NEW_JOB_PROC
    (P_JOB_ID IN JOBS.JOB_ID%TYPE,
     P_JOB_TITLE IN JOBS.JOB_TITLE%TYPE,
     P_MIN_SAL IN JOBS.MIN_SALARY%TYPE := 0, --���� �ƹ��͵� ������ �ȵǸ� �⺻�� 0
     P_MAX_SAL IN JOBS.MAX_SALARY%TYPE := 1000 --���� �ƹ��͵� ������ �ȵǸ� �⺻�� 1000
    )
IS
    V_COUNT NUMBER := 0; --��������
BEGIN
    SELECT COUNT(*)
    INTO V_COUNT
    FROM JOBS
    WHERE JOB_ID = P_JOB_ID; --���ν����� �Ű������� ������ ��
    
    IF V_COUNT = 0 THEN
        INSERT INTO JOBS VALUES (P_JOB_ID, P_JOB_TITLE, P_MIN_SAL, P_MAX_SAL);
    ELSE
        UPDATE JOBS
        SET JOB_TITLE = P_JOB_TITLE,
            MIN_SALARY = P_MIN_SAL,
            MAX_SALARY = P_MAX_SAL
        WHERE JOB_ID = P_JOB_ID;
    END IF;
END;

EXEC NEW_JOB_PROC('SM_MAN2', 'SAMPLE', 1000, 2000);
EXEC NEW_JOB_PROC('SM_MAN3', 'SAMPLE TEST');

SELECT * FROM JOBS;

--------------------------------------------------------

--OUT �Ű�����
--���ν����� OUT������ ������ �ִٸ� ���౸���� �͸��Ͽ��� �����Ѵ�.

CREATE OR REPLACE PROCEDURE NEW_JOB_PROC
    (
     P_JOB_ID IN JOBS.JOB_ID%TYPE,
     P_JOB_TITLE IN JOBS.JOB_TITLE%TYPE,
     P_MIN_SAL IN JOBS.MIN_SALARY%TYPE := 0,
     P_MAX_SAL IN JOBS.MAX_SALARY%TYPE := 1000,
     P_RESULT OUT VARCHAR2
    )
IS
    V_COUNT NUMBER := 0; --��������
BEGIN
    SELECT COUNT(*)
    INTO V_COUNT --��������
    FROM JOBS
    WHERE JOB_ID = P_JOB_ID;
    
    IF V_COUNT = 0 THEN
        INSERT INTO JOBS VALUES(P_JOB_ID, P_JOB_TITLE, P_MIN_SAL, P_MAX_SAL);
        P_RESULT := P_JOB_ID; --������ ��쿡�� �ƿ������� ���̵� ����
    ELSE
        UPDATE JOBS
        SET JOB_TITLE = P_JOB_TITLE,
            MIN_SALARY = P_MIN_SAL,
            MAX_SALARY = P_MAX_SAL
        WHERE JOB_ID = P_JOB_ID;
        
    P_RESULT := '�����ϴ� ���̱� ������ ������Ʈ �Ǿ����ϴ�.';--�̹� �����ϴ� ��� ���� ����.
    END IF;
END;

DECLARE
    STR VARCHAR2(100);
BEGIN
    NEW_JOB_PROC('TEST', 'TEST1', 1000, 2000, STR);
    DBMS_OUTPUT.PUT_LINE(STR); --���
END;

SET SERVEROUTPUT ON;

--------------------------------------

--IN OUT ����

CREATE OR REPLACE PROCEDURE TEST_PROC
    (
     P_VAR1 IN VARCHAR2, --�Էº���(��ȯ�Ұ�)
     P_VAR2 OUT VARCHAR2, --��º��� (���ν����� ������ ������ ���� �Ҵ��� �ȵȴ�.)
     P_VAR3 IN OUT VARCHAR2 -- ����º��� (�Ѵ� ����)
    )
IS

BEGIN
    DBMS_OUTPUT.PUT_LINE('P_VAR1�� ��:' || P_VAR1);
    DBMS_OUTPUT.PUT_LINE('P_VAR2�� ��:' || P_VAR2);
    DBMS_OUTPUT.PUT_LINE('P_VAR3�� ��:' || P_VAR3);
    
    --P_VAR1 := '���1'; (IN������ �Ҵ� �Ұ�)
    P_VAR2 := '���2';
    P_VAR3 := '���3';
END;

DECLARE
    V_A VARCHAR2(100) := 'A';
    V_B VARCHAR2(100) := 'B';
    V_C VARCHAR2(100) := 'C';
BEGIN
    TEST_PROC(V_A, V_B, V_C);
    DBMS_OUTPUT.PUT_LINE('V_B ����:' || V_B);
    DBMS_OUTPUT.PUT_LINE('V_C ����:' || V_C);
END;

--------------------------------------------

--���ν����� ���� RETURN 

CREATE OR REPLACE PROCEDURE NEW_JOB_PROC
    (
     P_JOB_ID IN JOBS.JOB_ID%TYPE
    )
IS
    V_COUNT NUMBER := 0;
    V_MIN_TOTAL NUMBER := 0; --�ּ� �޿� ��ü ��
BEGIN
    --���� ���ٸ� ����Ŀ� ���ν����� ���� �ִٸ� �� ���
    
    SELECT COUNT(*)
    INTO V_COUNT
    FROM JOBS
    WHERE JOB_ID LIKE '%' || P_JOB_ID || '%';

    IF V_COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE(P_JOB_ID || '���� �����ϴ�.');
        RETURN; --���ν����� ����
    ELSE
        --P_JOB_ID�� �ּұ޿� ��ü��
        SELECT SUM(MIN_SALARY)
        INTO V_MIN_TOTAL
        FROM JOBS
        WHERE JOB_ID LIKE '%' || P_JOB_ID || '%';
        
        DBMS_OUTPUT.PUT_LINE(P_JOB_ID || '�� MIN_SALARY ��:' || V_MIN_TOTAL);
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('���ν��� ��������');
END;

EXEC NEW_JOB_PROC('TTT');
EXEC NEW_JOB_PROC('MAN');


--��������
/*
EMPLOYEE_ID�� �޾Ƽ� EMPLOYEES�� �����ϸ� �ټӳ���� ���
���ٸ� �����ϴٸ� ����ϴ� ���ν���
*/

CREATE OR REPLACE PROCEDURE NEW_EMP_PROC
    (
     P_EMP_ID IN EMPLOYEES.EMPLOYEE_ID%TYPE
    )
IS --���ν������� ����� �Ű�����
    V_COUNT NUMBER := 0;
    V_YEAR NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO V_COUNT
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = P_EMP_ID;
    
    IF V_COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE(P_EMP_ID || '���� �����ϴ�.');
        RETURN;
    ELSE
        SELECT TRUNC((SYSDATE - HIRE_DATE) / 365)
        INTO V_YEAR
        FROM EMPLOYEES
        WHERE EMPLOYEE_ID = P_EMP_ID;
        
        DBMS_OUTPUT.PUT_LINE(P_EMP_ID || '�� �ټӳ��:' || V_YEAR || '��');
    END IF;
    
    --����ó��
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('�߸� �Է��߽��ϴ�.');
END;

EXEC NEW_EMP_PROC(200);