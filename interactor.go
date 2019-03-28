package acl

type IStorageDB interface {
	GetCategories(domainKey, roleKey string) (Categories, error)
	GetResources(domainKey, roleKey, categoryKey string) (Resources, error)
	GetResourcesByType(domainKey, roleKey, categoryKey, resourceTypeKey string) (Resources, error)
	CheckEndpointAccess(domainKey, roleKey, resourceTypeKey, method, endpoint string) (isAllowed bool, err error)
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

func (i *Interactor) GetCategories(request *GetCategoriesRequest) (Categories, error) {
	log.WithFields(map[string]interface{}{"method": "GetCategories"})
	log.Infof("getting categories [domain key: %s, role key: %s]", request.DomainKey, request.RoleKey)
	categories, err := i.storage.GetCategories(request.DomainKey, request.RoleKey)
	if err != nil {
		log.WithFields(map[string]interface{}{"error": err.Error()}).
			Errorf("error getting categories [domain key: %s, role key: %s, error: %s]", request.DomainKey, request.RoleKey, err).ToError()
		return nil, err
	}

	return categories, nil
}

func (i *Interactor) GetResources(request *GetResourcesRequest) (Resources, error) {
	log.WithFields(map[string]interface{}{"method": "GetResources"})
	log.Infof("getting resources [domain key: %s, role key: %s, category key: %s]", request.DomainKey, request.RoleKey, request.CategoryKey)
	resources, err := i.storage.GetResources(request.DomainKey, request.RoleKey, request.CategoryKey)
	if err != nil {
		log.WithFields(map[string]interface{}{"error": err.Error()}).
			Errorf("error getting categories [domain key: %s, role key: %s, category key: %s, error: %s]", request.DomainKey, request.RoleKey, request.CategoryKey, err).ToError()
		return nil, err
	}

	return resources, nil
}

func (i *Interactor) GetResourcesByType(request *GetResourcesByTypeRequest) (Resources, error) {
	log.WithFields(map[string]interface{}{"method": "GetResourcesByType"})
	log.Infof("getting resources [domain key: %s, role key: %s, category key: %s, type: %s]", request.DomainKey, request.RoleKey, request.CategoryKey, request.ResourceTypeKey)
	resources, err := i.storage.GetResourcesByType(request.DomainKey, request.RoleKey, request.CategoryKey, request.ResourceTypeKey)
	if err != nil {
		log.WithFields(map[string]interface{}{"error": err.Error()}).
			Errorf("error getting categories [domain key: %s, role key: %s, category key: %s, type: %s, error: %s]", request.DomainKey, request.RoleKey, request.CategoryKey, request.ResourceTypeKey, err).ToError()
		return nil, err
	}

	return resources, nil
}

func (i *Interactor) CheckEndpointAccess(request *CheckEndpointAccessRequest) (bool, error) {
	log.WithFields(map[string]interface{}{"method": "CheckEndpointAccess"})
	log.Infof("checking access [method: %s, endpoint: %s]", request.Params.Method, request.Params.Endpoint)
	isAllowed, err := i.storage.CheckEndpointAccess(request.UrlParams.DomainKey, request.UrlParams.RoleKey, request.UrlParams.ResourceTypeKey, request.Params.Method, request.Params.Endpoint)
	if err != nil {
		log.WithFields(map[string]interface{}{"error": err.Error()}).
			Errorf("error checking access [method: %s, endpoint: %s, error: %s]", request.Params.Method, request.Params.Endpoint, err).ToError()
		return false, err
	}

	return isAllowed, nil
}

func (i *Interactor) CheckAcl(request *CheckAclMiddleware) (bool, error) {
	log.WithFields(map[string]interface{}{"method": "CheckAcl"})
	log.Infof("checking access [method: %s, endpoint: %s]", request.Method, request.Endpoint)
	isAllowed, err := i.storage.CheckEndpointAccess(request.Params.DomainKey, request.Params.RoleKey, request.Params.ResourceTypeKey, request.Method, request.Endpoint)
	if err != nil {
		log.WithFields(map[string]interface{}{"error": err.Error()}).
			Errorf("error checking access [method: %s, endpoint: %s, error: %s]", request.Method, request.Endpoint, err).ToError()
		return false, err
	}

	return isAllowed, nil
}
