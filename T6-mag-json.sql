/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T6-mag-json.sql

--Student ID: 32506678
--Student Name: Crystal(Sujung) Shin


/* Comments for your marker:




*/

-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT TO GENERATE 
-- THE COLLECTION OF JSON DOCUMENTS HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer

SELECT
    JSON_OBJECT('_id' VALUE artist_code,
                'name' VALUE artist_gname||' '||artist_fname,
                'address' VALUE JSON_OBJECT(
                        'street' VALUE artist_street,
                        'city' VALUE artist_city,
                        'state' VALUE state_name),
                'phone' VALUE artist_phone,
                'no_of_artworks' VALUE COUNT(artwork_no),
                'artworks' VALUE JSON_ARRAYAGG(
                    JSON_OBJECT('no' VALUE artwork_no,
                                'title' VALUE artwork_title,
                                'minimum_price' VALUE artwork_minprice)
                                ORDER BY artwork_no)
    FORMAT JSON)
    || ','
FROM
    artist
    NATURAL JOIN artwork
    NATURAL JOIN state
GROUP BY
    artist_code,
    artist_gname,
    artist_fname,
    artist_street,
    artist_city,
    state_name,
    artist_phone
HAVING 
    COUNT(artwork_no) > 0
ORDER BY
    artist_code;


