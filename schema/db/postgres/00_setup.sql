
-- migrate up

CREATE SCHEMA IF NOT EXISTS "acl";

-- application domains
CREATE TABLE "acl"."domain" (
	id_domain 		            SERIAL PRIMARY KEY,
	"name"  		            TEXT NOT NULL,
	"key"  		                TEXT NOT NULL UNIQUE,
	description			        TEXT NOT NULL,
	"active"			        BOOLEAN DEFAULT TRUE NOT NULL,
	created_at			        TIMESTAMP DEFAULT NOW(),
	updated_at			        TIMESTAMP DEFAULT NOW()
);

-- domain roles
CREATE TABLE "acl"."role" (
	id_role 		            SERIAL PRIMARY KEY,
	fk_domain                   INTEGER NOT NULL REFERENCES "acl"."domain" (id_domain),
	"name"  		            TEXT NOT NULL,
	"key"  		                TEXT NOT NULL,
	description			        TEXT NOT NULL,
	"active"			        BOOLEAN DEFAULT TRUE NOT NULL,
	created_at			        TIMESTAMP DEFAULT NOW(),
	updated_at			        TIMESTAMP DEFAULT NOW(),
	UNIQUE(fk_domain, "key")
);

-- resource categories
CREATE TABLE "acl"."resource_category" (
	id_resource_category        SERIAL PRIMARY KEY,
	fk_domain                   INTEGER NOT NULL REFERENCES "acl"."domain" (id_domain),
	"name"  		            TEXT NOT NULL,
	"key"  		                TEXT NOT NULL,
	description			        TEXT NOT NULL,
	fk_parent_resource_category INTEGER REFERENCES "acl"."resource_category" (id_resource_category),
	"active"			        BOOLEAN DEFAULT TRUE NOT NULL,
	created_at			        TIMESTAMP DEFAULT NOW(),
	updated_at			        TIMESTAMP DEFAULT NOW(),
	UNIQUE(fk_domain, "key")
);

-- resource pages
CREATE TABLE "acl"."resource_page" (
	id_resource_page            SERIAL PRIMARY KEY,
	fk_domain                   INTEGER NOT NULL REFERENCES "acl"."domain" (id_domain),
	fk_resource_category        INTEGER NOT NULL REFERENCES "acl"."resource_category" (id_resource_category),
	"name"  		            TEXT NOT NULL,
    "key"  		                TEXT NOT NULL,
	description			        TEXT NOT NULL,
	fk_parent_resource_page     INTEGER REFERENCES "acl"."resource_page" (id_resource_page),
	"active"			        BOOLEAN DEFAULT TRUE NOT NULL,
	created_at			        TIMESTAMP DEFAULT NOW(),
	updated_at			        TIMESTAMP DEFAULT NOW(),
	UNIQUE(fk_domain, fk_resource_category, "key")
);

-- resource types
CREATE TABLE "acl"."resource_type" (
	id_resource_type            SERIAL PRIMARY KEY,
	"name"  		            TEXT NOT NULL,
	"key"  		                TEXT NOT NULL UNIQUE,
	description			        TEXT NOT NULL,
	"active"			        BOOLEAN DEFAULT TRUE NOT NULL,
	created_at			        TIMESTAMP DEFAULT NOW(),
	updated_at			        TIMESTAMP DEFAULT NOW()
);

-- resources
CREATE TABLE "acl"."resource" (
	id_resource                 SERIAL PRIMARY KEY,
	fk_domain                   INTEGER NOT NULL REFERENCES "acl"."domain" (id_domain),
	fk_resource_type            INTEGER NOT NULL REFERENCES "acl"."resource_type" (id_resource_type),
	fk_resource_page            INTEGER NOT NULL REFERENCES "acl"."resource_page" (id_resource_page),
	"name"  		            TEXT NOT NULL,
	"key"  		                TEXT NOT NULL,
	description			        TEXT NOT NULL,
	"active"			        BOOLEAN DEFAULT TRUE NOT NULL,
	created_at			        TIMESTAMP DEFAULT NOW(),
	updated_at			        TIMESTAMP DEFAULT NOW(),
	UNIQUE(fk_domain, "key")
);

