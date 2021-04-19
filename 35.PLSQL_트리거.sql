/*
트리거(TRIGGER)
트리거는 테이블에 부착해서 사용하는 형태로 INSERT, UPDATE, DELETE 작업이
수행될 때 특정 코드가 동작하도록 하는 구문이다.

트리거의 종류
AFTER - DML문 직후에 동작하는 트리거
BEFORE - DML문 이전에 동작하는 트리거
INSTEAD OF - 뷰에 부착하는 트리거

트리거의 형태
CREATE OR REPLACE TRIGGER 트리거명
    트리거타입
    ON 부착시킬 테이블
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
    AFTER DELETE OR UPDATE --삭제 OR 업데이트 이후에 동작
    ON TBL_TEST --부착시킬 테이블
    FOR EACH ROW --모든행에 적용하는 OPTION
BEGIN
    DBMS_OUTPUT.PUT_LINE('트리거가 동작함');
END;

--트리거 동작 확인
INSERT INTO TBL_TEST VALUES(1, '홍길동');
INSERT INTO TBL_TEST VALUES(2, '이순신');

UPDATE TBL_TEST
SET TEXT = '홍길자'
WHERE ID = 1;

DELETE FROM TBL_TEST
WHERE ID = 2;

-----------------------------------------------------
/*
트리거 변수 참조 키워드
:OLD - 참조 전 COLUMN값 (INSERT : 입력 전 자료, UPDATE : 수정 전 자료, DELETE : 삭제 전 자료)
:NEW - 참조 후 COLUMN값 (INSERT : 입력 후 자료, UPDATE : 수정 후 자료)
*/

--UPDATE OR DELETE를 시도하면 기존 자료를 백업 테이블에 보관

--AFTER 트리거는 보통 UPDATE, DELETE 사용 (:OLD, :NEW)
--BEFORE 트리거는 보통 INSERT 사용 (:OLD, :NEW)
CREATE TABLE TBL_USER
    (
     ID VARCHAR2(30) PRIMARY KEY,
     NAME VARCHAR(30)
    );

CREATE TABLE TBL_USER_BACKUP
    (
     ID VARCHAR2(30),
     NAME VARCHAR2(30),
     UPDATE_DATE DATE DEFAULT SYSDATE, -- 변경 날짜
     MODIFY_TYPE CHAR(1), -- 변경 OR 삭제 타입
     MODIFY_USER VARCHAR2(30) --변경한 사람
    );
    
    
--AFTER 트리거
CREATE OR REPLACE TRIGGER USER_BACKUP_TRI
    AFTER UPDATE OR DELETE
    ON TBL_USER
    FOR EACH ROW
DECLARE
    V_TYPE VARCHAR2(10); -- 트리거에서 사용할 변수
BEGIN
    IF UPDATING THEN --UPDATING은 시스템에서 지원하는 구문
        V_TYPE := 'U';
    ELSIF DELETING THEN --DELETE 되었을 때
        V_TYPE := 'D';
    END IF;
    
    --BACKUP 테이블에 동작할 기능
    --USER()는 현재 계정
    INSERT INTO TBL_USER_BACKUP VALUES(:OLD.ID, :OLD.NAME, SYSDATE, V_TYPE, USER());
END;

--트리거 확인
INSERT INTO TBL_USER VALUES ('TEST1', 'ADMIN1');
INSERT INTO TBL_USER VALUES ('TEST2', 'ADMIN2');
INSERT INTO TBL_USER VALUES ('TEST3', 'ADMIN3');

UPDATE TBL_USER
SET NAME = '홍길동'
WHERE ID = 'TEST1';

DELETE FROM TBL_USER
WHERE ID = 'TEST2';

SELECT * FROM TBL_USER_BACKUP;

-----------------------------------------------

--BEFORE 트리거
--TBL_USER 테이블에 이름이 저장될 때 **를 붙여서 저장

CREATE OR REPLACE TRIGGER USER_INSERT_TRI
   BEFORE INSERT
   ON TBL_USER
   FOR EACH ROW
DECLARE
    
BEGIN
    --INSERT에서 :OLD는 전부 NULL
    :NEW.NAME := SUBSTR(:NEW.NAME, 1, 1) || '***';
    
    DBMS_OUTPUT.PUT_LINE(:NEW.NAME);
END;

--트리거 동작
INSERT INTO TBL_USER VALUES('A123', '홍길동');
INSERT INTO TBL_USER VALUES('B123', '이순신');
INSERT INTO TBL_USER VALUES('C123', '박찬호');

SELECT * FROM TBL_USER;

------------------------------------------

/*
트리거 응용
주문 기록테이블: 주문번호 50000번
*/

--주문상세
CREATE TABLE ORDER_DETAIL
    (
     DETAIL_NO NUMBER(10) PRIMARY KEY,
     O_NO NUMBER(10), --FK(주문번호)
     P_NO NUMBER(10), --FK(상품번호)
     DETAIL_TOTAL NUMBER(10), --주문수량
     DETAIL_PRICE NUMBER(10) --주문금액
    );

DROP TABLE ORDER_DETAIL;
--상세
CREATE TABLE PRODUCT
    (
     P_NO NUMBER(10) PRIMARY KEY,
     P_NAME VARCHAR2(20),
     P_TOTAL NUMBER(5), --남은수량
     P_PRICE NUMBER(10)
    );
    
INSERT INTO PRODUCT VALUES(1, '피자', 100, 10000);
INSERT INTO PRODUCT VALUES(2, '치킨', 100, 15000);
INSERT INTO PRODUCT VALUES(3, '햄버거', 100, 5000);

SELECT * FROM PRODUCT;

--주문이 들어오면 상품테이블의 수량 감소 트리거
CREATE OR REPLACE TRIGGER ORDER_DETAIL_TRI
    AFTER INSERT
    ON ORDER_DETAIL
    FOR EACH ROW
DECLARE
    V_DETAIL_TOTAL NUMBER(10) := :NEW.DETAIL_TOTAL; --주문에 들어오는 수량
    V_NO PRODUCT.P_NO%TYPE := :NEW.P_NO; --주문에 들어오는 상품번호
BEGIN
    --상품테이블에 적용될 UPDATE문
    UPDATE PRODUCT
    SET P_TOTAL = P_TOTAL - V_DETAIL_TOTAL
    WHERE P_NO = V_NO;
END;

--트리거 동작 확인
INSERT INTO ORDER_DETAIL VALUES(1, 50000, 1, 5, 50000);
INSERT INTO ORDER_DETAIL VALUES(2, 50000, 2, 2, 30000);
INSERT INTO ORDER_DETAIL VALUES(3, 50000, 3, 3, 15000);

SELECT * FROM PRODUCT;