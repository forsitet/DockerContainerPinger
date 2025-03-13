package repository

import "errors"

var ErrKeyNotFound = errors.New("key not found")
var ErrUserExists = errors.New("user already exists")
