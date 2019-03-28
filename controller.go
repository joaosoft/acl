package acl

import (
	"github.com/joaosoft/validator"
	"github.com/joaosoft/web"
)

type Controller struct {
	config     *AclConfig
	interactor *Interactor
}

func NewController(config *AclConfig, interactor *Interactor) *Controller {
	return &Controller{
		config:     config,
		interactor: interactor,
	}
}

func (c *Controller) GetCategoriesHandler(ctx *web.Context) error {
	request := &GetCategoriesRequest{}

	if err := ctx.Request.BindUrlParams(&request); err != nil {
		return ctx.Response.JSON(web.StatusBadRequest, err)
	}

	if errs := validator.Validate(request); len(errs) > 0 {
		return ctx.Response.JSON(web.StatusBadRequest, errs)
	}

	response, err := c.interactor.GetCategories(request)
	if err != nil {
		return ctx.Response.JSON(web.StatusInternalServerError, ErrorResponse{Code: web.StatusInternalServerError, Message: err.Error()})
	}

	return ctx.Response.JSON(web.StatusOK, response)
}

func (c *Controller) GetResourcesHandler(ctx *web.Context) error {
	request := &GetResourcesRequest{}

	if err := ctx.Request.BindUrlParams(&request); err != nil {
		return ctx.Response.JSON(web.StatusBadRequest, err)
	}

	if errs := validator.Validate(request); len(errs) > 0 {
		return ctx.Response.JSON(web.StatusBadRequest, errs)
	}

	response, err := c.interactor.GetResources(request)
	if err != nil {
		return ctx.Response.JSON(web.StatusInternalServerError, ErrorResponse{Code: web.StatusInternalServerError, Message: err.Error()})
	}

	return ctx.Response.JSON(web.StatusOK, response)
}

func (c *Controller) GetResourcesByTypeHandler(ctx *web.Context) error {
	request := &GetResourcesByTypeRequest{}

	if err := ctx.Request.BindUrlParams(&request); err != nil {
		return ctx.Response.JSON(web.StatusBadRequest, err)
	}

	if errs := validator.Validate(request); len(errs) > 0 {
		return ctx.Response.JSON(web.StatusBadRequest, errs)
	}

	response, err := c.interactor.GetResourcesByType(request)
	if err != nil {
		return ctx.Response.JSON(web.StatusInternalServerError, ErrorResponse{Code: web.StatusInternalServerError, Message: err.Error()})
	}

	return ctx.Response.JSON(web.StatusOK, response)
}

func (c *Controller) CheckEndpointAccessHandler(ctx *web.Context) error {
	request := &CheckEndpointAccessRequest{}

	if err := ctx.Request.BindUrlParams(&request.UrlParams); err != nil {
		return ctx.Response.JSON(web.StatusBadRequest, err)
	}

	if err := ctx.Request.BindParams(&request.Params); err != nil {
		return ctx.Response.JSON(web.StatusBadRequest, err)
	}

	if errs := validator.Validate(request); len(errs) > 0 {
		return ctx.Response.JSON(web.StatusBadRequest, errs)
	}

	isAllowed, err := c.interactor.CheckEndpointAccess(request)
	if err != nil {
		return ctx.Response.JSON(web.StatusInternalServerError, ErrorResponse{Code: web.StatusInternalServerError, Message: err.Error()})
	}

	return ctx.Response.JSON(web.StatusOK, &CheckEndpointAccessResponse{IsAllowed: isAllowed})
}

func (c *Controller) DummyHandler(ctx *web.Context) error {
	return ctx.Response.NoContent(web.StatusNoContent)

}
