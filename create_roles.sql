-- Allow both roles to see and use the schema
GRANT USAGE ON SCHEMA "C23405732" TO mechanic_role, supervisor_role;

-- Mechanic permissions
GRANT SELECT ON car, test, test_center, testparttype TO mechanic_role;
GRANT SELECT, INSERT, UPDATE ON testpartresult TO mechanic_role;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA "C23405732" TO mechanic_role;

-- Supervisor permissions
GRANT SELECT, INSERT, UPDATE ON test, mechanic TO supervisor_role;
GRANT SELECT, UPDATE ON testpartresult TO supervisor_role;
GRANT SELECT ON owner, car, letter TO supervisor_role;
GRANT INSERT ON letter TO supervisor_role;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA "C23405732" TO supervisor_role;
