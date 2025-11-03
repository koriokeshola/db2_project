SET search_path TO "C23401212";

GRANT CREATE ON SCHEMA "C23401212" TO "C23401212";
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA "C23401212" TO "C23401212";



-- Drop statements
DROP TABLE if exists letter CASCADE;

DROP TABLE if exists testpartresult CASCADE;

DROP TABLE if exists mechanic CASCADE;

DROP TABLE if exists testparttype CASCADE;

DROP TABLE if exists test CASCADE;

DROP TABLE if exists test_center CASCADE;

DROP TABLE if exists car CASCADE;

DROP TABLE if exists owner CASCADE;


-- Create statements
CREATE TABLE owner (
	ownerid SERIAL PRIMARY KEY,
	owner_name VARCHAR(100) NOT NULL,
	address VARCHAR(100) NOT NULL
);

CREATE TABLE car (
	registration_num VARCHAR(100) PRIMARY KEY,
	make VARCHAR(100) NOT NULL,
	model VARCHAR(100) NOT NULL,
	manufacturer VARCHAR(100) NOT NULL,
	car_year INTEGER NOT NULL,
	owner_ownerid INTEGER NOT NULL REFERENCES owner(ownerid)
);

CREATE TABLE test_center (
	test_centerid SERIAL PRIMARY KEY,
	test_center_name VARCHAR(100) NOT NULL,
	location VARCHAR(100) NOT NULL
);

CREATE TABLE test (
	testid SERIAL PRIMARY KEY,
	test_date DATE NOT NULL,
	supervisor_name VARCHAR(100) NOT NULL,
	result VARCHAR(100) NOT NULL,
	fail_reason VARCHAR(100),
	car_registration_num VARCHAR(100) NOT NULL REFERENCES car(registration_num),
	test_center_test_centerid INTEGER NOT NULL REFERENCES test_center(test_centerid)
);

CREATE TABLE testparttype (
	test_typeid SERIAL PRIMARY KEY,
	test_type_name VARCHAR(100) NOT NULL,
	criticality VARCHAR(100) NOT NULL,
	criteria VARCHAR(100) NOT null
);

CREATE TABLE mechanic (
	mechanicid SERIAL PRIMARY KEY,
	mechanic_name VARCHAR(100) NOT NULL,
	specialty VARCHAR(100) NOT NULL,
	availability VARCHAR(100) NOT NULL
);

CREATE TABLE testpartresult (
	test_part_resultid SERIAL PRIMARY KEY,
	result VARCHAR(100) NOT NULL,
	comments VARCHAR(100) NOT NULL,
	test_testid INTEGER NOT NULL REFERENCES test(testid),
	mechanic_mechanicid INTEGER NOT NULL REFERENCES mechanic(mechanicid),
	testparttype_test_typeid INTEGER NOT NULL REFERENCES testparttype(test_typeid)
);

CREATE TABLE letter (
	letterid SERIAL PRIMARY KEY,
	issue_date DATE NOT NULL,
	appointment_date DATE NOT NULL,
	status VARCHAR(100) NOT NULL,
	notes VARCHAR(255) NOT NULL,
	owner_ownerid INTEGER NOT NULL REFERENCES owner(ownerid),
	test_center_test_centerid INTEGER NOT NULL REFERENCES test_center(test_centerid),
	car_registration_num VARCHAR(100) NOT NULL REFERENCES car(registration_num)
);


-- Insert statements
INSERT INTO owner (owner_name, address)
VALUES 
('Kayla Hayes', '24 Baggot Street'),
('Andrew Smith', '12 Mayberry Road'),
('Louise O Brien', '456 New Avenue'),
('Brian Griffin', '781 Campus Street');


INSERT INTO car (registration_num, make, model, manufacturer, car_year, owner_ownerid)
VALUES 
('01-D-24459', 'Jetta', '1.6D', 'Volkswagen', 2001, 1),
('12-C-33421', 'Civic', '1.8', 'Honda', 2012, 2),
('15-D-77889', 'Focus', '1.5T', 'Ford', 2015, 3),
('09-G-12345', 'Corolla', '1.4D', 'Toyota', 2009, 4);


INSERT INTO test_center (test_center_name, location)
VALUES 
('Tallaght Test Centre', 'Tallaght'),
('Finglas Test Centre', 'Finglas'),
('Blanchardstown Test Centre', 'Blanchardstown'),
('City Centre Test Centre', 'City Centre');


INSERT INTO test (test_date, supervisor_name, result, fail_reason, car_registration_num, test_center_test_centerid)
VALUES 
('2025-10-31', 'Larry Banks', 'Fail', 'Engine failure', '01-D-24459', 1),
('2025-09-30', 'Megan O Connor', 'Pass', NULL, '12-C-33421', 2),
('2025-08-31', 'Christian Yu', 'Fail', 'Brakes issue', '15-D-77889', 3),
('2025-07-31', 'Peter Parker', 'Pass', NULL, '09-G-12345', 4);


INSERT INTO testparttype (test_type_name, criticality, criteria)
VALUES 
('Brakes', 'High', 'Must stop on time'),
('Seat belts', 'High', 'Must lock properly.'),
('Mirror adjustability', 'Medium', 'Must be adjustable and intact.'),
('Carpet condition', 'Low', 'No severe wear.');

