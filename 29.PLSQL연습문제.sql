SET SERVEROUTPUT ON;

--1. 구구단 3단을 출력하는 익명블록

DECLARE
    N NUMBER := 3;
BEGIN
    DBMS_OUTPUT.PUT_LINE(N * 1);
    DBMS_OUTPUT.PUT_LINE(N * 2);
    DBMS_OUTPUT.PUT_LINE(N * 3);
    DBMS_OUTPUT.PUT_LINE(N * 4);
    DBMS_OUTPUT.PUT_LINE(N * 5);
    DBMS_OUTPUT.PUT_LINE(N * 6);
    DBMS_OUTPUT.PUT_LINE(N * 7);
    DBMS_OUTPUT.PUT_LINE(N * 8);
    DBMS_OUTPUT.PUT_LINE(N * 9);
END;

--2. 사원테이블의 201번 사원의 이름과 이메일 주소 출력

DECLARE
    EMP_NAME EMPLOYEES.FIRST_NAME%TYPE;
    EMP_EMAIL EMPLOYEES.EMAIL%TYPE;
BEGIN
    SELECT FIRST_NAME,
           EMAIL
    INTO EMP_NAME,
         EMP_EMAIL
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = 201;
    
    DBMS_OUTPUT.PUT_LINE('201번 사원의 이름은 ' || EMP_NAME || ' 이메일은 ' || EMP_EMAIL );
END;

--3. 사원테이블에서 사원번호가 가장 큰 사원을 찾아서 +1번으로
-- 아래 EMPS테이블에 사원번호, 이름, 이메일, 입사일, JOB_ID만 INSERT

CREATE TABLE EMPS AS (SELECT * FROM EMPLOYEES WHERE 1 = 2);

DECLARE
    EMP_ID EMPLOYEES.EMPLOYEE_ID%TYPE;
    EMP_NAME EMPLOYEES.LAST_NAME%TYPE;
    EMP_EMAIL EMPLOYEES.EMAIL%TYPE;
    EMP_DATE EMPLOYEES.HIRE_DATE%TYPE;
    EMP_JOB EMPLOYEES.JOB_ID%TYPE;
BEGIN
    SELECT EMPLOYEE_ID + 1,
           LAST_NAME,
           EMAIL,
           HIRE_DATE,
           JOB_ID
    INTO EMP_ID,
         EMP_NAME,
         EMP_EMAIL,
         EMP_DATE,
         EMP_JOB
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = (SELECT MAX(EMPLOYEE_ID)
        FROM EMPLOYEES);
        
    INSERT INTO EMPS (EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
    VALUES (EMP_ID, EMP_NAME, EMP_EMAIL, EMP_DATE, EMP_JOB);
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE(EMP_ID || '의 이름은 ' || EMP_NAME ||
                        ' 이메일은 ' || EMP_EMAIL|| ' 입사일은 ' || EMP_DATE || 
                        ' 직무는 ' ||EMP_JOB);
END;

SELECT * FROM EMPS;









