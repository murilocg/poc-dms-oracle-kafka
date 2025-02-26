DROP USER hr CASCADE;

--------------------------------------------------------
--  CREATE HR SCHEMA
--------------------------------------------------------

CREATE USER hr IDENTIFIED BY hr123;

ALTER USER hr DEFAULT TABLESPACE users QUOTA UNLIMITED ON users;

ALTER USER hr TEMPORARY TABLESPACE TEMP;

GRANT CREATE DIMENSION TO hr;

GRANT QUERY REWRITE TO hr;

GRANT CREATE MATERIALIZED VIEW TO hr;

GRANT CREATE SESSION TO hr;

GRANT CREATE SYNONYM TO hr;

GRANT CREATE TABLE TO hr;

GRANT CREATE VIEW TO hr;

GRANT CREATE SEQUENCE TO hr;

GRANT CREATE CLUSTER TO hr;

GRANT CREATE DATABASE LINK TO hr;

GRANT ALTER SESSION TO hr;

GRANT RESOURCE, UNLIMITED TABLESPACE TO hr;

--------------------------------------------------------
--  DDL for Table REGIONS
--------------------------------------------------------

CREATE TABLE "HR"."REGIONS"
    ( "REGION_ID"      NUMBER
    , "REGION_NAME"    VARCHAR2(25) 
    );


COMMENT ON TABLE "HR"."REGIONS"
IS 'Regions table that contains region numbers and names. Contains 4 rows; references with the Countries table.';

COMMENT ON COLUMN "HR"."REGIONS"."REGION_ID"
IS 'Primary key of regions table.';

COMMENT ON COLUMN "HR"."REGIONS"."REGION_NAME"
IS 'Names of regions. Locations are in the countries of these regions.';



--------------------------------------------------------
--  DDL for Table COUNTRIES
--------------------------------------------------------

CREATE TABLE "HR"."COUNTRIES" 
    ( "COUNTRY_ID"      CHAR(2)
    , "COUNTRY_NAME"    VARCHAR2(40) 
    , "REGION_ID"       NUMBER
    ); 

COMMENT ON TABLE "HR"."COUNTRIES"
IS 'country table. Contains 25 rows. References with locations table.';

COMMENT ON COLUMN "HR"."COUNTRIES"."COUNTRY_ID"
IS 'Primary key of countries table.';

COMMENT ON COLUMN "HR"."COUNTRIES"."COUNTRY_NAME"
IS 'Country name';

COMMENT ON COLUMN "HR"."COUNTRIES"."REGION_ID"
IS 'Region ID for the country. Foreign key to region_id column in the departments table.';


--------------------------------------------------------
--  DDL for Table LOCATIONS
--------------------------------------------------------

CREATE TABLE "HR"."LOCATIONS"
    ( "LOCATION_ID"    NUMBER(4)
    , "STREET_ADDRESS" VARCHAR2(40)
    , "POSTAL_CODE"    VARCHAR2(12)
    , "CITY"       VARCHAR2(30)
    , "STATE_PROVINCE" VARCHAR2(25)
    , "COUNTRY_ID"     CHAR(2)
    ) ;


COMMENT ON TABLE "HR"."LOCATIONS"
IS 'Locations table that contains specific address of a specific office,
warehouse, and/or production site of a company. Does not store addresses /
locations of customers. Contains 23 rows; references with the
departments and countries tables. ';

COMMENT ON COLUMN "HR"."LOCATIONS"."LOCATION_ID"
IS 'Primary key of locations table';

COMMENT ON COLUMN "HR"."LOCATIONS"."STREET_ADDRESS"
IS 'Street address of an office, warehouse, or production site of a company.
Contains building number and street name';

COMMENT ON COLUMN "HR"."LOCATIONS"."POSTAL_CODE"
IS 'Postal code of the location of an office, warehouse, or production site 
of a company. ';

