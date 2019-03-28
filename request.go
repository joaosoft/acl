package acl

import "github.com/joaosoft/web"

type ErrorResponse struct {
	Code    web.Status `json:"code,omitempty"`
	Message string     `json:"message,omitempty"`
	Cause   string     `json:"cause,omitempty"`
}

type GetCategoriesRequest struct {
	DomainKey string `json:"domain_key" validate:"notzero"`
	RoleKey   string `json:"role_key" validate:"notzero"`
}

type CheckEndpointAccessRequest struct {
	UrlParams struct {
		DomainKey       string `json:"domain_key" validate:"notzero"`
		RoleKey         string `json:"role_key" validate:"notzero"`
		ResourceTypeKey string `json:"resource_type_key" validate:"notzero"`
	}
	Params struct {
		Method   string `json:"method" validate:"notzero"`
		Endpoint string `json:"endpoint" validate:"notzero"`
	}
}

type CheckAclMiddleware struct {
	Method   string `json:"method" validate:"notzero"`
	Endpoint string `json:"endpoint" validate:"notzero"`
	Params   struct {
		DomainKey       string `json:"domain_key" validate:"notzero"`
		RoleKey         string `json:"role_key" validate:"notzero"`
		ResourceTypeKey string `json:"resource_type_key" validate:"notzero"`
	}
}

type CheckEndpointAccessResponse struct {
	IsAllowed bool `json:"is_allowed"`
}

type GetResourcesRequest struct {
	DomainKey   string `json:"domain_key" validate:"notzero"`
	RoleKey     string `json:"role_key" validate:"notzero"`
	CategoryKey string `json:"category_key" validate:"notzero"`
}

type GetResourcesByTypeRequest struct {
	DomainKey       string `json:"domain_key" validate:"notzero"`
	RoleKey         string `json:"role_key" validate:"notzero"`
	CategoryKey     string `json:"category_key" validate:"notzero"`
	ResourceTypeKey string `json:"resource_type_key" validate:"notzero"`
}
