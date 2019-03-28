package main

import "acl"

func main() {
	m, err := acl.NewAcl()
	if err != nil {
		panic(err)
	}

	if err := m.Start(); err != nil {
		panic(err)
	}
}
