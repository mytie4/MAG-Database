--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T5-mag-plsql.sql

--Student ID: 32506678
--Student Name: Crystal(Sujung) Shin

/* Comments for your marker:

For convenience and testing purposes, I have set artwork from task 3: "Shattered glass"'s display end date to NULL 
This should not matter as ROLLBACK command will be called after all tests are finished

*/

SET SERVEROUTPUT ON

--(a) 
--Write your trigger statement, 
--finish it with a slash(/) followed by a blank line
CREATE OR REPLACE TRIGGER check_min_price BEFORE
    INSERT ON sale FOR EACH ROW
DECLARE
    var_min_price NUMBER;
    var_gallery_comm NUMBER;
BEGIN
    SELECT artwork_minprice INTO var_min_price
    FROM artwork
    WHERE artist_code = (SELECT artist_code FROM aw_display WHERE aw_display_id = :new.aw_display_id)
    AND artwork_no = (SELECT artwork_no FROM aw_display WHERE aw_display_id = :new.aw_display_id);

    SELECT gallery_sale_percent INTO var_gallery_comm
    FROM gallery
    WHERE gallery_id = (SELECT gallery_id FROM aw_display WHERE aw_display_id = :new.aw_display_id);

    IF (:new.sale_price * (1 - (var_gallery_comm + 20) / 100) < var_min_price) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Sale price below minimum required. Sale cancelled.');
    ELSE
        dbms_output.put_line('New sale data inserted under sale id: '||:new.sale_id);
    END IF;
END;
/

-- Write Test Harness for (a)
-- Before value
SELECT * FROM sale ORDER BY sale_id;

-- Test trigger - Sale price below minimum - failed
BEGIN
    INSERT INTO sale VALUES (
        sale_seq.NEXTVAL,
        sysdate,
        30000,
        2,
        6
    );
END;
/

-- After value
SELECT * FROM sale ORDER BY sale_id;

-- Test trigger - Sale price above minimum - success
BEGIN
    INSERT INTO sale VALUES (
        sale_seq.NEXTVAL,
        sysdate,
        33800,
        2,
        6
    );
END;
/

-- After value
SELECT * FROM sale ORDER BY sale_id;

-- Close the transaction
ROLLBACK;
-- End of Test Harness

--(b) 
-- Complete the procedure below
CREATE OR REPLACE PROCEDURE prc_insert_sale (
    p_customer_id   IN NUMBER,
    p_artist_code   IN NUMBER,
    p_artwork_no    IN NUMBER,
    p_sale_price    IN NUMBER,
    p_output    OUT VARCHAR2
) AS
    var_cust_found NUMBER;
    var_artwork_found NUMBER;
    var_display_found NUMBER;
    var_aw_display_id NUMBER;
    var_cust_art_found NUMBER;
BEGIN
    SELECT count(*) INTO var_cust_found
    FROM customer
    WHERE customer_id = p_customer_id;
    IF (var_cust_found = 0) THEN
        p_output := 'Invalid customer id, Sale insertion cancelled';
    ELSE
        SELECT count(*) INTO var_artwork_found
        FROM artwork
        WHERE artist_code = p_artist_code
        AND artwork_no = p_artwork_no;
        IF (var_artwork_found = 0) THEN
            p_output := 'No such artwork exists in the system, Sale insertion cancelled';
        ELSE
            SELECT count(*) INTO var_display_found
            FROM aw_display
            WHERE artist_code = p_artist_code
            AND artwork_no = p_artwork_no
            AND (aw_display_end_date IS NULL OR aw_display_end_date > sysdate);
            IF (var_display_found = 0) THEN
                p_output := 'Artwork not on display, Sale insertion cancelled';
            ELSE
                SELECT max(aw_display_id) INTO var_aw_display_id
                FROM aw_display
                WHERE artist_code = p_artist_code
                AND artwork_no = p_artwork_no;

                INSERT INTO sale VALUES (
                    sale_seq.NEXTVAL,
                    sysdate,
                    p_sale_price,
                    p_customer_id,
                    var_aw_display_id
                );

                INSERT INTO aw_status VALUES (
                    aw_status_seq.NEXTVAL,
                    p_artist_code,
                    p_artwork_no,
                    sysdate,
                    'S',
                    NULL
                );

                UPDATE aw_display
                SET aw_display_end_date = sysdate
                WHERE artist_code = p_artist_code
                AND artwork_no = p_artwork_no
                AND aw_display_id = var_aw_display_id;
                
                SELECT count(*) INTO var_cust_art_found
                FROM customer_artist
                WHERE artist_code = p_artist_code
                AND customer_id = p_customer_id;

                IF (var_cust_art_found = 0) THEN
                    INSERT into customer_artist VALUES (
                        p_customer_id,
                        p_artist_code,
                        1
                    );
                ELSE
                    UPDATE customer_artist
                    SET cust_art_count = cust_art_count + 1
                    WHERE customer_id = p_customer_id
                    AND artist_code = p_artist_code;
                END IF;

                p_output := 'New sale insert with customer id: '||p_customer_id||', artistc code: '||p_artist_code||
                            ', artwork number: '||p_artwork_no||', with sale price of '||p_sale_price||'.';
            END IF;
        END IF;
    END IF;   
