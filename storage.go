package acl

import (
	"github.com/joaosoft/dbr"
)

type StoragePostgres struct {
	config *AclConfig
	db     *dbr.Dbr
}

func NewStoragePostgres(config *AclConfig) (*StoragePostgres, error) {
	dbr, err := dbr.New(dbr.WithConfiguration(config.Dbr))
	if err != nil {
		return nil, err
	}

	return &StoragePostgres{
		config: config,
		db:     dbr,
	}, nil
}

func (storage *StoragePostgres) GetCategories(domainKey, roleKey string) (Categories, error) {
	categories := make(Categories, 0)

	_, err := storage.db.
		Select([]interface{}{
			"c.name",
			"c.key",
			"c.description",
			"c.active",
			"c.created_at",
			"c.updated_at",
		}...).
		From(dbr.As(aclTableCategory, "c")).
		Join(dbr.As(aclTableRole, "r"), "r.id_role = c.fk_role").
		Join(dbr.As(aclTableDomain, "d"), "d.id_domain = r.fk_domain").
		Where("d.key = ?", domainKey).
		Where("r.key = ?", roleKey).
		Where("d.active").
		Where("r.active").
		Where("c.active").
		Load(&categories)

	if err != nil {
		return nil, err
	}

	return categories, nil
}

func (storage *StoragePostgres) GetResources(domainKey, roleKey, categoryKey string) (Resources, error) {
	resources := make(Resources, 0)

	_, err := storage.db.
		Select([]interface{}{
			"rs.name",
			"rs.key",
			dbr.As("rt.key", "type"),
			"rs.description",
			"rs.active",
			"rs.created_at",
			"rs.updated_at",
		}...).
		From(dbr.As(aclTableResource, "rs")).
		Join(dbr.As(aclTableRole, "r"), "r.id_role = rs.fk_role").
		Join(dbr.As(aclTableDomain, "d"), "d.id_domain = r.fk_domain").
		Join(dbr.As(aclTableResourceType, "rt"), "rt.id_resource_type = rs.fk_resource_type").
		Where("d.key = ?", domainKey).
		Where("r.key = ?", roleKey).
		Where("d.active").
		Where("r.active").
		Where("rs.active").
		Load(&resources)

	if err != nil {
		return nil, err
	}

	return resources, nil
}

func (storage *StoragePostgres) GetResourcesByType(domainKey, roleKey, categoryKey, resourceTypeKey string) (Resources, error) {
	resources := make(Resources, 0)

	_, err := storage.db.
		Select([]interface{}{
			"rs.name",
			"rs.key",
			dbr.As("rt.key", "type"),
			"rs.description",
			"rs.active",
			"rs.created_at",
			"rs.updated_at",
		}...).
		From(dbr.As(aclTableResource, "rs")).
		Join(dbr.As(aclTableRole, "r"), "r.id_role = rs.fk_role").
		Join(dbr.As(aclTableDomain, "d"), "d.id_domain = r.fk_domain").
		Join(dbr.As(aclTableResourceType, "rt"), "rt.id_resource_type = rs.fk_resource_type").
		Where("d.key = ?", domainKey).
		Where("r.key = ?", roleKey).
		Where("rt.key = ?", resourceTypeKey).
		Where("d.active").
		Where("r.active").
		Where("rs.active").
		Load(&resources)

	if err != nil {
		return nil, err
	}

	return resources, nil
}

func (storage *StoragePostgres) CheckEndpointAccess(domainKey, roleKey, resourceTypeKey, method, endpoint string) (isAllowed bool, err error) {

	_, err = storage.db.
		Select("count(1) > 0").
		From(dbr.As(aclTableEndpoint, "e")).
		Join(dbr.As(aclTableEndpointResource, "er"), "er.fk_endpoint = e.id_endpoint").
		Join(dbr.As(aclTableResource, "rs"), "rs.id_resource = er.fk_resource").
		Join(dbr.As(aclTableDomain, "d"), "d.id_domain = e.fk_domain").
		Join(dbr.As(aclTableRole, "r"), "r.id_role = er.fk_role").
		Join(dbr.As(aclTableResourceType, "rt"), "rt.id_resource_type = rs.fk_resource_type").
		Where("e.method = ?", method).
		Where("e.endpoint = ?", endpoint).
		Where("d.key = ?", domainKey).
		Where("r.key = ?", roleKey).
		Where("rt.key = ?", resourceTypeKey).
		Where("e.active").
		Where("er.active").
		Where("rs.active").
		Where("d.active").
		Where("r.active").
		Where("rt.active").
		Load(&isAllowed)

	if err != nil {
		return false, err
	}

	return isAllowed, nil
}
