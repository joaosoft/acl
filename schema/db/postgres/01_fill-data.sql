
-- migrate up

-- domain
INSERT INTO "acl"."domain" (id_domain, "name", "key", description, active, created_at, updated_at) VALUES
('1', 'Application', 'app', 'acl app', true, '2019-03-28 19:59:52.213', '2019-03-28 19:59:55.912');

-- role
INSERT INTO "acl"."role" (id_role, fk_domain, "name", "key", description, active, created_at, updated_at) VALUES
('1', '1', 'Administrator', 'admin', 'application administrator', true, '2019-03-28 20:00:29.819', '2019-03-28 20:00:29.819'),
('2', '1', 'User', 'user', 'application user', true, '2019-03-28 20:00:47.495', '2019-03-28 20:00:47.495');

-- resource_category
INSERT INTO "acl"."resource_category" (id_resource_category, fk_role, "name", "key", description, active, created_at, updated_at) VALUES
('1', '1', 'Home Page', 'home', 'site home page', true, '2019-03-28 20:01:23.161', '2019-03-28 20:01:23.161'),
('2', '1', 'Settings Page', 'settings', 'site settings page', true, '2019-03-28 20:01:50.697', '2019-03-28 20:01:50.697');

-- resource_page
INSERT INTO "acl"."resource_page" (id_resource_page, fk_role, fk_resource_category, "name", "key", description, fk_parent_resource_page, active, created_at, updated_at) VALUES
('1', '1', '1', 'Home Page', 'home', 'site home page', NULL, true, '2019-03-28 20:01:23.161', '2019-03-28 20:01:23.161'),
('2', '1', '2', 'Settings Page', 'settings', 'site settings page', NULL, true, '2019-03-28 20:01:50.697', '2019-03-28 20:01:50.697');

-- resource_type
INSERT INTO "acl"."resource_type" (id_resource_type, "name", "key", description, active, created_at, updated_at) VALUES
('1', 'Application Resource', 'app', 'application resource', true, '2019-03-28 20:03:29.061', '2019-03-28 20:04:12.060'),
('2', 'Business Resource', 'business', 'busioness resource', true, '2019-03-28 20:04:12.054', '2019-03-28 20:04:12.054');

-- resource
INSERT INTO "acl"."resource" (id_resource, fk_role, fk_resource_type, fk_resource_page, "name", "key", description, active, created_at, updated_at) VALUES
('1', '1', '1', '1', 'Read Access Home', 'access.home.read', 'read access to home page', true, '2019-03-28 20:03:29.061', '2019-03-28 20:04:12.060'),
('2', '1', '1', '1', 'Write Access Home', 'access.home.write', 'write access to home page', true, '2019-03-28 20:04:12.054', '2019-03-28 20:04:12.054'),
('3', '1', '2', '2', 'Read Business Dummy', 'business.dummy.read', 'read business dummy', true, '2019-03-28 20:03:29.061', '2019-03-28 20:04:12.060'),
('4', '1', '2', '2', 'Write Business Dummy', 'business.dummy.write', 'write business dummy', true, '2019-03-28 20:04:12.054', '2019-03-28 20:04:12.054');




-- endpoint
INSERT INTO "acl".endpoint (id_endpoint, fk_domain, "method", "endpoint", description, "check", active, created_at, updated_at) VALUES
('1', '1', 'GET', '/api/v1/dummy', 'dummy endpoint', true, true, '2019-03-28 20:02:45.184', '2019-03-28 20:02:45.184');

-- endpoint_resource
INSERT INTO "acl"."endpoint_resource" (fk_role, fk_endpoint, fk_resource, active, created_at, updated_at) VALUES
('1', '1', '1', true, '2019-03-28 20:04:30.768', '2019-03-28 20:04:30.768'),
('1', '2', '2', true, '2019-03-28 20:04:42.158', '2019-03-28 20:04:42.158');




-- migrate down

DROP TABLE "acl"."resource";
DROP TABLE "acl"."resource_type";
DROP TABLE "acl"."resource_page";
DROP TABLE "acl"."resource_category";
DROP TABLE "acl"."role";
DROP TABLE "acl"."domain";

DROP TABLE "acl"."endpoint_resource";
DROP TABLE "acl"."endpoint";