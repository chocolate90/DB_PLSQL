--예외 처리 구문 (EXCEPTION WHEN 예외종류 THEN)

DECLARE
    V_NUM NUMBER := 0;
BEGIN
    V_NUM := 10/0;
    
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('0으로 나눌 수 없습니다.');
END;
