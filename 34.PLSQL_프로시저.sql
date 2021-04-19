/*
저장 프로시저 - 하나의 함수처럼 실행하기 위한 쿼리의 집합

만드는 과정과 실행하는 구문을 나누어 작성한다.
*/

CREATE OR REPLACE PROCEDURE NEW_JOB_PROC --매개변수

IS --변수의 선언

BEGIN --실행 영역
    DBMS_OUTPUT.PUT_LINE('HELLO WORLD!');
END;

--프로시저의 실행
EXEC NEW_JOB_PROC;

--프로시저의 매개변수 IN구문
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

--프로시저의 IN변수를 활용(키값이 있다면 UPDATE, 없다면 INSERT)

CREATE OR REPLACE PROCEDURE NEW_JOB_PROC
    (P_JOB_ID IN JOBS.JOB_ID%TYPE,
     P_JOB_TITLE IN JOBS.JOB_TITLE%TYPE,
     P_MIN_SAL IN JOBS.MIN_SALARY%TYPE,
     P_MAX_SAL IN JOBS.MAX_SALARY%TYPE
    )
IS
    V_COUNT NUMBER := 0; --지역변수
BEGIN
    SELECT COUNT(*)
    INTO V_COUNT
    FROM JOBS
    WHERE JOB_ID = P_JOB_ID; --프로시저의 매개변수로 들어오는 값
    
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


--프로시저의 디폴트 매개값 설정

EXEC NEW_JOB_PROC('SM_MAN1', 'SAMPLE TEST'); -- 매개값이 맞지않아 오류

CREATE OR REPLACE PROCEDURE NEW_JOB_PROC
    (P_JOB_ID IN JOBS.JOB_ID%TYPE,
     P_JOB_TITLE IN JOBS.JOB_TITLE%TYPE,
     P_MIN_SAL IN JOBS.MIN_SALARY%TYPE := 0, --만약 아무것도 전달이 안되면 기본값 0
     P_MAX_SAL IN JOBS.MAX_SALARY%TYPE := 1000 --만약 아무것도 전달이 안되면 기본값 1000
    )
IS
    V_COUNT NUMBER := 0; --지역변수
BEGIN
    SELECT COUNT(*)
    INTO V_COUNT
    FROM JOBS
    WHERE JOB_ID = P_JOB_ID; --프로시저의 매개변수로 들어오는 값
    
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

--OUT 매개변수
--프로시저가 OUT변수를 가지고 있다면 실행구문을 익명블록에서 실행한다.

CREATE OR REPLACE PROCEDURE NEW_JOB_PROC
    (
     P_JOB_ID IN JOBS.JOB_ID%TYPE,
     P_JOB_TITLE IN JOBS.JOB_TITLE%TYPE,
     P_MIN_SAL IN JOBS.MIN_SALARY%TYPE := 0,
     P_MAX_SAL IN JOBS.MAX_SALARY%TYPE := 1000,
     P_RESULT OUT VARCHAR2
    )
IS
    V_COUNT NUMBER := 0; --지역변수
BEGIN
    SELECT COUNT(*)
    INTO V_COUNT --지역변수
    FROM JOBS
    WHERE JOB_ID = P_JOB_ID;
    
    IF V_COUNT = 0 THEN
        INSERT INTO JOBS VALUES(P_JOB_ID, P_JOB_TITLE, P_MIN_SAL, P_MAX_SAL);
        P_RESULT := P_JOB_ID; --성공인 경우에는 아웃변수에 아이디를 저장
    ELSE
        UPDATE JOBS
        SET JOB_TITLE = P_JOB_TITLE,
            MIN_SALARY = P_MIN_SAL,
            MAX_SALARY = P_MAX_SAL
        WHERE JOB_ID = P_JOB_ID;
        
    P_RESULT := '존재하는 값이기 때문에 업데이트 되었습니다.';--이미 존재하는 경우 문장 저장.
    END IF;
END;

DECLARE
    STR VARCHAR2(100);
