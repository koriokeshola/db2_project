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


-- Grant statements
-- role - C23405732
grant usage on schema "C23405732" to public;
grant select, insert, update, delete on all tables in schema "C23405732" to public;
grant usage, select on all sequences in schema "C23405732" to public;


-- role - C23401212
grant usage on schema "C23401212" to public;
grant select, insert, update, delete on all tables in schema "C23401212" to public;
grant usage, select on all sequences in schema "C23401212" to public;

select * from "C23405732".owner;
select * from "C23401212".owner;



-- Individual work:
/* PROGRAMMED TRANSACTION and TRIGGER (3 marks): Write a PLpgSQL function or procedure with parameters to
run a transaction to change the data in the database and leave it in a consistent state. It should include decision-
making and error checking and it should be appropriate to your user role. */

CREATE OR REPLACE FUNCTION addsupplier(
p_sname character varying, p_ph character)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE
      v_supplier_id integer;
begin
        insert into "C23401212".sh_supplier (sname, sph)
		values (p_sname, p_ph) returning supplier_id into v_supplier_id;
        RETURN v_supplier_id;
exception
when others then
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        return null;
END;
$function$
;