COMMENT ON COLUMN "HR"."LOCATIONS"."CITY"
IS 'A not null column that shows city where an office, warehouse, or 
production site of a company is located. ';

COMMENT ON COLUMN "HR"."LOCATIONS"."STATE_PROVINCE"
IS 'State or Province where an office, warehouse, or production site of a 
company is located.';

COMMENT ON COLUMN "HR"."LOCATIONS"."COUNTRY_ID"
IS 'Country where an office, warehouse, or production site of a company is
located. Foreign key to country_id column of the countries table.';



--------------------------------------------------------
--  DDL for Table DEPARTMENTS
--------------------------------------------------------

CREATE TABLE "HR"."DEPARTMENTS"
    ( "DEPARTMENT_ID"    NUMBER(4)
    , "DEPARTMENT_NAME"  VARCHAR2(30)
    , "LOCATION_ID"      NUMBER(4)
    ) ;


COMMENT ON COLUMN "HR"."DEPARTMENTS"."DEPARTMENT_ID"
IS 'Primary key column of departments table.';

COMMENT ON COLUMN "HR"."DEPARTMENTS"."DEPARTMENT_NAME"
IS 'A not null column that shows name of a department. Administration, 
Marketing, Purchasing, Human Resources, Shipping, IT, Executive, Public 
Relations, Sales, Finance, and Accounting. ';

COMMENT ON COLUMN "HR"."DEPARTMENTS"."LOCATION_ID"
IS 'Location id where a department is located. Foreign key to location_id column of locations table.';

COMMENT ON TABLE "HR"."DEPARTMENTS"
IS 'Departments table that shows details of departments where employees 
work. Contains 27 rows; references with locations, employees, and job_history tables.';



--------------------------------------------------------
--  DDL for Table JOBS
--------------------------------------------------------

CREATE TABLE "HR"."JOBS"
    ( "JOB_ID"         VARCHAR2(10)
    , "JOB_TITLE"      VARCHAR2(35)
    , "MIN_SALARY"     NUMBER(6)
    , "MAX_SALARY"     NUMBER(6)
    ) ;


COMMENT ON COLUMN "HR"."JOBS"."JOB_ID"
IS 'Primary key of jobs table.';

COMMENT ON COLUMN "HR"."JOBS"."JOB_TITLE"
IS 'A not null column that shows job title, e.g. AD_VP, FI_ACCOUNTANT';

COMMENT ON COLUMN "HR"."JOBS"."MIN_SALARY"
IS 'Minimum salary for a job title.';

COMMENT ON COLUMN "HR"."JOBS"."MAX_SALARY"
IS 'Maximum salary for a job title';

COMMENT ON TABLE "HR"."JOBS"
IS 'jobs table with job titles and salary ranges. Contains 19 rows.
References with employees and job_history table.';

--------------------------------------------------------
--  DDL for Table EMPLOYEES
--------------------------------------------------------

CREATE TABLE "HR"."EMPLOYEES"
    ( "EMPLOYEE_ID"    NUMBER(6)
    , "FIRST_NAME"     VARCHAR2(20)
    , "LAST_NAME"      VARCHAR2(25)
    , "EMAIL"          VARCHAR2(25)
    , "PHONE_NUMBER"   VARCHAR2(20)
    , "HIRE_DATE"      DATE
    , "JOB_ID"         VARCHAR2(10)
    , "SALARY"         NUMBER(8,2)
    , "COMMISSION_PCT" NUMBER(2,2)
    , "MANAGER_ID"     NUMBER(6)
    , "DEPARTMENT_ID"  NUMBER(4)
    ) ;


COMMENT ON COLUMN "HR"."EMPLOYEES"."EMPLOYEE_ID"
IS 'Primary key of employees table.';

COMMENT ON COLUMN "HR"."EMPLOYEES"."FIRST_NAME"
IS 'First name of the employee. A not null column.';

COMMENT ON COLUMN "HR"."EMPLOYEES"."LAST_NAME"
IS 'Last name of the employee. A not null column.';

