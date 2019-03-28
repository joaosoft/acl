package acl

import "fmt"

func format(schema, table string) string {
	return fmt.Sprintf("%s.%s", schema, table)
}

var (
	aclTableDomain           = format(schemaAcl, "domain")
	aclTableEndpoint         = format(schemaAcl, "endpoint")
	aclTableRole             = format(schemaAcl, "role")
	aclTableCategory         = format(schemaAcl, "category")
	aclTableResourceType     = format(schemaAcl, "resource_type")
	aclTableResource         = format(schemaAcl, "resource")
	aclTableEndpointResource = format(schemaAcl, "endpoint_resource")
)
