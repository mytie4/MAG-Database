/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T3-mag-dml.sql

--Student ID: 32506678
--Student Name: Crystal(Sujung) Shin

/* Comments for your marker:

1. Task d: Uses the values presented in the brief, overlooking the inconsistency of minimum artist payment.
2. Task d: Uses max() for future use: when theres multiple displays for "Shattered glass", use the most recent one
3. Task e: Assumes that there is only 1 "S" status per artwork, as they get deleted when sales get cancelled
4. to_date('1-Jan-2024','DD-MON-YYYY') + 1 + 13 : used +13 instead of +14 due to inclusive nature of "14 days duration"
*/

/*(a)*/
-- Drop sequence
DROP SEQUENCE aw_display_seq;
DROP SEQUENCE aw_status_seq;
DROP SEQUENCE sale_seq;

-- Create sequence
CREATE SEQUENCE aw_display_seq START WITH 100 INCREMENT BY 10;
CREATE SEQUENCE aw_status_seq START WITH 100 INCREMENT BY 10;
CREATE SEQUENCE sale_seq START WITH 100 INCREMENT BY 10;

/*(b)*/
-- Insert data for new artwork
INSERT INTO artwork VALUES (
    1,
    NVL((SELECT max(artwork_no) FROM artwork WHERE artist_code = 1), 0) + 1,
    'Shattered glass',
    25000,
    TO_DATE('30-Dec-2023', 'DD-MON-YYYY')
);

-- Insert status of the artwork
INSERT INTO aw_status VALUES (
    aw_status_seq.NEXTVAL,
    1,
    (SELECT max(artwork_no) FROM artwork WHERE artist_code = 1),
    to_date('30-DEC-2023 11:00', 'DD-MON-YYYY HH24:MI'),
    'W',
    NULL
);

COMMIT;

/*(c)*/
-- Transit
INSERT INTO aw_status VALUES (
    aw_status_seq.NEXTVAL,
    1,
    (SELECT artwork_no FROM artwork WHERE upper(artwork_title) = upper('Shattered glass')),
    to_date('1-Jan-2024 13:00','DD-MON-YYYY HH24:MI'),
    'T',
    (SELECT gallery_id FROM gallery WHERE gallery_phone = '0490556646')
);

COMMIT;

-- Arrival
INSERT INTO aw_status VALUES (
    aw_status_seq.NEXTVAL,
    1,
    (SELECT artwork_no FROM artwork WHERE upper(artwork_title) = upper('Shattered glass')),
    to_date('1-Jan-2024 13:00','DD-MON-YYYY HH24:MI') + (2/24 + 30/1440),
    'G',
    (SELECT gallery_id FROM gallery WHERE gallery_phone = '0490556646')
);

COMMIT;

-- Display
INSERT INTO aw_display VALUES (
    aw_display_seq.NEXTVAL,
    1,
    (SELECT artwork_no FROM artwork WHERE upper(artwork_title) = upper('Shattered glass')),
    to_date('1-Jan-2024','DD-MON-YYYY') + 1,
    to_date('1-Jan-2024','DD-MON-YYYY') + 1 + 13,
    (SELECT gallery_id FROM gallery WHERE gallery_phone = '0490556646')
);

COMMIT;

/*(d)*/
-- Insert sale data
INSERT INTO sale VALUES (
    sale_seq.NEXTVAL,
    to_date('04-Jan-2024', 'DD-MON-YYYY'),
    29499.99,
    (SELECT customer_id FROM customer WHERE customer_phone = '0458708402'),
    (SELECT max(aw_display_id) 
     FROM aw_display 
     WHERE artist_code = (SELECT artist_code FROM artwork WHERE upper(artwork_title) = upper('Shattered glass')) 
     AND artwork_no =  (SELECT artwork_no FROM artwork WHERE upper(artwork_title) = upper('Shattered glass')))
);

-- Insert sold artwork's status
INSERT INTO aw_status VALUES (
    aw_status_seq.NEXTVAL,
    1,
    (SELECT artwork_no FROM artwork WHERE upper(artwork_title) = upper('Shattered glass')),
    to_date('4-Jan-2024 11:30','DD-MON-YYYY HH24:MI'),
    'S',
    NULL
);

-- Update display end date
UPDATE aw_display
SET aw_display_end_date = to_date('04-JAN-2024', 'DD-MON-YYYY')
WHERE aw_display_id = 
(SELECT max(aw_display_id)  
     FROM aw_display 
     WHERE artist_code = (SELECT artist_code FROM artwork WHERE upper(artwork_title) = upper('Shattered glass')) 
     AND artwork_no =  (SELECT artwork_no FROM artwork WHERE upper(artwork_title) = upper('Shattered glass')));


COMMIT;

/*(e)*/
-- Delete sale data
DELETE FROM sale
WHERE customer_id = (SELECT customer_id FROM customer WHERE customer_phone = '0458708402')
AND aw_display_id = 
(SELECT max(aw_display_id)  
     FROM aw_display 
     WHERE artist_code = (SELECT artist_code FROM artwork WHERE upper(artwork_title) = upper('Shattered glass')) 
     AND artwork_no =  (SELECT artwork_no FROM artwork WHERE upper(artwork_title) = upper('Shattered glass')));

-- Delete aw_status data
DELETE FROM aw_status
WHERE upper(aws_status) = upper('S')
AND artist_code = 1
AND artwork_no = (SELECT artwork_no FROM artwork WHERE upper(artwork_title) = upper('Shattered glass'));

-- Update display end date to its original end date
UPDATE aw_display
SET aw_display_end_date = to_date('1-Jan-2024','DD-MON-YYYY') + 1 + 13
WHERE artist_code = 1
AND artwork_no = (SELECT artwork_no FROM artwork WHERE upper(artwork_title) = upper('Shattered glass'))
AND aw_display_start_date = to_date('1-Jan-2024','DD-MON-YYYY') + 1;

COMMIT;