COMMENT ON COLUMN "HR"."EMPLOYEES"."EMAIL"
IS 'Email id of the employee';

COMMENT ON COLUMN "HR"."EMPLOYEES"."PHONE_NUMBER"
IS 'Phone number of the employee; includes country code and area code';

COMMENT ON COLUMN "HR"."EMPLOYEES"."HIRE_DATE"
IS 'Date when the employee started on this job. A not null column.';

COMMENT ON COLUMN "HR"."EMPLOYEES"."JOB_ID"
IS 'Current job of the employee; foreign key to job_id column of the 
jobs table. A not null column.';

COMMENT ON COLUMN "HR"."EMPLOYEES"."SALARY"
IS 'Monthly salary of the employee. Must be greater 
than zero (enforced by constraint EMP_SALARY_MIN)';

COMMENT ON COLUMN "HR"."EMPLOYEES"."COMMISSION_PCT"
IS 'Commission percentage of the employee; Only employees in sales 
department elgible for commission percentage';

COMMENT ON COLUMN "HR"."EMPLOYEES"."MANAGER_ID"
IS 'Manager id of the employee; has same domain as manager_id in 
departments table. Foreign key to employee_id column of employees table.
(useful for reflexive joins and CONNECT BY query)';

COMMENT ON COLUMN "HR"."EMPLOYEES"."DEPARTMENT_ID"
IS 'Department id where employee works; foreign key to department_id 
column of the departments table';

COMMENT ON TABLE "HR"."EMPLOYEES"
IS 'employees table. Contains 107 rows. References with departments, 
jobs, job_history tables. Contains a self reference.';

--------------------------------------------------------
--  DDL for Table JOB_HISTORY
--------------------------------------------------------

CREATE TABLE "HR"."JOB_HISTORY"
    ( "EMPLOYEE_ID"   NUMBER(6)
    , "START_DATE"    DATE
    , "END_DATE"      DATE
    , "JOB_ID"        VARCHAR2(10)
    , "DEPARTMENT_ID" NUMBER(4)
    ) ;

COMMENT ON COLUMN "HR"."JOB_HISTORY"."EMPLOYEE_ID"
IS 'A not null column in the complex primary key employee_id+start_date.
Foreign key to employee_id column of the employee table';

COMMENT ON COLUMN "HR"."JOB_HISTORY"."START_DATE"
IS 'A not null column in the complex primary key employee_id+start_date. 
Must be less than the end_date of the job_history table. (enforced by 
constraint jhist_date_interval)';

COMMENT ON COLUMN "HR"."JOB_HISTORY"."END_DATE"
IS 'Last day of the employee in this job role. A not null column. Must be 
greater than the start_date of the job_history table. 
(enforced by constraint jhist_date_interval)';

COMMENT ON COLUMN "HR"."JOB_HISTORY"."JOB_ID"
IS 'Job role in which the employee worked in the past; foreign key to 
job_id column in the jobs table. A not null column.';

COMMENT ON COLUMN "HR"."JOB_HISTORY"."DEPARTMENT_ID"
IS 'Department id in which the employee worked in the past; foreign key to department_id column in the departments table';

COMMENT ON TABLE "HR"."JOB_HISTORY"
IS 'Table that stores job history of the employees. If an employee 
changes departments within the job or changes jobs within the department, 
new rows get inserted into this table with old job information of the 
employee. Contains a complex primary key: employee_id+start_date.
Contains 25 rows. References with jobs, employees, and departments tables.';

--------------------------------------------------------
--  Indexes
--------------------------------------------------------

CREATE UNIQUE INDEX "HR"."REG_ID_PK"
ON "HR"."REGIONS" ("REGION_ID");

CREATE UNIQUE INDEX "HR"."LOC_ID_PK"
ON "HR"."LOCATIONS" ("LOCATION_ID");