EXCEPTION 
-- catch the error raised by the DML statements
   WHEN OTHERS THEN
      raise_application_error(-20010,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
END;
/

-- Write Test Harness for (b)

--------------------------------------
--Invalid customer id
--------------------------------------
-- Before value
SELECT * FROM sale ORDER BY sale_id;

SELECT * FROM aw_status
WHERE upper(aws_status) = upper('S')
ORDER BY aws_id;

SELECT * FROM aw_display
ORDER BY artist_code, artwork_no;

SELECT * FROM customer_artist
ORDER BY customer_id, artist_code;

-- Execute the procedure - Invalid customer id - failed
DECLARE
    output VARCHAR2(200);
BEGIN
    prc_insert_sale(99, 3, 1, 50000, output);
    dbms_output.put_line(output);
END;
/

-- After value
SELECT * FROM sale ORDER BY sale_id;

SELECT * FROM aw_status
WHERE upper(aws_status) = upper('S')
ORDER BY aws_id;

SELECT * FROM aw_display
ORDER BY artist_code, artwork_no;

SELECT * FROM customer_artist
ORDER BY customer_id, artist_code;


--------------------------------------
--Artwork (artist_code, artwrok_no combination) not in system
--------------------------------------

-- Execute the procedure - Artwork does not exist in system - failed
DECLARE
    output VARCHAR2(200);
BEGIN
    prc_insert_sale(2, 9,9, 50000, output);
    dbms_output.put_line(output);
END;
/

-- After value
SELECT * FROM sale ORDER BY sale_id;

SELECT * FROM aw_status
WHERE upper(aws_status) = upper('S')
ORDER BY aws_id;

SELECT * FROM aw_display
ORDER BY artist_code, artwork_no;

SELECT * FROM customer_artist
ORDER BY customer_id, artist_code;

--------------------------------------
--Artwork not for display (Sold)
--------------------------------------
-- Execute the procedure - Artwork not for display - failed
DECLARE
    output VARCHAR2(200);
BEGIN
    prc_insert_sale(2, 7,2, 80000, output);
    dbms_output.put_line(output);
END;
/

-- After value
SELECT * FROM sale ORDER BY sale_id;

SELECT * FROM aw_status
WHERE upper(aws_status) = upper('S')
ORDER BY aws_id;

SELECT * FROM aw_display
ORDER BY artist_code, artwork_no;

SELECT * FROM customer_artist
ORDER BY customer_id, artist_code;

--------------------------------------
--Sale price below minimum (Trigger fired)
--------------------------------------
-- Execute the procedure - Sale price below minimum - failed
DECLARE
    output VARCHAR2(200);
BEGIN
    prc_insert_sale(2, 8,1, 10000, output);
    dbms_output.put_line(output);
END;
/

-- After value
SELECT * FROM sale ORDER BY sale_id;

SELECT * FROM aw_status
WHERE upper(aws_status) = upper('S')
ORDER BY aws_id;

SELECT * FROM aw_display
ORDER BY artist_code, artwork_no;

SELECT * FROM customer_artist
ORDER BY customer_id, artist_code;

--------------------------------------
--Success (customer have purchased from same artist before)
--------------------------------------
-- Updating a data for testing purposes (will be rolled back later)
UPDATE aw_display
SET aw_display_end_date = NULL
WHERE aw_display_id = 100;

DECLARE
    output VARCHAR2(200);
BEGIN
    prc_insert_sale(1, 1,3, 50000, output);
    dbms_output.put_line(output);
END;
/

-- After value
SELECT * FROM sale ORDER BY sale_id;

SELECT * FROM aw_status
WHERE upper(aws_status) = upper('S')
ORDER BY aws_id;

SELECT * FROM aw_display
ORDER BY artist_code, artwork_no;

SELECT * FROM customer_artist
ORDER BY customer_id, artist_code;

-- Close the transaction
ROLLBACK;

--------------------------------------
--Success (customer have not purchased from same artist before)
--------------------------------------
DECLARE
    output VARCHAR2(200);
BEGIN
    prc_insert_sale(5, 8,1, 70000, output);
    dbms_output.put_line(output);
END;
/

-- After value
SELECT * FROM sale ORDER BY sale_id;

SELECT * FROM aw_status
WHERE upper(aws_status) = upper('S')
ORDER BY aws_id;

SELECT * FROM aw_display
ORDER BY artist_code, artwork_no;

SELECT * FROM customer_artist
ORDER BY customer_id, artist_code;

-- Close the transaction
ROLLBACK;
-- End of Test Harness