BEGIN
    NEW_JOB_PROC('TEST', 'TEST1', 1000, 2000, STR);
    DBMS_OUTPUT.PUT_LINE(STR); --결과
END;

SET SERVEROUTPUT ON;

--------------------------------------

--IN OUT 변수

CREATE OR REPLACE PROCEDURE TEST_PROC
    (
     P_VAR1 IN VARCHAR2, --입력변수(반환불가)
     P_VAR2 OUT VARCHAR2, --출력변수 (프로시저가 끝나기 전에는 값의 할당이 안된다.)
     P_VAR3 IN OUT VARCHAR2 -- 입출력변수 (둘다 가능)
    )
IS

BEGIN
    DBMS_OUTPUT.PUT_LINE('P_VAR1의 값:' || P_VAR1);
    DBMS_OUTPUT.PUT_LINE('P_VAR2의 값:' || P_VAR2);
    DBMS_OUTPUT.PUT_LINE('P_VAR3의 값:' || P_VAR3);
    
    --P_VAR1 := '결과1'; (IN변수는 할당 불가)
    P_VAR2 := '결과2';
    P_VAR3 := '결과3';
END;

DECLARE
    V_A VARCHAR2(100) := 'A';
    V_B VARCHAR2(100) := 'B';
    V_C VARCHAR2(100) := 'C';
BEGIN
    TEST_PROC(V_A, V_B, V_C);
    DBMS_OUTPUT.PUT_LINE('V_B 변수:' || V_B);
    DBMS_OUTPUT.PUT_LINE('V_C 변수:' || V_C);
END;

--------------------------------------------

--프로시저의 종료 RETURN 

CREATE OR REPLACE PROCEDURE NEW_JOB_PROC
    (
     P_JOB_ID IN JOBS.JOB_ID%TYPE
    )
IS
    V_COUNT NUMBER := 0;
    V_MIN_TOTAL NUMBER := 0; --최소 급여 전체 합
BEGIN
    --값이 없다면 출력후에 프로시저를 종료 있다면 값 출력
    
    SELECT COUNT(*)
    INTO V_COUNT
    FROM JOBS
    WHERE JOB_ID LIKE '%' || P_JOB_ID || '%';

    IF V_COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE(P_JOB_ID || '값이 없습니다.');
        RETURN; --프로시저의 종료
    ELSE
        --P_JOB_ID의 최소급여 전체합
        SELECT SUM(MIN_SALARY)
        INTO V_MIN_TOTAL
        FROM JOBS
        WHERE JOB_ID LIKE '%' || P_JOB_ID || '%';
        
        DBMS_OUTPUT.PUT_LINE(P_JOB_ID || '의 MIN_SALARY 합:' || V_MIN_TOTAL);
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('프로시저 정상종료');
END;

EXEC NEW_JOB_PROC('TTT');
EXEC NEW_JOB_PROC('MAN');


--연습문제
/*
EMPLOYEE_ID를 받아서 EMPLOYEES에 존재하면 근속년수를 출력
없다면 없습니다를 출력하는 프로시저
*/

CREATE OR REPLACE PROCEDURE NEW_EMP_PROC
    (
     P_EMP_ID IN EMPLOYEES.EMPLOYEE_ID%TYPE
    )
IS --프로시저에서 사용할 매개변수
    V_COUNT NUMBER := 0;
    V_YEAR NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO V_COUNT
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = P_EMP_ID;
    
    IF V_COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE(P_EMP_ID || '값이 없습니다.');
        RETURN;
    ELSE
        SELECT TRUNC((SYSDATE - HIRE_DATE) / 365)
        INTO V_YEAR
        FROM EMPLOYEES
        WHERE EMPLOYEE_ID = P_EMP_ID;
        
        DBMS_OUTPUT.PUT_LINE(P_EMP_ID || '의 근속년수:' || V_YEAR || '년');
    END IF;
    
    --예외처리
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('잘못 입력했습니다.');
END;

EXEC NEW_EMP_PROC(200);