INSERT INTO mechanic (mechanic_name, specialty, availability)
VALUES 
('John Connors', 'Brakes', 'Available'),
('Joe Kinsella', 'Tyres', 'Available'),
('Kyle More', 'Engine', 'Unavailable'),
('Callum Anderson', 'Interior', 'Unavailable');


INSERT INTO testpartresult (result, comments, test_testid, mechanic_mechanicid, testparttype_test_typeid)
VALUES 
('Pass', 'Brakes working well', 1, 1, 1),
('Fail', 'Tyre damage present', 1, 3, 1),
('Warning', 'Front passenger seat stuck', 3, 4, 3),
('Pass', 'All belts working properly', 2, 2, 2);


INSERT INTO letter (issue_date, appointment_date, status, notes, owner_ownerid, test_center_test_centerid, car_registration_num)
VALUES 
('2025-10-01', '2025-10-30', 'Pending', 'First test', 1, 1, '01-D-24459'),
('2025-09-01', '2025-09-15', 'Completed', 'Passed', 2, 2, '12-C-33421'),
('2025-08-01', '2025-08-10', 'Completed', 'Failed once', 3, 3, '15-D-77889'),
('2025-07-01', '2025-07-12', 'Completed', 'Passed', 4, 4, '09-G-12345');


-- Select statements
select * from owner;
select * from car;
select * from test_center;
select * from test;
select * from testparttype;
select * from mechanic;
select * from testpartresult;
select * from letter;

/*

-- 🧰 Mechanic (C23401212)
-- This role can view general data and manage test part results only.
GRANT USAGE ON SCHEMA "C23405732" TO "C23401212";

GRANT SELECT ON 
    "C23405732".car,
    "C23405732".test,
    "C23405732".test_center,
    "C23405732".testparttype
TO "C23401212";

GRANT SELECT, INSERT, UPDATE, DELETE ON 
    "C23405732".testpartresult
TO "C23401212";

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA "C23405732" TO "C23401212";


-- 👩‍💼 Supervisor (C23405732)
-- This role can fully manage tests, mechanics, and letters,
-- and can view all supporting information.
GRANT USAGE ON SCHEMA "C23401212" TO "C23405732";

GRANT SELECT, INSERT, UPDATE, DELETE ON 
    "C23401212".test,
    "C23401212".mechanic,
    "C23401212".letter
TO "C23405732";

GRANT SELECT ON 
    "C23401212".owner,
    "C23401212".car,
    "C23401212".test_center,
    "C23401212".testparttype,
    "C23401212".testpartresult
TO "C23405732";

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA "C23401212" TO "C23405732";


-- Optional: test access visibility between schemas
SELECT * FROM "C23405732".owner;
SELECT * FROM "C23401212".owner;

-- Mechanic
GRANT USAGE ON SCHEMA "C23405732" TO "C23401212";

GRANT SELECT ON car, test, test_center, testparttype TO "C23401212";
GRANT SELECT, INSERT, UPDATE, DELETE ON testpartresult TO "C23401212";
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA "C23405732" TO "C23401212";
*/


 -- Grant statements
-- role - C23405732
grant usage on schema "C23401212" to "C23405732";
grant select, insert, update, delete on all tables in schema "C23401212" to "C23405732";
--grant usage, select on all sequences in schema "C23401212";
alter default privileges in schema "C23401212";

-- role - C23401212
grant usage on schema "C23405732" to "C23401212";
grant select, insert, update, delete on all tables in schema "C23405732";
--grant usage, select on all sequences in schema "C23405732";
alter default privileges in schema "C23405732";

select * from "C23405732".owner;
select * from "C23401212".owner; 


/*
-- Function - Clerical Officer
-- List all cars that are older than 5 years and have not been tested in the past year.
CREATE OR REPLACE FUNCTION list_cars_untested_in_5_years()
returns table (
	registration_num VARCHAR,
	make VARCHAR,
	model VARCHAR,
	manufacturer VARCHAR,
	car_year INTEGER,
	owner_name VARCHAR,
	last_test_date DATE
)
 LANGUAGE plpgsql
 as $$
 begin
 	return QUERY -- return all rows as output
 	select
 		car.registration_num,
		car.make,
		car.model,
		car.manufacturer,
		car.car_year,
		owner.owner_name,
		MAX(test.test_date) as last_test_date -- max = most recent
	from car
	join owner on car.owner_ownerid = owner.ownerid
	left join test on car.registration_num = test.car_registration_num -- includes all cars to identify which have been tested and which haven't
	group by car.registration_num, car.make, car.model, car.manufacturer, car.car_year, owner.owner_name -- using group by for aggregate function
	having
		(extract(year from CURRENT_DATE) - car.car_year) > 5 -- car is older than 5 years
		and (
			MAX(test.test_date) is null -- never been tested 
			or MAX(test.test_date) < (CURRENT_DATE - interval '1 year') 
		);
 end*/
 --$$;
 -- conclusion - these are cars that must be tested


/*select * from list_cars_untested_in_5_years();
*/



-- Individual work:
/* PROGRAMMED TRANSACTION and TRIGGER (3 marks): Write a PLpgSQL function or procedure with parameters to
run a transaction to change the data in the database and leave it in a consistent state. It should include decision-
making and error checking and it should be appropriate to your user role. */
