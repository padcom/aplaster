-------------------------------------------------------------------------------
--
-- Database creation
--
-------------------------------------------------------------------------------

--CONNECT ":C:\Temp\1\aplaster.fdb" USER "SYSDBA" PASSWORD "masterkey";
--DROP DATABASE; 

CREATE DATABASE ":C:\Temp\1\aplaster.fdb" USER "SYSDBA" PASSWORD "masterkey";

-------------------------------------------------------------------------------
--
-- File storage 
--
-------------------------------------------------------------------------------

CREATE TABLE t_files (
  f_filename CHAR(24),
  f_content  BLOB
);

-------------------------------------------------------------------------------
-- 
-- Access profiles
-- 
-------------------------------------------------------------------------------

CREATE DOMAIN IDENT DECIMAL(10, 0);
CREATE DOMAIN ID INT NOT NULL;
CREATE DOMAIN TRANSPONDER_ID CHAR(12) NOT NULL;

-------------------------------------------------------------------------------
-- People
-------------------------------------------------------------------------------

CREATE TABLE t_people (
  f_index      ID PRIMARY KEY,
  f_first_name CHAR(128),
  f_last_name  CHAR(128)
);

-------------------------------------------------------------------------------
-- Transponders
-------------------------------------------------------------------------------

CREATE TABLE t_transponder (
  f_index ID PRIMARY KEY,
  f_id    TRANSPONDER_ID
);

-------------------------------------------------------------------------------
-- Transponders assigned to people
-------------------------------------------------------------------------------

CREATE TABLE t_person_transponder (
  f_person      ID,
  f_transponder ID,

  PRIMARY KEY (f_person, f_transponder),
  
  FOREIGN KEY (f_person) REFERENCES t_people (f_index)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (f_transponder) REFERENCES t_transponder (f_index)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

-------------------------------------------------------------------------------
-- Time plan
-------------------------------------------------------------------------------

CREATE TABLE t_timeplan (
  f_index ID PRIMARY KEY,
  f_title CHAR(256),
  f_description CHAR(512)
);

-------------------------------------------------------------------------------
-- Periods
-------------------------------------------------------------------------------

CREATE TABLE t_periods (
  f_timeplan ID,
  f_day_of_week INT CHECK (f_day_of_week BETWEEN 1 AND 7),
  f_begin TIME,
  f_end TIME
);


-------------------------------------------------------------------------------
--
-- Stored procedures
--
-------------------------------------------------------------------------------

SET TERM !! ;

-------------------------------------------------------------------------------
-- Select all transponder ids assigned to person ":person"
-------------------------------------------------------------------------------

CREATE PROCEDURE p_transp_for_person(person INT) RETURNS (transponder CHAR(12)) AS
BEGIN
  FOR SELECT f_id FROM t_transponder  
    WHERE f_index IN (SELECT f_transponder FROM t_person_transponder WHERE f_person=:person) 
    INTO :transponder
  DO SUSPEND;
END !!

-------------------------------------------------------------------------------
-- Select all transponders assigned to person ":person"
-------------------------------------------------------------------------------

CREATE PROCEDURE p_transpid_for_person(person INT) RETURNS (transponder INT) AS
BEGIN
  FOR SELECT f_index FROM t_transponder  
    WHERE f_index IN (SELECT f_transponder FROM t_person_transponder WHERE f_person=:person) 
    INTO :transponder
  DO SUSPEND;
END !!

SET TERM ; !!

-------------------------------------------------------------------------------
--
-- Test data
--
-------------------------------------------------------------------------------

INSERT INTO t_people VALUES (1, 'Matthias', 'Hryniszak');
INSERT INTO t_people VALUES (2, 'Marzena', 'Hryniszak');
INSERT INTO t_people VALUES (3, 'Roman', 'Hryniszak');

INSERT INTO t_transponder VALUES (1, '123');
INSERT INTO t_transponder VALUES (2, '456');
INSERT INTO t_transponder VALUES (3, '226');
INSERT INTO t_transponder VALUES (4, '636');
INSERT INTO t_transponder VALUES (5, '846');

INSERT INTO t_person_transponder VALUES (1, 1);
INSERT INTO t_person_transponder VALUES (1, 2);
INSERT INTO t_person_transponder VALUES (1, 3);
INSERT INTO t_person_transponder VALUES (2, 4);
INSERT INTO t_person_transponder VALUES (3, 5);

SELECT * FROM p_transp_for_person(1);
SELECT * FROM p_transpid_for_person(1);

--SELECT * FROM t_person_transponder;
--DELETE FROM t_people WHERE f_index=1;
--SELECT * FROM t_person_transponder;

COMMIT;
