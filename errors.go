package acl

import (
	"github.com/joaosoft/errors"
	"github.com/joaosoft/web"
)

var (
	ErrorGeneric         = errors.New(errors.LevelError, int(web.StatusForbidden), "%s")
	ErrorAclAccessDenied = errors.New(errors.LevelError, int(web.StatusForbidden), "acl access denied")
)
