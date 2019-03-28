# acl
[![Build Status](https://travis-ci.org/joaosoft/acl.svg?branch=master)](https://travis-ci.org/joaosoft/acl) | [![codecov](https://codecov.io/gh/joaosoft/acl/branch/master/graph/badge.svg)](https://codecov.io/gh/joaosoft/acl) | [![Go Report Card](https://goreportcard.com/badge/github.com/joaosoft/acl)](https://goreportcard.com/report/github.com/joaosoft/acl) | [![GoDoc](https://godoc.org/github.com/joaosoft/acl?status.svg)](https://godoc.org/github.com/joaosoft/acl)

A simple acl implementation.


###### If i miss something or you have something interesting, please be part of this project. Let me know! My contact is at the end.

## With support for
* domains
* endpoint
* roles
* categories
* resources
* resource types

## Endpoints
* **Get categories:** 

    Method: GET

    Route: http://localhost:8001/api/v1/acl/domains/app/roles/admin/categories
    
    Response: 
    ```
    [
        {
            "name": "Home Page",
            "key": "home",
            "description": "site home page",
            "active": true,
            "created_at": "2019-03-28T20:01:23.161Z",
            "updated_at": "2019-03-28T20:01:23.161Z"
        },
        {
            "name": "Settings Page",
            "key": "settings",
            "description": "site settings page",
            "active": true,
            "created_at": "2019-03-28T20:01:50.697Z",
            "updated_at": "2019-03-28T20:01:50.697Z"
        }
    ]
    ```

* **Get category resources:** 

    Method: GET
    
    Route: http://localhost:8001/api/v1/acl/domains/app/roles/admin/categories/home/resources
    
    Response: 
    ```
    [
        {
            "name": "Read Access Home",
            "key": "access.home.read",
            "type": "app",
            "description": "read access to home page",
            "active": true,
            "created_at": "2019-03-28T20:03:29.061Z",
            "updated_at": "2019-03-28T20:04:12.06Z"
        },
        {
            "name": "Write Access Home",
            "key": "access.home.write",
            "type": "app",
            "description": "write access to home page",
            "active": true,
            "created_at": "2019-03-28T20:04:12.054Z",
            "updated_at": "2019-03-28T20:04:12.054Z"
        },
        {
            "name": "Read Business Dummy",
            "key": "business.dummy.read",
            "type": "business",
            "description": "read business dummy",
            "active": true,
            "created_at": "2019-03-28T20:03:29.061Z",
            "updated_at": "2019-03-28T20:04:12.06Z"
        },
        {
            "name": "Write Business Dummy",
            "key": "business.dummy.write",
            "type": "business",
            "description": "write business dummy",
            "active": true,
            "created_at": "2019-03-28T20:04:12.054Z",
            "updated_at": "2019-03-28T20:04:12.054Z"
        }
    ]
    ```

* **Get category resources of a type:** 

    Method: GET
    
    Route: http://localhost:8001/api/v1/acl/domains/app/roles/admin/categories/home/resources/types/app
    
    Response: 
    ```
    [
        {
            "name": "Read Access Home",
            "key": "access.home.read",
            "type": "app",
            "description": "read access to home page",
            "active": true,
            "created_at": "2019-03-28T20:03:29.061Z",
            "updated_at": "2019-03-28T20:04:12.06Z"
        },
        {
            "name": "Write Access Home",
            "key": "access.home.write",
            "type": "app",
            "description": "write access to home page",
            "active": true,
            "created_at": "2019-03-28T20:04:12.054Z",
            "updated_at": "2019-03-28T20:04:12.054Z"
        }
    ]
    ```

* **Check endpoint access:** 

    Method: GET
    
    Route: http://localhost:8001/api/v1/acl/domains/app/roles/admin/resources/types/app?method=GET&endpoint=/api/v1/dummy
    
    Response: 
    ```
    {
        "is_allowed": true
    }
    ```

* **Check endpoint access by middleware:** 

    Method: GET
    
    Route: http://localhost:8001/api/v1/dummy?domain_key=app&role_key=admin&resource_type_key=app
    
    Response: Status: 204
    
## Dependecy Management
>### Dependency

Project dependencies are managed using Dep. Read more about [Dep](https://github.com/golang/dep).
* Get dependency manager: `go get github.com/joaosoft/dependency`
* Install dependencies: `dependency get`


>### Go
```
go get github.com/joaosoft/acl
```

>### Configuration
```
{
  "acl": {
    "host": "localhost:8001",
    "token_key": "banana",
    "dbr": {
      "db": {
        "driver": "postgres",
        "datasource": "postgres://user:password@localhost:7000/postgres?sslmode=disable&acl_path=acl"
      }
    },
    "log": {
      "level": "info"
    },
    "migration": {
      "path": {
        "database": "schema/db/postgres"
      },
      "db": {
        "schema": "acl",
        "driver": "postgres",
        "datasource": "postgres://user:password@localhost:7000/postgres?sslmode=disable&acl_path=acl"
      },
      "log": {
        "level": "info"
      }
    }
  },
  "manager": {
    "log": {
      "level": "info"
    }
  }
}
```

## Usage 
This examples are available in the project at [acl/examples](https://github.com/joaosoft/acl/tree/master/examples)

```go
func main() {
	m, err := acl.NewAcl()
	if err != nil {
		panic(err)
	}

	if err := m.Start(); err != nil {
		panic(err)
	}
}
```

## Known issues

## Follow me at
Facebook: https://www.facebook.com/joaosoft

LinkedIn: https://www.linkedin.com/in/jo%C3%A3o-ribeiro-b2775438/

##### If you have something to add, please let me know joaosoft@gmail.com