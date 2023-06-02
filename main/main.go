package main

import "github.com/joaosoft/acl"

func main() {
	m, err := acl.NewAcl()
	if err != nil {
		panic(err)
	}

	if err := m.Start(); err != nil {
		panic(err)
	}
}
