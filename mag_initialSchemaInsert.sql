/*
  Database Unit 2024 Summer Semester B
  --Monash Art Gallery Schema File and Initial Data--
  --mag_initialSchemaInsert.sql

  Description:
  This file creates the Monash Art Gallery tables
  and populates several of the tables (those shown in purple on the supplied model).
  You should read this schema file carefully
  and be sure you understand the various data requirements.

Author: FIT Database Teaching Team
License: Copyright Monash University, unless otherwise stated. All Rights Reserved.
COPYRIGHT WARNING
Warning
This material is protected by copyright. For use within Monash University only. NOT FOR RESALE.
Do not remove this notice.

*/

DROP TABLE artist CASCADE CONSTRAINTS;

DROP TABLE artwork CASCADE CONSTRAINTS;

DROP TABLE aw_display CASCADE CONSTRAINTS;

DROP TABLE aw_status CASCADE CONSTRAINTS;

DROP TABLE customer CASCADE CONSTRAINTS;

DROP TABLE gallery CASCADE CONSTRAINTS;

DROP TABLE state CASCADE CONSTRAINTS;

DROP TABLE sale CASCADE CONSTRAINTS;


CREATE TABLE artist (
    artist_code   NUMBER(4) NOT NULL,
    artist_gname  VARCHAR2(20),
    artist_fname  VARCHAR2(20),
    artist_street VARCHAR2(30) NOT NULL,
    artist_city   VARCHAR2(30) NOT NULL,
    artist_phone  CHAR(10),
    state_code    CHAR(3) NOT NULL
);

COMMENT ON COLUMN artist.artist_code IS
    'Identifier for artist';

COMMENT ON COLUMN artist.artist_gname IS
    'Artist''s given name';

COMMENT ON COLUMN artist.artist_fname IS
    'Artist''s family name';

COMMENT ON COLUMN artist.artist_street IS
    'Street address of artist';

COMMENT ON COLUMN artist.artist_city IS
    'City address of artist';

COMMENT ON COLUMN artist.artist_phone IS
    'Phone number of artist';

COMMENT ON COLUMN artist.state_code IS
    'State three letters code';

ALTER TABLE artist ADD CONSTRAINT artist_pk PRIMARY KEY ( artist_code );

CREATE TABLE artwork (
    artist_code        NUMBER(4) NOT NULL,
    artwork_no         NUMBER(4) NOT NULL,
    artwork_title      VARCHAR2(25) NOT NULL,
    artwork_minprice   NUMBER(9, 2) NOT NULL,
    artwork_submitdate DATE NOT NULL
);

COMMENT ON COLUMN artwork.artist_code IS
    'Identifier for artist';

COMMENT ON COLUMN artwork.artwork_no IS
    'Identifier for artwork within this artist';

COMMENT ON COLUMN artwork.artwork_title IS
    'Title of artwork';

COMMENT ON COLUMN artwork.artwork_minprice IS
    'Minimum price artist is prepared to accept for the artwork';

COMMENT ON COLUMN artwork.artwork_submitdate IS
    'The date when an artwork is submitted';

ALTER TABLE artwork ADD CONSTRAINT artwork_pk PRIMARY KEY ( artwork_no,
                                                            artist_code );

CREATE TABLE aw_status (
    aws_id        NUMBER(6) NOT NULL,
    artist_code   NUMBER(4) NOT NULL,
    artwork_no    NUMBER(4) NOT NULL,
    aws_date_time DATE NOT NULL,
    aws_status    CHAR(1) NOT NULL,
    gallery_id    NUMBER(3)
);

ALTER TABLE aw_status
    ADD CONSTRAINT chk_awstatus CHECK ( aws_status IN ( 'G', 'R', 'S', 'T', 'W' ) );

COMMENT ON COLUMN aw_status.aws_id IS
    'Identifier for aw_status';

COMMENT ON COLUMN aw_status.artist_code IS
    'Identifier for artist';

