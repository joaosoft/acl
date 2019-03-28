
-- migrate up
CREATE SCHEMA IF NOT EXISTS "acl";


CREATE OR REPLACE FUNCTION "acl".function_updated_at()
  RETURNS TRIGGER AS $$
  BEGIN
   NEW.updated_at = now();
   RETURN NEW;
  END;
  $$ LANGUAGE 'plpgsql';


-- application domains
CREATE TABLE "acl"."domain" (
	id_domain 		    TEXT PRIMARY KEY,
	"name"  		    TEXT NOT NULL,
	"key"  		        TEXT NOT NULL UNIQUE,
	description			TEXT NOT NULL,
	"active"			BOOLEAN DEFAULT TRUE NOT NULL,
	created_at			TIMESTAMP DEFAULT NOW(),
	updated_at			TIMESTAMP DEFAULT NOW()
);

-- domain endpoints
CREATE TABLE "acl".endpoint (
	id_endpoint         TEXT PRIMARY KEY,
	fk_domain           TEXT NOT NULL REFERENCES "acl"."domain" (id_domain),
	"method"  		    TEXT NOT NULL,
	"endpoint"  		TEXT NOT NULL,
	description			TEXT NOT NULL,
	"check"				BOOLEAN DEFAULT TRUE NOT NULL,
	"active"		    BOOLEAN DEFAULT TRUE NOT NULL,
	created_at			TIMESTAMP DEFAULT NOW(),
	updated_at			TIMESTAMP DEFAULT NOW(),
	UNIQUE(fk_domain, "method", "endpoint")
);

-- domain roles
CREATE TABLE "acl"."role" (
	id_role 		    TEXT PRIMARY KEY,
	fk_domain           TEXT NOT NULL REFERENCES "acl"."domain" (id_domain),
	"name"  		    TEXT NOT NULL,
	"key"  		        TEXT NOT NULL,
	description			TEXT NOT NULL,
	"active"			BOOLEAN DEFAULT TRUE NOT NULL,
	created_at			TIMESTAMP DEFAULT NOW(),
	updated_at			TIMESTAMP DEFAULT NOW(),
	UNIQUE(fk_domain, "key")
);

-- domain categories
CREATE TABLE "acl"."category" (
	id_category         TEXT PRIMARY KEY,
	fk_role             TEXT NOT NULL REFERENCES "acl"."role" (id_role),
	"name"  		    TEXT NOT NULL,
	"key"  		        TEXT NOT NULL,
	description			TEXT NOT NULL,
	"active"			BOOLEAN DEFAULT TRUE NOT NULL,
	created_at			TIMESTAMP DEFAULT NOW(),
	updated_at			TIMESTAMP DEFAULT NOW(),
	UNIQUE(fk_role, "key")
);


-- resource types
CREATE TABLE "acl"."resource_type" (
	id_resource_type    TEXT PRIMARY KEY,
	"name"  		    TEXT NOT NULL,
	"key"  		        TEXT NOT NULL UNIQUE,
	description			TEXT NOT NULL,
	"active"			BOOLEAN DEFAULT TRUE NOT NULL,
	created_at			TIMESTAMP DEFAULT NOW(),
	updated_at			TIMESTAMP DEFAULT NOW()
);

-- resources
CREATE TABLE "acl"."resource" (
	id_resource         TEXT PRIMARY KEY,
	fk_role             TEXT NOT NULL REFERENCES "acl"."role" (id_role),
	fk_resource_type    TEXT NOT NULL REFERENCES "acl"."resource_type" (id_resource_type),
	"name"  		    TEXT NOT NULL,
	"key"  		        TEXT NOT NULL,
	description			TEXT NOT NULL,
	"active"			BOOLEAN DEFAULT TRUE NOT NULL,
	created_at			TIMESTAMP DEFAULT NOW(),
	updated_at			TIMESTAMP DEFAULT NOW(),
	UNIQUE(fk_role, "key")
);

-- category resources
CREATE TABLE "acl"."endpoint_resource" (
	fk_role             TEXT NOT NULL REFERENCES "acl"."role" (id_role),
	fk_endpoint         TEXT NOT NULL,
	fk_resource         TEXT NOT NULL,
	"active"			BOOLEAN DEFAULT TRUE NOT NULL,
	created_at			TIMESTAMP DEFAULT NOW(),
	updated_at			TIMESTAMP DEFAULT NOW()
);


-- triggers
CREATE TRIGGER trigger_acl_domain_updated_at BEFORE UPDATE
  ON "acl"."domain" FOR EACH ROW EXECUTE PROCEDURE "acl".function_updated_at();

CREATE TRIGGER trigger_acl_endpoint_updated_at BEFORE UPDATE
  ON "acl"."endpoint" FOR EACH ROW EXECUTE PROCEDURE "acl".function_updated_at();

CREATE TRIGGER trigger_acl_role_updated_at BEFORE UPDATE
  ON "acl"."role" FOR EACH ROW EXECUTE PROCEDURE "acl".function_updated_at();

CREATE TRIGGER trigger_acl_category_updated_at BEFORE UPDATE
  ON "acl"."category" FOR EACH ROW EXECUTE PROCEDURE "acl".function_updated_at();

CREATE TRIGGER trigger_acl_resource_updated_at BEFORE UPDATE
  ON "acl"."resource" FOR EACH ROW EXECUTE PROCEDURE "acl".function_updated_at();

CREATE TRIGGER trigger_acl_resource_type_updated_at BEFORE UPDATE
  ON "acl"."resource_type" FOR EACH ROW EXECUTE PROCEDURE "acl".function_updated_at();

CREATE TRIGGER trigger_acl_endpoint_resource_updated_at BEFORE UPDATE
  ON "acl"."endpoint_resource" FOR EACH ROW EXECUTE PROCEDURE "acl".function_updated_at();






-- migrate down
DROP TRIGGER trigger_acl_domain_updated_at ON "acl"."domain";
DROP TRIGGER trigger_acl_endpoint_updated_at ON "acl"."endpoint";
DROP TRIGGER trigger_acl_role_updated_at ON "acl"."role";
DROP TRIGGER trigger_acl_category_updated_at ON "acl"."category";
DROP TRIGGER trigger_acl_resource_updated_at ON "acl"."resource";
DROP TRIGGER trigger_acl_resource_type_updated_at ON "acl"."resource_type";
DROP TRIGGER trigger_acl_endpoint_resource_updated_at ON "acl"."endpoint_resource";

DROP TABLE "acl"."endpoint_resource";
DROP TABLE "acl"."resource_type";
DROP TABLE "acl"."resource";
DROP TABLE "acl"."category";
DROP TABLE "acl"."role";
DROP TABLE "acl"."endpoint";
DROP TABLE "acl"."domain";

DROP FUNCTION "acl".function_updated_at;

DROP SCHEMA "acl" CASCADE;
