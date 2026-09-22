-- Metadata table used by the Azure Data Factory pipeline

CREATE TABLE metadata
(
    sourcefoldername VARCHAR(50),
    storagepath      VARCHAR(50),
    isactive         INT,
    status           VARCHAR(50)
);

-- Initial metadata records

INSERT INTO metadata
VALUES ('cust', 'cust', 0, 'ready');

INSERT INTO metadata
VALUES ('orders', 'orders', 0, 'ready');

INSERT INTO metadata
VALUES ('emp', 'emp', 0, 'ready');

INSERT INTO metadata
VALUES ('discounts', 'discounts', 0, 'ready');

-- Verify metadata

SELECT *
FROM metadata;