COMMENT ON COLUMN aw_status.artwork_no IS
    'Identifier for artwork within this artist';

COMMENT ON COLUMN aw_status.aws_date_time IS
    'Date and time of status  change took place';

COMMENT ON COLUMN aw_status.aws_status IS
    'Artwork status
W = in MOG storage at the MOG central warehouse
T = in transit (being shipped to/from a gallery)
G = located at a gallery on display
S = sold, or
R = returned to the artist
';

COMMENT ON COLUMN aw_status.gallery_id IS
    'Identifier for Gallery';

ALTER TABLE aw_status ADD CONSTRAINT aw_status_pk PRIMARY KEY ( aws_id );

ALTER TABLE aw_status
    ADD CONSTRAINT awstatus_uq UNIQUE ( aws_date_time,
                                          artist_code,
                                          artwork_no );

CREATE TABLE customer (
    customer_id      NUMBER(5) NOT NULL,
    customer_gname   VARCHAR2(20),
    customer_fname   VARCHAR2(20),
    customer_busname VARCHAR2(30),
    customer_street  VARCHAR2(30) NOT NULL,
    customer_city    VARCHAR2(30) NOT NULL,
    customer_phone   CHAR(10) NOT NULL,
    state_code       CHAR(3) NOT NULL
);

COMMENT ON COLUMN customer.customer_id IS
    'Identifier for customer';

COMMENT ON COLUMN customer.customer_gname IS
    'Customers given name';

COMMENT ON COLUMN customer.customer_fname IS
    'Customers family name';

COMMENT ON COLUMN customer.customer_busname IS
    'Business name of customer';

COMMENT ON COLUMN customer.customer_street IS
    'Street address of customer';

COMMENT ON COLUMN customer.customer_city IS
    'City address of customer';

COMMENT ON COLUMN customer.customer_phone IS
    'Phone number of customer';

COMMENT ON COLUMN customer.state_code IS
    'State three letters code';

ALTER TABLE customer ADD CONSTRAINT customer_pk PRIMARY KEY ( customer_id );

ALTER TABLE customer ADD CONSTRAINT customer_phone_uq UNIQUE ( customer_phone );

CREATE TABLE gallery (
    gallery_id           NUMBER(3) NOT NULL,
    gallery_name         VARCHAR2(30) NOT NULL,
    gallery_manager      VARCHAR2(30) NOT NULL,
    gallery_street       VARCHAR2(30) NOT NULL,
    gallery_city         VARCHAR2(30) NOT NULL,
    gallery_phone        CHAR(10) NOT NULL,
    gallery_sale_percent NUMBER(4, 1) NOT NULL,
    gallery_open         DATE NOT NULL,
    gallery_close        DATE NOT NULL,
    state_code           CHAR(3) NOT NULL
);

COMMENT ON COLUMN gallery.gallery_id IS
    'Identifier for Gallery';

COMMENT ON COLUMN gallery.gallery_name IS
    'Name of gallery';

COMMENT ON COLUMN gallery.gallery_manager IS
    'Name of gallery manager';

COMMENT ON COLUMN gallery.gallery_street IS
    'Street address of gallery';

COMMENT ON COLUMN gallery.gallery_city IS
    'City address of gallery';

COMMENT ON COLUMN gallery.gallery_phone IS
    'Phone number of gallery';

COMMENT ON COLUMN gallery.gallery_sale_percent IS
    'Percentage of sale for gallery';

COMMENT ON COLUMN gallery.gallery_open IS
    'Open time of gallery';

COMMENT ON COLUMN gallery.gallery_close IS
    'Close time of gallery';

COMMENT ON COLUMN gallery.state_code IS
    'State three letters code';

ALTER TABLE gallery ADD CONSTRAINT gallery_pk PRIMARY KEY ( gallery_id );

ALTER TABLE gallery ADD CONSTRAINT gallery_phone_uq UNIQUE ( gallery_phone );

