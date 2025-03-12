package handlersUser

import (
    "net/http"
    "encoding/json"
    "backend/service"
    "backend/domain"
)

type LoginRequest struct {
    Username string `json:"username"`
    Password string `json:"password"`
}

type LoginResponse struct {
    User  *domain.User `json:"user"`
    Token string      `json:"token"`
}

func Login(w http.ResponseWriter, r *http.Request) {
    var req LoginRequest
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        http.Error(w, "Invalid request body", http.StatusBadRequest)
        return
    }

    user, token, err := service.Authenticate(req.Username, req.Password)
    if err != nil {
        http.Error(w, "Invalid credentials", http.StatusUnauthorized)
        return
    }

    response := LoginResponse{User: user, Token: token}
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(response)
}