package errors

import "errors"

var (
	ErrInvalidCredentials = errors.New("invalid credentials")
	ErrUserNotFound       = errors.New("user not found")
	ErrMissingKeyInParams = errors.New("missing key in params")
	ErrUserAlreadyExists  = errors.New("user already exists")
)
