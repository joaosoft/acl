package acl

import (
	"time"
)

type Categories []*Category

type Category struct {
	Name        string    `json:"name" db:"name"`
	Key         string    `json:"key" db:"key"`
	Description string    `json:"description" db:"description"`
	Active      bool      `json:"active" db:"active"`
	CreatedAt   time.Time `json:"created_at" db:"created_at"`
	UpdatedAt   time.Time `json:"updated_at" db:"updated_at"`
}

type Resources []*Resource

type Resource struct {
	Name        string    `json:"name" db:"name"`
	Key         string    `json:"key" db:"key"`
	Type        string    `json:"type" db:"type"`
	Description string    `json:"description" db:"description"`
	Active      bool      `json:"active" db:"active"`
	CreatedAt   time.Time `json:"created_at" db:"created_at"`
	UpdatedAt   time.Time `json:"updated_at" db:"updated_at"`
}
