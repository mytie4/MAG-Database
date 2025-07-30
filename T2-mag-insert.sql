/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T2-mag-insert.sql

--Student ID: 32506678
--Student Name: Crystal(Sujung) Shin

/* Comments for your marker:

1. All artworks sent to one specific gallery are shipped together 
- Thus they have same shipping date/time and arrival date/time

2. Gallery id is not record on aw_status when an artwork is sold
- an artwork does not belong to the gallery anymore
*/

--------------------------------------
--INSERT INTO aw_display
--------------------------------------
INSERT INTO aw_display VALUES (1, 1, 1, to_date('1-Jul-2023', 'DD-MON-YYYY'), NULL, 1);
INSERT INTO aw_display VALUES (2, 2, 1, to_date('1-Jul-2023', 'DD-MON-YYYY'), NULL, 1);
INSERT INTO aw_display VALUES (3, 7, 1, to_date('2-Jul-2023', 'DD-MON-YYYY'), NULL, 1);
INSERT INTO aw_display VALUES (4, 1, 2, to_date('3-Jul-2023', 'DD-MON-YYYY'), NULL, 2);
INSERT INTO aw_display VALUES (5, 7, 2, to_date('3-Jul-2023', 'DD-MON-YYYY'), NULL, 2);

INSERT INTO aw_display VALUES (6, 3, 1, to_date('13-Nov-2023', 'DD-MON-YYYY'), NULL, 3);
INSERT INTO aw_display VALUES (7, 4, 1, to_date('14-Nov-2023', 'DD-MON-YYYY'), NULL, 3);
INSERT INTO aw_display VALUES (8, 5, 1, to_date('15-Nov-2023', 'DD-MON-YYYY'), NULL, 3);
INSERT INTO aw_display VALUES (9, 8, 1, to_date('16-Nov-2023', 'DD-MON-YYYY'), NULL, 4);
INSERT INTO aw_display VALUES (10, 9, 1, to_date('17-Nov-2023', 'DD-MON-YYYY'), NULL, 4);
--------------------------------------
--INSERT INTO aw_status
--------------------------------------
-- Transit
INSERT INTO aw_status VALUES (14, 1, 1, to_date('28-Jun-2023 10:00', 'DD-MON-YYYY HH24:MI'), 'T', 1);
INSERT INTO aw_status VALUES (15, 2, 1, to_date('28-Jun-2023 10:00', 'DD-MON-YYYY HH24:MI'), 'T', 1);
INSERT INTO aw_status VALUES (16, 7, 1, to_date('28-Jun-2023 10:00', 'DD-MON-YYYY HH24:MI'), 'T', 1);
INSERT INTO aw_status VALUES (17, 1, 2, to_date('28-Jun-2023 12:00', 'DD-MON-YYYY HH24:MI'), 'T', 2);
INSERT INTO aw_status VALUES (18, 7, 2, to_date('28-Jun-2023 12:00', 'DD-MON-YYYY HH24:MI'), 'T', 2);

INSERT INTO aw_status VALUES (19, 3, 1, to_date('11-Nov-2023 10:00', 'DD-MON-YYYY HH24:MI'), 'T', 3);
INSERT INTO aw_status VALUES (20, 4, 1, to_date('11-Nov-2023 10:00', 'DD-MON-YYYY HH24:MI'), 'T', 3);
INSERT INTO aw_status VALUES (21, 5, 1, to_date('11-Nov-2023 10:00', 'DD-MON-YYYY HH24:MI'), 'T', 3);
INSERT INTO aw_status VALUES (22, 8, 1, to_date('11-Nov-2023 12:00', 'DD-MON-YYYY HH24:MI'), 'T', 4);
INSERT INTO aw_status VALUES (23, 9, 1, to_date('11-Nov-2023 12:00', 'DD-MON-YYYY HH24:MI'), 'T', 4);

