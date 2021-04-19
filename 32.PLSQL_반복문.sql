SET SERVEROUTPUT ON;

--반복문(WHILE, FOR IN), 탈출문(EXIT, CONTINUE)

--반복문 WHILE
DECLARE
    I NUMBER := 1;
BEGIN
    
    WHILE I <= 9
    LOOP
    
    DBMS_OUTPUT.PUT_LINE(I);
    
    I := I + 1; --변수 1증가
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

--탈출문 EXIT WHEN 조건

--1~10까지 회전 5일 때 탈출
DECLARE
    I NUMBER := 1;
BEGIN

    WHILE I <= 10
    LOOP
    
    DBMS_OUTPUT.PUT_LINE(I);
    EXIT WHEN I = 5; --탈출
    
    I := I + 1;
    END LOOP;

END;

--CONTINUE WHEN 조건

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

--FOR문 FOR I IN 범위

DECLARE
    
BEGIN
    FOR I IN 1..9
    LOOP
    
    DBMS_OUTPUT.PUT_LINE(I*3);
    END LOOP;
END;

--연습문제 1
--2~9단까지 출력

DECLARE

BEGIN

    FOR I IN 2..9
    LOOP
    
    DBMS_OUTPUT.PUT_LINE( I || '단');
        FOR J IN 1..9
            LOOP
            
            DBMS_OUTPUT.PUT_LINE(I || ' * ' || J || ' = ' ||J * I);
            
            END LOOP;
    
    END LOOP;

END;

--연습문제 2
--시퀀스를 이용해서 300행 INSERT
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