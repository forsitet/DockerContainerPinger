package types

import "errors"

var MissingKey = errors.New("missing key in params")

type errorResponse struct {
	Message string `json:"message"`
	Code    int    `json:"code"`
}

func NewErrorResponse(err error, code int) errorResponse {
	return errorResponse{Message: err.Error(), Code: code}
}

func ProcessError(err error) int{
	return 500
}