CREATE TABLE state (
    state_code      CHAR(3) NOT NULL,
    state_name      VARCHAR2(30) NOT NULL
);

COMMENT ON COLUMN state.state_code IS
    'State three letters code';

COMMENT ON COLUMN state.state_name IS
    'state name';

ALTER TABLE state ADD CONSTRAINT state_pk PRIMARY KEY ( state_code );

ALTER TABLE artwork
    ADD CONSTRAINT artist_artwork_fk FOREIGN KEY ( artist_code )
        REFERENCES artist ( artist_code );

ALTER TABLE artist
    ADD CONSTRAINT state_artist_fk FOREIGN KEY ( state_code )
        REFERENCES state ( state_code );

ALTER TABLE customer
    ADD CONSTRAINT state_customer_fk FOREIGN KEY ( state_code )
        REFERENCES state ( state_code );

ALTER TABLE gallery
    ADD CONSTRAINT state_gallery_fk FOREIGN KEY ( state_code )
        REFERENCES state ( state_code );

ALTER TABLE aw_status
    ADD CONSTRAINT artwork_aw_status_fk FOREIGN KEY ( artwork_no,
                                                   artist_code )
        REFERENCES artwork ( artwork_no,
                             artist_code );

ALTER TABLE aw_status
    ADD CONSTRAINT gallery_aw_status_fk FOREIGN KEY ( gallery_id )
        REFERENCES gallery ( gallery_id );


--------------------------------------
--INSERT INTO state
--------------------------------------
INSERT INTO STATE VALUES ('ACT','Australian Capital Territory');
INSERT INTO STATE VALUES ('NSW','New South Wales');
INSERT INTO STATE VALUES ('NT','Northern Territory');
INSERT INTO STATE VALUES ('QLD','Queensland');
INSERT INTO STATE VALUES ('SA','South Australia');
INSERT INTO STATE VALUES ('TAS','Tasmania');
INSERT INTO STATE VALUES ('VIC','Victoria');
INSERT INTO STATE VALUES ('WA','Western Austalia');


--------------------------------------
--INSERT INTO artist
--------------------------------------
INSERT INTO artist VALUES (1, 'Martainn', 'Jenteau', '328 Forest Pass', 'Melbourne', '0495300384', 'VIC');
INSERT INTO artist VALUES (2, 'Kipp', 'Grellis', '2755 Briar Crest Place', 'South Yarra', '0468858093', 'VIC');
INSERT INTO artist VALUES (3, 'Jessi', 'Allward', '9 Becker Plaza', 'Wallan', '0438843662', 'VIC');
INSERT INTO artist VALUES (4, 'Rosalinda', 'Zavattiero', '1 Del Mar Avenue', 'Malvern East', '', 'VIC');
INSERT INTO artist VALUES (5, 'Neda', 'Mylchreest', '327 Caliangt Street', 'Clayton South', '0409562816', 'VIC');
INSERT INTO artist VALUES (6, 'Elga', 'Yakolev', '6 Hanson Park', 'Lysterfield', '0496667027', 'VIC');
INSERT INTO artist VALUES (7, 'Weston', 'Stearndale', '39512 Kipling Road', 'Leongatha', '0417905216', 'VIC');
INSERT INTO artist VALUES (8, 'Reeba', 'Wildman', '92542 Service Junction', 'Malvern East', '0493427245', 'VIC');
INSERT INTO artist VALUES (9, 'Marlee', 'Champerlen', '64201 Carey Circle', 'Clayton South', '0427832032', 'VIC');
INSERT INTO artist VALUES (10, 'Dorette', '', '87596 Porter Place', 'Lysterfield', '0487345845', 'VIC');
INSERT INTO artist VALUES (11, 'Westley', 'Oakenford', '137 Tennessee Street', 'Attwood', '0418289108', 'VIC');
INSERT INTO artist VALUES (12, 'Kilian', 'Moisey', '05422 Pearson Avenue', 'Melbourne', '0429418600', 'VIC');