-- role resources
CREATE TABLE "acl"."role_resource" (
	fk_role                     INTEGER NOT NULL REFERENCES "acl"."role" (id_role),
	fk_resource                 INTEGER NOT NULL REFERENCES "acl"."resource" (id_resource),
	"active"			        BOOLEAN DEFAULT TRUE NOT NULL,
	created_at			        TIMESTAMP DEFAULT NOW(),
	updated_at			        TIMESTAMP DEFAULT NOW(),
	UNIQUE(fk_role, fk_resource)
);

-- user resource restrictions
CREATE TABLE "acl"."user_resource" (
	fk_user                     TEXT NOT NULL,
	fk_resource                 INTEGER NOT NULL REFERENCES "acl"."resource" (id_resource),
	"allow"			            BOOLEAN DEFAULT TRUE NOT NULL,
	"active"			        BOOLEAN DEFAULT TRUE NOT NULL,
	created_at			        TIMESTAMP DEFAULT NOW(),
	updated_at			        TIMESTAMP DEFAULT NOW(),
	UNIQUE(fk_user, fk_resource)
);

-- domain endpoints
CREATE TABLE "acl".endpoint (
	id_endpoint                 SERIAL PRIMARY KEY,
	fk_domain                   INTEGER NOT NULL REFERENCES "acl"."domain" (id_domain),
	"method"  		            TEXT NOT NULL,
	"endpoint"  		        TEXT NOT NULL,
	description			        TEXT NOT NULL,
	"check"				        BOOLEAN DEFAULT TRUE NOT NULL,
	"active"		            BOOLEAN DEFAULT TRUE NOT NULL,
	created_at			        TIMESTAMP DEFAULT NOW(),
	updated_at			        TIMESTAMP DEFAULT NOW(),
	UNIQUE(fk_domain, "method", "endpoint")
);

-- endpoint resources
CREATE TABLE "acl"."endpoint_resource" (
	fk_role                     INTEGER NOT NULL REFERENCES "acl"."role" (id_role),
	fk_endpoint                 INTEGER NOT NULL REFERENCES "acl"."endpoint" (id_endpoint),
	fk_resource                 INTEGER NOT NULL REFERENCES "acl"."resource" (id_resource),
	"active"			        BOOLEAN DEFAULT TRUE NOT NULL,
	created_at			        TIMESTAMP DEFAULT NOW(),
	updated_at			        TIMESTAMP DEFAULT NOW()
);

-- user endpoint restrictions
CREATE TABLE "acl"."user_endpoint" (
	fk_user                     TEXT NOT NULL,
	fk_endpoint                 INTEGER NOT NULL REFERENCES "acl"."endpoint" (id_endpoint),
	"allow"			            BOOLEAN DEFAULT TRUE NOT NULL,
	"active"			        BOOLEAN DEFAULT TRUE NOT NULL,
	created_at			        TIMESTAMP DEFAULT NOW(),
	updated_at			        TIMESTAMP DEFAULT NOW(),
	UNIQUE(fk_user, fk_endpoint)
);



-- migrate down

DROP TABLE "acl"."user_endpoint";
DROP TABLE "acl"."endpoint_resource";
DROP TABLE "acl"."endpoint";
DROP TABLE "acl"."user_resource";
DROP TABLE "acl"."role_resource";
DROP TABLE "acl"."resource";
DROP TABLE "acl"."resource_type";
DROP TABLE "acl"."resource_page";
DROP TABLE "acl"."resource_category";
DROP TABLE "acl"."role";
DROP TABLE "acl"."domain";

DROP SCHEMA "acl" CASCADE;
