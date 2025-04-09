package types

import "errors"

var MissingKey = errors.New("missing key in params")

type ErrorResponse struct {
	Message string `json:"message"`
	Code    int    `json:"code"`
}

func NewErrorResponse(err error, code int) ErrorResponse {
	return ErrorResponse{Message: err.Error(), Code: code}
}

func ProcessError(err error) int {
	return 500
}