--------------------------------------
--INSERT INTO customer
--------------------------------------
INSERT INTO customer VALUES (1, 'Florida', 'Goldhawk', null, '904 Talmadge Lane', 'Belgrave', '0454762942', 'VIC');
INSERT INTO customer VALUES (2, null, 'Clements', null, '4632 Monica Plaza', 'Belgrave South', '0425271315', 'VIC');
INSERT INTO customer VALUES (3, 'Stefanie', 'Wilstead', null, '1723 Dottie Parkway', 'Pakenham', '0452272267', 'VIC');
INSERT INTO customer VALUES (4, 'Guilermo', null, 'Quinlan Temperley Pvt. Ltd.', '1 Kinsman Terrace', 'Melbourne', '0475110074', 'VIC');
INSERT INTO customer VALUES (5, 'Lois', 'Hawkshaw', null, '7480 Center Crossing', 'Pakenham Upper', '0458708402', 'VIC');
INSERT INTO customer VALUES (6, 'Reinald', null, null, '2422 Calypso Circle', 'Leongatha', '0489832003', 'VIC');
INSERT INTO customer VALUES (7, 'Jobie', 'Pheazey', null, '03 New Castle Center', 'Leongatha', '0475761206', 'VIC');
INSERT INTO customer VALUES (8, null, 'Rochelle', 'Rochelle Zecchinii Pvt. Ltd.', '10 Forest Dale Terrace', 'Melbourne', '0409646679', 'VIC');
INSERT INTO customer VALUES (9, 'Danila', 'Geraldo', null, '9 Londonderry Parkway', 'Leongatha', '0464179129', 'VIC');
INSERT INTO customer VALUES (10, 'Haleigh', 'Bonifacio', null, '93 Buell Lane', 'Malvern East', '0480445917', 'VIC');


--------------------------------------
--INSERT INTO gallery
--------------------------------------
INSERT INTO gallery VALUES (1, 'Karma Art', 'Seline Fortey', '9 Mallory Court', 'Attwood', '0413432569', 5.6, TO_DATE('9:30', 'HH24:MI'), TO_DATE('17:30', 'HH24:MI'), 'VIC');
INSERT INTO gallery VALUES (2, 'Artology', 'Charmaine', '9 Gerald Park', 'Melbourne', '0474980815', 10.3, TO_DATE('9:00', 'HH24:MI'), TO_DATE('18:00', 'HH24:MI'), 'VIC');
INSERT INTO gallery VALUES (3, 'Inspire Art', 'Malissa McGlynn', '327 Rigney Plaza', 'Camira', '0417407587', 7.5, TO_DATE('10:00', 'HH24:MI'), TO_DATE('18:00', 'HH24:MI'), 'VIC');
INSERT INTO gallery VALUES (4, 'Art Smart', 'Ferrell Byard', '04 Florence Alley', 'Richmond', '0490556646', 9.6, TO_DATE('10:00', 'HH24:MI'), TO_DATE('18:00', 'HH24:MI'), 'VIC');
INSERT INTO gallery VALUES (5, 'Art Temple', 'Msard', '123 Hyde Park', 'South Yarra', '0438093219', 10.5, TO_DATE('10:00', 'HH24:MI'), TO_DATE('18:00', 'HH24:MI'), 'VIC');