-- Arrival at gallery (before display)
INSERT INTO aw_status VALUES (24, 1, 1, to_date('29-Jun-2023 10:00', 'DD-MON-YYYY HH24:MI'), 'G', 1);
INSERT INTO aw_status VALUES (25, 2, 1, to_date('29-Jun-2023 10:00', 'DD-MON-YYYY HH24:MI'), 'G', 1);
INSERT INTO aw_status VALUES (26, 7, 1, to_date('29-Jun-2023 10:00', 'DD-MON-YYYY HH24:MI'), 'G', 1);
INSERT INTO aw_status VALUES (27, 1, 2, to_date('29-Jun-2023 11:00', 'DD-MON-YYYY HH24:MI'), 'G', 2);
INSERT INTO aw_status VALUES (28, 7, 2, to_date('29-Jun-2023 11:00', 'DD-MON-YYYY HH24:MI'), 'G', 2);

INSERT INTO aw_status VALUES (29, 3, 1, to_date('12-Nov-2023 11:00', 'DD-MON-YYYY HH24:MI'), 'G', 3);
INSERT INTO aw_status VALUES (30, 4, 1, to_date('12-Nov-2023 11:00', 'DD-MON-YYYY HH24:MI'), 'G', 3);
INSERT INTO aw_status VALUES (31, 5, 1, to_date('12-Nov-2023 11:00', 'DD-MON-YYYY HH24:MI'), 'G', 3);
INSERT INTO aw_status VALUES (32, 8, 1, to_date('12-Nov-2023 10:30', 'DD-MON-YYYY HH24:MI'), 'G', 4);
INSERT INTO aw_status VALUES (33, 9, 1, to_date('12-Nov-2023 10:30', 'DD-MON-YYYY HH24:MI'), 'G', 4);

-- Sale
INSERT INTO aw_status VALUES (34, 1, 1, to_date('11-Jul-2023 12:00', 'DD-MON-YYYY HH24:MI'), 'S', NULL);
INSERT INTO aw_status VALUES (35, 2, 1, to_date('7-Aug-2023 13:00', 'DD-MON-YYYY HH24:MI'), 'S', NULL);
INSERT INTO aw_status VALUES (36, 7, 1, to_date('28-Sep-2023 14:00', 'DD-MON-YYYY HH24:MI'), 'S', NULL);
INSERT INTO aw_status VALUES (37, 1, 2, to_date('22-Oct-2023 15:00', 'DD-MON-YYYY HH24:MI'), 'S', NULL);

-- TO TEST TASK 4b
INSERT INTO aw_status VALUES (38, 7, 2, to_date('30-Sep-2023 16:00', 'DD-MON-YYYY HH24:MI'), 'S', NULL);
--------------------------------------
--INSERT INTO sale
--------------------------------------
INSERT INTO sale VALUES (1, to_date('11-Jul-2023'),45000,1,1);
INSERT INTO sale VALUES (2, to_date('7-Aug-2023'),80000,2,2);
INSERT INTO sale VALUES (3, to_date('28-Sep-2023'),20000,3,3);
INSERT INTO sale VALUES (4, to_date('22-Oct-2023'),25000,4,4);

-- TO TEST TASK 4b
INSERT INTO sale VALUES (5, to_date('30-Sep-2023'),60000,3,5);

COMMIT;

-- Update aw_display
UPDATE aw_display
SET aw_display_end_date = to_date('11-Jul-2023')
WHERE aw_display_id = 1;

UPDATE aw_display
SET aw_display_end_date = to_date('7-Aug-2023')
WHERE aw_display_id = 2;

UPDATE aw_display
SET aw_display_end_date = to_date('28-Sep-2023')
WHERE aw_display_id = 3;

UPDATE aw_display
SET aw_display_end_date = to_date('22-Oct-2023')
WHERE aw_display_id = 4;

-- TO TEST TASK 4b
UPDATE aw_display
SET aw_display_end_date = to_date('30-Sep-2023')
WHERE aw_display_id = 5;

COMMIT;    