CREATE UNIQUE INDEX "HR"."DEPT_ID_PK"
ON "HR"."DEPARTMENTS" ("DEPARTMENT_ID") ;

CREATE UNIQUE INDEX "HR"."JOB_ID_PK"
ON "HR"."JOBS" ("JOB_ID") ;

CREATE UNIQUE INDEX "HR"."JHIST_EMP_ID_ST_DATE_PK"
ON "HR"."JOB_HISTORY" ("EMPLOYEE_ID", "START_DATE");

--------------------------------------------------------
--  Constraints
--------------------------------------------------------

ALTER TABLE "HR"."REGIONS" 
ADD CONSTRAINT "REG_ID_PK"
    PRIMARY KEY ("REGION_ID");

ALTER TABLE "HR"."REGIONS"
ADD CONSTRAINT "REGION_ID_NN" 
CHECK ("REGION_ID" IS NOT NULL);

ALTER TABLE "HR"."COUNTRIES"
ADD CONSTRAINT country_id_nn 
CHECK ("COUNTRY_ID" IS NOT NULL);

ALTER TABLE "HR"."COUNTRIES"
ADD CONSTRAINT "COUNTRY_C_ID_PK"
PRIMARY KEY ("COUNTRY_ID");

ALTER TABLE "HR"."COUNTRIES" ADD (
    CONSTRAINT "COUNTRY_REG_FK"
    FOREIGN KEY ("REGION_ID")
    REFERENCES "HR"."REGIONS"("REGION_ID")
);

ALTER TABLE "HR"."LOCATIONS"
ADD CONSTRAINT "LOC_CITY_NN"
CHECK ("CITY" IS NOT NULL);

ALTER TABLE "HR"."LOCATIONS" 
ADD CONSTRAINT "LOC_ID_PK"
PRIMARY KEY ("LOCATION_ID");

ALTER TABLE "HR"."LOCATIONS" 
ADD CONSTRAINT "LOC_C_ID_FK"
     FOREIGN KEY ("COUNTRY_ID")
     REFERENCES "HR"."COUNTRIES"("COUNTRY_ID");

ALTER TABLE "HR"."DEPARTMENTS" 
ADD CONSTRAINT "DEPARTMENT_NAME_NN"
CHECK ("DEPARTMENT_NAME" IS NOT NULL);


ALTER TABLE "HR"."DEPARTMENTS" ADD ( 
    CONSTRAINT "DEPT_ID_PK"
        PRIMARY KEY ("DEPARTMENT_ID"),
    CONSTRAINT "DEPT_LOC_FK"
        FOREIGN KEY ("LOCATION_ID")
        REFERENCES "HR"."LOCATIONS" ("LOCATION_ID"));

ALTER TABLE "HR"."JOBS"
ADD CONSTRAINT "JOB_ID_PK"
PRIMARY KEY("JOB_ID");

ALTER TABLE "HR"."EMPLOYEES" ADD (
    CONSTRAINT "EMP_LAST_NAME_NN" CHECK ("LAST_NAME" IS NOT NULL),
    CONSTRAINT "EMP_EMAIL_NN" CHECK ("EMAIL" IS NOT NULL),
    CONSTRAINT "EMP_HIRE_DATE_NN" CHECK ("HIRE_DATE" IS  NOT NULL),
    CONSTRAINT "EMP_JOB_NN" CHECK ("JOB_ID" IS NOT NULL),
    CONSTRAINT "EMP_SALARY_MIN" CHECK ("SALARY" > 0),
    CONSTRAINT "EMP_EMAIL_UK" UNIQUE ("EMAIL"));


