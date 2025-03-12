package types

import (
    "encoding/json"
    "net/http"
    "backend/domain" 
)


type LoginRequest struct {
    Username string `json:"username"`
    Password string `json:"password"`
}

type LoginResponse struct {
    User *domain.User `json:"user"`
}

type ErrorResponse struct {
    Code    int    `json:"code"`
    Message string `json:"message"`
}

func CreateResponse(w http.ResponseWriter, resp any) {
    w.Header().Set("Content-Type", "application/json")

    if err, ok := resp.(ErrorResponse); ok {
        w.WriteHeader(err.Code)
    }

    if err := json.NewEncoder(w).Encode(resp); err != nil {
        w.WriteHeader(http.StatusInternalServerError)
        http.Error(w, "Internal server error", http.StatusInternalServerError)
        return
    }
}