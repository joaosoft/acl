package acl

type IStorageDB interface {
	GetResourceCategories(domainKey string) (Categories, error)
	GetResourceCategoryPages(domainKey, resourceCategoryKey string) (Pages, error)
	GetResourceCategoryPage(domainKey, resourcePageKey string) (*Page, error)
	GetPageResources(roleKey, resourcePageKey, user string) (Resources, error)
	GetPageResourcesByType(roleKey, resourcePageKey string, resourceTypeKey, user string) (Resources, error)
	CheckEndpointAccess(roleKey, resourceTypeKey, method, endpoint, user string) (isAllowed bool, err error)
}

type Interactor struct {
	config  *AclConfig
	storage IStorageDB
}

func NewInteractor(config *AclConfig, storageDB IStorageDB) *Interactor {
	return &Interactor{
		config:  config,
		storage: storageDB,
	}
}

func (i *Interactor) GetResourceCategories(request *GetResourceCategoriesRequest) (Categories, error) {
	log.WithFields(map[string]interface{}{"method": "GetResourceCategories"})
	log.Infof("getting categories [domain key: %s]", request.DomainKey)
	categories, err := i.storage.GetResourceCategories(request.DomainKey)
	if err != nil {
		log.WithFields(map[string]interface{}{"error": err.Error()}).
			Errorf("error getting categories [domain key: %s, error: %s]", request.DomainKey, err).ToError()
		return nil, err
	}

	return categories, nil
}

func (i *Interactor) GetResourceCategoryPages(request *GetResourceCategoryPagesRequest) (Pages, error) {
	log.WithFields(map[string]interface{}{"method": "GetResourceCategoryPages"})
	log.Infof("getting category pages [domain key: %s, resource category key: %s]", request.DomainKey, request.ResourceCategoryKey)
	pages, err := i.storage.GetResourceCategoryPages(request.DomainKey, request.ResourceCategoryKey)
	if err != nil {
		log.WithFields(map[string]interface{}{"error": err.Error()}).
			Errorf("error getting category pages [domain key: %s, resource category key: %s, error: %s]", request.DomainKey, request.ResourceCategoryKey, err).ToError()
		return nil, err
	}

	return pages, nil
}

func (i *Interactor) GetResourceCategoryPage(request *GetResourceCategoryPageRequest) (*Page, error) {
	log.WithFields(map[string]interface{}{"method": "GetResourceCategoryPage"})
	log.Infof("getting category pages [domain key: %s, resource page key: %s]", request.DomainKey, request.ResourcePageKey)
	page, err := i.storage.GetResourceCategoryPage(request.DomainKey, request.ResourcePageKey)
	if err != nil {
		log.WithFields(map[string]interface{}{"error": err.Error()}).
			Errorf("error getting category pages [domain key: %s, resource page key: %s, error: %s]", request.DomainKey, request.ResourcePageKey, err).ToError()
		return nil, err
	}

	return page, nil
}

func (i *Interactor) GetPageResources(request *GetPageResourcesRequest) (Resources, error) {
	log.WithFields(map[string]interface{}{"method": "GetPageResources"})
	log.Infof("getting resources [role key: %s, resource page key: %s, user: %s]", request.UrlParams.RoleKey, request.UrlParams.ResourcePageKey, request.Params.User)
	resources, err := i.storage.GetPageResources(request.UrlParams.RoleKey, request.UrlParams.ResourcePageKey, request.Params.User)
	if err != nil {
		log.WithFields(map[string]interface{}{"error": err.Error()}).
			Errorf("error getting categories [role key: %s, resource page key: %s, user: %s, error: %s]", request.UrlParams.RoleKey, request.UrlParams.ResourcePageKey, request.Params.User, err).ToError()
		return nil, err
	}

	return resources, nil
}

func (i *Interactor) GetResourcesByType(request *GetPageResourcesByTypeRequest) (Resources, error) {
	log.WithFields(map[string]interface{}{"method": "GetPageResourcesByType"})
	log.Infof("getting resources [role key: %s, resource page key: %s, resource type: %s, user: %s]", request.UrlParams.RoleKey, request.UrlParams.ResourcePageKey, request.UrlParams.ResourceTypeKey, request.Params.User)
	resources, err := i.storage.GetPageResourcesByType(request.UrlParams.RoleKey, request.UrlParams.ResourcePageKey, request.UrlParams.ResourceTypeKey, request.Params.User)
	if err != nil {
		log.WithFields(map[string]interface{}{"error": err.Error()}).
			Errorf("error getting categories [role key: %s, resource page key: %s, resource type: %s, user: %s, error: %s]", request.UrlParams.RoleKey, request.UrlParams.ResourcePageKey, request.UrlParams.ResourceTypeKey, request.Params.User, err).ToError()
		return nil, err
	}

	return resources, nil
}

func (i *Interactor) CheckEndpointAccess(request *CheckEndpointAccessRequest) (bool, error) {
	log.WithFields(map[string]interface{}{"method": "CheckEndpointAccess"})
	log.Infof("checking access [method: %s, endpoint: %s, user: %s]", request.Params.Method, request.Params.Endpoint, request.Params.User)
	isAllowed, err := i.storage.CheckEndpointAccess(request.UrlParams.RoleKey, request.UrlParams.ResourceTypeKey, request.Params.Method, request.Params.Endpoint, request.Params.User)
	if err != nil {
		log.WithFields(map[string]interface{}{"error": err.Error()}).
			Errorf("error checking access [method: %s, endpoint: %s, user: %s, error: %s]", request.Params.Method, request.Params.Endpoint, request.Params.User, err).ToError()
		return false, err
	}

	return isAllowed, nil
}

func (i *Interactor) CheckAcl(request *CheckAclMiddleware) (bool, error) {
	log.WithFields(map[string]interface{}{"method": "CheckAcl"})
	log.Infof("checking access [method: %s, endpoint: %s, user: %s]", request.Method, request.Endpoint, request.Params.User)
	isAllowed, err := i.storage.CheckEndpointAccess(request.Params.RoleKey, request.Params.ResourceTypeKey, request.Method, request.Endpoint, request.Params.User)
	if err != nil {
		log.WithFields(map[string]interface{}{"error": err.Error()}).
			Errorf("error checking access [method: %s, endpoint: %s, user: %s, error: %s]", request.Method, request.Endpoint, request.Params.User, err).ToError()
		return false, err
	}

	return isAllowed, nil
}