ALTER TABLE "HR"."EMPLOYEES" ADD (
    CONSTRAINT "EMP_EMP_ID_PK" 
        PRIMARY KEY ("EMPLOYEE_ID"),
    CONSTRAINT "EMP_DEPT_FK"
        FOREIGN KEY ("DEPARTMENT_ID") 
        REFERENCES "HR"."DEPARTMENTS",
     CONSTRAINT "EMP_JOB_FK"
         FOREIGN KEY ("JOB_ID")
         REFERENCES "HR"."JOBS" ("JOB_ID"),
     CONSTRAINT "EMP_MANAGER_FK"
         FOREIGN KEY ("MANAGER_ID")
         REFERENCES "HR"."EMPLOYEES"
);

ALTER TABLE "HR"."JOB_HISTORY" ADD ( 
    CONSTRAINT "JHIST_EMP_ID_ST_DATE_PK"
        PRIMARY KEY ("EMPLOYEE_ID", "START_DATE"),
    CONSTRAINT "JHIST_JOB_FK"
        FOREIGN KEY ("JOB_ID") 
        REFERENCES "HR"."JOBS",
    CONSTRAINT "JHIST_EMP_FK"
        FOREIGN KEY ("EMPLOYEE_ID")
        REFERENCES "HR"."EMPLOYEES",
    CONSTRAINT "JHIST_DEPT_FK"
        FOREIGN KEY ("DEPARTMENT_ID")
        REFERENCES "HR"."DEPARTMENTS"
);

CREATE OR REPLACE VIEW "HR"."EMP_DETAILS_VIEW" AS 
SELECT 
    E.EMPLOYEE_ID, E.JOB_ID, E.MANAGER_ID, E.DEPARTMENT_ID,
    D.LOCATION_ID, L.COUNTRY_ID, E.FIRST_NAME, E.LAST_NAME,
    E.SALARY, E.COMMISSION_PCT, D.DEPARTMENT_NAME, J.JOB_TITLE,
    L.CITY, L.STATE_PROVINCE, C.COUNTRY_NAME, R.REGION_NAME
FROM
  "HR"."EMPLOYEES" E,
  "HR"."DEPARTMENTS" D,
  "HR"."JOBS" J,
  "HR"."LOCATIONS" L,
  "HR"."COUNTRIES" C,
  "HR"."REGIONS" R
WHERE E."DEPARTMENT_ID" = D."DEPARTMENT_ID"
  AND D.LOCATION_ID = L.LOCATION_ID
  AND L.COUNTRY_ID = C.COUNTRY_ID
  AND C.REGION_ID = R.REGION_ID
  AND J.JOB_ID = E.JOB_ID
WITH READ ONLY;


CREATE SEQUENCE "HR"."LOCATIONS_SEQ"
 START WITH     3300
 INCREMENT BY   100
 MAXVALUE       9900
 NOCACHE
 NOCYCLE;

CREATE SEQUENCE "HR"."DEPARTMENTS_SEQ"
 START WITH     280
 INCREMENT BY   10
 MAXVALUE       9990
 NOCACHE
 NOCYCLE;

CREATE SEQUENCE "HR"."EMPLOYEES_SEQ"
 START WITH     207
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

CREATE OR REPLACE PROCEDURE "HR"."SECURE_DML"
IS
BEGIN
  IF TO_CHAR (SYSDATE, 'HH24:MI') NOT BETWEEN '08:00' AND '18:00'
        OR TO_CHAR (SYSDATE, 'DY') IN ('SAT', 'SUN') THEN
        RAISE_APPLICATION_ERROR (-20205,
                'You may only make changes during normal office hours');
  END IF;
END ;
/


CREATE OR REPLACE PROCEDURE "HR"."ADD_JOB_HISTORY"
  (  p_emp_id          HR.job_history.employee_id%type
   , p_start_date      HR.job_history.start_date%type
   , p_end_date        HR.job_history.end_date%type
   , p_job_id          HR.job_history.job_id%type
   , p_department_id   HR.job_history.department_id%type
   )
IS
BEGIN
  INSERT INTO HR.job_history (employee_id, start_date, end_date,
                           job_id, department_id)
    VALUES(p_emp_id, p_start_date, p_end_date, p_job_id, p_department_id);
END;
/

