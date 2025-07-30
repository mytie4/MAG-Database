--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T1-mag-schema.sql

--Student ID: 32506678
--Student Name: Crystal(Sujung) Shin


/* Comments for your marker:




*/

-- Task 1 Add Create table statements for the Missing TABLES below
-- Ensure all column comments, and constraints (other than FK's)
-- are included. FK constraints are to be added at the end of this script

-- AW_DISPLAY
CREATE TABLE aw_display(
    aw_display_id NUMBER(6) NOT NULL,
    artist_code NUMBER(4) NOT NULL,
    artwork_no NUMBER(4) NOT NULL,
    aw_display_start_date DATE NOT NULL,
    aw_display_end_date DATE,
    gallery_id NUMBER(3) NOT NULL
);

COMMENT ON COLUMN aw_display.aw_display_id IS
    'Identifier for aw_display';

COMMENT ON COLUMN aw_display.artist_code IS
    'Identifier for artist';

COMMENT ON COLUMN aw_display.artwork_no IS
    'Identifier for artwork within this artist';

COMMENT ON COLUMN aw_display.aw_display_start_date IS
    'Date this artwork display in the gallery began';

COMMENT ON COLUMN aw_display.aw_display_end_date IS
    'Date this artwork display in the gallery ends. The display end date must be after the display start date.';

COMMENT ON COLUMN aw_display.gallery_id IS
    'Identifier for Gallery';

ALTER TABLE aw_display ADD CONSTRAINT aw_display_pk PRIMARY KEY ( aw_display_id );
ALTER TABLE aw_display
    ADD CONSTRAINT aw_display_uq UNIQUE ( artist_code,
                                          artwork_no,
                                          aw_display_start_date );

ALTER TABLE aw_display 
ADD CONSTRAINT check_end_date CHECK ( aw_display_end_date IS NULL
                                      OR aw_display_end_date > aw_display_start_date);


-- SALE
CREATE TABLE sale(
    sale_id NUMBER(5) NOT NULL,
    sale_date DATE NOT NULL,
    sale_price NUMBER(9, 2) NOT NULL,
    customer_id NUMBER(5) NOT NULL,
    aw_display_id NUMBER(6) NOT NULL
);

COMMENT ON COLUMN sale.sale_id IS
    'Identifier for sale';

COMMENT ON COLUMN sale.sale_date IS
    'Date sale was closed';

COMMENT ON COLUMN sale.sale_price IS
    'Price customer paid for artwork';

COMMENT ON COLUMN sale.customer_id IS
    'Identifier for customer';

COMMENT ON COLUMN sale.aw_display_id IS
    'Identifier for aw_display';

ALTER TABLE sale ADD CONSTRAINT sale_pk PRIMARY KEY ( sale_id );

-- Add all missing FK Constraints below here

ALTER TABLE aw_display
    ADD CONSTRAINT artwork_aw_display_fk FOREIGN KEY ( artwork_no,
                                                       artist_code )
        REFERENCES artwork ( artwork_no,
                             artist_code );

ALTER TABLE aw_display
    ADD CONSTRAINT gallery_aw_display_fk FOREIGN KEY ( gallery_id )
        REFERENCES gallery ( gallery_id );

ALTER TABLE sale
    ADD CONSTRAINT customer_sale_fk FOREIGN KEY ( customer_id )
        REFERENCES customer ( customer_id );

ALTER TABLE sale
    ADD CONSTRAINT aw_display_sale_fk FOREIGN KEY ( aw_display_id )
        REFERENCES aw_display ( aw_display_id );