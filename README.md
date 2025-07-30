# Monash Art Gallery Database

## Project Overview

This repository contains SQL and MongoDB scripts to implement, populate, and manipulate a database backend for the Monash Art Gallery case study. The main objectives are:

* **Schema Definition**: Create and complete the relational schema for MAG.
* **Data Loading**: Populate initial and test data to validate the schema and constraints.
* **DML Operations**: Record artwork arrivals, transit, display, sales, and handle cancellations.
* **Schema Modifications**: Add reporting attributes and new relationship tables to the live database.
* **PL/SQL Development**: Implement triggers and stored procedures to enforce business rules.
* **Non-Relational Mapping**: Generate JSON documents from relational data and manage a corresponding MongoDB collection.

## File Descriptions

* **mag_initialSchemaInsert.sql**
  Provided by the FIT teaching team; sets up the base schema and populates key tables (Artists, Artworks, Galleries, Customers, States, Statuses).

* **T1-mag-schema.sql**
  **Task 1**: Add missing DDL for the `AW_DISPLAY` and `SALE` tables, including all required column definitions, comments, constraints, and primary/foreign keys.

* **T2-mag-insert.sql**
  **Task 2**: Insert test data (hardcoded primary keys below 100) for `AW_DISPLAY`, `AW_STATUS`, and `SALE` tables. Ensures the schema supports real-world scenarios and validates constraints.

* **T3-mag-dml.sql**
  **Task 3**: Perform DML operations using Oracle sequences:

  1. Create sequences for `AW_DISPLAY`, `AW_STATUS`, and `SALE`.
  2. Insert a new artwork (`Shattered glass`), track its transit and gallery display.
  3. Record its sale and then demonstrate sale cancellation.

* **T4-mag-mods.sql**
  **Task 4**: Modify the live database structure:

  * Add the `artist_submitted_artwork` column to `ARTIST` to track active submissions.
  * Create the `CUSTOMER_ARTIST` table to record the number of artworks each customer has purchased from each artist.

* **T5-mag-plsql.sql**
  **Task 5**: Develop PL/SQL components:

  * `check_min_price` trigger to validate sale prices against gallery and MAG commissions plus artist minimums.
  * `prc_insert_sale` stored procedure to encapsulate sale insertion logic with input validation.
  * Comprehensive test harnesses to demonstrate correct behavior and error handling.

* **T6-mag-json.sql**
  **Task 6a**: SQL script to generate a JSON document collection representing each artist and their artworks, suitable for non-relational export.

* **T6-mag-mongo.mongodb.js**
  **Task 6b**: MongoDB script to:

  1. Create the `artistartwork` collection from JSON output.
  2. Perform queries for filtering, updates, and aggregation as specified in the assignment.


## Academic Context

This project was completed as part of the **FIT3171 Databases - Assignment 2** at Monash University. The context and instructions for this assignment were provided in the assignment brief file, which outlines the Monash Art Gallery (MAG) case study and the detailed task requirements.
