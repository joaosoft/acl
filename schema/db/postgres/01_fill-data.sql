
-- migrate up

-- domain
INSERT INTO "acl"."domain" (id_domain, "name", "key", description, "active", created_at, updated_at) VALUES
('1', 'Application', 'app', 'acl app', true, now(), now());

-- role
INSERT INTO "acl"."role" (id_role, fk_domain, "name", "key", description, "active", created_at, updated_at) VALUES
('1', '1', 'Administrator', 'admin', 'application administrator', true, now(), now()),
('2', '1', 'User', 'user', 'application user', true, now(), now());

-- resource_category
INSERT INTO "acl"."resource_category" (id_resource_category, fk_domain, "name", "key", description, fk_parent_resource_category, "active", created_at, updated_at) VALUES
('1', '1', 'Profile', 'profile', 'profile page', NULL, true, now(), now()),
('2', '1', 'Projects', 'projects', 'projects page', NULL, true, now(), now()),
('3', '1', 'About', 'about', 'about page', NULL, true, now(), now());

-- resource_page
INSERT INTO "acl"."resource_page" (id_resource_page, fk_domain, fk_resource_category, "name", "key", description, fk_parent_resource_page, "active", created_at, updated_at) VALUES
('1', '1', '1', 'Profile Page', 'profile', 'profile page', NULL, true, now(), now()),
('2', '1', '1', 'Projects Page', 'projects', 'projects page', NULL, true, now(), now()),
('3', '1', '2', 'About Page', 'about', 'about page', NULL, true, now(), now());

-- resource_type
INSERT INTO "acl"."resource_type" (id_resource_type, "name", "key", description, "active", created_at, updated_at) VALUES
('1', 'Application Resource', 'app', 'application resource', true, now(), now()),
('2', 'Business Resource', 'business', 'business resource', true, now(), now());

-- resource
INSERT INTO "acl"."resource" (id_resource, fk_domain, fk_resource_type, fk_resource_page, "name", "key", description, "active", created_at, updated_at) VALUES
('1', '1', '1', '1', 'Read Access Profile', 'access.profile.read', 'read access to profile page', true, now(), now()),
('2', '1', '1', '1', 'Write Access Profile', 'access.profile.write', 'write access to profile page', true, now(), now()),
('3', '1', '1', '2', 'Read Access Projects', 'access.projects.read', 'read access to projects page', true, now(), now()),
('4', '1', '1', '2', 'Write Access Projects', 'access.projects.write', 'write access to projects page', true, now(), now()),
('5', '1', '1', '3', 'Read Access About', 'access.about.read', 'read access about', true, now(), now()),
('6', '1', '1', '3', 'Write Access About', 'access.about.write', 'write access about', true, now(), now());

-- role_resource
INSERT INTO "acl"."role_resource" (fk_resource, fk_role, "active", created_at, updated_at) VALUES
('1', '1', true, now(), now()),
('2', '1', true, now(), now()),
('3', '1', true, now(), now()),
('4', '1', true, now(), now()),
('5', '1', true, now(), now()),
('6', '1', true, now(), now());

-- user_resource
INSERT INTO "acl"."user_resource" (fk_user, fk_resource, "active", "allow", created_at, updated_at) VALUES
('111', '1', true, true, now(), now()),
('222', '2', true, true, now(), now());





-- endpoint
INSERT INTO "acl".endpoint (id_endpoint, fk_domain, "method", "endpoint", description, "check", "active", created_at, updated_at) VALUES
('1', '1', 'GET', '/api/v1/profile/sections/:section_key', 'sections endpoint', true, true, now(), now());

-- endpoint_resource
INSERT INTO "acl"."endpoint_resource" (fk_role, fk_endpoint, fk_resource, "active", created_at, updated_at) VALUES
('1', '1', '1', true, now(), now()),
('1', '2', '2', true, now(), now()),
('1', '2', '3', true, now(), now()),
('1', '2', '4', true, now(), now()),
('1', '2', '5', true, now(), now()),
('1', '2', '6', true, now(), now());

-- user_endpoint
INSERT INTO "acl"."user_endpoint" (fk_user, fk_endpoint, "active", "allow", created_at, updated_at) VALUES
('111', '1', true, true, now(), now()),
('222', '1', true, true, now(), now());



-- migrate down

DROP TABLE "acl"."resource";
DROP TABLE "acl"."resource_type";
DROP TABLE "acl"."resource_page";
DROP TABLE "acl"."resource_category";
DROP TABLE "acl"."role";
DROP TABLE "acl"."domain";

DROP TABLE "acl"."endpoint_resource";
DROP TABLE "acl"."endpoint";