--------------------------------------
--INSERT INTO artwork
--------------------------------------
INSERT INTO artwork VALUES (1, 1, 'The Creation of Adam', 30000, TO_DATE('2-Jun-2022', 'DD-MON-YYYY'));
INSERT INTO artwork VALUES (2, 1, 'The Starry Night', 55400, TO_DATE('4-Jun-2022', 'DD-MON-YYYY'));
INSERT INTO artwork VALUES (3, 1, 'Saint francis of Assisi', 24500, TO_DATE('5-Jun-2022', 'DD-MON-YYYY'));
INSERT INTO artwork VALUES (4, 1, 'The Last Supper', 17900, TO_DATE('6-Jun-2022', 'DD-MON-YYYY'));
INSERT INTO artwork VALUES (7, 1, 'Orange Veils', 12900, TO_DATE('7-Jun-2022', 'DD-MON-YYYY'));
INSERT INTO artwork VALUES (8, 1, 'Girl with a Pearl Earring', 23100, TO_DATE('8-Jun-2022', 'DD-MON-YYYY'));
INSERT INTO artwork VALUES (5, 1, 'the bushes', 45000, TO_DATE('15-Jul-2022', 'DD-MON-YYYY'));
INSERT INTO artwork VALUES (9, 1, 'The Mystic', 34000, TO_DATE('14-Aug-2022', 'DD-MON-YYYY'));
INSERT INTO artwork VALUES (10, 1, 'The Scientist', 24000, TO_DATE('1-Sep-2022', 'DD-MON-YYYY'));
INSERT INTO artwork VALUES (1, 2, 'Boat festival', 14500, TO_DATE('18-Oct-2022', 'DD-MON-YYYY'));
INSERT INTO artwork VALUES (7, 2, 'Saint Francis of Assisi', 34536.9, TO_DATE('19-Oct-2022', 'DD-MON-YYYY'));
INSERT INTO artwork VALUES (8, 2, 'Cafe Terrace at Night', 45600.35, TO_DATE('24-Oct-2022', 'DD-MON-YYYY'));
INSERT INTO artwork VALUES (5, 2, 'The Sojourn', 46700.45, TO_DATE('27-Oct-2022', 'DD-MON-YYYY'));


--------------------------------------
--INSERT INTO aw_status
--------------------------------------
INSERT INTO aw_status VALUES (1, 1, 1, TO_DATE('1-Jun-2023 08:00', 'DD-MON-YYYY HH24:MI'), 'W', null);
INSERT INTO aw_status VALUES (2, 2, 1, TO_DATE('1-Jun-2023 08:00', 'DD-MON-YYYY HH24:MI'), 'W', null);
INSERT INTO aw_status VALUES (3, 3, 1, TO_DATE('1-Jun-2023 08:00', 'DD-MON-YYYY HH24:MI'), 'W', null);
INSERT INTO aw_status VALUES (4, 4, 1, TO_DATE('1-Jun-2023 08:00', 'DD-MON-YYYY HH24:MI'), 'W', null);
INSERT INTO aw_status VALUES (5, 7, 1, TO_DATE('1-Jun-2023 08:00', 'DD-MON-YYYY HH24:MI'), 'W', null);
INSERT INTO aw_status VALUES (6, 8, 1, TO_DATE('1-Jun-2023 08:00', 'DD-MON-YYYY HH24:MI'), 'W', null);

INSERT INTO aw_status VALUES (7, 5, 1, TO_DATE('1-Jun-2023 08:00', 'DD-MON-YYYY HH24:MI'), 'W', null);
INSERT INTO aw_status VALUES (8, 9, 1, TO_DATE('1-Jun-2023 08:00', 'DD-MON-YYYY HH24:MI'), 'W', null);
INSERT INTO aw_status VALUES (9, 10, 1, TO_DATE('1-Jun-2023 08:00', 'DD-MON-YYYY HH24:MI'), 'W', null);
INSERT INTO aw_status VALUES (10, 1, 2, TO_DATE('1-Jun-2023 08:00', 'DD-MON-YYYY HH24:MI'), 'W', null);
INSERT INTO aw_status VALUES (11, 7, 2, TO_DATE('1-Jun-2023 08:00', 'DD-MON-YYYY HH24:MI'), 'W', null);
INSERT INTO aw_status VALUES (12, 8, 2, TO_DATE('1-Jun-2023 08:00', 'DD-MON-YYYY HH24:MI'), 'W', null);
INSERT INTO aw_status VALUES (13, 5, 2, TO_DATE('1-Jun-2023 08:00', 'DD-MON-YYYY HH24:MI'), 'W', null);


commit;