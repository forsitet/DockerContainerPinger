package types

import (
  "encoding/json"
  "errors"
  "fmt"
  "net/http"
  "post/domain"

  "github.com/go-chi/chi/v5"
)

type GetHandelerRequest struct {
  Key string
}

func CreateGetHandelerRequest(r *http.Request) (*GetHandelerRequest, error) {
  key := chi.URLParam(r, "task_id")
  if key == "" {
    return nil, errors.New("missing key in params")
  }
  return &GetHandelerRequest{Key: key}, nil
}

type GetHandelerResponse struct {
  Value string `json:"value"`
}

func CreateResponse(w http.ResponseWriter, resp any) {
  w.Header().Set("Content-Type", "application/json")

  if err, ok := (resp).(ErrorResponse); ok {
    w.WriteHeader(err.Code)
  }

  if err := json.NewEncoder(w).Encode(&resp); err != nil {
    w.WriteHeader(http.StatusInternalServerError)
    http.Error(w, "Internal error", http.StatusInternalServerError)
    return
  }
}
