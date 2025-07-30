/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T4-mag-mods.sql

--Student ID: 32506678
--Student Name: Crystal(Sujung) Shin


/* Comments for your marker:




*/

/*(a)*/
ALTER TABLE artist ADD (
    artist_submitted_artwork NUMBER(3) DEFAULT 0 NOT NULL
);

COMMENT ON COLUMN artist.artist_submitted_artwork IS
    'Total number of Artworks that each Artist has submitted which have been sold or are currently available for sale';

UPDATE artist a
SET artist_submitted_artwork = (
    SELECT count(*)
    FROM (
    SELECT artist_code
    FROM aw_status aw
    WHERE upper(aws_status) <> upper('R') 
    AND aw.artist_code = a.artist_code
    GROUP BY artist_code, artwork_no
    ) 
);

COMMIT;

SELECT artist_code, artist_submitted_artwork FROM artist ORDER BY artist_code;
DESC artist;

/*(b)*/
DROP TABLE customer_artist CASCADE CONSTRAINTS;

CREATE TABLE customer_artist(
    customer_id      NUMBER(5) NOT NULL,
    artist_code   NUMBER(4) NOT NULL,
    cust_art_count NUMBER(3) DEFAULT 0 NOT NULL
);

COMMENT ON COLUMN customer_artist.customer_id IS
    'Identifier for Customer';

COMMENT ON COLUMN customer_artist.artist_code IS
    'Identifier for Artist';

COMMENT ON COLUMN customer_artist.cust_art_count IS
    'Number of Artworks that each Customer has purchased from each Artist';

ALTER TABLE customer_artist ADD CONSTRAINT CA_pk PRIMARY KEY ( customer_id, artist_code );

ALTER TABLE customer_artist ADD CONSTRAINT customer_CA_fk FOREIGN KEY ( customer_id ) 
    REFERENCES customer ( customer_id );

ALTER TABLE customer_artist ADD CONSTRAINT artist_CA_fk FOREIGN KEY ( artist_code ) 
    REFERENCES artist ( artist_code );


INSERT INTO customer_artist
    SELECT customer_id, artist_code, COUNT(sale_id)
    FROM sale NATURAL JOIN aw_display 
    GROUP BY customer_id, artist_code;

COMMIT;

SELECT * FROM customer_artist ORDER BY customer_id, artist_code;
DESC customer_artist;


