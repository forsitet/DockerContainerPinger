package types

import (
	"encoding/json"
	"net/http"
)

type GetHandlerReq struct {
	Key string
}

type GetHandlerResp struct {
	Value string `json:"value"`
}

func CreateGetHandlerReq(r *http.Request, rawKey string) (*GetHandlerReq, error) {
	key := r.URL.Query().Get(rawKey)
	if key == "" {
		return nil, MissingKey
	}

	return &GetHandlerReq{Key: key}, nil
}

func CreateResponse(w http.ResponseWriter, resp any) {
	w.Header().Set("Content-Type", "application/json")
	if err, ok := resp.(errorResponse); ok {
		w.WriteHeader(err.Code)
	}

	if err := json.NewEncoder(w).Encode(&resp); err != nil {
		w.WriteHeader(http.StatusInternalServerError)
	}
}
